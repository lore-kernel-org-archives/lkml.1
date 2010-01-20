Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173Ab0ATXuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0ATXuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144Ab0ATXuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:10 -0500
Received: from kroah.org ([198.145.64.141]:33617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0ATXuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] Revert "sysdev: fix prototype for memory_sysdev_class show/store functions"
Date: Wed, 20 Jan 2010 15:49:19 -0800
Message-Id: <1264031359-32196-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234753.GB32068@kroah.com>
References: <20100120234753.GB32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 8ff410daa009c4b44be445ded5b0cec00abc0426

It should not have been sent to Linus's tree yet, as it depends
on changes that are queued up in my driver-core for the .34 kernel
merge.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "Zheng, Shaohui" <shaohui.zheng@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index ae6b6c4..bd02505 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -309,19 +309,17 @@ static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
  * Block size attribute stuff
  */
 static ssize_t
-print_block_size(struct sysdev_class *class,
-		 struct sysdev_class_attribute *class_attr,
-		 char *buf)
+print_block_size(struct class *class, char *buf)
 {
 	return sprintf(buf, "%#lx\n", (unsigned long)PAGES_PER_SECTION * PAGE_SIZE);
 }
 
-static SYSDEV_CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
+static CLASS_ATTR(block_size_bytes, 0444, print_block_size, NULL);
 
 static int block_size_init(void)
 {
 	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&attr_block_size_bytes.attr);
+				&class_attr_block_size_bytes.attr);
 }
 
 /*
@@ -332,9 +330,7 @@ static int block_size_init(void)
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
-memory_probe_store(struct sysdev_class *class,
-		   struct sysdev_class_attribute *class_attr,
-		   const char *buf, size_t count)
+memory_probe_store(struct class *class, const char *buf, size_t count)
 {
 	u64 phys_addr;
 	int nid;
@@ -350,12 +346,12 @@ memory_probe_store(struct sysdev_class *class,
 
 	return count;
 }
-static SYSDEV_CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
+static CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 
 static int memory_probe_init(void)
 {
 	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&attr_probe.attr);
+				&class_attr_probe.attr);
 }
 #else
 static inline int memory_probe_init(void)
@@ -371,9 +367,7 @@ static inline int memory_probe_init(void)
 
 /* Soft offline a page */
 static ssize_t
-store_soft_offline_page(struct sysdev_class *class,
-			struct sysdev_class_attribute *class_attr,
-			const char *buf, size_t count)
+store_soft_offline_page(struct class *class, const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
@@ -390,9 +384,7 @@ store_soft_offline_page(struct sysdev_class *class,
 
 /* Forcibly offline a page, including killing processes. */
 static ssize_t
-store_hard_offline_page(struct sysdev_class *class,
-			struct sysdev_class_attribute *class_attr,
-			const char *buf, size_t count)
+store_hard_offline_page(struct class *class, const char *buf, size_t count)
 {
 	int ret;
 	u64 pfn;
@@ -405,18 +397,18 @@ store_hard_offline_page(struct sysdev_class *class,
 	return ret ? ret : count;
 }
 
-static SYSDEV_CLASS_ATTR(soft_offline_page, 0644, NULL, store_soft_offline_page);
-static SYSDEV_CLASS_ATTR(hard_offline_page, 0644, NULL, store_hard_offline_page);
+static CLASS_ATTR(soft_offline_page, 0644, NULL, store_soft_offline_page);
+static CLASS_ATTR(hard_offline_page, 0644, NULL, store_hard_offline_page);
 
 static __init int memory_fail_init(void)
 {
 	int err;
 
 	err = sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&attr_soft_offline_page.attr);
+				&class_attr_soft_offline_page.attr);
 	if (!err)
 		err = sysfs_create_file(&memory_sysdev_class.kset.kobj,
-				&attr_hard_offline_page.attr);
+				&class_attr_hard_offline_page.attr);
 	return err;
 }
 #else
-- 
1.6.5.7

