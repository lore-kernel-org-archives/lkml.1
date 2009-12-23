Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZLWMtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZLWMtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZLWMta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:49:30 -0500
Received: from mx1.moondrake.net ([212.85.150.166]:35230 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbZLWMt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:49:28 -0500
X-Greylist: delayed 1288 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Dec 2009 07:49:28 EST
X-Spam-Virus: No
Message-ID: <4B320CAA.1030708@mandriva.com>
Date: Wed, 23 Dec 2009 10:27:22 -0200
From: Eugeni Dodonov <eugeni@mandriva.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091211 Mandriva/3.0-4mdv2010.1 (2010.1) Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: PATCH: asus_oled oops in 2.6.32.2
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After updating to 2.6.32 kernel, I started experiencing Oopses caused by
the asus_oled module. After quick investigation, I wrapped this simple
patch which fixes an Oops in by asus_oled module on 2.6.32.2 kernel,
caused by incorrect usage of strict_strtoul function call within
set_enabled and set_disabled functions. This can be triggered by simple
running the userspace client for asus_old (e.g., 'asusoled -e' or
'asusoled -d').

--- drivers/staging/asus_oled/asus_oled.c.ori	2009-12-23
08:56:09.454535290 -0200
+++ drivers/staging/asus_oled/asus_oled.c	2009-12-23 09:04:12.591283411
-0200
@@ -194,9 +194,11 @@
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct asus_oled_dev *odev = usb_get_intfdata(intf);
-	int temp = strict_strtoul(buf, 10, NULL);
+	unsigned long value;
+	if (strict_strtoul(buf, 10, &value))
+		return -EINVAL;

-	enable_oled(odev, temp);
+	enable_oled(odev, value);

 	return count;
 }
@@ -207,10 +209,12 @@
 {
 	struct asus_oled_dev *odev =
 		(struct asus_oled_dev *) dev_get_drvdata(device);
+	unsigned long value;

-	int temp = strict_strtoul(buf, 10, NULL);
+	if (strict_strtoul(buf, 10, &value))
+		return -EINVAL;

-	enable_oled(odev, temp);
+	enable_oled(odev, value);

 	return count;
 }

Please let me know if you need more info.

Thanks.

-- 
Eugeni Dodonov
