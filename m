Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZGOWOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZGOWOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZGOWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:14:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52560 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZGOWOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:14:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] connector: make callback argument type explicit
Date: Wed, 15 Jul 2009 18:14:07 -0400
Message-Id: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The connector documentation states that the argument to the callback
function is always a pointer to a struct cn_msg, but rather than encode it
in the API itself, it uses a void pointer everywhere.  This doesn't make
much sense to encode the pointer in documentation as it prevents proper C
type checking from occurring and can easily allow people to use the wrong
pointer type.  So convert the argument type to an explicit struct cn_msg
pointer.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/connector/cn_test.c |    4 +---
 drivers/connector/cn_proc.c       |    3 +--
 drivers/connector/cn_queue.c      |    7 +++++--
 drivers/connector/connector.c     |    6 +++---
 drivers/staging/dst/dcore.c       |    3 +--
 drivers/video/uvesafb.c           |    3 +--
 drivers/w1/w1_netlink.c           |    3 +--
 include/linux/connector.h         |    6 +++---
 8 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
index f688eba..50d5ce4 100644
--- a/Documentation/connector/cn_test.c
+++ b/Documentation/connector/cn_test.c
@@ -32,10 +32,8 @@ static char cn_test_name[] = "cn_test";
 static struct sock *nls;
 static struct timer_list cn_test_timer;
 
-void cn_test_callback(void *data)
+void cn_test_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = (struct cn_msg *)data;
-
 	printk("%s: %lu: idx=%x, val=%x, seq=%u, ack=%u, len=%d: %s.\n",
 	       __func__, jiffies, msg->id.idx, msg->id.val,
 	       msg->seq, msg->ack, msg->len, (char *)msg->data);
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index c5afc98..85e5dc0 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -202,9 +202,8 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
  * cn_proc_mcast_ctl
  * @data: message sent from userspace via the connector
  */
-static void cn_proc_mcast_ctl(void *data)
+static void cn_proc_mcast_ctl(struct cn_msg *msg)
 {
-	struct cn_msg *msg = data;
 	enum proc_cn_mcast_op *mc_op = NULL;
 	int err = 0;
 
diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index c769ef2..d478aef 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -87,7 +87,9 @@ void cn_queue_wrapper(struct work_struct *work)
 	kfree(d->free);
 }
 
-static struct cn_callback_entry *cn_queue_alloc_callback_entry(char *name, struct cb_id *id, void (*callback)(void *))
+static struct cn_callback_entry *
+cn_queue_alloc_callback_entry(char *name, struct cb_id *id,
+			      void (*callback)(struct cn_msg *))
 {
 	struct cn_callback_entry *cbq;
 
@@ -120,7 +122,8 @@ int cn_cb_equal(struct cb_id *i1, struct cb_id *i2)
 	return ((i1->idx == i2->idx) && (i1->val == i2->val));
 }
 
-int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id, void (*callback)(void *))
+int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id,
+			  void (*callback)(struct cn_msg *))
 {
 	struct cn_callback_entry *cbq, *__cbq;
 	int found = 0;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index fd336c5..3f45669 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -269,7 +269,8 @@ static void cn_notify(struct cb_id *id, u32 notify_event)
  *
  * May sleep.
  */
-int cn_add_callback(struct cb_id *id, char *name, void (*callback)(void *))
+int cn_add_callback(struct cb_id *id, char *name,
+		    void (*callback)(struct cn_msg *))
 {
 	int err;
 	struct cn_dev *dev = &cdev;
@@ -351,9 +352,8 @@ static int cn_ctl_msg_equals(struct cn_ctl_msg *m1, struct cn_ctl_msg *m2)
  *
  * Used for notification of a request's processing.
  */
-static void cn_callback(void *data)
+static void cn_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = data;
 	struct cn_ctl_msg *ctl;
 	struct cn_ctl_entry *ent;
 	u32 size;
diff --git a/drivers/staging/dst/dcore.c b/drivers/staging/dst/dcore.c
index fad25b7..8472418 100644
--- a/drivers/staging/dst/dcore.c
+++ b/drivers/staging/dst/dcore.c
@@ -846,10 +846,9 @@ static dst_command_func dst_commands[] = {
 /*
  * Configuration parser.
  */
-static void cn_dst_callback(void *data)
+static void cn_dst_callback(struct cn_msg *msg)
 {
 	struct dst_ctl *ctl;
-	struct cn_msg *msg = data;
 	int err;
 	struct dst_ctl_ack ack;
 	struct dst_node *n = NULL, *tmp;
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index ca5b464..e98baf6 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -67,9 +67,8 @@ static DEFINE_MUTEX(uvfb_lock);
  * find the kernel part of the task struct, copy the registers and
  * the buffer contents and then complete the task.
  */
-static void uvesafb_cn_callback(void *data)
+static void uvesafb_cn_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = data;
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index fdf7285..52ccb3d 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -306,9 +306,8 @@ static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rm
 	return error;
 }
 
-static void w1_cn_callback(void *data)
+static void w1_cn_callback(struct cn_msg *msg)
 {
-	struct cn_msg *msg = data;
 	struct w1_netlink_msg *m = (struct w1_netlink_msg *)(msg + 1);
 	struct w1_netlink_cmd *cmd;
 	struct w1_slave *sl;
diff --git a/include/linux/connector.h b/include/linux/connector.h
index b68d278..47ebf41 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -136,7 +136,7 @@ struct cn_callback_data {
 	void *ddata;
 	
 	void *callback_priv;
-	void (*callback) (void *);
+	void (*callback) (struct cn_msg *);
 
 	void *free;
 };
@@ -167,11 +167,11 @@ struct cn_dev {
 	struct cn_queue_dev *cbdev;
 };
 
-int cn_add_callback(struct cb_id *, char *, void (*callback) (void *));
+int cn_add_callback(struct cb_id *, char *, void (*callback) (struct cn_msg *));
 void cn_del_callback(struct cb_id *);
 int cn_netlink_send(struct cn_msg *, u32, gfp_t);
 
-int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id, void (*callback)(void *));
+int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id, void (*callback)(struct cn_msg *));
 void cn_queue_del_callback(struct cn_queue_dev *dev, struct cb_id *id);
 
 int queue_cn_work(struct cn_callback_entry *cbq, struct work_struct *work);
-- 
1.6.3.3

