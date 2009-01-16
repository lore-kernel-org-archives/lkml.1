Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbZAPAQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbZAPAQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZAPAQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:16:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:53979 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbZAPAQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:16:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=lFPQb0aKYxUNQL+OI1ibGJzaAadtftwjOWgTqY3DYpq/0X+6lDnP2aazP5eHL8s1zp
         IRJ/nxuHTVyL4pw4sDitkT3TanbKTr01bRO6jNWTK10ESDfOctrXWhESy5+jWDiX09NL
         dFUHx305RORp1aHRh64q8LhohGOegx2AOj6fQ=
Message-ID: <496fd1d3.0d135e0a.171b.43ea@mx.google.com>
Date: Thu, 15 Jan 2009 16:16:19 -0800 (PST)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: dmitry.torokhov@gmail.com, dtor@mail.ru
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-input@vger.kernel.org
Subject: [PATCH] psmouse: run kpsmoused only while needed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the workqueue tracer, I noticed that kpsmoused receives
rarely (if not never) events.

Currently, when a mouse has to resync, it uses the kpsmoused singlethreaded
workqueue. But recync are rare. While reading an old discussion, it seems
that usual workqueue events can't be used for that purpose because resync
can take too much time and could delay the other works in queue.

But if you have built psmouse driver, this workqueue will always be present
whether you have a ps/2 port or not. And its events are rare.

To avoid this pointless task, this patch makes the kpsmoused a kernel
thread only created on the fly when a recync is needed. Once the recync is done,
this thread will die. So you will almost never see it, and it will not be
an inactive task anymore.

This thread is created through a usual workqueue event (because we can't create
it from interrupt).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/input/mouse/psmouse-base.c |   76 ++++++++++++++++++++++--------------
 drivers/input/mouse/psmouse.h      |    4 +-
 2 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index f8f86de..7b78cee 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/libps2.h>
 #include <linux/mutex.h>
+#include <linux/kthread.h>
 
 #include "psmouse.h"
 #include "synaptics.h"
@@ -104,8 +105,6 @@ static struct attribute_group psmouse_attribute_group = {
  */
 static DEFINE_MUTEX(psmouse_mutex);
 
-static struct workqueue_struct *kpsmoused_wq;
-
 struct psmouse_protocol {
 	enum psmouse_type type;
 	const char *name;
@@ -203,11 +202,6 @@ static psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse)
 	return PSMOUSE_FULL_PACKET;
 }
 
-void psmouse_queue_work(struct psmouse *psmouse, struct delayed_work *work,
-		unsigned long delay)
-{
-	queue_delayed_work(kpsmoused_wq, work, delay);
-}
 
 /*
  * __psmouse_set_state() sets new psmouse state and resets all flags.
@@ -313,7 +307,8 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 		       psmouse->name, psmouse->phys, psmouse->pktcnt);
 		psmouse->badbyte = psmouse->packet[0];
 		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
-		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
+		atomic_inc(&psmouse->nb_recync_pending);
+		schedule_work(&psmouse->resync_work);
 		goto out;
 	}
 
@@ -350,7 +345,8 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 	    time_after(jiffies, psmouse->last + psmouse->resync_time * HZ)) {
 		psmouse->badbyte = psmouse->packet[0];
 		__psmouse_set_state(psmouse, PSMOUSE_RESYNCING);
-		psmouse_queue_work(psmouse, &psmouse->resync_work, 0);
+		atomic_inc(&psmouse->nb_recync_pending);
+		schedule_work(&psmouse->resync_work);
 		goto out;
 	}
 
@@ -979,13 +975,16 @@ static int psmouse_poll(struct psmouse *psmouse)
 
 
 /*
- * psmouse_resync() attempts to re-validate current protocol.
+ * psmouse_resync_thread() attempts to re-validate current protocol.
+ * This thread is created on the fly when needed because its job can take too
+ * much time on events workqueues, and the resync is rare enough to avoid
+ * the need of a private workqueue.
  */
 
-static void psmouse_resync(struct work_struct *work)
+static int psmouse_resync_thread(void *v)
 {
-	struct psmouse *parent = NULL, *psmouse =
-		container_of(work, struct psmouse, resync_work.work);
+	struct psmouse *psmouse = v;
+	struct psmouse *parent = NULL;
 	struct serio *serio = psmouse->ps2dev.serio;
 	psmouse_ret_t rc = PSMOUSE_GOOD_DATA;
 	int failed = 0, enabled = 0;
@@ -1072,6 +1071,30 @@ static void psmouse_resync(struct work_struct *work)
 		psmouse_activate(parent);
  out:
 	mutex_unlock(&psmouse_mutex);
+
+	/*
+	 * While disconnecting, the driver wants to be sure all resync are done
+	 */
+	if (!atomic_dec_return(&psmouse->nb_recync_pending))
+		wake_up(&psmouse->recync_pending_queue);
+	return 0;
+}
+
+/* Launch the recync thread */
+static void psmouse_resync_thread_helper(struct work_struct *work)
+{
+	struct task_struct *t;
+	struct psmouse *psmouse;
+
+	psmouse = container_of(work, struct psmouse, resync_work);
+
+	t = kthread_run(psmouse_resync_thread, psmouse, "kpsmoused");
+	if (t == ERR_PTR(-ENOMEM)) {
+		printk(KERN_WARNING "psmouse.c: failed to create kpsmoused"
+				    " thread\n");
+		if (!atomic_dec_return(&psmouse->nb_recync_pending))
+			wake_up(&psmouse->recync_pending_queue);
+	}
 }
 
 /*
@@ -1120,6 +1143,7 @@ static void psmouse_cleanup(struct serio *serio)
 static void psmouse_disconnect(struct serio *serio)
 {
 	struct psmouse *psmouse, *parent = NULL;
+	DEFINE_WAIT(wait);
 
 	psmouse = serio_get_drvdata(serio);
 
@@ -1131,7 +1155,13 @@ static void psmouse_disconnect(struct serio *serio)
 
 	/* make sure we don't have a resync in progress */
 	mutex_unlock(&psmouse_mutex);
-	flush_workqueue(kpsmoused_wq);
+
+	prepare_to_wait(&psmouse->recync_pending_queue, &wait,
+				TASK_UNINTERRUPTIBLE);
+	if (atomic_read(&psmouse->nb_recync_pending))
+		schedule();
+	finish_wait(&psmouse->recync_pending_queue, &wait);
+
 	mutex_lock(&psmouse_mutex);
 
 	if (serio->parent && serio->id.type == SERIO_PS_PSTHRU) {
@@ -1244,7 +1274,8 @@ static int psmouse_connect(struct serio *serio, struct serio_driver *drv)
 		goto err_free;
 
 	ps2_init(&psmouse->ps2dev, serio);
-	INIT_DELAYED_WORK(&psmouse->resync_work, psmouse_resync);
+	INIT_WORK(&psmouse->resync_work, psmouse_resync_thread_helper);
+	init_waitqueue_head(&psmouse->recync_pending_queue);
 	psmouse->dev = input_dev;
 	snprintf(psmouse->phys, sizeof(psmouse->phys), "%s/input0", serio->phys);
 
@@ -1647,25 +1678,12 @@ static int psmouse_get_maxproto(char *buffer, struct kernel_param *kp)
 
 static int __init psmouse_init(void)
 {
-	int err;
-
-	kpsmoused_wq = create_singlethread_workqueue("kpsmoused");
-	if (!kpsmoused_wq) {
-		printk(KERN_ERR "psmouse: failed to create kpsmoused workqueue\n");
-		return -ENOMEM;
-	}
-
-	err = serio_register_driver(&psmouse_drv);
-	if (err)
-		destroy_workqueue(kpsmoused_wq);
-
-	return err;
+	return serio_register_driver(&psmouse_drv);
 }
 
 static void __exit psmouse_exit(void)
 {
 	serio_unregister_driver(&psmouse_drv);
-	destroy_workqueue(kpsmoused_wq);
 }
 
 module_init(psmouse_init);
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 54ed267..6dc16ba 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -39,7 +39,9 @@ struct psmouse {
 	void *private;
 	struct input_dev *dev;
 	struct ps2dev ps2dev;
-	struct delayed_work resync_work;
+	struct work_struct resync_work;
+	atomic_t nb_recync_pending;
+	wait_queue_head_t recync_pending_queue;
 	char *vendor;
 	char *name;
 	unsigned char packet[8];
-- 
1.6.0.4


