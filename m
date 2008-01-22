Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYAVF7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYAVF7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYAVF7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:59:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:50647 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYAVF7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:59:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=v7hVZCCdghRdrp5K98tVr24NfpVV4UujLItwCAJ5CIrA/y7MJiq4K2pjhw77HGNt+mhu/BD/Bxyl58pe1iY4N1HfxwgvCEua96N5ciIB/ZFxLzckZLeBwmCVeVjFW+dmSpnPReUmF0iH2toGM/GwoDGWg3Rg+WkpBvZzsc2SnJQ=
Date: Tue, 22 Jan 2008 14:00:34 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: a.zummo@towertech.it
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 4/6] rtc : use class iteration api
Message-ID: <20080122060034.GE3066@darkstar.te-china.tietoenator.com>
References: <20080112095330.GD2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112095330.GD2893@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/rtc/interface.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -upr linux/drivers/rtc/interface.c linux.new/drivers/rtc/interface.c
--- linux/drivers/rtc/interface.c	2008-01-11 18:06:38.000000000 +0800
+++ linux.new/drivers/rtc/interface.c	2008-01-11 18:06:38.000000000 +0800
@@ -251,20 +251,23 @@ void rtc_update_irq(struct rtc_device *r
 }
 EXPORT_SYMBOL_GPL(rtc_update_irq);
 
+static int __rtc_match(struct device *dev, void *data)
+{
+	char *name = (char *)data;
+
+	if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0)
+		return 1;
+	return 0;
+}
+
 struct rtc_device *rtc_class_open(char *name)
 {
 	struct device *dev;
 	struct rtc_device *rtc = NULL;
 
-	down(&rtc_class->sem);
-	list_for_each_entry(dev, &rtc_class->devices, node) {
-		if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0) {
-			dev = get_device(dev);
-			if (dev)
-				rtc = to_rtc_device(dev);
-			break;
-		}
-	}
+	dev = class_find_device(rtc_class, name, __rtc_match);
+	if (dev)
+		rtc = to_rtc_device(dev);
 
 	if (rtc) {
 		if (!try_module_get(rtc->owner)) {
@@ -272,7 +275,6 @@ struct rtc_device *rtc_class_open(char *
 			rtc = NULL;
 		}
 	}
-	up(&rtc_class->sem);
 
 	return rtc;
 }
