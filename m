Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYLPSIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYLPSIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYLPSIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:08:17 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:37156 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYLPSIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:08:16 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [w1] Send status messages after command processing.
Date: Tue, 16 Dec 2008 21:08:02 +0300
Message-Id: <1229450882-745-5-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1229450882-745-4-git-send-email-zbr@ioremap.net>
References: <1229450882-745-1-git-send-email-zbr@ioremap.net>
 <1229450882-745-2-git-send-email-zbr@ioremap.net>
 <1229450882-745-3-git-send-email-zbr@ioremap.net>
 <1229450882-745-4-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send completion status of the commands to the userspace.
Message and protocol are described in the documentation.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/w1/w1.netlink |   29 +++++++++++++++++++++++
 drivers/w1/w1_netlink.c     |   53 +++++++++++++++++++++++++++++++++++++-----
 drivers/w1/w1_netlink.h     |    2 +-
 3 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
index 25721af..089e65e 100644
--- a/Documentation/w1/w1.netlink
+++ b/Documentation/w1/w1.netlink
@@ -118,6 +118,35 @@ W1 reset command.
   	id is equal to the bus master id to use for searching]
   [w1_netlink_cmd cmd = W1_CMD_RESET]
 
+
+Command status replies.
+======================
+
+Each command (either root, master or slave with or without w1_netlink_cmd
+structure) will be 'acked' by the w1 core. Format of the reply is the same
+as request message except that length parameters do not account for data
+requested by the user, i.e. read/write/touch IO requests will not contain
+data, so w1_netlink_cmd.len will be 0, w1_netlink_msg.len will be size
+of the w1_netlink_cmd structure and cn_msg.len will be equal to the sum
+of the sizeof(struct w1_netlink_msg) and sizeof(struct w1_netlink_cmd).
+If reply is generated for master or root command (which do not have
+w1_netlink_cmd attached), reply will contain only cn_msg and w1_netlink_msg
+structires.
+
+w1_netlink_msg.status field will carry positive error value
+(EINVAL for example) or zero in case of success.
+
+All other fields in every structure will mirror the same parameters in the
+request message (except lengths as described above).
+
+Status reply is generated for every w1_netlink_cmd embedded in the
+w1_netlink_msg, if there are no w1_netlink_cmd structures,
+reply will be generated for the w1_netlink_msg.
+
+All w1_netlink_cmd command structures are handled in every w1_netlink_msg,
+even if there were errors, only length mismatch interrupts message processing.
+
+
 Operation steps in w1 core when new command is received.
 =======================================================
 
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index e807265..7cb83ad 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -152,7 +152,7 @@ static int w1_process_command_io(struct w1_master *dev, struct cn_msg *msg,
 			w1_write_block(dev, cmd->data, cmd->len);
 			break;
 		default:
-			err = -1;
+			err = -EINVAL;
 			break;
 	}
 
@@ -195,14 +195,13 @@ static int w1_process_command_master(struct w1_master *dev, struct cn_msg *req_m
 		case W1_CMD_READ:
 		case W1_CMD_WRITE:
 		case W1_CMD_TOUCH:
-			err = w1_process_command_io(dev, msg, hdr, cmd);
+			err = w1_process_command_io(dev, req_msg, req_hdr, req_cmd);
 			break;
 		case W1_CMD_RESET:
 			err = w1_reset_bus(dev);
 			break;
 		default:
-			cmd->res = EINVAL;
-			cn_netlink_send(msg, 0, GFP_KERNEL);
+			err = -EINVAL;
 			break;
 	}
 
@@ -246,7 +245,7 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 	w = (struct w1_netlink_msg *)(cn + 1);
 
 	w->type = W1_LIST_MASTERS;
-	w->reserved = 0;
+	w->status = 0;
 	w->len = 0;
 	id = (u32 *)(w + 1);
 
@@ -273,6 +272,40 @@ static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mc
 	return 0;
 }
 
+static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rmsg,
+		struct w1_netlink_cmd *rcmd, int error)
+{
+	struct cn_msg *cmsg;
+	struct w1_netlink_msg *msg;
+	struct w1_netlink_cmd *cmd;
+
+	cmsg = kzalloc(sizeof(*msg) + sizeof(*cmd) + sizeof(*cmsg), GFP_KERNEL);
+	if (!cmsg)
+		return -ENOMEM;
+
+	msg = (struct w1_netlink_msg *)(cmsg + 1);
+	cmd = (struct w1_netlink_cmd *)(msg + 1);
+
+	memcpy(cmsg, rcmsg, sizeof(*cmsg));
+	cmsg->len = sizeof(*msg);
+
+	memcpy(msg, rmsg, sizeof(*msg));
+	msg->len = 0;
+	msg->status = (short)-error;
+
+	if (rcmd) {
+		memcpy(cmd, rcmd, sizeof(*cmd));
+		cmd->len = 0;
+		msg->len += sizeof(*cmd);
+		cmsg->len += sizeof(*cmd);
+	}
+
+	error = cn_netlink_send(cmsg, 0, GFP_KERNEL);
+	kfree(cmsg);
+
+	return error;
+}
+
 static void w1_cn_callback(void *data)
 {
 	struct cn_msg *msg = data;
@@ -289,6 +322,7 @@ static void w1_cn_callback(void *data)
 
 		dev = NULL;
 		sl = NULL;
+		cmd = NULL;
 
 		memcpy(&id, m->id.id, sizeof(id));
 #if 0
@@ -336,9 +370,12 @@ static void w1_cn_callback(void *data)
 			}
 
 			if (sl)
-				w1_process_command_slave(sl, msg, m, cmd);
+				err = w1_process_command_slave(sl, msg, m, cmd);
 			else
-				w1_process_command_master(dev, msg, m, cmd);
+				err = w1_process_command_master(dev, msg, m, cmd);
+
+			w1_netlink_send_error(msg, m, cmd, err);
+			err = 0;
 
 			cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
 			mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
@@ -349,6 +386,8 @@ out_up:
 			atomic_dec(&sl->refcnt);
 		mutex_unlock(&dev->mutex);
 out_cont:
+		if (!cmd || err)
+			w1_netlink_send_error(msg, m, cmd, err);
 		msg->len -= sizeof(struct w1_netlink_msg) + m->len;
 		m = (struct w1_netlink_msg *)(((u8 *)m) + sizeof(struct w1_netlink_msg) + m->len);
 
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index 68a4ff4..27e950f 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -40,7 +40,7 @@ enum w1_netlink_message_types {
 struct w1_netlink_msg
 {
 	__u8				type;
-	__u8				reserved;
+	__u8				status;
 	__u16				len;
 	union {
 		__u8			id[8];
-- 
1.5.6.3

