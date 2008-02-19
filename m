Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYBSTqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYBSTqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYBSTp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:45:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:35953 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbYBSTpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:45:55 -0500
Subject: patch driver-core-register_memory-unregister_memory-clean-ups-and-bugfix.patch added to gregkh-2.6 tree
To: pbadari@us.ibm.com, akpm@linux-foundation.org, greg@kroah.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org
From: <gregkh@suse.de>
Date: Tue, 19 Feb 2008 11:43:13 -0800
In-Reply-To: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <12034501931380@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: driver core: register_memory/unregister_memory clean ups and bugfix

to my gregkh-2.6 tree.  Its filename is

     driver-core-register_memory-unregister_memory-clean-ups-and-bugfix.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From pbadari@us.ibm.com Mon Feb 11 09:20:30 2008
From: Badari Pulavarty <pbadari@us.ibm.com>
Date: Mon, 11 Feb 2008 09:23:18 -0800
Subject: driver core: register_memory/unregister_memory clean ups and bugfix
To: Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, haveblue@us.ibm.com, linux-mm <linux-mm@kvack.org>
Message-ID: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>

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
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -62,8 +62,8 @@ void unregister_memory_notifier(struct n
 /*
  * register_memory - Setup a sysfs device for a memory block
  */
-int register_memory(struct memory_block *memory, struct mem_section *section,
-		struct node *root)
+static
+int register_memory(struct memory_block *memory, struct mem_section *section)
 {
 	int error;
 
@@ -71,26 +71,18 @@ int register_memory(struct memory_block 
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
@@ -345,7 +337,7 @@ static int add_memory_block(unsigned lon
 	mutex_init(&mem->state_mutex);
 	mem->phys_device = phys_device;
 
-	ret = register_memory(mem, section, NULL);
+	ret = register_memory(mem, section);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_index);
 	if (!ret)
@@ -396,7 +388,7 @@ int remove_memory_block(unsigned long no
 	mem_remove_simple_file(mem, phys_index);
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
-	unregister_memory(mem, section, NULL);
+	unregister_memory(mem, section);
 
 	return 0;
 }


Patches currently in gregkh-2.6 which might be from pbadari@us.ibm.com are

driver/driver-core-register_memory-unregister_memory-clean-ups-and-bugfix.patch
