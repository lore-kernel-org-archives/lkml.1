Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYEOBRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYEOBRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbYEOBQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:16:22 -0400
Received: from mail.vyatta.com ([216.93.170.194]:50101 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbYEOBQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:16:18 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.507
Date: Wed, 14 May 2008 18:16:03 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       fubar@us.ibm.com
Cc: netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sysfs: remove error messages for -EEXIST case
Message-ID: <20080514181603.411e834f@extreme>
In-Reply-To: <20080514181257.74fbb5aa@extreme>
References: <20080514170316.672f809d@extreme>
 <20080514181257.74fbb5aa@extreme>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that the entry in sysfs already exists, one case of this is
when a network device is renamed to bonding_masters. Anyway, in this case
the proper error path is for device_rename to return an error code, not to
generate bogus backtrace and errors.

Also, to avoid possible races, the create link should be done before the
remove link. This makes a device rename atomic operation like other renames.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/base/core.c	2008-05-14 17:56:36.000000000 -0700
+++ b/drivers/base/core.c	2008-05-14 17:56:40.000000000 -0700
@@ -1218,13 +1218,11 @@ int device_rename(struct device *dev, ch
 	}
 #else
 	if (dev->class) {
-		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
 		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
 					  dev->bus_id);
-		if (error) {
-			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
-				__func__, error);
-		}
+		if (error)
+			goto out;
+		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
 	}
 #endif
 
--- a/fs/sysfs/dir.c	2008-05-14 17:56:36.000000000 -0700
+++ b/fs/sysfs/dir.c	2008-05-14 17:56:40.000000000 -0700
@@ -419,12 +419,8 @@ void sysfs_addrm_start(struct sysfs_addr
  */
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
-		printk(KERN_WARNING "sysfs: duplicate filename '%s' "
-		       "can not be created\n", sd->s_name);
-		WARN_ON(1);
+	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
 		return -EEXIST;
-	}
 
 	sd->s_parent = sysfs_get(acxt->parent_sd);
 
