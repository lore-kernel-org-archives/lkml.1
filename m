Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZKTFkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZKTFkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 00:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZKTFj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 00:39:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbZKTFj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 00:39:57 -0500
Date: Fri, 20 Nov 2009 06:36:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jeff Law <law@redhat.com>,
       rostedt@goodmis.org, "H. Peter Anvin" <hpa@zytor.com>,
       David Daney <ddaney@caviumnetworks.com>, Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
Message-ID: <20091120053609.GA6821@elte.hu>
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>
 <4B05B7AD.20500@redhat.com>
 <1258670580.22249.1002.camel@gandalf.stny.rr.com>
 <4B05DBBF.5000804@redhat.com>
 <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [ Btw, looking at that, why are X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT 
>   totally unrelated numbers? Very confusing. ]

incidentally (or maybe not so incidentally) that got fixed yesterday in 
-tip - at around the time i triggered that crash:

  350f8f5: x86: Eliminate redundant/contradicting cache line size config options

See the full commit below. The config that triggered the crash for me 
has:

  CONFIG_X86_L1_CACHE_SHIFT=4

so it's 16 bytes - and it's consistent now, which is a new angle. So i 
think this explains why it stayed dormant for such a long time - it was 
hidden by the cacheline-size config value inconsistencies.

	Ingo

----------------->
>From 350f8f5631922c7848ec4b530c111cb8c2ff7caa Mon Sep 17 00:00:00 2001
From: Jan Beulich <JBeulich@novell.com>
Date: Fri, 13 Nov 2009 11:54:40 +0000
Subject: [PATCH] x86: Eliminate redundant/contradicting cache line size config options

Rather than having X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT
(with inconsistent defaults), just having the latter suffices as
the former can be easily calculated from it.

To be consistent, also change X86_INTERNODE_CACHE_BYTES to
X86_INTERNODE_CACHE_SHIFT, and set it to 7 (128 bytes) for NUMA
to account for last level cache line size (which here matters
more than L1 cache line size).

Finally, make sure the default value for X86_L1_CACHE_SHIFT,
when X86_GENERIC is selected, is being seen before that for the
individual CPU model options (other than on x86-64, where
GENERIC_CPU is part of the choice construct, X86_GENERIC is a
separate option on ix86).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Ravikiran Thirumalai <kiran@scalex86.org>
Acked-by: Nick Piggin <npiggin@suse.de>
LKML-Reference: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu                   |   14 +++++---------
 arch/x86/boot/compressed/vmlinux.lds.S |    3 ++-
 arch/x86/include/asm/cache.h           |    7 ++++---
 arch/x86/kernel/vmlinux.lds.S          |   10 +++++-----
 arch/x86/mm/tlb.c                      |    3 ++-
 5 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f2824fb..621f2bd 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
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
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index f4193bb..a6f1a59 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -4,6 +4,7 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 
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
diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 549860d..2f9047c 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
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
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index fd2dabe..eeb4f5f 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -135,13 +135,13 @@ SECTIONS
 
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
@@ -165,12 +165,12 @@ SECTIONS
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
@@ -194,7 +194,7 @@ SECTIONS
 	}
 	vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.jiffies : AT(VLOAD(.jiffies)) {
 		*(.jiffies)
 	}
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 36fe08e..65b58e4 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
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
