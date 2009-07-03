Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZGCTIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZGCTIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbZGCTIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:08:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36293 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbZGCTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:08:40 -0400
Date: Fri, 3 Jul 2009 21:08:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] two block fixes
Message-ID: <20090703190843.GS23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Only two things here - a kexec related cciss fix, and an important fix
from Tejun that could potentially cause data corruption. Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Hannes Reinecke (1):
      cciss: Ignore stale commands after reboot

Tejun Heo (1):
      block: don't merge requests of different failfast settings

 block/blk-merge.c         |    6 ++++++
 block/elevator.c          |    8 ++++++++
 drivers/block/cciss.c     |   15 +++++++++++++--
 drivers/block/cciss_cmd.h |    1 +
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 39ce644..e199967 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -350,6 +350,12 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (blk_integrity_rq(req) != blk_integrity_rq(next))
 		return 0;
 
+	/* don't merge requests of different failfast settings */
+	if (blk_failfast_dev(req)	!= blk_failfast_dev(next)	||
+	    blk_failfast_transport(req)	!= blk_failfast_transport(next)	||
+	    blk_failfast_driver(req)	!= blk_failfast_driver(next))
+		return 0;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
diff --git a/block/elevator.c b/block/elevator.c
index ca86192..6f23753 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -100,6 +100,14 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return 0;
 
+	/*
+	 * Don't merge if failfast settings don't match
+	 */
+	if (bio_failfast_dev(bio)	!= blk_failfast_dev(rq)		||
+	    bio_failfast_transport(bio)	!= blk_failfast_transport(rq)	||
+	    bio_failfast_driver(bio)	!= blk_failfast_driver(rq))
+		return 0;
+
 	if (!elv_iosched_allow_merge(rq, bio))
 		return 0;
 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index c7a527c..65a0655 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -226,8 +226,18 @@ static inline void addQ(struct hlist_head *list, CommandList_struct *c)
 
 static inline void removeQ(CommandList_struct *c)
 {
-	if (WARN_ON(hlist_unhashed(&c->list)))
+	/*
+	 * After kexec/dump some commands might still
+	 * be in flight, which the firmware will try
+	 * to complete. Resetting the firmware doesn't work
+	 * with old fw revisions, so we have to mark
+	 * them off as 'stale' to prevent the driver from
+	 * falling over.
+	 */
+	if (WARN_ON(hlist_unhashed(&c->list))) {
+		c->cmd_type = CMD_MSG_STALE;
 		return;
+	}
 
 	hlist_del_init(&c->list);
 }
@@ -4246,7 +4256,8 @@ static void fail_all_cmds(unsigned long ctlr)
 	while (!hlist_empty(&h->cmpQ)) {
 		c = hlist_entry(h->cmpQ.first, CommandList_struct, list);
 		removeQ(c);
-		c->err_info->CommandStatus = CMD_HARDWARE_ERR;
+		if (c->cmd_type != CMD_MSG_STALE)
+			c->err_info->CommandStatus = CMD_HARDWARE_ERR;
 		if (c->cmd_type == CMD_RWREQ) {
 			complete_command(h, c, 0);
 		} else if (c->cmd_type == CMD_IOCTL_PEND)
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index cd665b0..dbaed1e 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -274,6 +274,7 @@ typedef struct _ErrorInfo_struct {
 #define CMD_SCSI	0x03
 #define CMD_MSG_DONE	0x04
 #define CMD_MSG_TIMEOUT 0x05
+#define CMD_MSG_STALE	0xff
 
 /* This structure needs to be divisible by 8 for new
  * indexing method.

-- 
Jens Axboe

