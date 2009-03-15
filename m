Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbZCOIAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbZCOIAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 04:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZCOIAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 04:00:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:41073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbZCOIAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 04:00:31 -0400
Message-ID: <49BCB557.3030000@kernel.org>
Date: Sun, 15 Mar 2009 00:59:19 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: print out in e820_update_range()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: to find crazy calling

try to print out more info, to catch wrong calling

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   56 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -131,6 +131,31 @@ void __init e820_add_region(u64 start, u
 	__e820_add_region(&e820, start, size, type);
 }
 
+static void __init e820_print_type(u32 type)
+{
+	switch (type) {
+	case E820_RAM:
+	case E820_RESERVED_KERN:
+		printk(KERN_CONT "(usable)");
+		break;
+	case E820_RESERVED:
+		printk(KERN_CONT "(reserved)");
+		break;
+	case E820_ACPI:
+		printk(KERN_CONT "(ACPI data)");
+		break;
+	case E820_NVS:
+		printk(KERN_CONT "(ACPI NVS)");
+		break;
+	case E820_UNUSABLE:
+		printk(KERN_CONT "(unusable)");
+		break;
+	default:
+		printk(KERN_CONT "type %u", type);
+		break;
+	}
+}
+
 void __init e820_print_map(char *who)
 {
 	int i;
@@ -140,27 +165,8 @@ void __init e820_print_map(char *who)
 		       (unsigned long long) e820.map[i].addr,
 		       (unsigned long long)
 		       (e820.map[i].addr + e820.map[i].size));
-		switch (e820.map[i].type) {
-		case E820_RAM:
-		case E820_RESERVED_KERN:
-			printk(KERN_CONT "(usable)\n");
-			break;
-		case E820_RESERVED:
-			printk(KERN_CONT "(reserved)\n");
-			break;
-		case E820_ACPI:
-			printk(KERN_CONT "(ACPI data)\n");
-			break;
-		case E820_NVS:
-			printk(KERN_CONT "(ACPI NVS)\n");
-			break;
-		case E820_UNUSABLE:
-			printk("(unusable)\n");
-			break;
-		default:
-			printk(KERN_CONT "type %u\n", e820.map[i].type);
-			break;
-		}
+		e820_print_type(e820.map[i].type);
+		printk(KERN_CONT "\n");
 	}
 }
 
@@ -437,6 +443,14 @@ static u64 __init __e820_update_range(st
 		size = ULLONG_MAX - start;
 
 	end = start + size;
+	printk(KERN_DEBUG "e820 update range: %016Lx - %016Lx ",
+		       (unsigned long long) start,
+		       (unsigned long long) end);
+	e820_print_type(old_type);
+	printk(KERN_CONT " ==> ");
+	e820_print_type(new_type);
+	printk(KERN_CONT "\n");
+
 	for (i = 0; i < e820x->nr_map; i++) {
 		struct e820entry *ei = &e820x->map[i];
 		u64 final_start, final_end;
