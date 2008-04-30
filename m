Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYD3D0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYD3D0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYD3DZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:25:58 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:21450 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYD3DZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=bmPeR4V1waF6ovoLFm4MR/T/mpK5voWazu4SQSQyVKQTXab2g4gF2Q9lnMyfjXWE1A4oBkjcVU0nK0jBEBFBhiBCOnewgNGlwbOEQe1TJKCziD40RzXHlX1tgGx18IAjBGidlhxcbhgM56cUKr540SEKC/w4xoFrU4ehMlc9qZQ=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>
Subject: [PATCH] x86: fix trimming e820 with MTRR holes. - fix
Date: Tue, 29 Apr 2008 20:25:16 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804290157.30651.yhlu.kernel@gmail.com> <200804290159.49882.yhlu.kernel@gmail.com>
In-Reply-To: <200804290159.49882.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804292025.17159.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2: process hole then end_pfn
    fix update_memory_range with whole cover comparing

Signed-off-by: Yinghai Lu <yinghai.lu@gmail.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -1098,11 +1098,12 @@ int __init amd_special_default_mtrr(void
 static u64 __init real_trim_memory(unsigned long start_pfn, unsigned long limit_pfn)
 {
 	u64 trim_start, trim_size;
-	trim_start =  start_pfn;
+	trim_start = start_pfn;
 	trim_start <<= PAGE_SHIFT;
 	trim_size = limit_pfn;
 	trim_size <<= PAGE_SHIFT;
 	trim_size -= trim_start;
+
 	return update_memory_range(trim_start, trim_size, E820_RAM,
 				E820_RESERVED);
 }
@@ -1124,7 +1125,6 @@ int __init mtrr_trim_uncached_memory(uns
 	struct res_range range[RANGE_NUM];
 	int nr_range;
 	u64 total_real_trim_size;
-	int changed;
 
 	/* extra one for all 0 */
 	int num[MTRR_NUM_TYPES + 1];
@@ -1189,49 +1189,35 @@ int __init mtrr_trim_uncached_memory(uns
 	}
 	nr_range = x86_get_mtrr_mem_range(range, nr_range, 0, 0);
 
-	changed = 0;
-	total_real_trim_size = 0;
-
-	/* check the top at first */
-	i = nr_range - 1;
-	if (range[i].end + 1 < end_pfn) {
-			total_real_trim_size += real_trim_memory(range[i].end + 1, end_pfn);
-	}
-
-	if (total_real_trim_size) {
-		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
-			" all of memory, losing %lluMB of RAM.\n",
-			total_real_trim_size >> 20);
-
-		WARN_ON(1);
-
-		printk(KERN_INFO "update e820 for mtrr -- end_pfn\n");
-		update_e820();
-		changed = 1;
-	}
-
 	total_real_trim_size = 0;
+	/* check the head */
 	if (range[0].start)
 		total_real_trim_size += real_trim_memory(0, range[0].start);
-
-	for (i = 0; i < nr_range - 1; i--) {
+	/* check the holes */
+	for (i = 0; i < nr_range - 1; i++) {
 		if (range[i].end + 1 < range[i+1].start)
 			total_real_trim_size += real_trim_memory(range[i].end + 1, range[i+1].start);
 	}
+	/* check the top */
+	i = nr_range - 1;
+	if (range[i].end + 1 < end_pfn)
+		total_real_trim_size += real_trim_memory(range[i].end + 1, end_pfn);
 
 	if (total_real_trim_size) {
 		printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
 			" all of memory, losing %lluMB of RAM.\n",
 			total_real_trim_size >> 20);
 
-		WARN_ON(1);
+		if (enable_mtrr_cleanup < 1)
+			WARN_ON(1);
 
-		printk(KERN_INFO "update e820 for mtrr -- holes\n");
+		printk(KERN_INFO "update e820 for mtrr\n");
 		update_e820();
-		changed = 1;
+
+		return 1;
 	}
 
-	return changed;
+	return 0;
 }
 
 /**
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -843,7 +843,8 @@ u64 __init update_memory_range(u64 start
 		if (ei->type != old_type)
 			continue;
 		/* totally covered? */
-		if (ei->addr >= start && ei->size <= size) {
+		if (ei->addr >= start &&
+		    (ei->addr + ei->size) <= (start + size)) {
 			ei->type = new_type;
 			real_updated_size += ei->size;
 			continue;
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -797,7 +797,8 @@ u64 __init update_memory_range(u64 start
 		if (ei->type != old_type)
 			continue;
 		/* totally covered? */
-		if (ei->addr >= start && ei->size <= size) {
+		if (ei->addr >= start &&
+		    (ei->addr + ei->size) <= (start + size)) {
 			ei->type = new_type;
 			real_updated_size += ei->size;
 			continue;
