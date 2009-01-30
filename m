Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZA3MFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZA3MFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZA3MFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:05:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:34579 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751702AbZA3MFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:05:01 -0500
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX19VFEpinMRV9AaafP0YLD4O5xQuY00QxUftcMPkJk
	OCzhvAwe7cXoL4
Date: Fri, 30 Jan 2009 13:04:56 +0100
From: Richard Atterer <atterer@debian.org>
To: linux-kernel@vger.kernel.org
Cc: vojtech@ucw.cz, linux-input@vger.kernel.org, dtor@mail.ru,
       rubini@vision.unipv.it, jkosina@suse.cz
Subject: [PATCH 2.6.28] mousedev: Allow devices to be excluded from
	/dev/input/mice
Message-ID: <20090130120456.GA20461@arbonne.lan>
Mail-Followup-To: linux-kernel@vger.kernel.org, vojtech@ucw.cz,
	linux-input@vger.kernel.org, dtor@mail.ru, rubini@ipvvis.unipv.it,
	jkosina@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Atterer <atterer@debian.org>

Allow devices to be excluded from /dev/input/mice

This patch adds an "ignoreid=0x1234:0x5678" parameter to the mousedev 
module. If a mouse matches the given device ID(s), its movement and button 
presses will not be relayed via /dev/input/mice.

Why is this needed? In my case, I'm using some mice as sensors (robotic 
application, more or less), so their movement should not influence the 
mouse pointer at all. I could simply specify only my main mouse in 
xorg.conf rather than /dev/input/mice. However, /dev/input/mice is the only 
way to allow hot-plugging of mice with X.

This feature could also be used to disable non-working/buggy touchpads in 
laptops.

As soon as the "ignoreid" parameter is used, the code also prints out 
information on devices that it does *not* ignore, to help users find out 
the device IDs they may want to blacklist.

mousedev is usually compiled into the kernel rather than as a module, so I 
would have liked to make the sysfs permissions for the parameter 0644 
rather than 0444. However, I believe there may be a bug in the code for 
array-of-charp parameters which prevents this from working:
After setting up the array via an "echo" to the sysfs file, only the number 
of array entries is set correctly, the strings themselves are usually empty 
or point to garbage. I don't think my own code is at fault here!? :-/

  Richard

Signed-off-by: Richard Atterer <atterer@debian.org>
---
 mousedev.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
--- a/drivers/input/mousedev.c	2008-12-25 00:26:37.000000000 +0100
+++ b/drivers/input/mousedev.c	2009-01-26 22:36:06.417673499 +0100
@@ -49,6 +49,18 @@ static unsigned tap_time = 200;
 module_param(tap_time, uint, 0644);
 MODULE_PARM_DESC(tap_time, "Tap time for touchpads in absolute mode (msecs)");
 
+static char* ignoreid[8];
+static int ignoreid_count;
+/* Would like to make this 0644, but overwriting via sysfs seems buggy: */
+module_param_array(ignoreid, charp, &ignoreid_count, 0444);
+MODULE_PARM_DESC(ignoreid, "Specify input IDs of mouse devices which"
+		" should not be included in /dev/input/mice, as a"
+		" comma-separated list of \"idVendor:idProduct\" pairs,"
+		" e.g. ignoreid=idVendor0:idProduct0,idVendor1:idProduct1"
+		" where both idVendor and idProduct are hex with a 0x"
+		" prefix. Changes after module load time only work for"
+		" devices that are not yet plugged in.");
+
 struct mousedev_hw_data {
 	int dx, dy, dz;
 	int x, y;
@@ -962,6 +974,22 @@ static void mixdev_remove_device(struct 
 	put_device(&mousedev->dev);
 }
 
+static int mixdev_ignore(struct input_dev *dev) {
+	u16 idVendor, idProduct;
+	int i;
+	for (i = 0; i < ignoreid_count; ++i) {
+		int m = sscanf(ignoreid[i], "0x%hx:0x%hx", &idVendor, &idProduct);
+		if (m != 2) {
+			printk(KERN_WARNING "mousedev: Could not parse"
+			       " ignoreid param #%d \"%s\"\n", i, ignoreid[i]);
+			continue;
+		}
+		if (dev->id.vendor == idVendor && dev->id.product == idProduct)
+			return 1;
+	}
+	return 0;
+}
+
 static int mousedev_connect(struct input_handler *handler,
 			    struct input_dev *dev,
 			    const struct input_device_id *id)
@@ -970,6 +998,18 @@ static int mousedev_connect(struct input
 	int minor;
 	int error;
 
+	if (ignoreid_count) {
+		if (mixdev_ignore(dev)) {
+			printk(KERN_INFO "mousedev: Ignoring device"
+				" 0x%04x:0x%04x for /dev/input/mice\n",
+				dev->id.vendor, dev->id.product);
+			return 0;
+		}
+		printk(KERN_INFO "mousedev: Including device"
+			" 0x%04x:0x%04x in /dev/input/mice\n",
+			dev->id.vendor, dev->id.product);
+	}
+
 	for (minor = 0; minor < MOUSEDEV_MINORS; minor++)
 		if (!mousedev_table[minor])
 			break;
