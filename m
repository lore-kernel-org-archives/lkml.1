Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZG3MLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZG3MLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZG3MLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:11:07 -0400
Received: from mail-fx0-f210.google.com ([209.85.220.210]:38755 "EHLO
	mail-fx0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZG3MLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=VwJNFUCXDhAA5LgRJ/qAcV5sP5+BlJM20DqOAxuQ9XIQiWJ6W0dEbCLTxnC0OSxjvZ
         EMAtMnHhgig8B028tcCX8kKjAyUOPNl9U1EJGrb4bo5iDI3nfeHBIt+Cc8Ui2y4SqSfS
         adEAT1PJMAejSJbJUw2i+lNuFp+GFy6btvm98=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: consolidated fixes (NULL pointer checks, [un]registration fixes, etc)
Date: Thu, 30 Jul 2009 14:08:10 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
References: <200907300755.n6U7tM4e001263@mercury.physics.adelaide.edu.au>
In-Reply-To: <200907300755.n6U7tM4e001263@mercury.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907301408.10864.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009 09:55:22 Jonathan Woithe wrote:
> Hi all
> 
> This patch consolidates the two patches posted by Bartlomiej Zolnierkiewicz
> and the NULL pointer patch which came out of a discussion with Julia Lawall.
> Some additional NULL pointer check tidy-ups have also been done.
> 
> To summarise:

I think that for the increased readability and to preserve proper credits it
would be better to keep separate patches (updating the driver version can be
as well handled in an incremental patch).

I would also strongly insist on removing the following needless NULL pointer
checks introduced by this version.  They may hide real bugs in the ACPI driver
code (which should make sure that we always have valid 'device' in the ACPI
driver methods and that it doesn't go away while the method executes) or in
the fujitsu-laptop itself (which has to always provide valid 'fujitsu_hotkey',
'fujitsu' and 'input' pointers and not free them while there are still some
users left).

If this is the case we should fix the underlying problems and not hide them
with the "defensive coding".  While it could (sometimes) help in avoiding
the underlying issue it may also easily result in the whole new bag of issues
resulting from introducing the unexpected code paths and system states, i.e.
ACPI driver code assumes that the ACPI device is no longer used/referenced by
higher-layers (like input layer) and unregistered from the driver after
->remove method finishes -- this assumption will no longer be true in case of
premature return caused by 'device == NULL' check if 'device' is NULL (it will
never be NULL actually, this is just an example to explain the problem with
the "defensive coding" principle).

I understand the sentiment for the "defensive coding" methods (often caused by
the real need for them when working on components for the closed code software)
but they should be avoided in the open source software.

Thanks.

diff -u b/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
--- b/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c	2009-07-30 16:48:45.542784340 +0930
@@ -70,7 +70,7 @@
 #include <linux/leds.h>
 #endif
 
-#define FUJITSU_DRIVER_VERSION "0.5.0"
+#define FUJITSU_DRIVER_VERSION "0.6.0"
 
 #define FUJITSU_LCD_N_LEVELS 8
 
@@ -321,7 +321,7 @@ 	vdbg_printk(FUJLAPTOP_DBG_TRACE, "set lcd level via SBLL [%d]\n",
 		    level);
 
-	if (level < 0 || level >= fujitsu->max_brightness)
+	if (!fujitsu || level < 0 || level >= fujitsu->max_brightness)
 		return -EINVAL;
 
 	status = acpi_get_handle(fujitsu->acpi_handle, "SBLL", &handle);
@@ -349,7 +349,7 @@
 	vdbg_printk(FUJLAPTOP_DBG_TRACE, "set lcd level via SBL2 [%d]\n",
 		    level);
 
-	if (level < 0 || level >= fujitsu->max_brightness)
+	if (!fujitsu || level < 0 || level >= fujitsu->max_brightness)
 		return -EINVAL;
 
 	status = acpi_get_handle(fujitsu->acpi_handle, "SBL2", &handle);
@@ -732,12 +732,21 @@
 
 static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 {
-	struct fujitsu_t *fujitsu = acpi_driver_data(device);
-	struct input_dev *input = fujitsu->input;
+	struct fujitsu_t *fujitsu = NULL;
+	struct input_dev *input = NULL;
 
-	input_unregister_device(input);
+	if (!device)
+		return -EINVAL;
 
-	input_free_device(input);
+        fujitsu = acpi_driver_data(device);
+        if (!fujitsu)
+        	return -EINVAL;
+        input = fujitsu->input;
+
+        if (input) {
+		input_unregister_device(input);
+		input_free_device(input);
+	}
 
 	fujitsu->acpi_handle = NULL;
 
@@ -941,8 +950,16 @@
 
 static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
 {
-	struct fujitsu_hotkey_t *fujitsu_hotkey = acpi_driver_data(device);
-	struct input_dev *input = fujitsu_hotkey->input;
+	struct fujitsu_hotkey_t *fujitsu_hotkey = NULL;
+	struct input_dev *input = NULL;
+
+	if (!device)
+		return -EINVAL;
+	fujitsu_hotkey = acpi_driver_data(device);
+	if (!fujitsu_hotkey)
+		return -EINVAL;
+
+	input = fujitsu_hotkey->input;
 
 #ifdef CONFIG_LEDS_CLASS
 	if (fujitsu_hotkey->logolamp_registered)
@@ -952,9 +969,10 @@
 		led_classdev_unregister(&kblamps_led);
 #endif
 
-	input_unregister_device(input);
-
-	input_free_device(input);
+	if (input) {
+		input_unregister_device(input);
+		input_free_device(input);
+	}
 
 	kfifo_free(fujitsu_hotkey->fifo);
 
