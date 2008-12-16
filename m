Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYLPSJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYLPSJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbYLPSIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:08:38 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:37186 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417AbYLPSIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:08:37 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [w1] Allow master IO commands.
Date: Tue, 16 Dec 2008 21:07:59 +0300
Message-Id: <1229450882-745-2-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1229450882-745-1-git-send-email-zbr@ioremap.net>
References: <1229450882-745-1-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to start IO not against already found slave devices,
but against the bus itself, which can be used for example to probe device.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1_netlink.c |  126 ++++++++++++++++++++++++++---------------------
 1 files changed, 69 insertions(+), 57 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 24ad6bb..0267fe4 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -95,51 +95,8 @@ static int w1_process_search_command(struct w1_master *dev, struct cn_msg *msg,
 	return 0;
 }
 
-static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_msg,
-		struct w1_netlink_msg *req_hdr, struct w1_netlink_cmd *req_cmd)
-{
-	int err = -EINVAL;
-	struct cn_msg *msg;
-	struct w1_netlink_msg *hdr;
-	struct w1_netlink_cmd *cmd;
-
-	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	msg->id = req_msg->id;
-	msg->seq = req_msg->seq;
-	msg->ack = 0;
-	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
-
-	hdr = (struct w1_netlink_msg *)(msg + 1);
-	cmd = (struct w1_netlink_cmd *)(hdr + 1);
-
-	hdr->type = W1_MASTER_CMD;
-	hdr->id = req_hdr->id;
-	hdr->len = sizeof(struct w1_netlink_cmd);
-
-	cmd->cmd = req_cmd->cmd;
-	cmd->len = 0;
-
-	switch (cmd->cmd) {
-		case W1_CMD_SEARCH:
-		case W1_CMD_ALARM_SEARCH:
-			err = w1_process_search_command(dev, msg,
-				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
-			break;
-		default:
-			cmd->res = EINVAL;
-			cn_netlink_send(msg, 0, GFP_KERNEL);
-			break;
-	}
-
-	kfree(msg);
-	return err;
-}
-
-static int w1_send_read_reply(struct w1_slave *sl, struct cn_msg *msg,
-		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+static int w1_send_read_reply(struct cn_msg *msg, struct w1_netlink_msg *hdr,
+		struct w1_netlink_cmd *cmd)
 {
 	void *data;
 	struct w1_netlink_msg *h;
@@ -163,7 +120,8 @@ static int w1_send_read_reply(struct w1_slave *sl, struct cn_msg *msg,
 	memcpy(c, cmd, sizeof(struct w1_netlink_cmd));
 
 	cm->ack = msg->seq+1;
-	cm->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd) + cmd->len;
+	cm->len = sizeof(struct w1_netlink_msg) +
+		sizeof(struct w1_netlink_cmd) + cmd->len;
 
 	h->len = sizeof(struct w1_netlink_cmd) + cmd->len;
 
@@ -176,26 +134,22 @@ static int w1_send_read_reply(struct w1_slave *sl, struct cn_msg *msg,
 	return err;
 }
 
-static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
+static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
 		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
 {
 	int err = 0;
 
-	dev_dbg(&sl->master->dev, "%s: %02x.%012llx.%02x: cmd=%02x, len=%u.\n",
-		__func__, sl->reg_num.family, (unsigned long long)sl->reg_num.id, sl->reg_num.crc,
-		cmd->cmd, cmd->len);
-
 	switch (cmd->cmd) {
 		case W1_CMD_TOUCH:
-			w1_touch_block(sl->master, cmd->data, cmd->len);
-			w1_send_read_reply(sl, msg, hdr, cmd);
+			w1_touch_block(dev, cmd->data, cmd->len);
+			w1_send_read_reply(msg, hdr, cmd);
 			break;
 		case W1_CMD_READ:
-			w1_read_block(sl->master, cmd->data, cmd->len);
-			w1_send_read_reply(sl, msg, hdr, cmd);
+			w1_read_block(dev, cmd->data, cmd->len);
+			w1_send_read_reply(msg, hdr, cmd);
 			break;
 		case W1_CMD_WRITE:
-			w1_write_block(sl->master, cmd->data, cmd->len);
+			w1_write_block(dev, cmd->data, cmd->len);
 			break;
 		default:
 			err = -1;
@@ -205,6 +159,64 @@ static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
 	return err;
 }
 
+static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_msg,
+		struct w1_netlink_msg *req_hdr, struct w1_netlink_cmd *req_cmd)
+{
+	int err = -EINVAL;
+	struct cn_msg *msg;
+	struct w1_netlink_msg *hdr;
+	struct w1_netlink_cmd *cmd;
+
+	msg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	msg->id = req_msg->id;
+	msg->seq = req_msg->seq;
+	msg->ack = 0;
+	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
+
+	hdr = (struct w1_netlink_msg *)(msg + 1);
+	cmd = (struct w1_netlink_cmd *)(hdr + 1);
+
+	hdr->type = W1_MASTER_CMD;
+	hdr->id = req_hdr->id;
+	hdr->len = sizeof(struct w1_netlink_cmd);
+
+	cmd->cmd = req_cmd->cmd;
+	cmd->len = 0;
+
+	switch (cmd->cmd) {
+		case W1_CMD_SEARCH:
+		case W1_CMD_ALARM_SEARCH:
+			err = w1_process_search_command(dev, msg,
+				PAGE_SIZE - msg->len - sizeof(struct cn_msg));
+			break;
+		case W1_CMD_READ:
+		case W1_CMD_WRITE:
+		case W1_CMD_TOUCH:
+			err = w1_process_command_io(dev, msg, hdr, cmd);
+			break;
+		default:
+			cmd->res = EINVAL;
+			cn_netlink_send(msg, 0, GFP_KERNEL);
+			break;
+	}
+
+	kfree(msg);
+	return err;
+}
+
+static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
+		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+{
+	dev_dbg(&sl->master->dev, "%s: %02x.%012llx.%02x: cmd=%02x, len=%u.\n",
+		__func__, sl->reg_num.family, (unsigned long long)sl->reg_num.id,
+		sl->reg_num.crc, cmd->cmd, cmd->len);
+
+	return w1_process_command_io(sl->master, msg, hdr, cmd);
+}
+
 static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mcmd)
 {
 	struct w1_master *m;
@@ -214,7 +226,7 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 
 	if (mcmd->type != W1_LIST_MASTERS) {
 		printk(KERN_NOTICE "%s: msg: %x.%x, wrong type: %u, len: %u.\n",
-				__func__, msg->id.idx, msg->id.val, mcmd->type, mcmd->len);
+			__func__, msg->id.idx, msg->id.val, mcmd->type, mcmd->len);
 		return -EPROTO;
 	}
 
-- 
1.5.6.3

