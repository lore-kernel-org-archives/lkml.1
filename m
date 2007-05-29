Return-Path: <linux-kernel-owner+w=401wt.eu-S1764903AbXE2Sxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764903AbXE2Sxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbXE2Sxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:53:30 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4015 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764482AbXE2Sx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:53:29 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: about redundant(?) argument checks
Date: Tue, 29 May 2007 20:53:26 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705292053.27105.m.kozlowski@tuxland.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	I found a couple of places in kernel where the argument of function
is checked right before the function is called but the function does similar
check itself.

ie. backlight_device_unregister() defined in drivers/video/backlight/backlight.c
this way:

266 void backlight_device_unregister(struct backlight_device *bd)
267 {
268         int i;
269 
270         if (!bd)
271                 return;

then if you look at drivers/acpi/asus_acpi.c

1360 static void __exit asus_acpi_exit(void)
1361 {
1362         if (asus_backlight_device)
1363                 backlight_device_unregister(asus_backlight_device);

the check in line 1362 looks redundant. From this point of view it would
be better to remove it. The thing is that when you look at the object
size it actually grows (24 bytes) when the redundant check is removed (why?).

without the patch -> 114368 bytes
with the patch    -> 114392 bytes

(the patch is attached below)

24 bytes is not much but ... ;) Should I dig and send patches for similar
cases or not? Or to put it another way. Is the object size more important
than 'clean' code?

Regards,

	Mariusz



diff -upr linux-2.6.22-rc2-mm1-a/drivers/acpi/asus_acpi.c linux-2.6.22-rc2-mm1-b/drivers/acpi/asus_acpi.c
--- linux-2.6.22-rc2-mm1-a/drivers/acpi/asus_acpi.c	2007-05-19 06:06:17.000000000 +0200
+++ linux-2.6.22-rc2-mm1-b/drivers/acpi/asus_acpi.c	2007-05-29 18:23:58.000000000 +0200
@@ -1359,8 +1359,7 @@ static struct backlight_ops asus_backlig
 
 static void __exit asus_acpi_exit(void)
 {
-	if (asus_backlight_device)
-		backlight_device_unregister(asus_backlight_device);
+	backlight_device_unregister(asus_backlight_device);
 
 	acpi_bus_unregister_driver(&asus_hotk_driver);
 	remove_proc_entry(PROC_ASUS, acpi_root_dir);
