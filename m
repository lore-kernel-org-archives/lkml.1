Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZCMEhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZCMEhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZCMEhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:37:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:41365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZCMEha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:37:30 -0400
Message-ID: <49B9E286.502@kernel.org>
Date: Thu, 12 Mar 2009 21:35:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: [PATCH] x86: fix e820_update_range()
References: <49B914B6.76E4.0078.0@novell.com> <tip-82034d6f59b4772f4233bbb61c670290803a9960@git.kernel.org>
In-Reply-To: <tip-82034d6f59b4772f4233bbb61c670290803a9960@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix left range size on head.

| commit 5c0e6f035df983210e4d22213aed624ced502d3d
|    x86: fix code paths used by update_mptable
|    Impact: fix crashes under Xen due to unrobust e820 code
fix one bug about e820 referring, but introduce other bug

need update size for left range at first in case it is header.

also add __e820_add_region take more parameter.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -110,19 +110,25 @@ int __init e820_all_mapped(u64 start, u6
 /*
  * Add a memory region to the kernel e820 map.
  */
-void __init e820_add_region(u64 start, u64 size, int type)
+static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
+					 int type)
 {
-	int x = e820.nr_map;
+	int x = e820x->nr_map;
 
-	if (x == ARRAY_SIZE(e820.map)) {
+	if (x == ARRAY_SIZE(e820x->map)) {
 		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
 		return;
 	}
 
-	e820.map[x].addr = start;
-	e820.map[x].size = size;
-	e820.map[x].type = type;
-	e820.nr_map++;
+	e820x->map[x].addr = start;
+	e820x->map[x].size = size;
+	e820x->map[x].type = type;
+	e820x->nr_map++;
+}
+
+void __init e820_add_region(u64 start, u64 size, int type)
+{
+	__e820_add_region(&e820, start, size, type);
 }
 
 void __init e820_print_map(char *who)
@@ -417,11 +423,11 @@ static int __init append_e820_map(struct
 	return __append_e820_map(biosmap, nr_map);
 }
 
-static u64 __init e820_update_range_map(struct e820map *e820x, u64 start,
+static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
 					u64 size, unsigned old_type,
 					unsigned new_type)
 {
-	unsigned int i, x;
+	unsigned int i;
 	u64 real_updated_size = 0;
 
 	BUG_ON(old_type == new_type);
@@ -447,22 +453,19 @@ static u64 __init e820_update_range_map(
 		if (final_start >= final_end)
 			continue;
 
-		x = e820x->nr_map;
-		if (x == ARRAY_SIZE(e820x->map)) {
-			printk(KERN_ERR "Too many memory map entries!\n");
-			break;
-		}
-		e820x->map[x].addr = final_start;
-		e820x->map[x].size = final_end - final_start;
-		e820x->map[x].type = new_type;
-		e820x->nr_map++;
+		__e820_add_region(e820x, final_start, final_end - final_start,
+				  new_type);
 
 		real_updated_size += final_end - final_start;
 
+		/*
+		 * left range could be head or tail, so need to update
+		 * size at first.
+		 */
+		ei->size -= final_end - final_start;
 		if (ei->addr < final_start)
 			continue;
 		ei->addr = final_end;
-		ei->size -= final_end - final_start;
 	}
 	return real_updated_size;
 }
@@ -470,13 +473,13 @@ static u64 __init e820_update_range_map(
 u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
 			     unsigned new_type)
 {
-	return e820_update_range_map(&e820, start, size, old_type, new_type);
+	return __e820_update_range(&e820, start, size, old_type, new_type);
 }
 
 static u64 __init e820_update_range_saved(u64 start, u64 size,
 					  unsigned old_type, unsigned new_type)
 {
-	return e820_update_range_map(&e820_saved, start, size, old_type,
+	return __e820_update_range(&e820_saved, start, size, old_type,
 				     new_type);
 }
 
