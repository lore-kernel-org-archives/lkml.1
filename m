Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYGVKcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYGVKcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYGVKci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:32:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:51936 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYGVKch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=HiwomNtTrCQIPZ7Q4B7Q8LlG3QYLmH4R1aZdcFBEjd6vntOxn2DsXhtnGb13txI3LT
         dWwIfBV25RXmn0EyY8BMl0eouZPUWE+rnHfIbwRUw2lW8q9rL58uJRAEIbSziJMm+N8+
         sG5LT9I3uQCVgS+y644oYrMwleHxT6yWQt7Hg=
Date: Tue, 22 Jul 2008 14:32:31 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080722123231.GA13172@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716142225.GA19054@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 4:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> I'm not sure how we should proceed with this. On one hand, we could
>> just fix the issues as they come up and be done with it. On the other
>> hand, this was exactly the thing I wanted to avoid by automatic it. I
>> guess it can never be fully automated... The question is if there is
>> any danger of *silent* (read: runtime) breakage, which would be much
>> worse than compiler errors.
>
> dont worry, lets fix the above hideous hack first, then i can merge the
> guards fixes ontop of that fix. That's why we do testing, to catch the
> cases where assumptions fail. Your script is just fine - it beats having
> to edit 280+ files by hand ...

I've updated my script to also fix any rogue uses of header-guard names in
auxiliary files. I'm attaching the resulting patch.

It doesn't really _fix_ the hideous hack, it merely unbreaks it.

Patch #2 also fixes some left-over headers. They both apply on top of
tip/x86/header-guards.

(I guess it should be tested for a bit longer before going to linux-next,
just in case something else bad happens? I did a small test on x86_32 and
x86_64, and also verified that UML doesn't require any of the x86 header
guard names.)

Thanks,


Vegard


>From 3ec9258ef7414d3dd0a8a6c399bd2cd58103bf62 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 22 Jul 2008 13:53:24 +0200
Subject: [PATCH] x86: fix other files that depend on specific header-guard names

This patch should be squashed into the first "consolidate header guards"
commit in order to preserve bisectability.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/boot/compressed/misc.c  |    2 +-
 arch/x86/kernel/asm-offsets_64.c |    2 +-
 arch/x86/kernel/syscall_64.c     |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index bc5553b..3ee338c 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -16,7 +16,7 @@
  */
 #undef CONFIG_PARAVIRT
 #ifdef CONFIG_X86_32
-#define _ASM_DESC_H_ 1
+#define ASM_X86__DESC_H 1
 #endif
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index bacf5de..a39b19a 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -20,7 +20,7 @@
 
 #define __NO_STUBS 1
 #undef __SYSCALL
-#undef _ASM_X86_64_UNISTD_H_
+#undef ASM_X86__UNISTD_64_H
 #define __SYSCALL(nr, sym) [nr] = 1,
 static char syscalls[] = {
 #include <asm/unistd.h>
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 170d43c..3d1be4f 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -8,12 +8,12 @@
 #define __NO_STUBS
 
 #define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_64_UNISTD_H_
+#undef ASM_X86__UNISTD_64_H
 #include <asm/unistd_64.h>
 
 #undef __SYSCALL
 #define __SYSCALL(nr, sym) [nr] = sym,
-#undef _ASM_X86_64_UNISTD_H_
+#undef ASM_X86__UNISTD_64_H
 
 typedef void (*sys_call_ptr_t)(void);
 
-- 
1.5.5.1


>From 8b7af7c2e502a0fdc1a0ce8f7b003249a226a107 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 22 Jul 2008 13:56:36 +0200
Subject: [PATCH] x86: consolidate header guards

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-x86/amd_iommu_types.h |    6 +++---
 include/asm-x86/dma-mapping.h     |    6 +++---
 include/asm-x86/ds.h              |    6 +++---
 include/asm-x86/pda.h             |    6 +++---
 include/asm-x86/vdso.h            |    6 +++---
 include/asm-x86/xen/interface.h   |    6 +++---
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 7bfcb47..20b5077 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -17,8 +17,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-#ifndef __AMD_IOMMU_TYPES_H__
-#define __AMD_IOMMU_TYPES_H__
+#ifndef ASM_X86__AMD_IOMMU_TYPES_H
+#define ASM_X86__AMD_IOMMU_TYPES_H
 
 #include <linux/types.h>
 #include <linux/list.h>
@@ -241,4 +241,4 @@ static inline void print_devid(u16 devid, int nl)
 		printk("\n");
 }
 
-#endif
+#endif /* ASM_X86__AMD_IOMMU_TYPES_H */
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..0d817d0 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_DMA_MAPPING_H_
-#define _ASM_DMA_MAPPING_H_
+#ifndef ASM_X86__DMA_MAPPING_H
+#define ASM_X86__DMA_MAPPING_H
 
 /*
  * IOMMU interface. See Documentation/DMA-mapping.txt and DMA-API.txt for
@@ -234,4 +234,4 @@ extern void *
 dma_mark_declared_memory_occupied(struct device *dev,
 				  dma_addr_t device_addr, size_t size);
 #endif /* CONFIG_X86_32 */
-#endif
+#endif /* ASM_X86__DMA_MAPPING_H */
diff --git a/include/asm-x86/ds.h b/include/asm-x86/ds.h
index 7881368..6b27c68 100644
--- a/include/asm-x86/ds.h
+++ b/include/asm-x86/ds.h
@@ -17,8 +17,8 @@
  * Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
  */
 
-#ifndef _ASM_X86_DS_H
-#define _ASM_X86_DS_H
+#ifndef ASM_X86__DS_H
+#define ASM_X86__DS_H
 
 #include <linux/types.h>
 #include <linux/init.h>
@@ -69,4 +69,4 @@ extern int ds_write_bts(void *, const struct bts_struct *);
 extern unsigned long ds_debugctl_mask(void);
 extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *c);
 
-#endif /* _ASM_X86_DS_H */
+#endif /* ASM_X86__DS_H */
diff --git a/include/asm-x86/pda.h b/include/asm-x86/pda.h
index b34e9a7..80860af 100644
--- a/include/asm-x86/pda.h
+++ b/include/asm-x86/pda.h
@@ -1,5 +1,5 @@
-#ifndef X86_64_PDA_H
-#define X86_64_PDA_H
+#ifndef ASM_X86__PDA_H
+#define ASM_X86__PDA_H
 
 #ifndef __ASSEMBLY__
 #include <linux/stddef.h>
@@ -134,4 +134,4 @@ do {									\
 
 #define PDA_STACKOFFSET (5*8)
 
-#endif
+#endif /* ASM_X86__PDA_H */
diff --git a/include/asm-x86/vdso.h b/include/asm-x86/vdso.h
index 86e085e..4426394 100644
--- a/include/asm-x86/vdso.h
+++ b/include/asm-x86/vdso.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_X86_VDSO_H
-#define _ASM_X86_VDSO_H	1
+#ifndef ASM_X86__VDSO_H
+#define ASM_X86__VDSO_H
 
 #ifdef CONFIG_X86_64
 extern const char VDSO64_PRELINK[];
@@ -36,4 +36,4 @@ extern const char VDSO32_PRELINK[];
 extern void __user __kernel_sigreturn;
 extern void __user __kernel_rt_sigreturn;
 
-#endif	/* asm-x86/vdso.h */
+#endif /* ASM_X86__VDSO_H */
diff --git a/include/asm-x86/xen/interface.h b/include/asm-x86/xen/interface.h
index 6227000..1837d80 100644
--- a/include/asm-x86/xen/interface.h
+++ b/include/asm-x86/xen/interface.h
@@ -6,8 +6,8 @@
  * Copyright (c) 2004, K A Fraser
  */
 
-#ifndef __XEN_PUBLIC_ARCH_X86_32_H__
-#define __XEN_PUBLIC_ARCH_X86_32_H__
+#ifndef ASM_X86__XEN__INTERFACE_H
+#define ASM_X86__XEN__INTERFACE_H
 
 #ifdef __XEN__
 #define __DEFINE_GUEST_HANDLE(name, type) \
@@ -213,4 +213,4 @@ struct xen_callback {
 #define XEN_CPUID          XEN_EMULATE_PREFIX "cpuid"
 #endif
 
-#endif
+#endif /* ASM_X86__XEN__INTERFACE_H */
-- 
1.5.5.1

