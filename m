Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbXDKSUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbXDKSUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXDKSUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:20:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXDKST7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:19:59 -0400
From: Danny Kukawka <dkukawka@suse.de>
Subject: Re: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
To: Jiri Slaby <jirislaby@gmail.com>
Date: Wed, 11 Apr 2007 20:18:30 +0200
References: <22473653910004885@karneval.cz> <200704111505.03625.corentincj@iksaif.net> <461CE6AA.6050806@gmail.com>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net, corentincj@iksaif.net,
       sziwan@users.sourceforge.net
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200704112018.31026.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Corentin CHARY napsal(a):
>> Le Wednesday 11 April 2007 11:33:48 Jiri Slaby, vous avez écrit :
>>> asus_acpi, support F2JE model
>> Just use the new asus-laptop driver =)
>> (see acpi4asus-0.40)
> 
> code seems good, but this is not so good:
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
> #warning "This module does not support 2.6.20 yet, wait for a new release
> #=)" endif
>
> When do you plan to support latest kernels and merge it to mainline?

This patch fixes acpi4asus-0.40 for me at least with 2.6.20 on a ASUS R1F.

Danny

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
---
 asus-laptop.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- acpi4asus-0.40/driver/asus-laptop.c	2007-02-13 17:42:51.000000000 +0100
+++ acpi4asus-0.40/driver/asus-laptop.c	2007-04-11 20:12:49.000000000 +0200
@@ -41,8 +41,8 @@
 # include <linux/autoconf.h>
 #endif
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
-#warning "This module does not support 2.6.20 yet, wait for a new release =)"
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
+#warning "This module does not support 2.6.21 yet, wait for a new release =)"
 #endif
 
 #include <linux/kernel.h>
@@ -226,8 +226,8 @@
 	static void object##_led_set(struct led_classdev *led_cdev,	\
 				     enum led_brightness value);	\
 	static int object##_led_wk;					\
-	static void object##_led_update(void *data);			\
-        DECLARE_WORK(object##_led_work, object##_led_update, NULL);	\
+	static void object##_led_update(struct work_struct *dummy);	\
+        DECLARE_WORK(object##_led_work, object##_led_update);		\
 	static struct led_classdev object##_led = {			\
 		.name           = "asus:" ledname,			\
 		.brightness_set = object##_led_set,			\
@@ -329,7 +329,7 @@
 		object##_led_wk = value;				\
 		queue_work(led_workqueue, &object##_led_work);		\
 	}								\
-	static void object##_led_update(void * data)			\
+	static void object##_led_update(struct work_struct *dummy)	\
 	{								\
 		int value = object##_led_wk;				\
 		write_status(object##_set_handle, value, (mask));	\
@@ -1053,8 +1053,7 @@
 	struct backlight_device *bd;
 
 	if(brightness_set_handle && lcd_switch_handle) {
-		bd = backlight_device_register (ASUS_HOTK_FILE, NULL,
-						&asusbl_data);
+		bd = backlight_device_register (ASUS_HOTK_FILE, NULL, NULL, &asusbl_data);
 
 		if (IS_ERR (bd)) {
 			printk(ASUS_ERR
