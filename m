Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYLEMlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYLEMlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbYLEMlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:41:15 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:21429 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbYLEMlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:41:14 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [W1] List slaves commands.
Date: Fri,  5 Dec 2008 15:41:27 +0300
Message-Id: <12284808903744-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12284808902058-git-send-email-zbr@ioremap.net>
References: <1228480888739-git-send-email-zbr@ioremap.net>
 <1228480889246-git-send-email-zbr@ioremap.net>
 <12284808902058-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initiates search (or alarm search) and returns all found devices to userspace.
Found devices are not added into the system (i.e. they are not attached
to family devices or bus masters), it will be done via (if was not done yet)
usual timed searching.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1_netlink.c |  102 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index cae556c..24ad6bb 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -47,19 +47,97 @@ void w1_netlink_send(struct w1_master *dev, struct w1_netlink_msg *msg)
 	cn_netlink_send(m, 0, GFP_KERNEL);
 }
 
-static int w1_process_command_master(struct w1_master *dev, struct cn_msg *msg,
-		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
+static void w1_send_slave(struct w1_master *dev, u64 rn)
 {
-	dev_dbg(&dev->dev, "%s: %s: cmd=%02x, len=%u.\n",
-		__func__, dev->name, cmd->cmd, cmd->len);
+	struct cn_msg *msg = dev->priv;
+	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
+	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
+	int avail;
+	
+	avail = dev->priv_size - cmd->len;
+
+	if (avail > 8) {
+		u64 *data = (void *)(cmd + 1) + cmd->len;
+
+		*data = rn;
+		cmd->len += 8;
+		hdr->len += 8;
+		msg->len += 8;
+		return;
+	}
+
+	msg->ack++;
+	cn_netlink_send(msg, 0, GFP_KERNEL);
+
+	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
+	hdr->len = sizeof(struct w1_netlink_cmd);
+	cmd->len = 0;
+}
+
+static int w1_process_search_command(struct w1_master *dev, struct cn_msg *msg,
+		unsigned int avail)
+{
+	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
+	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
+	int search_type = (cmd->cmd == W1_CMD_ALARM_SEARCH)?W1_ALARM_SEARCH:W1_SEARCH;
+
+	dev->priv = msg;
+	dev->priv_size = avail;
+
+	w1_search_devices(dev, search_type, w1_send_slave);
 
-	if (cmd->cmd != W1_CMD_SEARCH && cmd->cmd != W1_CMD_ALARM_SEARCH)
-		return -EINVAL;
+	msg->ack = 0;
+	cn_netlink_send(msg, 0, GFP_KERNEL);
+
+	dev->priv = NULL;
+	dev->priv_size = 0;
 
-	w1_search_process(dev, (cmd->cmd == W1_CMD_ALARM_SEARCH)?W1_ALARM_SEARCH:W1_SEARCH);
 	return 0;
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
 static int w1_send_read_reply(struct w1_slave *sl, struct cn_msg *msg,
 		struct w1_netlink_msg *hdr, struct w1_netlink_cmd *cmd)
 {
@@ -119,11 +197,6 @@ static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
 		case W1_CMD_WRITE:
 			w1_write_block(sl->master, cmd->data, cmd->len);
 			break;
-		case W1_CMD_SEARCH:
-		case W1_CMD_ALARM_SEARCH:
-			w1_search_process(sl->master,
-					(cmd->cmd == W1_CMD_ALARM_SEARCH)?W1_ALARM_SEARCH:W1_SEARCH);
-			break;
 		default:
 			err = -1;
 			break;
@@ -270,11 +343,6 @@ out_cont:
 		if (err == -ENODEV)
 			err = 0;
 	}
-#if 0
-	if (err) {
-		printk("%s: malformed message. Dropping.\n", __func__);
-	}
-#endif
 }
 
 int w1_init_netlink(void)
-- 
1.5.2.5

