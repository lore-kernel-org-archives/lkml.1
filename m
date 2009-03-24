Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZCXGOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZCXGOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZCXGOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:14:35 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:60035 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZCXGOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:14:34 -0400
Date: Mon, 23 Mar 2009 23:14:29 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090324061429.GH7278@localdomain>
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322124818.GA31466@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 01:48:18PM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> On Sat, Feb 28, 2009 at 10:44:30AM +0100, Ingo Molnar wrote:
>> >
>> >* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>> >
>> >> 
>> >> True, but by how much? 212 bytes, out of 7285943 bytes which 
>> >> is very very small percentage wise.
>> >
>> >How does this eliminate the validity of the patch?
>> >
>> 
>> It costs 212 bytes to leave is_vsmp_box() to not just be a dummy 
>> no-op. Having is_vsmp_box() detect if the hardware is indeed vSMP, 
>> is meaningful even when CONFIG_VSMP is not turned on.  This is 
>> because is_vsmp_box() is used to tell the kernel, that although 
>> the cpus being used are supposed to have TSCs in sync, they are 
>> not really in sync.  This is because you cannot ensure TSCs won't 
>> drift between multiple boards being aggregated on vSMP systems. 
>> Take the case of distro kernels.  Distro kernels typically do not 
>> have CONFIG_X86_VSMP on.  Due to the large internode cacheline 
>> setting, CONFIG_VSMP would not be on on the generic distro 
>> installer kernels. If is_vsmp_box() is a no-op, the generic distro 
>> installer kernels will assume TSCs to be synched, which is bad.  
>> Hence, it will be nice if, for the cost of 212 bytes, vsmp64.o be 
>> compiled either unconditionally, OR conditionally for 64bit 
>> architectures only.  The question is, is 212 bytes out of 7285943 
>> bytes too expensive for the generic kernels?  I hope not.
>
>Sorry - got distracted and forgot about this thread. The TSC quirk 
>indeed looks required for your systems - you dont have a reliable 
>TSC due to virtualization, right?
>

Yes. Also, because  there is no way to avoid tsc drift on
multiple boards/nodes.


>Mind sending a patch (partial revert or so) against latest -tip that 
>fixes that?
>

Sure.  Here's  a revert, it is a partial revert which compiles vsmp64.c only
for 64bit architectures.

Thanks,
Kiran


Partial revert of commit 129d8bc828e011bda0b7110a097bf3a0167f966e
titled 'x86: don't compile vsmp_64 for 32bit'
Commit reverted to compile vsmp_64.c if CONFIG_X86_64 is defined,
since is_vsmp_box() needs to indicate that TSCs are not synchronized, and
hence, not a valid time source, even when CONFIG_X86_VSMP is not defined.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: git.tip/arch/x86/include/asm/apic.h
===================================================================
--- git.tip.orig/arch/x86/include/asm/apic.h	2009-03-23 12:50:37.000000000 -0800
+++ git.tip/arch/x86/include/asm/apic.h	2009-03-23 20:21:02.000000000 -0800
@@ -75,7 +75,7 @@ static inline void default_inquire_remot
 #define setup_secondary_clock setup_secondary_APIC_clock
 #endif
 
-#ifdef CONFIG_X86_VSMP
+#ifdef CONFIG_X86_64
 extern int is_vsmp_box(void);
 #else
 static inline int is_vsmp_box(void)
Index: git.tip/arch/x86/include/asm/setup.h
===================================================================
--- git.tip.orig/arch/x86/include/asm/setup.h	2009-03-23 12:50:37.000000000 -0800
+++ git.tip/arch/x86/include/asm/setup.h	2009-03-23 20:19:18.000000000 -0800
@@ -64,7 +64,7 @@ extern void x86_quirk_time_init(void);
 #include <asm/bootparam.h>
 
 /* Interrupt control for vSMPowered x86_64 systems */
-#ifdef CONFIG_X86_VSMP
+#ifdef CONFIG_X86_64
 void vsmp_init(void);
 #else
 static inline void vsmp_init(void) { }
Index: git.tip/arch/x86/kernel/Makefile
===================================================================
--- git.tip.orig/arch/x86/kernel/Makefile	2009-03-23 12:50:37.000000000 -0800
+++ git.tip/arch/x86/kernel/Makefile	2009-03-23 20:29:34.000000000 -0800
@@ -71,7 +71,6 @@ obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
-obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
@@ -121,4 +120,5 @@ ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
+	obj-y				+= vsmp_64.o
 endif
Index: git.tip/arch/x86/kernel/vsmp_64.c
===================================================================
--- git.tip.orig/arch/x86/kernel/vsmp_64.c	2009-03-23 12:50:37.000000000 -0800
+++ git.tip/arch/x86/kernel/vsmp_64.c	2009-03-23 21:09:34.000000000 -0800
@@ -22,7 +22,7 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 
-#ifdef CONFIG_PARAVIRT
+#if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
  * Interrupt control on vSMPowered systems:
  * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
@@ -114,6 +114,7 @@ static void __init set_vsmp_pv_ops(void)
 }
 #endif
 
+#ifdef CONFIG_PCI
 static int is_vsmp = -1;
 
 static void __init detect_vsmp_box(void)
@@ -139,6 +140,15 @@ int is_vsmp_box(void)
 	}
 }
 
+#else
+static void __init detect_vsmp_box(void)
+{
+}
+int is_vsmp_box(void)
+{
+	return 0;
+}
+#endif
 void __init vsmp_init(void)
 {
 	detect_vsmp_box();
