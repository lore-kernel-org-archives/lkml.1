Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZGBIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZGBIX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZGBIXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:23:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZGBIXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:23:13 -0400
Date: Thu, 02 Jul 2009 10:23:13 +0200
To: Jens Axboe <jens.axboe@oracle.com>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org
Subject: [PATCH] cciss: Ignore stale commands after reboot
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090702082313.F3754D340B@pentland.suse.de>
From: hare@suse.de (Hannes Reinecke)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When doing an unexpected shutdown like kexec the cciss
firmware might still have some commands in flight, which
it is trying to complete.
The driver is doing it's best on resetting the HBA,
but sadly there's a firmware issue causing the firmware
_not_ to abort or drop old commands.
So the firmware will send us commands which we haven't
accounted for, causing the driver to panic.

With this patch we're just ignoring these commands as
there is nothing we could be doing with them anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/cciss.c     |   14 ++++++++++++--
 drivers/block/cciss_cmd.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index c7a527c..8dd4c0d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -226,7 +226,16 @@ static inline void addQ(struct hlist_head *list, CommandList_struct *c)
 
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
+	if (unlikely(hlist_unhashed(&c->list))) {
+		c->cmd_type = CMD_MSG_STALE;
 		return;
 
 	hlist_del_init(&c->list);
@@ -4246,7 +4255,8 @@ static void fail_all_cmds(unsigned long ctlr)
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
1.5.3.2

