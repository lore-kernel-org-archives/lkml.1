Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZJMJ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZJMJ32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbZJMJ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:29:26 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52255 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZJMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:28:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 2/7] connector: Provide the sender's credentials to the callback
Date: Tue, 13 Oct 2009 11:28:13 +0200
Message-Id: <1255426098-9411-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1255426098-9411-2-git-send-email-philipp.reisner@linbit.com>
References: <20091009222505.GA28979@kroah.com>
 <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
 <1255426098-9411-2-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/connector/cn_test.c      |    4 +---
 Documentation/connector/connector.txt  |    8 ++++----
 drivers/connector/cn_proc.c            |    3 +--
 drivers/connector/cn_queue.c           |   10 +++++++---
 drivers/connector/connector.c          |    6 +++---
 drivers/md/dm-log-userspace-transfer.c |    3 +--
 drivers/staging/dst/dcore.c            |    3 +--
 drivers/staging/pohmelfs/config.c      |    3 +--
 drivers/video/uvesafb.c                |    3 +--
 drivers/w1/w1_netlink.c                |    3 +--
 include/linux/connector.h              |    6 +++---
 11 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
index 6a5be5d..473c589 100644
--- a/Documentation/connector/cn_test.c
+++ b/Documentation/connector/cn_test.c
@@ -32,10 +32,8 @@ static char cn_test_name[] = "cn_test";
 static struct sock *nls;
 static struct timer_list cn_test_timer;
 
-void cn_test_callback(void *data)
+static void cn_test_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = (struct cn_msg *)data;
-
 	printk("%s: %lu: idx=%x, val=%x, seq=%u, ack=%u, len=%d: %s.\n",
 	       __func__, jiffies, msg->id.idx, msg->id.val,
 	       msg->seq, msg->ack, msg->len, (char *)msg->data);
diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
index ad6e0ba..3e6dcc7 100644
--- a/Documentation/connector/connector.txt
+++ b/Documentation/connector/connector.txt
@@ -23,7 +23,7 @@ handling...  Connector allows any kernelspace agents to use netlink
 based networking for inter-process communication in a significantly
 easier way:
 
-int cn_add_callback(struct cb_id *id, char *name, void (*callback) (void *));
+int cn_add_callback(struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
 void cn_netlink_send(struct cn_msg *msg, u32 __group, int gfp_mask);
 
 struct cb_id
@@ -53,15 +53,15 @@ struct cn_msg
 Connector interfaces.
 /*****************************************/
 
-int cn_add_callback(struct cb_id *id, char *name, void (*callback) (void *));
+int cn_add_callback(struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
 
 Registers new callback with connector core.
 
 struct cb_id *id 		- unique connector's user identifier.
 			  	  It must be registered in connector.h for legal in-kernel users.
 char *name 			- connector's callback symbolic name.
-void (*callback) (void *)	- connector's callback.
-				  Argument must be dereferenced to struct cn_msg *.
+void (*callback) (struct cn..)	- connector's callback.
+				  cn_msg and the sender's credentials
 
 void cn_del_callback(struct cb_id *id);
 
diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index c5afc98..9ca20d0 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -202,9 +202,8 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
  * cn_proc_mcast_ctl
  * @data: message sent from userspace via the connector
  */
-static void cn_proc_mcast_ctl(void *data)
+static void cn_proc_mcast_ctl(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = data;
 	enum proc_cn_mcast_op *mc_op = NULL;
 	int err = 0;
 
diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 327dfde..163c3e3 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -79,8 +79,9 @@ void cn_queue_wrapper(struct work_struct *work)
 		container_of(work, struct cn_callback_entry, work);
 	struct cn_callback_data *d = &cbq->data;
 	struct cn_msg *msg = NLMSG_DATA(nlmsg_hdr(d->skb));
+	struct netlink_skb_parms *nsp = &NETLINK_CB(d->skb);
 
-	d->callback(msg);
+	d->callback(msg, nsp);
 
 	d->destruct_data(d->ddata);
 	d->ddata = NULL;
@@ -88,7 +89,9 @@ void cn_queue_wrapper(struct work_struct *work)
 	kfree(d->free);
 }
 
-static struct cn_callback_entry *cn_queue_alloc_callback_entry(char *name, struct cb_id *id, void (*callback)(void *))
+static struct cn_callback_entry *
+cn_queue_alloc_callback_entry(char *name, struct cb_id *id,
+			      void (*callback)(struct cn_msg *, struct netlink_skb_parms *))
 {
 	struct cn_callback_entry *cbq;
 
@@ -121,7 +124,8 @@ int cn_cb_equal(struct cb_id *i1, struct cb_id *i2)
 	return ((i1->idx == i2->idx) && (i1->val == i2->val));
 }
 
-int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id, void (*callback)(void *))
+int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id,
+			  void (*callback)(struct cn_msg *, struct netlink_skb_parms *))
 {
 	struct cn_callback_entry *cbq, *__cbq;
 	int found = 0;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 9bb14ac..e59f0ab 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -268,7 +268,8 @@ static void cn_notify(struct cb_id *id, u32 notify_event)
  *
  * May sleep.
  */
-int cn_add_callback(struct cb_id *id, char *name, void (*callback)(void *))
+int cn_add_callback(struct cb_id *id, char *name,
+		    void (*callback)(struct cn_msg *, struct netlink_skb_parms *))
 {
 	int err;
 	struct cn_dev *dev = &cdev;
@@ -350,9 +351,8 @@ static int cn_ctl_msg_equals(struct cn_ctl_msg *m1, struct cn_ctl_msg *m2)
  *
  * Used for notification of a request's processing.
  */
-static void cn_callback(void *data)
+static void cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = data;
 	struct cn_ctl_msg *ctl;
 	struct cn_ctl_entry *ent;
 	u32 size;
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index ba0edad..1327e1a 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -129,9 +129,8 @@ static int fill_pkg(struct cn_msg *msg, struct dm_ulog_request *tfr)
  * This is the connector callback that delivers data
  * that was sent from userspace.
  */
-static void cn_ulog_callback(void *data)
+static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = (struct cn_msg *)data;
 	struct dm_ulog_request *tfr = (struct dm_ulog_request *)(msg + 1);
 
 	spin_lock(&receiving_list_lock);
diff --git a/drivers/staging/dst/dcore.c b/drivers/staging/dst/dcore.c
index fad25b7..32f102d 100644
--- a/drivers/staging/dst/dcore.c
+++ b/drivers/staging/dst/dcore.c
@@ -846,10 +846,9 @@ static dst_command_func dst_commands[] = {
 /*
  * Configuration parser.
  */
-static void cn_dst_callback(void *data)
+static void cn_dst_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
 	struct dst_ctl *ctl;
-	struct cn_msg *msg = data;
 	int err;
 	struct dst_ctl_ack ack;
 	struct dst_node *n = NULL, *tmp;
diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index a6eaa42..1b4d564 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -446,9 +446,8 @@ out_unlock:
 	return err;
 }
 
-static void pohmelfs_cn_callback(void *data)
+static void pohmelfs_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = data;
 	int err;
 
 	switch (msg->flags) {
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index ca5b464..aa7cd95 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -67,9 +67,8 @@ static DEFINE_MUTEX(uvfb_lock);
  * find the kernel part of the task struct, copy the registers and
  * the buffer contents and then complete the task.
  */
-static void uvesafb_cn_callback(void *data)
+static void uvesafb_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = data;
 	struct uvesafb_task *utask;
 	struct uvesafb_ktask *task;
 
diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index fdf7285..45c126f 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -306,9 +306,8 @@ static int w1_netlink_send_error(struct cn_msg *rcmsg, struct w1_netlink_msg *rm
 	return error;
 }
 
-static void w1_cn_callback(void *data)
+static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 {
-	struct cn_msg *msg = data;
 	struct w1_netlink_msg *m = (struct w1_netlink_msg *)(msg + 1);
 	struct w1_netlink_cmd *cmd;
 	struct w1_slave *sl;
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 51b9ebd..545728e 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -136,7 +136,7 @@ struct cn_callback_data {
 	void *ddata;
 
 	struct sk_buff *skb;
-	void (*callback) (struct cn_msg *);
+	void (*callback) (struct cn_msg *, struct netlink_skb_parms *);
 
 	void *free;
 };
@@ -167,11 +167,11 @@ struct cn_dev {
 	struct cn_queue_dev *cbdev;
 };
 
-int cn_add_callback(struct cb_id *, char *, void (*callback) (void *));
+int cn_add_callback(struct cb_id *, char *, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
 void cn_del_callback(struct cb_id *);
 int cn_netlink_send(struct cn_msg *, u32, gfp_t);
 
-int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id, void (*callback)(void *));
+int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id, void (*callback)(struct cn_msg *, struct netlink_skb_parms *));
 void cn_queue_del_callback(struct cn_queue_dev *dev, struct cb_id *id);
 
 int queue_cn_work(struct cn_callback_entry *cbq, struct work_struct *work);
-- 
1.6.0.4

