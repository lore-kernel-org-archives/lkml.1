Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbZBNNVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbZBNNVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 08:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZBNNV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 08:21:27 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:38355 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZBNNV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 08:21:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=VUS1jyWZa3LqA2/5kOQxjuzAj1wL6pkeK2HcwheZfpPpvZwNrO9usoPlXN3ZV2+uvx
         3wbRGmu18GxLzwo1HxQAovY8+qBk4HuAHAsDuojEte0NCXp0lQ/2ufQGt7w4fMzxv7Yf
         DbemdBagm9ERyMDA3km523tKCebhlA38E9bXo=
Message-ID: <4996C549.4040209@gmail.com>
Date: Sat, 14 Feb 2009 21:21:13 +0800
From: Dave Young <hidave.darkstar@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081010)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb-serial: fix usb_serial_register bug when boot with
 nousb param (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With "nousb" cmdline booting, built-in serial drivers (ie. airecable)
will trigger kernel oops.

Indeed, if nousb, usb_serial_init will failed, and the usb serial bus type
will not be registerd, then usb_serial_register call driver_register
which try to register the driver to a not registered bus.

Here add usb_disabled() check in usb_serial_register to fix it.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/usb/serial/usb-serial.c |    3 +++
1 file changed, 3 insertions(+)

diff -uprN a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c	2009-02-14 18:17:16.111250634 +0800
+++ b/drivers/usb/serial/usb-serial.c	2009-02-14 18:19:42.809343462 +0800
@@ -1230,6 +1230,9 @@ int usb_serial_register(struct usb_seria
 	/* must be called with BKL held */
 	int retval;
 
+	if (usb_disabled())
+		return -ENODEV;
+
 	fixup_generic(driver);
 
 	if (!driver->description)
