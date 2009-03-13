Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZCMVKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZCMVKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZCMVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:09:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbZCMVJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:09:52 -0400
Message-ID: <49BACB61.8000302@kernel.org>
Date: Fri, 13 Mar 2009 14:08:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: print fixed mtrr out continuous part together
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: less lines print out

1. print continuous range with same type together
2. change _INFO to _DEBUG

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/generic.c |   58 ++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -208,13 +208,47 @@ void mtrr_save_fixed_ranges(void *info)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
+static unsigned __initdata last_fixed_start;
+static unsigned __initdata last_fixed_end;
+static mtrr_type __initdata last_fixed_type;
+
+static void __init print_fixed_last(void)
+{
+	if (!last_fixed_end)
+		return;
+
+	printk(KERN_DEBUG "  %05X-%05X %s\n", last_fixed_start,
+		last_fixed_end - 1, mtrr_attrib_to_str(last_fixed_type));
+
+	last_fixed_end = 0;
+}
+
+static void __init update_fixed_last(unsigned base, unsigned end,
+				       mtrr_type type)
+{
+	last_fixed_start = base;
+	last_fixed_end = end;
+	last_fixed_type = type;
+}
+
+static void __init print_fixed(unsigned base, unsigned step,
+			       const mtrr_type *types)
 {
 	unsigned i;
 
-	for (i = 0; i < 8; ++i, ++types, base += step)
-		printk(KERN_INFO "  %05X-%05X %s\n",
-			base, base + step - 1, mtrr_attrib_to_str(*types));
+	for (i = 0; i < 8; ++i, ++types, base += step) {
+		if (last_fixed_end == 0) {
+			update_fixed_last(base, base + step, *types);
+			continue;
+		}
+		if (last_fixed_end == base && last_fixed_type == *types) {
+			last_fixed_end = base + step;
+			continue;
+		}
+		/* new segments: gap or different type */
+		print_fixed_last();
+		update_fixed_last(base, base + step, *types);
+	}
 }
 
 static void prepare_set(void);
@@ -225,22 +259,26 @@ static void __init print_mtrr_state(void
 	unsigned int i;
 	int high_width;
 
-	printk(KERN_INFO "MTRR default type: %s\n", mtrr_attrib_to_str(mtrr_state.def_type));
+	printk(KERN_DEBUG "MTRR default type: %s\n",
+			 mtrr_attrib_to_str(mtrr_state.def_type));
 	if (mtrr_state.have_fixed) {
-		printk(KERN_INFO "MTRR fixed ranges %sabled:\n",
+		printk(KERN_DEBUG "MTRR fixed ranges %sabled:\n",
 		       mtrr_state.enabled & 1 ? "en" : "dis");
 		print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
 		for (i = 0; i < 2; ++i)
 			print_fixed(0x80000 + i * 0x20000, 0x04000, mtrr_state.fixed_ranges + (i + 1) * 8);
 		for (i = 0; i < 8; ++i)
 			print_fixed(0xC0000 + i * 0x08000, 0x01000, mtrr_state.fixed_ranges + (i + 3) * 8);
+
+		/* tail */
+		print_fixed_last();
 	}
-	printk(KERN_INFO "MTRR variable ranges %sabled:\n",
+	printk(KERN_DEBUG "MTRR variable ranges %sabled:\n",
 	       mtrr_state.enabled & 2 ? "en" : "dis");
 	high_width = ((size_or_mask ? ffs(size_or_mask) - 1 : 32) - (32 - PAGE_SHIFT) + 3) / 4;
 	for (i = 0; i < num_var_ranges; ++i) {
 		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
-			printk(KERN_INFO "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
+			printk(KERN_DEBUG "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
 			       i,
 			       high_width,
 			       mtrr_state.var_ranges[i].base_hi,
@@ -250,10 +288,10 @@ static void __init print_mtrr_state(void
 			       mtrr_state.var_ranges[i].mask_lo >> 12,
 			       mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
 		else
-			printk(KERN_INFO "   %u disabled\n", i);
+			printk(KERN_DEBUG "  %u disabled\n", i);
 	}
 	if (mtrr_tom2) {
-		printk(KERN_INFO "TOM2: %016llx aka %lldM\n",
+		printk(KERN_DEBUG "TOM2: %016llx aka %lldM\n",
 				  mtrr_tom2, mtrr_tom2>>20);
 	}
 }
