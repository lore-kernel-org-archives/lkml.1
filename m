Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbZCMChT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbZCMChT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbZCMCfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:35:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:52522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936AbZCMCfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:35:41 -0400
Date: Fri, 13 Mar 2009 02:34:35 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B9BA5A.40108@kernel.org>
References: <49B9BA5A.40108@kernel.org>
Subject: [tip:x86/mtrr] x86: more MTRR debug printouts
Message-ID: <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>
Git-Commit-ID: 8ad9790588ee2e69118b2b294ddab6f3f0379ad9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:34:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ad9790588ee2e69118b2b294ddab6f3f0379ad9
Gitweb:     http://git.kernel.org/tip/8ad9790588ee2e69118b2b294ddab6f3f0379ad9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 12 Mar 2009 18:43:54 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:52:18 +0100

x86: more MTRR debug printouts

Impact: improve MTRR debugging messages

There's still inefficiencies suspected with the MTRR sanitizing
code, so make sure we get all the info we need from a dmesg.

- Remove unneeded mtrr_show

 (It will only printout one time by first cpu, so it is no big deal.)

- Also print out directly from get_mtrr, because it doesn't update mtrr_state.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49B9BA5A.40108@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/generic.c |   95 +++++++++++++++++++-----------------
 1 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0c0a455..9644035 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
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
@@ -193,13 +185,51 @@ static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
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
-
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
+
+	print_mtrr_state();
+
 	mtrr_state_set = 1;
 
 	/* PAT setup for BP. We need to go through sync steps here */
@@ -377,7 +375,12 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
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
@@ -407,6 +410,10 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	*size = -mask_lo;
 	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
 	*type = base_lo & 0xff;
+
+	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
+			smp_processor_id(), reg, *base, *size,
+			mtrr_attrib_to_str(*type & 0xff));
 }
 
 /**
