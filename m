Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbXJGQXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbXJGQXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXJGQXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:23:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:43345 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbXJGQXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=po6KJnK2GaDtyQ9EcVvv2SXJNDWWQjmHHJcRVbjVQk97H4JhGF7R3s3v02cCD73/r5ZpoxaoYutXqr4wAqTjDgLVJSoc20rynOE6z/aSyh7GLSGweGJqsuQOUGEWHVs/EUTJmHnUNtwu1BKQTN13vOXQTBvf+TmPLNQ7gNDlFA8=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for 2.6.23] Driver core: fix regression with SYSFS_DEPRECTATED
Date: Sun, 7 Oct 2007 12:22:21 -0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710071222.22218.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Driver core: fix SYSF_DEPRECATED breakage for nested classdevs
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

We should only reparent to a class former class devices that
form the base of class hierarchy. Nested devices should still
grow from their real parents.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>
Tested-by: Anssi Hannula <anssi.hannula@gmail.com>
---

Linus,

Please consider applying this patch before releasing 2.6.23. It fixes
a regression in UDEV/HAL caused by conversion of input devices from
class devices to regular devices.

Thanks,

Dmitry

Index: linux/drivers/base/core.c
===================================================================
--- linux.orig/drivers/base/core.c
+++ linux/drivers/base/core.c
@@ -586,9 +586,13 @@ void device_initialize(struct device *de
 static struct kobject * get_device_parent(struct device *dev,
 					  struct device *parent)
 {
-	/* Set the parent to the class, not the parent device */
-	/* this keeps sysfs from having a symlink to make old udevs happy */
-	if (dev->class)
+	/*
+	 * Set the parent to the class, not the parent device
+	 * for topmost devices in class hierarchy.
+	 * This keeps sysfs from having a symlink to make old
+	 * udevs happy
+	 */
+	if (dev->class && (!parent || parent->class != dev->class))
 		return &dev->class->subsys.kobj;
 	else if (parent)
 		return &parent->kobj;

\\
