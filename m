Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbXEJOpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbXEJOpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXEJOp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:45:29 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:63169 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXEJOp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fVoBV7UkQg7otP2HVkfw7k2Pk5VMq91bXnf6+fypbJO3u1+ikzjOywWEX6KWXMZGVmKgtdx/OmCWfEFgpxZ/DqfpInpcggBpGdoZiRSW4UPioFwOrtNLYgIgL4xg6PAEeF+XzfCxUUXKrs/+Cg6lmzPBStidfCnazhNGjB2e/M0=
Message-ID: <46432FFD.1040304@gmail.com>
Date: Thu, 10 May 2007 16:45:17 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [PATCH] driver-core: don't free devt_attr till the device is released
References: <602729.80444.qm@web52910.mail.re2.yahoo.com> <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com> <4641E245.7040603@gmail.com> <20070509154039.GA27681@kroah.com>
In-Reply-To: <20070509154039.GA27681@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, devt_attr for the "dev" file is freed immediately on device
removal, but if the "dev" sysfs file is open when a device is removed,
sysfs will access its attribute structure for further access including
close resulting in jumping to garbled address.  Fix it by postponing
freeing devt_attr to device release time.

Note that devt_attr for class_device is already freed on release.

This bug is reported by Chris Rankin as bugzilla bug#8198.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Chris Rankin <rankincj@yahoo.com>
---
Applies well to 2.6.20 and 21.  As sysfs-immediate-disconnect doesn't
seem to be included in 2.6.22, this should be included in linus#master
too (applies well there as well).

* This is the second post.  Something went wrong with the recipients
  list on the first posting.  Both are same.

Thanks.

 drivers/base/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: tree0/drivers/base/core.c
===================================================================
--- tree0.orig/drivers/base/core.c
+++ tree0/drivers/base/core.c
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
