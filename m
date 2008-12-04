Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYLDOv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYLDOv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbYLDOuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:50:11 -0500
Received: from cavolo.yandex.ru ([87.250.244.45]:53985 "EHLO cavolo.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbYLDOuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:50:07 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [W1] Added list masters w1 command.
Date: Thu,  4 Dec 2008 17:50:06 +0300
Message-Id: <12284022143564-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <122840221468-git-send-email-zbr@ioremap.net>
References: <12284022104086-git-send-email-zbr@ioremap.net>
 <122840221468-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on cavolo.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1_netlink.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/w1/w1_netlink.h |    1 +
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 65c5ebd..a3b2630 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -128,6 +128,59 @@ static int w1_process_command_slave(struct w1_slave *sl, struct cn_msg *msg,
 	return err;
 }
 
+static int w1_process_command_root(struct cn_msg *msg, struct w1_netlink_msg *mcmd)
+{
+	struct w1_master *m;
+	struct cn_msg *cn;
+	struct w1_netlink_msg *w;
+	u32 *id;
+
+	if (mcmd->type != W1_LIST_MASTERS) {
+		printk(KERN_NOTICE "%s: msg: %x.%x, wrong type: %u, len: %u.\n",
+				__func__, msg->id.idx, msg->id.val, mcmd->type, mcmd->len);
+		return -EPROTO;
+	}
+
+	cn = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cn)
+		return -ENOMEM;
+
+	cn->id.idx = CN_W1_IDX;
+	cn->id.val = CN_W1_VAL;
+
+	cn->seq = msg->seq;
+	cn->ack = 1;
+	cn->len = sizeof(struct w1_netlink_msg);
+	w = (struct w1_netlink_msg *)(cn + 1);
+
+	w->type = W1_LIST_MASTERS;
+	w->reserved = 0;
+	w->len = 0;
+	id = (u32 *)(w + 1);
+
+	mutex_lock(&w1_mlock);
+	list_for_each_entry(m, &w1_masters, w1_master_entry) {
+		if (cn->len + sizeof(*id) > PAGE_SIZE - sizeof(struct cn_msg)) {
+			cn_netlink_send(cn, 0, GFP_KERNEL);
+			cn->ack++
+			cn->len = sizeof(struct w1_netlink_msg);
+			w->len = 0;
+			id = (u32 *)(w + 1);
+		}
+
+		*id = m->id;
+		w->len += sizeof(*id);
+		cn->len += sizeof(*id);
+		id++;
+	}
+	cn->ack = 0;
+	cn_netlink_send(cn, 0, GFP_KERNEL);
+	mutex_unlock(&w1_mlock);
+
+	kfree(cn);
+	return 0;
+}
+
 static void w1_cn_callback(void *data)
 {
 	struct cn_msg *msg = data;
@@ -164,6 +217,9 @@ static void w1_cn_callback(void *data)
 			sl = w1_search_slave(&id);
 			if (sl)
 				dev = sl->master;
+		} else {
+			err = w1_process_command_root(msg, m);
+			goto out_cont;
 		}
 
 		if (!dev) {
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index 56122b9..21913df 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -34,6 +34,7 @@ enum w1_netlink_message_types {
 	W1_MASTER_REMOVE,
 	W1_MASTER_CMD,
 	W1_SLAVE_CMD,
+	W1_LIST_MASTERS,
 };
 
 struct w1_netlink_msg
-- 
1.5.2.5

