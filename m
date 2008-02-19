Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbYBSTsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbYBSTsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbYBSTre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:47:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:36269 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760055AbYBSTrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:47:32 -0500
Subject: patch usb-usbatm-convert-heavy-init-dances-to-kthread-api.patch added to gregkh-2.6 tree
To: xemul@openvz.org, akpm@linux-foundation.org, baldrick.bulk@free.fr,
       baldrick@free.fr, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Tue, 19 Feb 2008 11:43:45 -0800
In-Reply-To: <47B03EE1.8060806@openvz.org>
Message-ID: <12034502253856@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: usbatm: convert heavy init dances to kthread API

to my gregkh-2.6 tree.  Its filename is

     usb-usbatm-convert-heavy-init-dances-to-kthread-api.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From linux-usb-owner@vger.kernel.org Mon Feb 11 04:29:00 2008
From: Pavel Emelyanov <xemul@openvz.org>
Date: Mon, 11 Feb 2008 15:26:09 +0300
Subject: USB: usbatm: convert heavy init dances to kthread API
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Duncan Sands <baldrick.bulk@free.fr>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Message-ID: <47B03EE1.8060806@openvz.org>


This is an attempt to kill two birds with one stone.

First, we kill one more user of kernel_thread, which is scheduled
for removal. Second - we kill one of the last users of kill_proc -
the function which is also to be removed, because it uses a pid_t
which is not safe now.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Duncan Sands <baldrick@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/atm/usbatm.c |   25 ++++++++++++++-----------
 drivers/usb/atm/usbatm.h |    2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -80,6 +80,7 @@
 #include <linux/stat.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
+#include <linux/kthread.h>
 
 #ifdef VERBOSE_DEBUG
 static int usbatm_print_packet(const unsigned char *data, int len);
@@ -1014,10 +1015,7 @@ static int usbatm_do_heavy_init(void *ar
 	struct usbatm_data *instance = arg;
 	int ret;
 
-	daemonize(instance->driver->driver_name);
 	allow_signal(SIGTERM);
-	instance->thread_pid = current->pid;
-
 	complete(&instance->thread_started);
 
 	ret = instance->driver->heavy_init(instance, instance->usb_intf);
@@ -1026,7 +1024,7 @@ static int usbatm_do_heavy_init(void *ar
 		ret = usbatm_atm_init(instance);
 
 	mutex_lock(&instance->serialize);
-	instance->thread_pid = -1;
+	instance->thread = NULL;
 	mutex_unlock(&instance->serialize);
 
 	complete_and_exit(&instance->thread_exited, ret);
@@ -1034,13 +1032,18 @@ static int usbatm_do_heavy_init(void *ar
 
 static int usbatm_heavy_init(struct usbatm_data *instance)
 {
-	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
+	struct task_struct *t;
 
-	if (ret < 0) {
-		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
-		return ret;
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
@@ -1124,7 +1127,7 @@ int usbatm_usb_probe(struct usb_interfac
 	kref_init(&instance->refcount);		/* dropped in usbatm_usb_disconnect */
 	mutex_init(&instance->serialize);
 
-	instance->thread_pid = -1;
+	instance->thread = NULL;
 	init_completion(&instance->thread_started);
 	init_completion(&instance->thread_exited);
 
@@ -1287,8 +1290,8 @@ void usbatm_usb_disconnect(struct usb_in
 
 	mutex_lock(&instance->serialize);
 	instance->disconnected = 1;
-	if (instance->thread_pid >= 0)
-		kill_proc(instance->thread_pid, SIGTERM, 1);
+	if (instance->thread != NULL)
+		send_sig(SIGTERM, instance->thread, 1);
 	mutex_unlock(&instance->serialize);
 
 	wait_for_completion(&instance->thread_exited);
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -176,7 +176,7 @@ struct usbatm_data {
 	int disconnected;
 
 	/* heavy init */
-	int thread_pid;
+	struct task_struct *thread;
 	struct completion thread_started;
 	struct completion thread_exited;
 


Patches currently in gregkh-2.6 which might be from xemul@openvz.org are

usb/usb-usbatm-convert-heavy-init-dances-to-kthread-api.patch
