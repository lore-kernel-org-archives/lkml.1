Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZCMEk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZCMEk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZCMEkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:40:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbZCMEkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:40:12 -0400
Date: Fri, 13 Mar 2009 04:39:33 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B9E286.502@kernel.org>
References: <49B9E286.502@kernel.org>
Subject: [tip:x86/mm] x86: fix e820_update_range()
Message-ID: <tip-773e673de27297d07d852e7e9bfd1a695cae1da2@git.kernel.org>
Git-Commit-ID: 773e673de27297d07d852e7e9bfd1a695cae1da2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 04:39:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  773e673de27297d07d852e7e9bfd1a695cae1da2
Gitweb:     http://git.kernel.org/tip/773e673de27297d07d852e7e9bfd1a695cae1da2
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 12 Mar 2009 21:35:18 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 05:38:29 +0100

x86: fix e820_update_range()

Impact: fix left range size on head

| commit 5c0e6f035df983210e4d22213aed624ced502d3d
|    x86: fix code paths used by update_mptable
|    Impact: fix crashes under Xen due to unrobust e820 code

fixes one e820 bug, but introduces another bug.

Need to update size for left range at first in case it is header.

also add __e820_add_region take more parameter.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: jbeulich@novell.com
LKML-Reference: <49B9E286.502@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/e820.c |   45 ++++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 3cf6681..95b81c1 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -110,19 +110,25 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
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
@@ -417,11 +423,11 @@ static int __init append_e820_map(struct e820entry *biosmap, int nr_map)
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
@@ -447,22 +453,19 @@ static u64 __init e820_update_range_map(struct e820map *e820x, u64 start,
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
@@ -470,13 +473,13 @@ static u64 __init e820_update_range_map(struct e820map *e820x, u64 start,
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
 
