Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYA3Bzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYA3Bzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYA3Bz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:55:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:45086 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYA3Bz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:55:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=lb6H2k7XFcUWgU+Hu9VnjDjVsknWKXJWM4ZXUdeZLmWBinKVl7WMkOABmSHWpePWZ4l1ng8jbjEg41HERMT4h9jK/MTGHU1+eVy/dHNu1h582zPQA/2xwl2bUrRg7jh/wOFSOHZUg28Qu+3ey7XlFuCTtLgJYZL+XFKmQkCAcYA=
Date: Wed, 30 Jan 2008 09:56:25 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] driver-core : get_device before create/remove sysfs files
Message-ID: <20080130015625.GA3058@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get dev reference before create/remove sysfiles, errno fixes as well.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/base/core.c |   12 ++++++++----
1 file changed, 8 insertions(+), 4 deletions(-)

diff -upr a/drivers/base/core.c b/drivers/base/core.c
--- a/drivers/base/core.c	2008-01-30 09:49:56.000000000 +0800
+++ b/drivers/base/core.c	2008-01-30 09:49:56.000000000 +0800
@@ -414,7 +414,7 @@ struct kset *devices_kset;
  */
 int device_create_file(struct device *dev, struct device_attribute *attr)
 {
-	int error = 0;
+	int error = -ENODEV;
 	if (get_device(dev)) {
 		error = sysfs_create_file(&dev->kobj, &attr->attr);
 		put_device(dev);
@@ -442,9 +442,11 @@ void device_remove_file(struct device *d
  */
 int device_create_bin_file(struct device *dev, struct bin_attribute *attr)
 {
-	int error = -EINVAL;
-	if (dev)
+	int error = -ENODEV;
+	if (get_device(dev)) {
 		error = sysfs_create_bin_file(&dev->kobj, attr);
+		put_device(dev);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(device_create_bin_file);
@@ -456,8 +458,10 @@ EXPORT_SYMBOL_GPL(device_create_bin_file
  */
 void device_remove_bin_file(struct device *dev, struct bin_attribute *attr)
 {
-	if (dev)
+	if (get_device(dev)) {
 		sysfs_remove_bin_file(&dev->kobj, attr);
+		put_device(dev);
+	}
 }
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
