Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYBKM2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYBKM2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbYBKM2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:28:13 -0500
Received: from sacred.ru ([62.205.161.221]:33855 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbYBKM2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:28:12 -0500
Message-ID: <47B03EE1.8060806@openvz.org>
Date: Mon, 11 Feb 2008 15:26:09 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Duncan Sands <baldrick.bulk@free.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: [PATCH] Usbatm: convert heavy init dances to kthread API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 11 Feb 2008 15:25:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to kill two birds with one stone.

First, we kill one more user of kernel_thread, which is scheduled
for removal. Second - we kill one of the last users of kill_proc -
the function which is also to be removed, because it uses a pid_t
which is not safe now.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Tested-by: Duncan Sands <baldrick.bulk@free.fr>

---

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index e717f5b..0722872 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -80,6 +80,7 @@
 #include <linux/stat.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
+#include <linux/kthread.h>
 
 #ifdef VERBOSE_DEBUG
 static int usbatm_print_packet(const unsigned char *data, int len);
@@ -1014,10 +1015,7 @@ static int usbatm_do_heavy_init(void *arg)
 	struct usbatm_data *instance = arg;
 	int ret;
 
-	daemonize(instance->driver->driver_name);
 	allow_signal(SIGTERM);
-	instance->thread_pid = current->pid;
-
 	complete(&instance->thread_started);
 
 	ret = instance->driver->heavy_init(instance, instance->usb_intf);
@@ -1026,7 +1024,7 @@ static int usbatm_do_heavy_init(void *arg)
 		ret = usbatm_atm_init(instance);
 
 	mutex_lock(&instance->serialize);
-	instance->thread_pid = -1;
+	instance->thread = NULL;
 	mutex_unlock(&instance->serialize);
 
 	complete_and_exit(&instance->thread_exited, ret);
@@ -1034,13 +1032,18 @@ static int usbatm_do_heavy_init(void *arg)
 
 static int usbatm_heavy_init(struct usbatm_data *instance)
 {
-	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
-
-	if (ret < 0) {
-		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
-		return ret;
+	struct task_struct *t;
+
+	t = kthread_create(usbatm_do_heavy_init, instance,
+			instance->driver->driver_name);
+	if (IS_ERR(t)) {
+		usb_err(instance, "%s: failed to create kernel_thread (%ld)!\n",
+				__func__, PTR_ERR(t));
+		return PTR_ERR(t);
 	}
 
+	instance->thread = t;
+	wake_up_process(t);
 	wait_for_completion(&instance->thread_started);
 
 	return 0;
@@ -1124,7 +1127,7 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 	kref_init(&instance->refcount);		/* dropped in usbatm_usb_disconnect */
 	mutex_init(&instance->serialize);
 
-	instance->thread_pid = -1;
+	instance->thread = NULL;
 	init_completion(&instance->thread_started);
 	init_completion(&instance->thread_exited);
 
@@ -1287,8 +1290,8 @@ void usbatm_usb_disconnect(struct usb_interface *intf)
 
 	mutex_lock(&instance->serialize);
 	instance->disconnected = 1;
-	if (instance->thread_pid >= 0)
-		kill_proc(instance->thread_pid, SIGTERM, 1);
+	if (instance->thread != NULL)
+		send_sig(SIGTERM, instance->thread, 1);
 	mutex_unlock(&instance->serialize);
 
 	wait_for_completion(&instance->thread_exited);
diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index ff8551e..d23aca9 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -176,7 +176,7 @@ struct usbatm_data {
 	int disconnected;
 
 	/* heavy init */
-	int thread_pid;
+	struct task_struct *thread;
 	struct completion thread_started;
 	struct completion thread_exited;
 
