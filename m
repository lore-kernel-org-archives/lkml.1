Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbYLEMkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbYLEMkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYLEMkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:40:45 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:21245 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYLEMko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:40:44 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [W1] Added touch block command.
Date: Fri,  5 Dec 2008 15:41:26 +0300
Message-Id: <12284808902058-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1228480889246-git-send-email-zbr@ioremap.net>
References: <1228480888739-git-send-email-zbr@ioremap.net>
 <1228480889246-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writes and returns sampled data back to userspace.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1.h         |    1 +
 drivers/w1/w1_io.c      |   26 +++++++++++++++++++++++++-
 drivers/w1/w1_netlink.c |   13 +++++++++----
 drivers/w1/w1_netlink.h |    1 +
 4 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 97304bd..d8a9709 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -210,6 +210,7 @@ u8 w1_read_8(struct w1_master *);
 int w1_reset_bus(struct w1_master *);
 u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);
+void w1_touch_block(struct w1_master *, u8 *, int);
 u8 w1_read_block(struct w1_master *, u8 *, int);
 int w1_reset_select_slave(struct w1_slave *sl);
 void w1_next_pullup(struct w1_master *, int);
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 0d15b0e..3d781f8 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -238,7 +238,6 @@ EXPORT_SYMBOL_GPL(w1_read_8);
  * @param dev     the master device
  * @param buf     pointer to the data to write
  * @param len     the number of bytes to write
- * @return        the byte read
  */
 void w1_write_block(struct w1_master *dev, const u8 *buf, int len)
 {
@@ -256,6 +255,31 @@ void w1_write_block(struct w1_master *dev, const u8 *buf, int len)
 EXPORT_SYMBOL_GPL(w1_write_block);
 
 /**
+ * Touches a series of bytes.
+ *
+ * @param dev     the master device
+ * @param buf     pointer to the data to write
+ * @param len     the number of bytes to write
+ */
+void w1_touch_block(struct w1_master *dev, u8 *buf, int len)
+{
+	int i, j;
+	u8 tmp;
+
+	for (i = 0; i < len; ++i) {
+		tmp = 0;
+		for (j = 0; j < 8; ++j) {
+			if (j == 7)
+				w1_pre_write(dev);
+			tmp |= w1_touch_bit(dev, (buf[i] >> j) & 0x1) << j;
+		}
+
+		buf[i] = tmp;
+	}
+}
+EXPORT_SYMBOL_GPL(w1_touch_block);
+
+/**
  * Reads a series of bytes.
  *
  * @param dev     the master device
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index a3b2630..cae556c 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -108,6 +108,10 @@ static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
 		cmd->cmd, cmd->len);
 
 	switch (cmd->cmd) {
+		case W1_CMD_TOUCH:
+			w1_touch_block(sl->master, cmd->data, cmd->len);
+			w1_send_read_reply(sl, msg, hdr, cmd);
+			break;
 		case W1_CMD_READ:
 			w1_read_block(sl->master, cmd->data, cmd->len);
 			w1_send_read_reply(sl, msg, hdr, cmd);
@@ -208,9 +212,6 @@ static void w1_cn_callback(void *data)
 			break;
 		}
 
-		if (!mlen)
-			goto out_cont;
-
 		if (m->type == W1_MASTER_CMD) {
 			dev = w1_search_master_id(m->id.mst.id);
 		} else if (m->type == W1_SLAVE_CMD) {
@@ -227,6 +228,10 @@ static void w1_cn_callback(void *data)
 			goto out_cont;
 		}
 
+		err = 0;
+		if (!mlen)
+			goto out_cont;
+
 		mutex_lock(&dev->mutex);
 
 		if (sl && w1_reset_select_slave(sl)) {
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index 21913df..99dd21b 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -56,6 +56,7 @@ struct w1_netlink_msg
 #define W1_CMD_WRITE		0x1
 #define W1_CMD_SEARCH		0x2
 #define W1_CMD_ALARM_SEARCH	0x3
+#define W1_CMD_TOUCH		0x4
 
 struct w1_netlink_cmd
 {
-- 
1.5.2.5

