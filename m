Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXFOLRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXFOLRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXFOLRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:17:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:8950 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXFOLRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fBmIet6DrBPApn55i9pNfI7yueE3x6rIev6atd7zM17oMR0++kRuUmSgx3DpGBttXpEvfZXRHKP31lwY/ZbHkLGbShH1yqlFWD6t5qGlnupFdR5qWbv4Ws5jW7x26MErqsUUNw1688AqT0Pja7lTQPEMu4TxQ0dx9g7IpNxZE7g=
Date: Fri, 15 Jun 2007 20:17:28 +0900
From: Tejun Heo <htejun@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Greaves <david@dgreaves.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] block: always requeue !fs requests at the front
Message-ID: <20070615111728.GO29122@htj.dyndns.org>
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com> <46715A66.8030806@suse.de> <20070615094246.GN29122@htj.dyndns.org> <20070615110544.GR6149@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615110544.GR6149@kernel.dk>
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

2. Suspend requested.  Queue is quiesced with part or all of IO
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
> Yep looks good, except for the bad multi-line comment style, but that's
> minor stuff ;-)

That's how Jeff likes it in libata and my fingers are hardcoded to it,
but I do appreciate the paramount importance of each maintainer's
right to his/her own comment style, so here's the respinned patch.  :-)

 block/ll_rw_blk.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 6b5173a..c99b463 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -340,6 +340,15 @@ unsigned blk_ordered_req_seq(struct request *rq)
 	if (rq == &q->post_flush_rq)
 		return QUEUE_ORDSEQ_POSTFLUSH;
 
+	/*
+	 * !fs requests don't need to follow barrier ordering.  Always
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
