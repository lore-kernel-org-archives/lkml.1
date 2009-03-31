Return-Path: <linux-kernel-owner+w=401wt.eu-S1765193AbZDAAVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765193AbZDAAVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764914AbZDAAU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:20:26 -0400
Received: from sous-sol.org ([216.99.217.87]:55731 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765439AbZDAAUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:20:25 -0400
Message-Id: <20090331231628.798612700@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 27/45] SCSI: sg: avoid blk_put_request/blk_rq_unmap_user in interrupt
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=scsi-sg-avoid-blk_put_request-blk_rq_unmap_user-in-interrupt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

upstream commit: c96952ed7031e7c576ecf90cf95b8ec099d5295a

This fixes the following oops:

http://marc.info/?l=linux-kernel&m=123316111415677&w=2

You can reproduce this bug by interrupting a program before a sg
response completes. This leads to the special sg state (the orphan
state), then sg calls blk_put_request in interrupt (rq->end_io).

The above bug report shows the recursive lock problem because sg calls
blk_put_request in interrupt. We could call __blk_put_request here
instead however we also need to handle blk_rq_unmap_user here, which
can't be called in interrupt too.

In the orphan state, we don't need to care about the data transfer
(the program revoked the command) so adding 'just free the resource'
mode to blk_rq_unmap_user is a possible option.

I prefer to avoid complicating the blk mapping API when possible. I
change the orphan state to call sg_finish_rem_req via
execute_in_process_context. We hold sg_fd->kref so sg_fd doesn't go
away until keventd_wq finishes our work. copy_from_user/to_user fails
so blk_rq_unmap_user just frees the resource without the data
transfer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/scsi/sg.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -138,6 +138,7 @@ typedef struct sg_request {	/* SG_MAX_QU
 	volatile char done;	/* 0->before bh, 1->before read, 2->read */
 	struct request *rq;
 	struct bio *bio;
+	struct execute_work ew;
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
@@ -1234,6 +1235,15 @@ sg_mmap(struct file *filp, struct vm_are
 	return 0;
 }
 
+static void sg_rq_end_io_usercontext(struct work_struct *work)
+{
+	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
+	struct sg_fd *sfp = srp->parentfp;
+
+	sg_finish_rem_req(srp);
+	kref_put(&sfp->f_ref, sg_remove_sfp);
+}
+
 /*
  * This function is a "bottom half" handler that is called by the mid
  * level when a command is completed (or has failed).
@@ -1312,10 +1322,9 @@ static void sg_rq_end_io(struct request 
 		 */
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+		kref_put(&sfp->f_ref, sg_remove_sfp);
 	} else
-		sg_finish_rem_req(srp); /* call with srp->done == 0 */
-
-	kref_put(&sfp->f_ref, sg_remove_sfp);
+		execute_in_process_context(sg_rq_end_io_usercontext, &srp->ew);
 }
 
 static struct file_operations sg_fops = {

