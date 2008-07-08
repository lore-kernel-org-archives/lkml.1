Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYGHQ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYGHQ6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYGHQ5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:55112 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbYGHQ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:33 -0400
Date: Tue, 8 Jul 2008 09:56:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 16/17] Usr WARN() in fs/sysfs
Message-ID: <20080708095625.0c0015d3@infradead.org>
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
Subject: Use WARN() instead of printk+WARN_ON in fs/sysfs

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.
Also, with this, one fo the if() sections collapses entirely into
the WARN().

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/sysfs/dir.c   |    5 +----
 fs/sysfs/file.c  |    3 +--
 fs/sysfs/group.c |    3 +--
 3 files changed, 3 insertions(+), 8 deletions(-)

Index: linux.trees.git/fs/sysfs/dir.c
===================================================================
--- linux.trees.git.orig/fs/sysfs/dir.c
+++ linux.trees.git/fs/sysfs/dir.c
@@ -459,11 +459,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt
 	int ret;
 
 	ret = __sysfs_add_one(acxt, sd);
-	if (ret == -EEXIST) {
-		printk(KERN_WARNING "sysfs: duplicate filename '%s' "
+	WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
 		       "can not be created\n", sd->s_name);
-		WARN_ON(1);
-	}
 	return ret;
 }
 
Index: linux.trees.git/fs/sysfs/file.c
===================================================================
--- linux.trees.git.orig/fs/sysfs/file.c
+++ linux.trees.git/fs/sysfs/file.c
@@ -350,9 +350,8 @@ static int sysfs_open_file(struct inode 
 	if (kobj->ktype && kobj->ktype->sysfs_ops)
 		ops = kobj->ktype->sysfs_ops;
 	else {
-		printk(KERN_ERR "missing sysfs attribute operations for "
+		WARN(1, KERN_ERR "missing sysfs attribute operations for "
 		       "kobject: %s\n", kobject_name(kobj));
-		WARN_ON(1);
 		goto err_out;
 	}
 
Index: linux.trees.git/fs/sysfs/group.c
===================================================================
--- linux.trees.git.orig/fs/sysfs/group.c
+++ linux.trees.git/fs/sysfs/group.c
@@ -134,9 +134,8 @@ void sysfs_remove_group(struct kobject *
 	if (grp->name) {
 		sd = sysfs_get_dirent(dir_sd, grp->name);
 		if (!sd) {
-			printk(KERN_WARNING "sysfs group %p not found for "
+			WARN(!sd, KERN_WARNING "sysfs group %p not found for "
 				"kobject '%s'\n", grp, kobject_name(kobj));
-			WARN_ON(!sd);
 			return;
 		}
 	} else

