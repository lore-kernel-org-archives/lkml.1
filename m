Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbYGHRCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbYGHRCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbYGHQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:58:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:37991 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbYGHQ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:58:13 -0400
Date: Tue, 8 Jul 2008 09:53:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 13/17] Use WARN() in drivers/base/
Message-ID: <20080708095307.6423cb6f@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in drivers/base 

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>Index: linux.trees.git/drivers/base/core.c
===================================================================
---
 drivers/base/core.c   |    6 ++----
 drivers/base/memory.c |    3 +--
 drivers/base/sys.c    |   12 ++++--------
 3 files changed, 7 insertions(+), 14 deletions(-)

Index: linux.trees.git/drivers/base/core.c
===================================================================
--- linux.trees.git.orig/drivers/base/core.c
+++ linux.trees.git/drivers/base/core.c
@@ -116,12 +116,10 @@ static void device_release(struct kobjec
 		dev->type->release(dev);
 	else if (dev->class && dev->class->dev_release)
 		dev->class->dev_release(dev);
-	else {
-		printk(KERN_ERR "Device '%s' does not have a release() "
+	else
+		WARN(1, KERN_ERR "Device '%s' does not have a release() "
 			"function, it is broken and must be fixed.\n",
 			dev->bus_id);
-		WARN_ON(1);
-	}
 }
 
 static struct kobj_type device_ktype = {
Index: linux.trees.git/drivers/base/sys.c
===================================================================
--- linux.trees.git.orig/drivers/base/sys.c
+++ linux.trees.git/drivers/base/sys.c
@@ -168,19 +168,16 @@ int sysdev_driver_register(struct sysdev
 	int err = 0;
 
 	if (!cls) {
-		printk(KERN_WARNING "sysdev: invalid class passed to "
+		WARN(1, KERN_WARNING "sysdev: invalid class passed to "
 			"sysdev_driver_register!\n");
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
 	/* Check whether this driver has already been added to a class. */
-	if (drv->entry.next && !list_empty(&drv->entry)) {
-		printk(KERN_WARNING "sysdev: class %s: driver (%p) has already"
+	if (drv->entry.next && !list_empty(&drv->entry))
+		WARN(1, KERN_WARNING "sysdev: class %s: driver (%p) has already"
 			" been registered to a class, something is wrong, but "
 			"will forge on!\n", cls->name, drv);
-		WARN_ON(1);
-	}
 
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
@@ -194,8 +191,7 @@ int sysdev_driver_register(struct sysdev
 		}
 	} else {
 		err = -EINVAL;
-		printk(KERN_ERR "%s: invalid device class\n", __func__);
-		WARN_ON(1);
+		WARN(1, KERN_ERR "%s: invalid device class\n", __func__);
 	}
 	mutex_unlock(&sysdev_drivers_lock);
 	return err;
Index: linux.trees.git/drivers/base/memory.c
===================================================================
--- linux.trees.git.orig/drivers/base/memory.c
+++ linux.trees.git/drivers/base/memory.c
@@ -189,9 +189,8 @@ memory_block_action(struct memory_block 
 			}
 			break;
 		default:
-			printk(KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
+			WARN(1, KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
 					__func__, mem, action, action);
-			WARN_ON(1);
 			ret = -EINVAL;
 	}
 
