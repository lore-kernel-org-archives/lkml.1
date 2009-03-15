Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZCOJzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZCOJzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZCOJzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:55:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56332 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZCOJzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:55:03 -0400
Date: Sun, 15 Mar 2009 09:54:28 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49BCB557.3030000@kernel.org>
References: <49BCB557.3030000@kernel.org>
Subject: [tip:x86/mm] x86: print out more info in e820_update_range()
Message-ID: <tip-c61cf4cfe7c73c7aa62dde3ff82cd475b9c41481@git.kernel.org>
Git-Commit-ID: c61cf4cfe7c73c7aa62dde3ff82cd475b9c41481
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 15 Mar 2009 09:54:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c61cf4cfe7c73c7aa62dde3ff82cd475b9c41481
Gitweb:     http://git.kernel.org/tip/c61cf4cfe7c73c7aa62dde3ff82cd475b9c41481
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 15 Mar 2009 00:59:19 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Mar 2009 10:01:59 +0100

x86: print out more info in e820_update_range()

Impact: help debug e820 bugs

Try to print out more info, to catch wrong call parameters.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49BCB557.3030000@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/e820.c |   56 ++++++++++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0c34ff4..fb638d9 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -131,6 +131,31 @@ void __init e820_add_region(u64 start, u64 size, int type)
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
 
@@ -437,6 +443,14 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
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
