Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYDZPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYDZPxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYDZPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:52:52 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:62257 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbYDZPww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:52:52 -0400
Message-ID: <48134FC3.6040002@aknet.ru>
Date: Sat, 26 Apr 2008 19:52:35 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Linux kernel <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch] detect duplicate drivers
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------060409090607030400070608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060409090607030400070608
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello.

Currently an attempt to register multiple
drivers with the same name causes the
stack trace with some cryptic error message.
The attached patch adds the necessary check
and the clear error message.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>

--------------060409090607030400070608
Content-Type: text/x-patch;
 name="drv_dup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="drv_dup.diff"

--- a/drivers/base/driver.c	2008-04-22 20:51:31.000000000 +0400
+++ b/drivers/base/driver.c	2008-04-26 19:43:26.000000000 +0400
@@ -217,12 +217,22 @@
 int driver_register(struct device_driver *drv)
 {
 	int ret;
+	struct device_driver *other;
 
 	if ((drv->bus->probe && drv->probe) ||
 	    (drv->bus->remove && drv->remove) ||
 	    (drv->bus->shutdown && drv->shutdown))
 		printk(KERN_WARNING "Driver '%s' needs updating - please use "
 			"bus_type methods\n", drv->name);
+
+	other = driver_find(drv->name, drv->bus);
+	if (other) {
+		put_driver(other);
+		printk(KERN_ERR "Error: Driver '%s' is already registered, "
+			"aborting...\n", drv->name);
+		return -EEXIST;
+	}
+
 	ret = bus_add_driver(drv);
 	if (ret)
 		return ret;

--------------060409090607030400070608--
