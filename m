Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbZDWH5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbZDWH5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZDWHeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:23 -0400
Received: from sous-sol.org ([216.99.217.87]:51049 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757036AbZDWHeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:19 -0400
Message-Id: <20090423072904.126675150@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
Subject: [patch 076/100] SCSI: sg: fix q->queue_lock on scsi_error_handler path
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=scsi-sg-fix-q-queue_lock-on-scsi_error_handler-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

upstream commit: 015640edb1f346e0b2eda703587c4cd1c310ec1d

sg_rq_end_io() is called via rq->end_io. In some rare cases,
sg_rq_end_io calls blk_put_request/blk_rq_unmap_user (when a program
issuing a command has gone before the command completion; e.g. by
interrupting a program issuing a command before the command
completes).

We can't call blk_put_request/blk_rq_unmap_user in interrupt so the
commit c96952ed7031e7c576ecf90cf95b8ec099d5295a uses
execute_in_process_context().

The problem is that scsi_error_handler() calls rq->end_io too. We
can't call blk_put_request/blk_rq_unmap_user too in this path (we hold
q->queue_lock).

To avoid the above problem, in these rare cases, this patch always
uses schedule_work() instead of execute_in_process_context().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Stable Tree <stable@kernel.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/scsi/sg.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1323,8 +1323,10 @@ static void sg_rq_end_io(struct request 
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
-	} else
-		execute_in_process_context(sg_rq_end_io_usercontext, &srp->ew);
+	} else {
+		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
+		schedule_work(&srp->ew.work);
+	}
 }
 
 static struct file_operations sg_fops = {
@@ -2134,7 +2136,8 @@ static void sg_remove_sfp(struct kref *k
 	write_unlock_irqrestore(&sg_index_lock, iflags);
 	wake_up_interruptible(&sdp->o_excl_wait);
 
-	execute_in_process_context(sg_remove_sfp_usercontext, &sfp->ew);
+	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
+	schedule_work(&sfp->ew.work);
 }
 
 static int

