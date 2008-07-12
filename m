Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYGLWki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYGLWki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYGLWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:40:20 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:49070 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbYGLWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:40:18 -0400
From: Bernhard Walle <bernhard.walle@gmx.de>
To: x86@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, Bernhard Walle <bernhard.walle@gmx.de>,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 1/2] firmware/memmap: Cleanup
Date: Sun, 13 Jul 2008 00:15:32 +0200
Message-Id: <1215900933-27592-2-git-send-email-bernhard.walle@gmx.de>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <20080711173609.8310504d.akpm@linux-foundation.org>
References: <20080711173609.8310504d.akpm@linux-foundation.org>
X-Relay-User: bernhard@bwalle.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various cleanup the drivers/firmware/memmap (after review by AKPM):

    - fix kdoc to conform to the standard
    - move kdoc from header to implementation files
    - remove superfluous WARN_ON() after kmalloc()
    - WARN_ON(x); if (!x) -> if(!WARN_ON(x))
    - improve some comments


Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Bernhard Walle <bernhard.walle@gmx.de>
---
 drivers/firmware/memmap.c        |   61 ++++++++++++++++++++++++++-----------
 include/linux/firmware-map.h     |   26 ----------------
 2 files changed, 43 insertions(+), 44 deletions(-)
 create mode 100644 include/config/firmware/memmap.h

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index e23399c..73b7c1d 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -84,20 +84,23 @@ static struct kobj_type memmap_ktype = {
  */
 
 /*
- * Firmware memory map entries
+ * Firmware memory map entries. No locking is needed because the
+ * firmware_map_add() and firmware_map_add_early() functions are called
+ * in firmware initialisation code in one single thread of execution.
  */
 static LIST_HEAD(map_entries);
 
 /**
- * Common implementation of firmware_map_add() and firmware_map_add_early()
- * which expects a pre-allocated struct firmware_map_entry.
- *
+ * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
  * @end:   End of the memory range (inclusive).
  * @type:  Type of the memory range.
  * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
  *         entry.
- */
+ *
+ * Common implementation of firmware_map_add() and firmware_map_add_early()
+ * which expects a pre-allocated struct firmware_map_entry.
+ **/
 static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
 				  const char *type,
 				  struct firmware_map_entry *entry)
@@ -115,33 +118,52 @@ static int firmware_map_add_entry(resource_size_t start, resource_size_t end,
 	return 0;
 }
 
-/*
- * See <linux/firmware-map.h> for documentation.
- */
+/**
+ * firmware_map_add() - Adds a firmware mapping entry.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ *
+ * This function uses kmalloc() for memory
+ * allocation. Use firmware_map_add_early() if you want to use the bootmem
+ * allocator.
+ *
+ * That function must be called before late_initcall.
+ *
+ * Returns 0 on success, or -ENOMEM if no memory could be allocated.
+ **/
 int firmware_map_add(resource_size_t start, resource_size_t end,
 		     const char *type)
 {
 	struct firmware_map_entry *entry;
 
 	entry = kmalloc(sizeof(struct firmware_map_entry), GFP_ATOMIC);
-	WARN_ON(!entry);
 	if (!entry)
 		return -ENOMEM;
 
 	return firmware_map_add_entry(start, end, type, entry);
 }
 
-/*
- * See <linux/firmware-map.h> for documentation.
- */
+/**
+ * firmware_map_add_early() - Adds a firmware mapping entry.
+ * @start: Start of the memory range.
+ * @end:   End of the memory range (inclusive).
+ * @type:  Type of the memory range.
+ *
+ * Adds a firmware mapping entry. This function uses the bootmem allocator
+ * for memory allocation. Use firmware_map_add() if you want to use kmalloc().
+ *
+ * That function must be called before late_initcall.
+ *
+ * Returns 0 on success, or -ENOMEM if no memory could be allocated.
+ **/
 int __init firmware_map_add_early(resource_size_t start, resource_size_t end,
 				  const char *type)
 {
 	struct firmware_map_entry *entry;
 
 	entry = alloc_bootmem_low(sizeof(struct firmware_map_entry));
-	WARN_ON(!entry);
-	if (!entry)
+	if (WARN_ON(!entry))
 		return -ENOMEM;
 
 	return firmware_map_add_entry(start, end, type, entry);
@@ -181,7 +203,10 @@ static ssize_t memmap_attr_show(struct kobject *kobj,
 /*
  * Initialises stuff and adds the entries in the map_entries list to
  * sysfs. Important is that firmware_map_add() and firmware_map_add_early()
- * must be called before late_initcall.
+ * must be called before late_initcall. That's just because that function
+ * is called as late_initcall() function, which means that if you call
+ * firmware_map_add() or firmware_map_add_early() afterwards, the entries
+ * are not added to sysfs.
  */
 static int __init memmap_init(void)
 {
@@ -190,13 +215,13 @@ static int __init memmap_init(void)
 	struct kset *memmap_kset;
 
 	memmap_kset = kset_create_and_add("memmap", NULL, firmware_kobj);
-	WARN_ON(!memmap_kset);
-	if (!memmap_kset)
+	if (WARN_ON(!memmap_kset))
 		return -ENOMEM;
 
 	list_for_each_entry(entry, &map_entries, list) {
 		entry->kobj.kset = memmap_kset;
-		kobject_add(&entry->kobj, NULL, "%d", i++);
+		if (kobject_add(&entry->kobj, NULL, "%d", i++))
+			kobject_put(&entry->kobj);
 	}
 
 	return 0;
diff --git a/include/config/firmware/memmap.h b/include/config/firmware/memmap.h
new file mode 100644
index 0000000..e69de29
diff --git a/include/linux/firmware-map.h b/include/linux/firmware-map.h
index acbdbcc..6e199c8 100644
--- a/include/linux/firmware-map.h
+++ b/include/linux/firmware-map.h
@@ -24,34 +24,8 @@
  */
 #ifdef CONFIG_FIRMWARE_MEMMAP
 
-/**
- * Adds a firmware mapping entry. This function uses kmalloc() for memory
- * allocation. Use firmware_map_add_early() if you want to use the bootmem
- * allocator.
- *
- * That function must be called before late_initcall.
- *
- * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
- * @type:  Type of the memory range.
- *
- * Returns 0 on success, or -ENOMEM if no memory could be allocated.
- */
 int firmware_map_add(resource_size_t start, resource_size_t end,
 		     const char *type);
-
-/**
- * Adds a firmware mapping entry. This function uses the bootmem allocator
- * for memory allocation. Use firmware_map_add() if you want to use kmalloc().
- *
- * That function must be called before late_initcall.
- *
- * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
- * @type:  Type of the memory range.
- *
- * Returns 0 on success, or -ENOMEM if no memory could be allocated.
- */
 int firmware_map_add_early(resource_size_t start, resource_size_t end,
 			   const char *type);
 
-- 
1.5.6.2

