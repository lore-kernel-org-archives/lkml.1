Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZKMLym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZKMLym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZKMLyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:54:36 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54195 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZKMLyf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Fri, 13 Nov 2009 06:54:35 -0500
Message-Id: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 13 Nov 2009 11:54:40 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: eliminate redundant/contradicting cache line size
	 config options
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT (with
inconsistent defaults), just having the latter suffices as the former
can be easily calculated from it.

To be consistent, also change X86_INTERNODE_CACHE_BYTES to
X86_INTERNODE_CACHE_SHIFT, and set it to 7 (128 bytes) for NUMA to
account for last level cache line size (which here matters more than
L1 cache line size).

Finally, make sure the default value for X86_L1_CACHE_SHIFT, when
X86_GENERIC is selected, is being seen before that for the individual
CPU model options (other than on x86-64, where GENERIC_CPU is part of
the choice construct, X86_GENERIC is a separate option on ix86).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 arch/x86/Kconfig.cpu                   |   14 +++++---------
 arch/x86/boot/compressed/vmlinux.lds.S |    3 ++-
 arch/x86/include/asm/cache.h           |    7 ++++---
 arch/x86/kernel/vmlinux.lds.S          |   10 +++++-----
 arch/x86/mm/tlb.c                      |    3 ++-
 5 files changed, 18 insertions(+), 19 deletions(-)

--- linux-2.6.32-rc7/arch/x86/Kconfig.cpu	2009-11-13 12:38:01.000000000 +0100
+++ 2.6.32-rc7-x86-cache-config/arch/x86/Kconfig.cpu	2009-11-09 15:55:41.000000000 +0100
@@ -301,15 +301,11 @@ config X86_CPU
 
 #
 # Define implied options from the CPU selection here
-config X86_L1_CACHE_BYTES
+config X86_INTERNODE_CACHE_SHIFT
 	int
-	default "128" if MPSC
-	default "64" if GENERIC_CPU || MK8 || MCORE2 || MATOM || X86_32
-
-config X86_INTERNODE_CACHE_BYTES
-	int
-	default "4096" if X86_VSMP
-	default X86_L1_CACHE_BYTES if !X86_VSMP
+	default "12" if X86_VSMP
+	default "7" if NUMA
+	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
@@ -317,9 +313,9 @@ config X86_CMPXCHG
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
 
 config X86_XADD
 	def_bool y
--- linux-2.6.32-rc7/arch/x86/boot/compressed/vmlinux.lds.S	2009-11-13 12:38:01.000000000 +0100
+++ 2.6.32-rc7-x86-cache-config/arch/x86/boot/compressed/vmlinux.lds.S	2009-11-09 15:52:47.000000000 +0100
@@ -4,6 +4,7 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONF
 
 #undef i386
 
+#include <asm/cache.h>
 #include <asm/page_types.h>
 
 #ifdef CONFIG_X86_64
@@ -46,7 +47,7 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.bss : {
 		_bss = . ;
 		*(.bss)
--- linux-2.6.32-rc7/arch/x86/include/asm/cache.h	2009-11-13 12:38:01.000000000 +0100
+++ 2.6.32-rc7-x86-cache-config/arch/x86/include/asm/cache.h	2009-11-09 15:50:22.000000000 +0100
@@ -9,12 +9,13 @@
 
 #define __read_mostly __attribute__((__section__(".data.read_mostly")))
 
+#define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
+#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
+
 #ifdef CONFIG_X86_VSMP
-/* vSMP Internode cacheline shift */
-#define INTERNODE_CACHE_SHIFT (12)
 #ifdef CONFIG_SMP
 #define __cacheline_aligned_in_smp					\
-	__attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))	\
+	__attribute__((__aligned__(INTERNODE_CACHE_BYTES)))		\
 	__page_aligned_data
 #endif
 #endif
--- linux-2.6.32-rc7/arch/x86/kernel/vmlinux.lds.S	2009-11-13 12:38:02.000000000 +0100
+++ 2.6.32-rc7-x86-cache-config/arch/x86/kernel/vmlinux.lds.S	2009-11-09 15:52:23.000000000 +0100
@@ -107,13 +107,13 @@ SECTIONS
 
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
 
-		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */
-		READ_MOSTLY_DATA(CONFIG_X86_INTERNODE_CACHE_BYTES)
+		READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)
 
 		/* End of data section */
 		_edata = .;
@@ -137,12 +137,12 @@ SECTIONS
 		*(.vsyscall_0)
 	} :user
 
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
 		*(.vsyscall_fn)
 	}
 
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
 		*(.vsyscall_gtod_data)
 	}
@@ -166,7 +166,7 @@ SECTIONS
 	}
 	vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.jiffies : AT(VLOAD(.jiffies)) {
 		*(.jiffies)
 	}
--- linux-2.6.32-rc7/arch/x86/mm/tlb.c	2009-11-13 12:38:02.000000000 +0100
+++ 2.6.32-rc7-x86-cache-config/arch/x86/mm/tlb.c	2009-11-09 15:57:23.000000000 +0100
@@ -8,6 +8,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/cache.h>
 #include <asm/apic.h>
 #include <asm/uv/uv.h>
 
@@ -43,7 +44,7 @@ union smp_flush_state {
 		spinlock_t tlbstate_lock;
 		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
-	char pad[CONFIG_X86_INTERNODE_CACHE_BYTES];
+	char pad[INTERNODE_CACHE_BYTES];
 } ____cacheline_internodealigned_in_smp;
 
 /* State is put into the per CPU data section, but padded


