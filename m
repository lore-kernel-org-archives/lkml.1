Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbXI0Hd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbXI0Hd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXI0HdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:33:19 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4965 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbXI0HdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:33:18 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: jkosina@suse.cz
Subject: [PATCH] hid: hidraw_connect memleak fix
Date: Thu, 27 Sep 2007 09:33:12 +0200
User-Agent: KMail/1.9.7
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709270933.13497.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like hidraw_connect() is leaking memory in case of failure.
Also it should return -ENOMEM when kzalloc fails.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/hid/hidraw.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc8-mm1-a/drivers/hid/hidraw.c	2007-09-26 12:07:37.000000000 +0200
+++ linux-2.6.23-rc8-mm1-b/drivers/hid/hidraw.c	2007-09-26 14:36:08.000000000 +0200
@@ -282,7 +282,7 @@ EXPORT_SYMBOL_GPL(hidraw_report_event);

 int hidraw_connect(struct hid_device *hid)
 {
-	int minor, result = -EINVAL;
+	int minor, result;
 	struct hidraw *dev;

 	/* TODO currently we accept any HID device. This should later
@@ -290,8 +290,11 @@ int hidraw_connect(struct hid_device *hi
 	 * non-input applications
 	 */

-	if (!(dev = kzalloc(sizeof(struct hidraw), GFP_KERNEL)))
-		return -1;
+	dev = kzalloc(sizeof(struct hidraw), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	result = -EINVAL;

 	spin_lock(&minors_lock);

@@ -305,8 +308,10 @@ int hidraw_connect(struct hid_device *hi

 	spin_unlock(&minors_lock);

-	if (result)
+	if (result) {
+		kfree(dev);
 		goto out;
+	}

 	dev->dev = device_create(hidraw_class, NULL, MKDEV(hidraw_major, minor),
 				"%s%d", "hidraw", minor);
@@ -316,6 +321,7 @@ int hidraw_connect(struct hid_device *hi
 		hidraw_table[minor] = NULL;
 		spin_unlock(&minors_lock);
 		result = PTR_ERR(dev->dev);
+		kfree(dev);
 		goto out;
 	}

