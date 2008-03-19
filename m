Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbYCSTzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbYCSTzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYCSTh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:50529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbYCSThW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="307375676"
Message-Id: <20080319000058.541493000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:14 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 02/13] x86: PAT infrastructure patch
Content-Disposition: inline; filename=pat_init_infrastructure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sets up pat_init() infrastructure.

PAT MSR has following setting.
	PAT
	|PCD
	||PWT
	|||
	000 WB		_PAGE_CACHE_WB
	001 WC		_PAGE_CACHE_WC
	010 UC-		_PAGE_CACHE_UC_MINUS
	011 UC		_PAGE_CACHE_UC

We are effectively changing WT from boot time setting to WC.
UC_MINUS is used to provide backward compatibility to existing /dev/mem
users(X).

reserve_memtype and free_memtype are new interfaces for maintaining alias-free
mapping. It is currently implemented in a simple way with a linked list and
not optimized. reserve and free tracks the effective memory type, as a result
of PAT and MTRR setting rather than what is actually requested in PAT.

pat_init piggy backs on mtrr_init as the rules for setting both pat and mtrr
are same.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/kernel/cpu/mtrr/generic.c	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/kernel/cpu/mtrr/generic.c	2008-03-18 02:54:04.000000000 -0700
@@ -11,6 +11,7 @@
 #include <asm/cpufeature.h>
 #include <asm/processor-flags.h>
 #include <asm/tlbflush.h>
+#include <asm/pat.h>
 #include "mtrr.h"
 
 struct mtrr_state {
@@ -35,6 +36,7 @@
 
 static unsigned long smp_changes_mask;
 static struct mtrr_state mtrr_state = {};
+static int mtrr_state_set;
 
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
@@ -42,6 +44,106 @@
 static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
+/*
+ * Returns the effective MTRR type for the region
+ * Error returns:
+ * - 0xFE - when the range is "not entirely covered" by _any_ var range MTRR
+ * - 0xFF - when MTRR is not enabled
+ */
+u8 mtrr_type_lookup(u64 start, u64 end)
+{
+	int i;
+	u64 base, mask;
+	u8 prev_match, curr_match;
+
+	if (!mtrr_state_set)
+		return 0xFF;
+
+	if (!mtrr_state.enabled)
+		return 0xFF;
+
+	/* Make end inclusive end, instead of exclusive */
+	end--;
+
+	/* Look in fixed ranges. Just return the type as per start */
+	if (mtrr_state.have_fixed && (start < 0x100000)) {
+		int idx;
+
+		if (start < 0x80000) {
+			idx = 0;
+			idx += (start >> 16);
+			return mtrr_state.fixed_ranges[idx];
+		} else if (start < 0xC0000) {
+			idx = 1 * 8;
+			idx += ((start - 0x80000) >> 14);
+			return mtrr_state.fixed_ranges[idx];
+		} else if (start < 0x1000000) {
+			idx = 3 * 8;
+			idx += ((start - 0xC0000) >> 12);
+			return mtrr_state.fixed_ranges[idx];
+		}
+	}
+
+	/*
+	 * Look in variable ranges
+	 * Look of multiple ranges matching this address and pick type
+	 * as per MTRR precedence
+	 */
+	if (!mtrr_state.enabled & 2) {
+		return mtrr_state.def_type;
+	}
+
+	prev_match = 0xFF;
+	for (i = 0; i < num_var_ranges; ++i) {
+		unsigned short start_state, end_state;
+
+		if (!(mtrr_state.var_ranges[i].mask_lo & (1 << 11)))
+			continue;
+
+		base = (((u64)mtrr_state.var_ranges[i].base_hi) << 32) +
+		       (mtrr_state.var_ranges[i].base_lo & PAGE_MASK);
+		mask = (((u64)mtrr_state.var_ranges[i].mask_hi) << 32) +
+		       (mtrr_state.var_ranges[i].mask_lo & PAGE_MASK);
+
+		start_state = ((start & mask) == (base & mask));
+		end_state = ((end & mask) == (base & mask));
+		if (start_state != end_state)
+			return 0xFE;
+
+		if ((start & mask) != (base & mask)) {
+			continue;
+		}
+
+		curr_match = mtrr_state.var_ranges[i].base_lo & 0xff;
+		if (prev_match == 0xFF) {
+			prev_match = curr_match;
+			continue;
+		}
+
+		if (prev_match == MTRR_TYPE_UNCACHABLE ||
+		    curr_match == MTRR_TYPE_UNCACHABLE) {
+			return MTRR_TYPE_UNCACHABLE;
+		}
+
+		if ((prev_match == MTRR_TYPE_WRBACK &&
+		     curr_match == MTRR_TYPE_WRTHROUGH) ||
+		    (prev_match == MTRR_TYPE_WRTHROUGH &&
+		     curr_match == MTRR_TYPE_WRBACK)) {
+			prev_match = MTRR_TYPE_WRTHROUGH;
+			curr_match = MTRR_TYPE_WRTHROUGH;
+		}
+
+		if (prev_match != curr_match) {
+			return MTRR_TYPE_UNCACHABLE;
+		}
+	}
+
+	if (prev_match != 0xFF)
+		return prev_match;
+
+	return mtrr_state.def_type;
+}
+
 /*  Get the MSR pair relating to a var range  */
 static void
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
@@ -79,12 +181,16 @@
 			base, base + step - 1, mtrr_attrib_to_str(*types));
 }
 
+static void prepare_set(void);
+static void post_set(void);
+
 /*  Grab all of the MTRR state for this CPU into *state  */
 void __init get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
 	unsigned lo, dummy;
+	unsigned long flags;
 
 	vrs = mtrr_state.var_ranges;
 
@@ -131,6 +237,17 @@
 				printk(KERN_INFO "MTRR %u disabled\n", i);
 		}
 	}
+	mtrr_state_set = 1;
+
+	/* PAT setup for BP. We need to go through sync steps here */
+	local_irq_save(flags);
+	prepare_set();
+
+	pat_init();
+
+	post_set();
+	local_irq_restore(flags);
+
 }
 
 /*  Some BIOS's are fucked and don't set all MTRRs the same!  */
@@ -393,6 +510,9 @@
 	/* Actually set the state */
 	mask = set_mtrr_state();
 
+	/* also set PAT */
+	pat_init();
+
 	post_set();
 	local_irq_restore(flags);
 
Index: linux-2.6-x86.git/arch/x86/mm/pat.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86.git/arch/x86/mm/pat.c	2008-03-18 09:20:34.000000000 -0700
@@ -0,0 +1,402 @@
+/*
+ * Handle caching attributes in page tables (PAT)
+ *
+ * Authors: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ *          Suresh B Siddha <suresh.b.siddha@intel.com>
+ *
+ * Loosely based on earlier PAT patchset from Eric Biederman and Andi Kleen.
+ */
+
+#include <linux/mm.h>
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/fs.h>
+
+#include <asm/msr.h>
+#include <asm/tlbflush.h>
+#include <asm/processor.h>
+#include <asm/pgtable.h>
+#include <asm/pat.h>
+#include <asm/e820.h>
+#include <asm/cacheflush.h>
+#include <asm/fcntl.h>
+#include <asm/mtrr.h>
+
+int pat_wc_enabled = 1;
+
+static u64 __read_mostly boot_pat_state;
+
+static int nopat(char *str)
+{
+	pat_wc_enabled = 0;
+	printk(KERN_INFO "x86: PAT support disabled.\n");
+
+	return 0;
+}
+early_param("nopat", nopat);
+
+static int pat_known_cpu(void)
+{
+	if (!pat_wc_enabled)
+		return 0;
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+	    (boot_cpu_data.x86 == 0xF ||
+	     (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model >= 15))) {
+		if (cpu_has_pat) {
+			return 1;
+		}
+	}
+
+	pat_wc_enabled = 0;
+	printk(KERN_INFO "CPU and/or kernel does not support PAT.\n");
+	return 0;
+}
+
+enum {
+	PAT_UC = 0,		/* uncached */
+	PAT_WC = 1,		/* Write combining */
+	PAT_WT = 4,		/* Write Through */
+	PAT_WP = 5,		/* Write Protected */
+	PAT_WB = 6,		/* Write Back (default) */
+	PAT_UC_MINUS = 7,	/* UC, but can be overriden by MTRR */
+};
+
+#define PAT(x,y)	((u64)PAT_ ## y << ((x)*8))
+
+void pat_init(void)
+{
+	u64 pat;
+
+#ifndef CONFIG_X86_PAT
+	nopat(NULL);
+#endif
+
+	/* Boot CPU enables PAT based on CPU feature */
+	if (!smp_processor_id() && !pat_known_cpu())
+		return;
+
+	/* APs enable PAT iff boot CPU has enabled it before */
+	if (smp_processor_id() && !pat_wc_enabled)
+		return;
+
+	/* Set PWT to Write-Combining. All other bits stay the same */
+	/*
+	 * PTE encoding used in Linux:
+	 *      PAT
+	 *      |PCD
+	 *      ||PWT
+	 *      |||
+	 *      000 WB		_PAGE_CACHE_WB
+	 *      001 WC		_PAGE_CACHE_WC
+	 *      010 UC-		_PAGE_CACHE_UC_MINUS
+	 *      011 UC		_PAGE_CACHE_UC
+	 * PAT bit unused
+	 */
+	pat = PAT(0,WB) | PAT(1,WC) | PAT(2,UC_MINUS) | PAT(3,UC) |
+	      PAT(4,WB) | PAT(5,WC) | PAT(6,UC_MINUS) | PAT(7,UC);
+
+	/* Boot CPU check */
+	if (!smp_processor_id()) {
+		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
+	}
+
+	wrmsrl(MSR_IA32_CR_PAT, pat);
+	printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
+	       smp_processor_id(), boot_pat_state, pat);
+}
+
+#undef PAT
+
+static char *cattr_name(unsigned long flags)
+{
+	switch (flags & _PAGE_CACHE_MASK) {
+		case _PAGE_CACHE_UC:		return "uncached";
+		case _PAGE_CACHE_UC_MINUS:	return "uncached-minus";
+		case _PAGE_CACHE_WB:		return "write-back";
+		case _PAGE_CACHE_WC:		return "write-combining";
+		default:			return "broken";
+	}
+}
+
+/*
+ * The global memtype list keeps track of memory type for specific
+ * physical memory areas. Conflicting memory types in different
+ * mappings can cause CPU cache corruption. To avoid this we keep track.
+ *
+ * The list is sorted based on starting address and can contain multiple
+ * entries for each address (this allows reference counting for overlapping
+ * areas). All the aliases have the same cache attributes of course.
+ * Zero attributes are represented as holes.
+ *
+ * Currently the data structure is a list because the number of mappings
+ * are expected to be relatively small. If this should be a problem
+ * it could be changed to a rbtree or similar.
+ *
+ * memtype_lock protects the whole list.
+ */
+
+struct memtype {
+	u64 start;
+	u64 end;
+	unsigned long type;
+	struct list_head nd;
+};
+
+static LIST_HEAD(memtype_list);
+static DEFINE_SPINLOCK(memtype_lock); 	/* protects memtype list */
+
+/*
+ * Does intersection of PAT memory type and MTRR memory type and returns
+ * the resulting memory type as PAT understands it.
+ * (Type in pat and mtrr will not have same value)
+ * The intersection is based on "Effective Memory Type" tables in IA-32
+ * SDM vol 3a
+ */
+static int pat_x_mtrr_type(u64 start, u64 end, unsigned long prot,
+				unsigned long *ret_prot)
+{
+	unsigned long pat_type;
+	u8 mtrr_type;
+
+	mtrr_type = mtrr_type_lookup(start, end);
+	if (mtrr_type == 0xFF) {		/* MTRR not enabled */
+		*ret_prot = prot;
+		return 0;
+	}
+	if (mtrr_type == 0xFE) {		/* MTRR match error */
+		*ret_prot = _PAGE_CACHE_UC;
+		return -1;
+	}
+	if (mtrr_type != MTRR_TYPE_UNCACHABLE &&
+	    mtrr_type != MTRR_TYPE_WRBACK &&
+	    mtrr_type != MTRR_TYPE_WRCOMB) {	/* MTRR type unhandled */
+		*ret_prot = _PAGE_CACHE_UC;
+		return -1;
+	}
+
+	pat_type = prot & _PAGE_CACHE_MASK;
+	prot &= (~_PAGE_CACHE_MASK);
+
+	/* Currently doing intersection by hand. Optimize it later. */
+	if (pat_type == _PAGE_CACHE_WC) {
+		*ret_prot = prot | _PAGE_CACHE_WC;
+	} else if (pat_type == _PAGE_CACHE_UC_MINUS) {
+		*ret_prot = prot | _PAGE_CACHE_UC_MINUS;
+	} else if (pat_type == _PAGE_CACHE_UC ||
+	           mtrr_type == MTRR_TYPE_UNCACHABLE) {
+		*ret_prot = prot | _PAGE_CACHE_UC;
+	} else if (mtrr_type == MTRR_TYPE_WRCOMB) {
+		*ret_prot = prot | _PAGE_CACHE_WC;
+	} else {
+		*ret_prot = prot | _PAGE_CACHE_WB;
+	}
+
+	return 0;
+}
+
+int reserve_memtype(u64 start, u64 end, unsigned long req_type,
+			unsigned long *ret_type)
+{
+	struct memtype *new_entry = NULL;
+	struct memtype *parse;
+	unsigned long actual_type;
+	int err = 0;
+
+	/* Only track when pat_wc_enabled */
+	if (!pat_wc_enabled) {
+		if (ret_type)
+			*ret_type = req_type;
+
+		return 0;
+	}
+
+	/* Low ISA region is always mapped WB in page table. No need to track */
+	if (start >= ISA_START_ADDRESS && (end - 1) <= ISA_END_ADDRESS) {
+		if (ret_type)
+			*ret_type = _PAGE_CACHE_WB;
+
+		return 0;
+	}
+
+	req_type &= _PAGE_CACHE_MASK;
+	err = pat_x_mtrr_type(start, end, req_type, &actual_type);
+	if (err) {
+		if (ret_type)
+			*ret_type = actual_type;
+
+		return -EINVAL;
+	}
+
+	new_entry  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
+	if (!new_entry)
+		return -ENOMEM;
+
+	new_entry->start = start;
+	new_entry->end = end;
+	new_entry->type = actual_type;
+
+	if (ret_type)
+		*ret_type = actual_type;
+
+	spin_lock(&memtype_lock);
+
+	/* Search for existing mapping that overlaps the current range */
+	list_for_each_entry(parse, &memtype_list, nd) {
+		struct memtype *saved_ptr;
+
+		if (parse->start >= end) {
+			list_add(&new_entry->nd, parse->nd.prev);
+			new_entry = NULL;
+			break;
+		}
+
+		if (start <= parse->start && end >= parse->start) {
+			if (actual_type != parse->type && ret_type) {
+				actual_type = parse->type;
+				*ret_type = actual_type;
+				new_entry->type = actual_type;
+			}
+
+			if (actual_type != parse->type) {
+				printk(
+		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
+					current->comm, current->pid,
+					start, end,
+					cattr_name(actual_type),
+					cattr_name(parse->type));
+				err = -EBUSY;
+				break;
+			}
+
+			saved_ptr = parse;
+			/*
+			 * Check to see whether the request overlaps more
+			 * than one entry in the list
+			 */
+			list_for_each_entry_continue(parse, &memtype_list, nd) {
+				if (end <= parse->start) {
+					break;
+				}
+
+				if (actual_type != parse->type) {
+					printk(
+		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
+						current->comm, current->pid,
+						start, end,
+						cattr_name(actual_type),
+						cattr_name(parse->type));
+					err = -EBUSY;
+					break;
+				}
+			}
+
+			if (err) {
+				break;
+			}
+
+			/* No conflict. Go ahead and add this new entry */
+			list_add(&new_entry->nd, saved_ptr->nd.prev);
+			new_entry = NULL;
+			break;
+		}
+
+		if (start < parse->end) {
+			if (actual_type != parse->type && ret_type) {
+				actual_type = parse->type;
+				*ret_type = actual_type;
+				new_entry->type = actual_type;
+			}
+
+			if (actual_type != parse->type) {
+				printk(
+		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
+					current->comm, current->pid,
+					start, end,
+					cattr_name(actual_type),
+					cattr_name(parse->type));
+				err = -EBUSY;
+				break;
+			}
+
+			saved_ptr = parse;
+			/*
+			 * Check to see whether the request overlaps more
+			 * than one entry in the list
+			 */
+			list_for_each_entry_continue(parse, &memtype_list, nd) {
+				if (end <= parse->start) {
+					break;
+				}
+
+				if (actual_type != parse->type) {
+					printk(
+		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
+						current->comm, current->pid,
+						start, end,
+						cattr_name(actual_type),
+						cattr_name(parse->type));
+					err = -EBUSY;
+					break;
+				}
+			}
+
+			if (err) {
+				break;
+			}
+
+			/* No conflict. Go ahead and add this new entry */
+			list_add(&new_entry->nd, &saved_ptr->nd);
+			new_entry = NULL;
+			break;
+		}
+	}
+
+	if (err) {
+		kfree(new_entry);
+		spin_unlock(&memtype_lock);
+		return err;
+	}
+
+	if (new_entry) {
+		/* No conflict. Not yet added to the list. Add to the tail */
+		list_add_tail(&new_entry->nd, &memtype_list);
+	}
+
+	spin_unlock(&memtype_lock);
+	return err;
+}
+
+int free_memtype(u64 start, u64 end)
+{
+	struct memtype *ml;
+	int err = -EINVAL;
+
+	/* Only track when pat_wc_enabled */
+	if (!pat_wc_enabled) {
+		return 0;
+	}
+
+	/* Low ISA region is always mapped WB. No need to track */
+	if (start >= ISA_START_ADDRESS && end <= ISA_END_ADDRESS) {
+		return 0;
+	}
+
+	spin_lock(&memtype_lock);
+	list_for_each_entry(ml, &memtype_list, nd) {
+		if (ml->start == start && ml->end == end) {
+			list_del(&ml->nd);
+			kfree(ml);
+			err = 0;
+			break;
+		}
+	}
+	spin_unlock(&memtype_lock);
+
+	if (err) {
+		printk(KERN_DEBUG "%s:%d freeing invalid memtype %Lx-%Lx\n",
+			current->comm, current->pid, start, end);
+	}
+	return err;
+}
+
Index: linux-2.6-x86.git/include/asm-x86/pat.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86.git/include/asm-x86/pat.h	2008-03-17 11:06:51.000000000 -0700
@@ -0,0 +1,16 @@
+
+#ifndef _ASM_PAT_H
+#define _ASM_PAT_H 1
+
+#include <linux/types.h>
+
+extern int pat_wc_enabled;
+
+extern void pat_init(void);
+
+extern int reserve_memtype(u64 start, u64 end,
+		unsigned long req_type, unsigned long *ret_type);
+extern int free_memtype(u64 start, u64 end);
+
+#endif
+
Index: linux-2.6-x86.git/arch/x86/Kconfig
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/Kconfig	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/Kconfig	2008-03-17 11:06:51.000000000 -0700
@@ -1013,6 +1013,21 @@
 
 	  See <file:Documentation/mtrr.txt> for more information.
 
+config X86_PAT
+	def_bool y
+	prompt "x86 PAT support"
+	depends on MTRR && NONPROMISC_DEVMEM
+	help
+	  Use PAT attributes to setup page level cache control.
+	---help---
+	  PATs are the modern equivalents of MTRRs and are much more
+	  flexible than MTRRs.
+
+	  Say N here if you see bootup problems (boot crash, boot hang,
+	  spontaneous reboots) or a non-working Xorg.
+
+	  If unsure, say Y.
+
 config EFI
 	def_bool n
 	prompt "EFI runtime service support"
Index: linux-2.6-x86.git/arch/x86/mm/Makefile
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/Makefile	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/Makefile	2008-03-17 11:06:51.000000000 -0700
@@ -1,4 +1,4 @@
-obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o
+obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o pat.o
 
 
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
Index: linux-2.6-x86.git/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/pageattr.c	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/pageattr.c	2008-03-18 09:20:36.000000000 -0700
@@ -774,14 +774,14 @@
 int set_memory_uc(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_PCD | _PAGE_PWT));
+				    __pgprot(_PAGE_CACHE_UC));
 }
 EXPORT_SYMBOL(set_memory_uc);
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
 	return change_page_attr_clear(addr, numpages,
-				      __pgprot(_PAGE_PCD | _PAGE_PWT));
+				      __pgprot(_PAGE_CACHE_MASK));
 }
 EXPORT_SYMBOL(set_memory_wb);
 
Index: linux-2.6-x86.git/include/asm-x86/mtrr.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/mtrr.h	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/mtrr.h	2008-03-17 11:06:51.000000000 -0700
@@ -84,6 +84,8 @@
 
 #ifdef __KERNEL__
 
+extern u8 mtrr_type_lookup(u64 addr, u64 end);
+
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
 extern void mtrr_save_fixed_ranges(void *);
Index: linux-2.6-x86.git/include/asm-x86/pgtable.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/pgtable.h	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/pgtable.h	2008-03-18 09:20:34.000000000 -0700
@@ -57,6 +57,12 @@
 
 #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
 
+#define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
+#define _PAGE_CACHE_WB		(0)
+#define _PAGE_CACHE_WC		(_PAGE_PWT)
+#define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
+#define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
+
 #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_NX)
 
Index: linux-2.6-x86.git/include/asm-x86/cpufeature.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/cpufeature.h	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/cpufeature.h	2008-03-17 11:06:51.000000000 -0700
@@ -186,6 +186,7 @@
 #define cpu_has_bts		boot_cpu_has(X86_FEATURE_BTS)
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
+#define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
Index: linux-2.6-x86.git/include/asm-x86/msr-index.h
===================================================================
--- linux-2.6-x86.git.orig/include/asm-x86/msr-index.h	2008-03-17 11:06:47.000000000 -0700
+++ linux-2.6-x86.git/include/asm-x86/msr-index.h	2008-03-17 11:06:51.000000000 -0700
@@ -57,6 +57,8 @@
 #define MSR_MTRRfix4K_F8000		0x0000026f
 #define MSR_MTRRdefType			0x000002ff
 
+#define MSR_IA32_CR_PAT			0x00000277
+
 #define MSR_IA32_DEBUGCTLMSR		0x000001d9
 #define MSR_IA32_LASTBRANCHFROMIP	0x000001db
 #define MSR_IA32_LASTBRANCHTOIP		0x000001dc

-- 
