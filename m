Return-Path: <linux-kernel-owner+w=401wt.eu-S1761905AbYDTKmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761905AbYDTKmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYDTKkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56270 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYDTKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/36] driver core: register_memory/unregister_memory clean ups and bugfix
Date: Sun, 20 Apr 2008 03:45:39 -0700
Message-Id: <1208688366-9252-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Badari Pulavarty <pbadari@us.ibm.com>

register_memory()/unregister_memory() never gets called with
"root". unregister_memory() is accessing kobject_name of
the object just freed up. Since no one uses the code,
lets take the code out. And also, make register_memory() static.

Another bug fix - before calling unregister_memory()
remove_memory_block() gets a ref on kobject. unregister_memory()
need to drop that ref before calling sysdev_unregister().

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 1f3801a..7891f7c 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -62,8 +62,8 @@ void unregister_memory_notifier(struct notifier_block *nb)
 /*
  * register_memory - Setup a sysfs device for a memory block
  */
-int register_memory(struct memory_block *memory, struct mem_section *section,
-		struct node *root)
+static
+int register_memory(struct memory_block *memory, struct mem_section *section)
 {
 	int error;
 
@@ -71,26 +71,18 @@ int register_memory(struct memory_block *memory, struct mem_section *section,
 	memory->sysdev.id = __section_nr(section);
 
 	error = sysdev_register(&memory->sysdev);
-
-	if (root && !error)
-		error = sysfs_create_link(&root->sysdev.kobj,
-					  &memory->sysdev.kobj,
-					  kobject_name(&memory->sysdev.kobj));
-
 	return error;
 }
 
 static void
-unregister_memory(struct memory_block *memory, struct mem_section *section,
-		struct node *root)
+unregister_memory(struct memory_block *memory, struct mem_section *section)
 {
 	BUG_ON(memory->sysdev.cls != &memory_sysdev_class);
 	BUG_ON(memory->sysdev.id != __section_nr(section));
 
+	/* drop the ref. we got in remove_memory_block() */
+	kobject_put(&memory->sysdev.kobj);
 	sysdev_unregister(&memory->sysdev);
-	if (root)
-		sysfs_remove_link(&root->sysdev.kobj,
-				  kobject_name(&memory->sysdev.kobj));
 }
 
 /*
@@ -345,7 +337,7 @@ static int add_memory_block(unsigned long node_id, struct mem_section *section,
 	mutex_init(&mem->state_mutex);
 	mem->phys_device = phys_device;
 
-	ret = register_memory(mem, section, NULL);
+	ret = register_memory(mem, section);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_index);
 	if (!ret)
@@ -396,7 +388,7 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
-	unregister_memory(mem, section, NULL);
+	unregister_memory(mem, section);
 
 	return 0;
 }
-- 
1.5.4.5

