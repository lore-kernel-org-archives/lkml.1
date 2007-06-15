Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbXFOJnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbXFOJnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXFOJmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:42:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:29838 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXFOJmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oT6/PkG0+Tb4zLLnA6RxmOXTFlwFUE2JV/66OYM9bdq0oEu66Xa5uBON0wp9hKcnfCqrXNFxl2iVCUyWgbhHIBKRsECOU1cGqgBGdUsY3ISpJ7FBelmo9jxGYIGYTeKZFtvMqaWi4zBzik0se08v0H2mZAdpWeuNM5XW8+44w+E=
Date: Fri, 15 Jun 2007 18:42:46 +0900
From: Tejun Heo <htejun@gmail.com>
To: David Greaves <david@dgreaves.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>, jens.axboe@oracle.com
Subject: [PATCH] block: always requeue !fs requests at the front
Message-ID: <20070615094246.GN29122@htj.dyndns.org>
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com> <46715A66.8030806@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46715A66.8030806@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SCSI marks internal commands with REQ_PREEMPT and push it at the front
of the request queue using blk_execute_rq().  When entering suspended
or frozen state, SCSI devices are quiesced using
scsi_device_quiesce().  In quiesced state, only REQ_PREEMPT requests
are processed.  This is how SCSI blocks other requests out while
suspending and resuming.  As all internal commands are pushed at the
front of the queue, this usually works.

Unfortunately, this interacts badly with ordered requeueing.  To
preserve request order on requeueing (due to busy device, active EH or
other failures), requests are sorted according to ordered sequence on
requeue if IO barrier is in progress.

The following sequence deadlocks.

1. IO barrier sequence issues.

2. Suspend requested.  Queue is quiesced with part of all of IO
   barrier sequence at the front.

3. During suspending or resuming, SCSI issues internal command which
   gets deferred and requeued for some reason.  As the command is
   issued after the IO barrier in #1, ordered requeueing code puts the
   request after IO barrier sequence.

4. The device is ready to process requests again but still is in
   quiesced state and the first request of the queue isn't
   REQ_PREEMPT, so command processing is deadlocked -
   suspending/resuming waits for the issued request to complete while
   the request can't be processed till device is put back into
   running state by resuming.

This can be fixed by always putting !fs requests at the front when
requeueing.

The following thread reports this deadlock.

  http://thread.gmane.org/gmane.linux.kernel/537473

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jenn Axboe <jens.axboe@oracle.com>
Cc: David Greaves <david@dgreaves.com>
---
Okay, it took a lot of hours of debugging but boiled down to two liner
fix.  I feel so empty. :-) RAID6 triggers this reliably because it
uses BIO_BARRIER heavily to update its superblock.  The recent ATA
suspend/resume rewrite is hit by this because it uses SCSI internal
commands to spin down and up the drives for suspending and resuming.

David, please test this.  Jens, does it look okay?

Thanks.

 block/ll_rw_blk.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 6b5173a..a2fe2e5 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -340,6 +340,14 @@ unsigned blk_ordered_req_seq(struct request *rq)
 	if (rq == &q->post_flush_rq)
 		return QUEUE_ORDSEQ_POSTFLUSH;
 
+	/* !fs requests don't need to follow barrier ordering.  Always
+	 * put them at the front.  This fixes the following deadlock.
+	 *
+	 * http://thread.gmane.org/gmane.linux.kernel/537473
+	 */
+	if (!blk_fs_request(rq))
+		return QUEUE_ORDSEQ_DRAIN;
+
 	if ((rq->cmd_flags & REQ_ORDERED_COLOR) ==
 	    (q->orig_bar_rq->cmd_flags & REQ_ORDERED_COLOR))
 		return QUEUE_ORDSEQ_DRAIN;
