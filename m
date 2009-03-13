Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZCMBoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZCMBoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZCMBoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:44:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:46329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZCMBop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:44:45 -0400
Message-ID: <49B9BA5A.40108@kernel.org>
Date: Thu, 12 Mar 2009 18:43:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: more debug print out with mtrr
References: <49B87BE7.3040809@kernel.org> <20090313014052.GB6178@elte.hu>
In-Reply-To: <20090313014052.GB6178@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: more print out

remove unneeded mtrr_show

it will only printout one time by first cpu, so it is not big deal.

also print out directly from get_mtrr, because it doesn't update mtrr_state.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/generic.c |   93 +++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 43 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -33,14 +33,6 @@ u64 mtrr_tom2;
 struct mtrr_state_type mtrr_state = {};
 EXPORT_SYMBOL_GPL(mtrr_state);
 
-static int __initdata mtrr_show;
-static int __init mtrr_debug(char *opt)
-{
-	mtrr_show = 1;
-	return 0;
-}
-early_param("mtrr.show", mtrr_debug);
-
 /*
  * Returns the effective MTRR type for the region
  * Error returns:
@@ -193,13 +185,51 @@ static void print_fixed(unsigned base, u
 	unsigned i;
 
 	for (i = 0; i < 8; ++i, ++types, base += step)
-		printk(KERN_INFO "MTRR %05X-%05X %s\n",
+		printk(KERN_INFO "  %05X-%05X %s\n",
 			base, base + step - 1, mtrr_attrib_to_str(*types));
 }
 
 static void prepare_set(void);
 static void post_set(void);
 
+static void __init print_mtrr_state(void)
+{
+	unsigned int i;
+	int high_width;
+
+	printk(KERN_INFO "MTRR default type: %s\n", mtrr_attrib_to_str(mtrr_state.def_type));
+	if (mtrr_state.have_fixed) {
+		printk(KERN_INFO "MTRR fixed ranges %sabled:\n",
+		       mtrr_state.enabled & 1 ? "en" : "dis");
+		print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
+		for (i = 0; i < 2; ++i)
+			print_fixed(0x80000 + i * 0x20000, 0x04000, mtrr_state.fixed_ranges + (i + 1) * 8);
+		for (i = 0; i < 8; ++i)
+			print_fixed(0xC0000 + i * 0x08000, 0x01000, mtrr_state.fixed_ranges + (i + 3) * 8);
+	}
+	printk(KERN_INFO "MTRR variable ranges %sabled:\n",
+	       mtrr_state.enabled & 2 ? "en" : "dis");
+	high_width = ((size_or_mask ? ffs(size_or_mask) - 1 : 32) - (32 - PAGE_SHIFT) + 3) / 4;
+	for (i = 0; i < num_var_ranges; ++i) {
+		if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
+			printk(KERN_INFO "  %u base %0*X%05X000 mask %0*X%05X000 %s\n",
+			       i,
+			       high_width,
+			       mtrr_state.var_ranges[i].base_hi,
+			       mtrr_state.var_ranges[i].base_lo >> 12,
+			       high_width,
+			       mtrr_state.var_ranges[i].mask_hi,
+			       mtrr_state.var_ranges[i].mask_lo >> 12,
+			       mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
+		else
+			printk(KERN_INFO "   %u disabled\n", i);
+	}
+	if (mtrr_tom2) {
+		printk(KERN_INFO "TOM2: %016llx aka %lldM\n",
+				  mtrr_tom2, mtrr_tom2>>20);
+	}
+}
+
 /*  Grab all of the MTRR state for this CPU into *state  */
 void __init get_mtrr_state(void)
 {
@@ -231,41 +261,9 @@ void __init get_mtrr_state(void)
 		mtrr_tom2 |= low;
 		mtrr_tom2 &= 0xffffff800000ULL;
 	}
-	if (mtrr_show) {
-		int high_width;
 
-		printk(KERN_INFO "MTRR default type: %s\n", mtrr_attrib_to_str(mtrr_state.def_type));
-		if (mtrr_state.have_fixed) {
-			printk(KERN_INFO "MTRR fixed ranges %sabled:\n",
-			       mtrr_state.enabled & 1 ? "en" : "dis");
-			print_fixed(0x00000, 0x10000, mtrr_state.fixed_ranges + 0);
-			for (i = 0; i < 2; ++i)
-				print_fixed(0x80000 + i * 0x20000, 0x04000, mtrr_state.fixed_ranges + (i + 1) * 8);
-			for (i = 0; i < 8; ++i)
-				print_fixed(0xC0000 + i * 0x08000, 0x01000, mtrr_state.fixed_ranges + (i + 3) * 8);
-		}
-		printk(KERN_INFO "MTRR variable ranges %sabled:\n",
-		       mtrr_state.enabled & 2 ? "en" : "dis");
-		high_width = ((size_or_mask ? ffs(size_or_mask) - 1 : 32) - (32 - PAGE_SHIFT) + 3) / 4;
-		for (i = 0; i < num_var_ranges; ++i) {
-			if (mtrr_state.var_ranges[i].mask_lo & (1 << 11))
-				printk(KERN_INFO "MTRR %u base %0*X%05X000 mask %0*X%05X000 %s\n",
-				       i,
-				       high_width,
-				       mtrr_state.var_ranges[i].base_hi,
-				       mtrr_state.var_ranges[i].base_lo >> 12,
-				       high_width,
-				       mtrr_state.var_ranges[i].mask_hi,
-				       mtrr_state.var_ranges[i].mask_lo >> 12,
-				       mtrr_attrib_to_str(mtrr_state.var_ranges[i].base_lo & 0xff));
-			else
-				printk(KERN_INFO "MTRR %u disabled\n", i);
-		}
-		if (mtrr_tom2) {
-			printk(KERN_INFO "TOM2: %016llx aka %lldM\n",
-					  mtrr_tom2, mtrr_tom2>>20);
-		}
-	}
+	print_mtrr_state();
+
 	mtrr_state_set = 1;
 
 	/* PAT setup for BP. We need to go through sync steps here */
@@ -377,7 +375,12 @@ static void generic_get_mtrr(unsigned in
 	unsigned int mask_lo, mask_hi, base_lo, base_hi;
 	unsigned int tmp, hi;
 
+	/*
+	 * get_mtrr doesn't need to update mtrr_state, also it could be called
+	 * from any cpu, so try to print it out directly.
+	 */
 	rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
+
 	if ((mask_lo & 0x800) == 0) {
 		/*  Invalid (i.e. free) range  */
 		*base = 0;
@@ -407,6 +410,10 @@ static void generic_get_mtrr(unsigned in
 	*size = -mask_lo;
 	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
 	*type = base_lo & 0xff;
+
+	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
+			smp_processor_id(), reg, *base, *size,
+			mtrr_attrib_to_str(*type & 0xff));
 }
 
 /**
