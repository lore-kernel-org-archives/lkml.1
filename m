Return-Path: <linux-kernel-owner+w=401wt.eu-S966649AbXFHHUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966649AbXFHHUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937843AbXFHHRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:13 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33139 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937817AbXFHHRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:09 -0400
Message-Id: <20070608071537.858994000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       Chris Rankin <rankincj@yahoo.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 08/32] driver-core: dont free devt_attr till the device is released
Content-Disposition: inline; filename=driver-core-don-t-free-devt_attr-till-the-device-is-released.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tejun Heo <htejun@gmail.com>

Currently, devt_attr for the "dev" file is freed immediately on device
removal, but if the "dev" sysfs file is open when a device is removed,
sysfs will access its attribute structure for further access including
close resulting in jumping to garbled address.  Fix it by postponing
freeing devt_attr to device release time.

Note that devt_attr for class_device is already freed on release.

This bug is reported by Chris Rankin as bugzilla bug#8198.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Chris Rankin <rankincj@yahoo.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
Applies well to 2.6.20 and 21.  As sysfs-immediate-disconnect doesn't
seem to be included in 2.6.22, this should be included in linus#master
too (applies well there as well).

 drivers/base/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.20.13.orig/drivers/base/core.c
+++ linux-2.6.20.13/drivers/base/core.c
@@ -93,6 +93,9 @@ static void device_release(struct kobjec
 {
 	struct device * dev = to_dev(kobj);
 
+	kfree(dev->devt_attr);
+	dev->devt_attr = NULL;
+
 	if (dev->release)
 		dev->release(dev);
 	else if (dev->class && dev->class->dev_release)
@@ -650,10 +653,8 @@ void device_del(struct device * dev)
 
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (dev->devt_attr) {
+	if (dev->devt_attr)
 		device_remove_file(dev, dev->devt_attr);
-		kfree(dev->devt_attr);
-	}
 	if (dev->class) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		/* If this is not a "fake" compatible device, remove the

-- 
