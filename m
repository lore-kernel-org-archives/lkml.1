Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYBFQPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYBFQPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYBFQPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:15:38 -0500
Received: from sacred.ru ([62.205.161.221]:58793 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYBFQPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:15:37 -0500
Message-ID: <47A9DD30.5040604@openvz.org>
Date: Wed, 06 Feb 2008 19:15:44 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][USBATM]: convert heavy init dances to kthread API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 06 Feb 2008 19:15:25 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to kill two birds with one stone.

First, we kill one more user of kernel_thread. Second - we kill
one of the last users of kill_proc - the function which is also
to be removed, because it uses a pid_t which is not safe now.

The problem is that I couldn't find the maintainer for the code 
in drivers/usb/atm/. Besides, I don't have a proper hardware to 
test this.

So, who should I send this patch for review/testing?

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index e717f5b..a99469a 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -80,6 +80,7 @@
 #include <linux/stat.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
+#include <linux/kthread.h>
 
 #ifdef VERBOSE_DEBUG
 static int usbatm_print_packet(const unsigned char *data, int len);
@@ -1014,11 +1015,7 @@ static int usbatm_do_heavy_init(void *arg)
 	struct usbatm_data *instance = arg;
 	int ret;
 
-	daemonize(instance->driver->driver_name);
 	allow_signal(SIGTERM);
-	instance->thread_pid = current->pid;
-
-	complete(&instance->thread_started);
 
 	ret = instance->driver->heavy_init(instance, instance->usb_intf);
 
@@ -1026,7 +1023,7 @@ static int usbatm_do_heavy_init(void *arg)
 		ret = usbatm_atm_init(instance);
 
 	mutex_lock(&instance->serialize);
-	instance->thread_pid = -1;
+	instance->thread = NULL;
 	mutex_unlock(&instance->serialize);
 
 	complete_and_exit(&instance->thread_exited, ret);
@@ -1034,15 +1031,15 @@ static int usbatm_do_heavy_init(void *arg)
 
 static int usbatm_heavy_init(struct usbatm_data *instance)
 {
-	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
-
-	if (ret < 0) {
-		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
-		return ret;
-	}
+	struct task_struct *t;
 
-	wait_for_completion(&instance->thread_started);
+	t = kthread_create(usbatm_do_heavy_init, instance,
+			instance->driver->driver_name);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
 
+	instance->thread = t;
+	wake_up_process(t);
 	return 0;
 }
 
@@ -1124,8 +1121,7 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 	kref_init(&instance->refcount);		/* dropped in usbatm_usb_disconnect */
 	mutex_init(&instance->serialize);
 
-	instance->thread_pid = -1;
-	init_completion(&instance->thread_started);
+	instance->thread = NULL;
 	init_completion(&instance->thread_exited);
 
 	INIT_LIST_HEAD(&instance->vcc_list);
@@ -1287,8 +1283,8 @@ void usbatm_usb_disconnect(struct usb_interface *intf)
 
 	mutex_lock(&instance->serialize);
 	instance->disconnected = 1;
-	if (instance->thread_pid >= 0)
-		kill_proc(instance->thread_pid, SIGTERM, 1);
+	if (instance->thread != NULL)
+		send_sig(SIGTERM, instance->thread, 1);
 	mutex_unlock(&instance->serialize);
 
 	wait_for_completion(&instance->thread_exited);
diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index ff8551e..62a46fc 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -176,8 +176,7 @@ struct usbatm_data {
 	int disconnected;
 
 	/* heavy init */
-	int thread_pid;
-	struct completion thread_started;
+	struct task_struct *thread;
 	struct completion thread_exited;
 
 	/* ATM device */
