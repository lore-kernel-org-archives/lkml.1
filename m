Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYBQRDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYBQRDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYBQRDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:03:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:58239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYBQRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=ZsHkuNwXqLVoYtTVQ+YInrSvECrQvTVShYNCFkjhjYa7jCmkJbqZ9FSZWxyuNk5bqr19JqrhHlNrRnytOZBfiwPC+0STRjFtdxHfu29SDrxRussBDRRYBFHtDaLBZjo+zl1KBSp06l5L36Q627amyd04Qa4WSzVtBKjhKq8l7jM=
Message-ID: <6101e8c40802170903i13ef8d99v3da02a347f705981@mail.gmail.com>
Date: Sun, 17 Feb 2008 18:03:15 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: request for v2.6.22.19-queue
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2166_29143688.1203267796108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2166_29143688.1203267796108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From a8a7690626756b6dcd49ad23b58f4406bfa59d7f Mon Sep 17 00:00:00 2001
From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, 11 Feb 2008 16:17:33 -0700
Subject: [PATCH] Be more robust about bad arguments in get_user_pages()

MAINLINE: 900cf086fd2fbad07f72f4575449e0d0958f860f

So I spent a while pounding my head against my monitor trying to figure
out the vmsplice() vulnerability - how could a failure to check for
*read* access turn into a root exploit? It turns out that it's a buffer
overflow problem which is made easy by the way get_user_pages() is
coded.

In particular, "len" is a signed int, and it is only checked at the
*end* of a do {} while() loop.  So, if it is passed in as zero, the loop
will execute once and decrement len to -1.  At that point, the loop will
proceed until the next invalid address is found; in the process, it will
likely overflow the pages array passed in to get_user_pages().

I think that, if get_user_pages() has been asked to grab zero pages,
that's what it should do.  Thus this patch; it is, among other things,
enough to block the (already fixed) root exploit and any others which
might be lurking in similar code.  I also think that the number of pages
should be unsigned, but changing the prototype of this function probably
requires some more careful review.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/mm/memory.c b/mm/memory.c
index f64cbf9..538f054 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -983,6 +983,8 @@ int get_user_pages(struct task_struct *tsk, struct
mm_struct *mm,
 	int i;
 	unsigned int vm_flags;

+	if (len <= 0)
+		return 0;
 	/*
 	 * Require read or write permissions.
 	 * If 'force' is set, we only require the "MAY" flags.
>From 7d0cf656110bc5a64798162c5c03913b2ffed65b Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Tue, 31 Jul 2007 00:39:39 -0700
Subject: [PATCH] cciss: fix memory leak

There's a memory leak in the cciss driver.

MAINLINE: f2912a1223c0917a7b4e054f18086209137891ea

in alloc_cciss_hba() we may leak sizeof(ctlr_info_t) bytes if a
call to alloc_disk(1 << NWD_SHIFT) fails.
This patch should fix the issue.

Spotted by the Coverity checker.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5acc6c4..132f76b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3225,12 +3225,15 @@ static int alloc_cciss_hba(void)
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
 			ctlr_info_t *p;
+
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
 			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
-			if (!p->gendisk[0])
+			if (!p->gendisk[0]) {
+				kfree(p);
 				goto Enomem;
+			}
 			hba[i] = p;
 			return i;
 		}
>From a228962494b69e7b3ed16f8cda693c816c68bbe7 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 15 Feb 2008 20:58:22 +0100
Subject: [PATCH] x86_64: CPA, fix cache attribute inconsistency bug,
v2.6.22 backport

MAINLINE:  not-yet-in-mainline

fix CPA cache attribute bug in v2.6.2[234]. When phys_base is nonzero
(when CONFIG_RELOCATABLE=y) then change_page_attr_addr() miscalculates
the secondary alias address by -14 MB (depending on the configured
offset).

The default 64-bit kernels of Fedora and Ubuntu are affected:

   $ grep RELOCA /boot/config-2.6.23.9-85.fc8
     CONFIG_RELOCATABLE=y

   $ grep RELOC /boot/config-2.6.22-14-generic
     CONFIG_RELOCATABLE=y

and probably on many other distros as well.

the bug affects all pages in the first 40 MB of physical RAM that
are allocated by some subsystem that does ioremap_nocache() on them:

       if (__pa(address) < KERNEL_TEXT_SIZE) {

Hence we might leave page table entries with inconsistent cache
attributes around (pages mapped at both UnCacheable and Write-Back),
and we can also set the wrong kernel text pages to UnCacheable.

the effects of this bug can be random slowdowns and other misbehavior.
If for example AGP allocates its aperture pages into the first 40 MB
of physical RAM, then the -14 MB bug might mark random kernel texto
pages as uncacheable, slowing down a random portion of the 64-bit
kernel until the AGP driver is unloaded.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/arch/x86_64/mm/pageattr.c b/arch/x86_64/mm/pageattr.c
index 7cd5254..d6cd5c4 100644
--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -204,7 +204,7 @@ int change_page_attr_addr(unsigned long address,
int numpages, pgprot_t prot)
 		if (__pa(address) < KERNEL_TEXT_SIZE) {
 			unsigned long addr2;
 			pgprot_t prot2;
-			addr2 = __START_KERNEL_map + __pa(address);
+			addr2 = __START_KERNEL_map + __pa(address) - phys_base;
 			/* Make sure the kernel mappings stay executable */
 			prot2 = pte_pgprot(pte_mkexec(pfn_pte(0, prot)));
 			err = __change_page_attr(addr2, pfn, prot2,
>From 3dacfc9387587eca249e91d819930308508a4b15 Mon Sep 17 00:00:00 2001
From: Roland McGrath <roland@redhat.com>
Date: Mon, 16 Jul 2007 08:03:16 -0700
Subject: [PATCH] Handle bogus %cs selector in single-step instruction decoding

Handle bogus %cs selector in single-step instruction decoding

MAINLINE: 29eb51101c02df517ca64ec472d7501127ad1da8

The code for LDT segment selectors was not robust in the face of a bogus
selector set in %cs via ptrace before the single-step was done.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/arch/i386/kernel/ptrace.c b/arch/i386/kernel/ptrace.c
index 0c0ceec..120a63b 100644
--- a/arch/i386/kernel/ptrace.c
+++ b/arch/i386/kernel/ptrace.c
@@ -164,14 +164,22 @@ static unsigned long
convert_eip_to_linear(struct task_struct *child, struct pt_
 		u32 *desc;
 		unsigned long base;

-		down(&child->mm->context.sem);
-		desc = child->mm->context.ldt + (seg & ~7);
-		base = (desc[0] >> 16) | ((desc[1] & 0xff) << 16) | (desc[1] & 0xff000000);
+		seg &= ~7UL;

-		/* 16-bit code segment? */
-		if (!((desc[1] >> 22) & 1))
-			addr &= 0xffff;
-		addr += base;
+		down(&child->mm->context.sem);
+		if (unlikely((seg >> 3) >= child->mm->context.size))
+			addr = -1L; /* bogus selector, access would fault */
+		else {
+			desc = child->mm->context.ldt + seg;
+			base = ((desc[0] >> 16) |
+				((desc[1] & 0xff) << 16) |
+				(desc[1] & 0xff000000));
+
+			/* 16-bit code segment? */
+			if (!((desc[1] >> 22) & 1))
+				addr &= 0xffff;
+			addr += base;
+		}
 		up(&child->mm->context.sem);
 	}
 	return addr;
diff --git a/arch/x86_64/kernel/ptrace.c b/arch/x86_64/kernel/ptrace.c
index 8d89d8c..7fc0e73 100644
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -102,16 +102,25 @@ unsigned long convert_rip_to_linear(struct
task_struct *child, struct pt_regs *r
 		u32 *desc;
 		unsigned long base;

-		down(&child->mm->context.sem);
-		desc = child->mm->context.ldt + (seg & ~7);
-		base = (desc[0] >> 16) | ((desc[1] & 0xff) << 16) | (desc[1] & 0xff000000);
+		seg &= ~7UL;

-		/* 16-bit code segment? */
-		if (!((desc[1] >> 22) & 1))
-			addr &= 0xffff;
-		addr += base;
+		down(&child->mm->context.sem);
+		if (unlikely((seg >> 3) >= child->mm->context.size))
+			addr = -1L; /* bogus selector, access would fault */
+		else {
+			desc = child->mm->context.ldt + seg;
+			base = ((desc[0] >> 16) |
+				((desc[1] & 0xff) << 16) |
+				(desc[1] & 0xff000000));
+
+			/* 16-bit code segment? */
+			if (!((desc[1] >> 22) & 1))
+				addr &= 0xffff;
+			addr += base;
+		}
 		up(&child->mm->context.sem);
 	}
+
 	return addr;
 }

>From 502ebf4d4b9b0508bebd88594985d1e8ec968d01 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 18 Jul 2007 18:59:22 +0200
Subject: [PATCH] i386: fixup TRACE_IRQ breakage

i386: fixup TRACE_IRQ breakage

MAINLINE: a10d9a71bafd3a283da240d2868e71346d2aef6f

The TRACE_IRQS_ON function in iret_exc: calls a C function without
ensuring that the segments are set properly. Move the trace function and
the enabling of interrupt into the C stub.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
index 3c3c220..b7be5cf 100644
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -409,8 +409,6 @@ restore_nocheck_notrace:
 1:	INTERRUPT_RETURN
 .section .fixup,"ax"
 iret_exc:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushl $0			# no error code
 	pushl $do_iret_error
 	jmp error_code
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 90da057..4995b92 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -517,10 +517,12 @@ fastcall void do_##name(struct pt_regs * regs,
long error_code) \
 	do_trap(trapnr, signr, str, 0, regs, error_code, NULL); \
 }

-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr) \
+#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq) \
 fastcall void do_##name(struct pt_regs * regs, long error_code) \
 { \
 	siginfo_t info; \
+	if (irq) \
+		local_irq_enable(); \
 	info.si_signo = signr; \
 	info.si_errno = 0; \
 	info.si_code = sicode; \
@@ -560,13 +562,13 @@ DO_VM86_ERROR( 3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR( 4, SIGSEGV, "overflow", overflow)
 DO_VM86_ERROR( 5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN, regs->eip)
+DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN,
regs->eip, 0)
 DO_ERROR( 9, SIGFPE,  "coprocessor segment overrun",
coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
-DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0)
+DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
+DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)

 fastcall void __kprobes do_general_protection(struct pt_regs * regs,
 					      long error_code)
>From 8aa4c64e9902139d19418a2c13782e191f1a674a Mon Sep 17 00:00:00 2001
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
Date: Fri, 8 Feb 2008 23:05:15 +0100
Subject: [PATCH] Intel_agp: really fix 945/965GME

Intel_agp: really fix 945/965GME

MAINLINE: dde4787642ee3cb85aef80bdade04b6f8ddc3df8

Fix some missing places to check with device id info, which
should probe the device gart correctly.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index a124060..d06b652 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -20,7 +20,9 @@
 #define PCI_DEVICE_ID_INTEL_82965G_IG       0x29A2
 #define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
 #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
+#define PCI_DEVICE_ID_INTEL_82965GME_HB     0x2A10
 #define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
+#define PCI_DEVICE_ID_INTEL_82945GME_HB     0x27AC
 #define PCI_DEVICE_ID_INTEL_82945GME_IG     0x27AE
 #define PCI_DEVICE_ID_INTEL_G33_HB          0x29C0
 #define PCI_DEVICE_ID_INTEL_G33_IG          0x29C2
@@ -33,7 +35,8 @@
                  agp_bridge->dev->device ==
PCI_DEVICE_ID_INTEL_82965G_1_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
-                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB)
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB || \
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB)

 #define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
@@ -527,6 +530,7 @@ static void intel_i830_init_gtt_entries(void)
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB ||
 			    IS_I965 || IS_G33)
 				gtt_entries = MB(48) - KB(size);
 			else
@@ -538,6 +542,7 @@ static void intel_i830_init_gtt_entries(void)
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB ||
 			    IS_I965 || IS_G33)
 				gtt_entries = MB(64) - KB(size);
 			else
@@ -1848,9 +1853,9 @@ static const struct intel_driver_description {
 		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, 0, "945G",
 		NULL, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 1, "945GM",
+	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 0, "945GM",
 		NULL, &intel_915_driver },
-	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG,
0, "945GME",
+	{ PCI_DEVICE_ID_INTEL_82945GME_HB, PCI_DEVICE_ID_INTEL_82945GME_IG,
0, "945GME",
 		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
 		NULL, &intel_i965_driver },
@@ -1860,9 +1865,9 @@ static const struct intel_driver_description {
 		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
 		NULL, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1, "965GM",
+	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 0, "965GM",
 		NULL, &intel_i965_driver },
-	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG,
0, "965GME/GLE",
+	{ PCI_DEVICE_ID_INTEL_82965GME_HB, PCI_DEVICE_ID_INTEL_82965GME_IG,
0, "965GME/GLE",
 		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
@@ -2051,11 +2056,13 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_82915GM_HB),
 	ID(PCI_DEVICE_ID_INTEL_82945G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82945GM_HB),
+	ID(PCI_DEVICE_ID_INTEL_82945GME_HB),
 	ID(PCI_DEVICE_ID_INTEL_82946GZ_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
+	ID(PCI_DEVICE_ID_INTEL_82965GME_HB),
 	ID(PCI_DEVICE_ID_INTEL_G33_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
>From 2debc65425a0d38ea4af888ff265fb252c01b67b Mon Sep 17 00:00:00 2001
From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 2 Nov 2007 15:36:08 -0400
Subject: [PATCH] knfsd: fix spurious EINVAL errors on first access of
new filesystem

mainline: ac8587dcb58e40dd336d99d60f852041e06cc3dd

The v2/v3 acl code in nfsd is translating any return from fh_verify() to
nfserr_inval.  This is particularly unfortunate in the case of an
nfserr_dropit return, which is an internal error meant to indicate to
callers that this request has been deferred and should just be dropped
pending the results of an upcall to mountd.

Thanks to Roland <devzero@web.de> for bug report and data collection.

Cc: Roland <devzero@web.de>
Acked-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index b617428..0e5fa11 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -41,7 +41,7 @@ static __be32 nfsacld_proc_getacl(struct svc_rqst * rqstp,

 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);

 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);
diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
index 3e3f2de..b647f2f 100644
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -37,7 +37,7 @@ static __be32 nfsd3_proc_getacl(struct svc_rqst * rqstp,

 	fh = fh_copy(&resp->fh, &argp->fh);
 	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
-		RETURN_STATUS(nfserr_inval);
+		RETURN_STATUS(nfserr);

 	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
 		RETURN_STATUS(nfserr_inval);
>From 2175db184faa2202fe6c819b7050836febebab68 Mon Sep 17 00:00:00 2001
From: J. Bruce Fields <bfields@citi.umich.edu>
Date: Fri, 28 Sep 2007 16:45:51 -0400
Subject: [PATCH] knfsd: query filesystem for NFSv4 getattr of FATTR4_MAXNAME

mainline: a16e92edcd0a2846455a30823e1bac964e743baa

Without this we always return 2^32-1 as the the maximum namelength.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 15809df..0898aec 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1453,7 +1453,8 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct
svc_export *exp,
 	err = vfs_getattr(exp->ex_mnt, dentry, &stat);
 	if (err)
 		goto out_nfserr;
-	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL)) ||
+	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL |
+			FATTR4_WORD0_MAXNAME)) ||
 	    (bmval1 & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
 		       FATTR4_WORD1_SPACE_TOTAL))) {
 		err = vfs_statfs(dentry, &statfs);
@@ -1699,7 +1700,7 @@ out_acl:
 	if (bmval0 & FATTR4_WORD0_MAXNAME) {
 		if ((buflen -= 4) < 0)
 			goto out_resource;
-		WRITE32(~(u32) 0);
+		WRITE32(statfs.f_namelen);
 	}
 	if (bmval0 & FATTR4_WORD0_MAXREAD) {
 		if ((buflen -= 8) < 0)
>From 2b28f2bc9372d6fe659810292e621c9282bc9396 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Fri, 28 Sep 2007 12:27:41 -0400
Subject: [PATCH] NFS: Fix an Oops in encode_lookup()

MAINLINE: 54af3bb543c071769141387a42deaaab5074da55

It doesn't look as if the NFS file name limit is being initialised correctly
in the struct nfs_server. Make sure that we limit whatever is being set in
nfs_probe_fsinfo() and nfs_init_server().

Also ensure that readdirplus and nfs4_path_walk respect our file name
limits.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: NeilBrown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 881fa49..aaf4b04 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -614,16 +614,6 @@ static int nfs_init_server(struct nfs_server
*server, const struct nfs_mount_dat
 	server->namelen  = data->namlen;
 	/* Create a client RPC handle for the NFSv3 ACL management interface */
 	nfs_init_server_aclclient(server);
-	if (clp->cl_nfsversion == 3) {
-		if (server->namelen == 0 || server->namelen > NFS3_MAXNAMLEN)
-			server->namelen = NFS3_MAXNAMLEN;
-		if (!(data->flags & NFS_MOUNT_NORDIRPLUS))
-			server->caps |= NFS_CAP_READDIRPLUS;
-	} else {
-		if (server->namelen == 0 || server->namelen > NFS2_MAXNAMLEN)
-			server->namelen = NFS2_MAXNAMLEN;
-	}
-
 	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
 	return 0;

@@ -820,6 +810,16 @@ struct nfs_server *nfs_create_server(const struct
nfs_mount_data *data,
 	error = nfs_probe_fsinfo(server, mntfh, &fattr);
 	if (error < 0)
 		goto error;
+	if (server->nfs_client->rpc_ops->version == 3) {
+		if (server->namelen == 0 || server->namelen > NFS3_MAXNAMLEN)
+			server->namelen = NFS3_MAXNAMLEN;
+		if (!(data->flags & NFS_MOUNT_NORDIRPLUS))
+			server->caps |= NFS_CAP_READDIRPLUS;
+	} else {
+		if (server->namelen == 0 || server->namelen > NFS2_MAXNAMLEN)
+			server->namelen = NFS2_MAXNAMLEN;
+	}
+
 	if (!(fattr.valid & NFS_ATTR_FATTR)) {
 		error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
 		if (error < 0) {
@@ -1010,6 +1010,9 @@ struct nfs_server *nfs4_create_server(const
struct nfs4_mount_data *data,
 	if (error < 0)
 		goto error;

+	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
+		server->namelen = NFS4_MAXNAMLEN;
+
 	BUG_ON(!server->nfs_client);
 	BUG_ON(!server->nfs_client->rpc_ops);
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
@@ -1082,6 +1085,9 @@ struct nfs_server
*nfs4_create_referral_server(struct nfs_clone_mount *data,
 	if (error < 0)
 		goto error;

+	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
+		server->namelen = NFS4_MAXNAMLEN;
+
 	dprintk("Referral FSID: %llx:%llx\n",
 		(unsigned long long) server->fsid.major,
 		(unsigned long long) server->fsid.minor);
@@ -1141,6 +1147,9 @@ struct nfs_server *nfs_clone_server(struct
nfs_server *source,
 	if (error < 0)
 		goto out_free_server;

+	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
+		server->namelen = NFS4_MAXNAMLEN;
+
 	dprintk("Cloned FSID: %llx:%llx\n",
 		(unsigned long long) server->fsid.major,
 		(unsigned long long) server->fsid.minor);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 95f2631..db1d6b9 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1162,6 +1162,8 @@ static struct dentry
*nfs_readdir_lookup(nfs_readdir_descriptor_t *desc)
 	}
 	if (!desc->plus || !(entry->fattr->valid & NFS_ATTR_FATTR))
 		return NULL;
+	if (name.len > NFS_SERVER(dir)->namelen)
+		return NULL;
 	/* Note: caller is already holding the dir->i_mutex! */
 	dentry = d_alloc(parent, &name);
 	if (dentry == NULL)
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index d1cbf0a..522e5ad 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -175,6 +175,9 @@ next_component:
 		path++;
 	name.len = path - (const char *) name.name;

+	if (name.len > NFS4_MAXNAMLEN)
+		return -ENAMETOOLONG;
+
 eat_dot_dir:
 	while (*path == '/')
 		path++;
>From 42fb057088829339af4c37207aef5351c083e263 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Fri, 8 Feb 2008 14:23:35 -0500
Subject: [PATCH] NFS: Fix a potential file corruption issue when writing

patch 5d47a35600270e7115061cb1320ee60ae9bcb6b8 in mainline.

If the inode is flagged as having an invalid mapping, then we can't rely on
the PageUptodate() flag. Ensure that we don't use the "anti-fragmentation"
write optimisation in nfs_updatepage(), since that will cause NFS to write
out areas of the page that are no longer guaranteed to be up to date.

A potential corruption could occur in the following scenario:

client 1			client 2
===============			===============
				fd=open("f",O_CREAT|O_WRONLY,0644);
				write(fd,"fubar\n",6);	// cache last page
				close(fd);
fd=open("f",O_WRONLY|O_APPEND);
write(fd,"foo\n",4);
close(fd);

				fd=open("f",O_WRONLY|O_APPEND);
				write(fd,"bar\n",4);
				close(fd);
-----
The bug may lead to the file "f" reading 'fubar\n\0\0\0\nbar\n' because
client 2 does not update the cached page after re-opening the file for
write. Instead it keeps it marked as PageUptodate() until someone calls
invalidate_inode_pages2() (typically by calling read()).

The bug was introduced by commit 44b11874ff583b6e766a05856b04f3c492c32b84
"NFS: Separate metadata and page cache revalidation mechanisms"

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index af344a1..380a7ae 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -710,6 +710,17 @@ int nfs_flush_incompatible(struct file *file,
struct page *page)
 }

 /*
+ * If the page cache is marked as unsafe or invalid, then we can't rely on
+ * the PageUptodate() flag. In this case, we will need to turn off
+ * write optimisations that depend on the page contents being correct.
+ */
+static int nfs_write_pageuptodate(struct page *page, struct inode *inode)
+{
+	return PageUptodate(page) &&
+		!(NFS_I(inode)->cache_validity &
(NFS_INO_REVAL_PAGECACHE|NFS_INO_INVALID_DATA));
+}
+
+/*
  * Update and possibly write a cached page of an NFS file.
  *
  * XXX: Keep an eye on generic_file_read to make sure it doesn't do bad
@@ -730,10 +741,13 @@ int nfs_updatepage(struct file *file, struct page *page,
 		(long long)(page_offset(page) +offset));

 	/* If we're not using byte range locks, and we know the page
-	 * is entirely in cache, it may be more efficient to avoid
-	 * fragmenting write requests.
+	 * is up to date, it may be more efficient to extend the write
+	 * to cover the entire page in order to avoid fragmentation
+	 * inefficiencies.
 	 */
-	if (PageUptodate(page) && inode->i_flock == NULL && !(file->f_mode &
O_SYNC)) {
+	if (nfs_write_pageuptodate(page, inode) &&
+			inode->i_flock == NULL &&
+			!(file->f_mode & O_SYNC)) {
 		count = max(count + offset, nfs_page_length(page));
 		offset = 0;
 	}
>From 56fe4e34e97f8d0c65a2cb6ca1a4477d0b1b711a Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 5 Jun 2007 13:26:15 -0400
Subject: [PATCH] NFS: Fix nfs_reval_fsid()

MAINLINE: a0356862bcbeb20acf64bc1a82d28a4c5bb957a7

We don't need to revalidate the fsid on the root directory. It suffices to
revalidate it on the current directory.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: NeilBrown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index c27258b..95f2631 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -897,14 +897,13 @@ int nfs_is_exclusive_create(struct inode *dir,
struct nameidata *nd)
 	return (nd->intent.open.flags & O_EXCL) != 0;
 }

-static inline int nfs_reval_fsid(struct vfsmount *mnt, struct inode *dir,
-				 struct nfs_fh *fh, struct nfs_fattr *fattr)
+static inline int nfs_reval_fsid(struct inode *dir, const struct
nfs_fattr *fattr)
 {
 	struct nfs_server *server = NFS_SERVER(dir);

 	if (!nfs_fsid_equal(&server->fsid, &fattr->fsid))
-		/* Revalidate fsid on root dir */
-		return __nfs_revalidate_inode(server, mnt->mnt_root->d_inode);
+		/* Revalidate fsid using the parent directory */
+		return __nfs_revalidate_inode(server, dir);
 	return 0;
 }

@@ -946,7 +945,7 @@ static struct dentry *nfs_lookup(struct inode
*dir, struct dentry * dentry, stru
 		res = ERR_PTR(error);
 		goto out_unlock;
 	}
-	error = nfs_reval_fsid(nd->mnt, dir, &fhandle, &fattr);
+	error = nfs_reval_fsid(dir, &fattr);
 	if (error < 0) {
 		res = ERR_PTR(error);
 		goto out_unlock;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index bd9f5a8..2219b6c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -961,8 +961,8 @@ static int nfs_update_inode(struct inode *inode,
struct nfs_fattr *fattr)
 		goto out_changed;

 	server = NFS_SERVER(inode);
-	/* Update the fsid if and only if this is the root directory */
-	if (inode == inode->i_sb->s_root->d_inode
+	/* Update the fsid? */
+	if (S_ISDIR(inode->i_mode)
 			&& !nfs_fsid_equal(&server->fsid, &fattr->fsid))
 		server->fsid = fattr->fsid;

>From c39bf6c63dd9102fe053bcaed51d236ae4256357 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 11 Dec 2007 11:05:19 -0500
Subject: [PATCH] NFSv2/v3: Fix a memory leak when using -onolock

MAINLINE: 13ef7b69b54aa8ae4ed264d0bf41339737f8543a

    Neil Brown said:
    > Hi Trond,
    >
    > We found that a machine which made moderately heavy use of
    > 'automount' was leaking some nfs data structures - particularly the
    > 4K allocated by rpc_alloc_iostats.
    > It turns out that this only happens with filesystems with -onolock
    > set.

    > The problem is that if NFS_MOUNT_NONLM is set, nfs_start_lockd doesn't
    > set server->destroy, so when the filesystem is unmounted, the
    > ->client_acl is not shutdown, and so several resources are still
    > held.  Multiple mount/umount cycles will slowly eat away memory
    > several pages at a time.

    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Neil Brown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index aaf4b04..b6fd8a7 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -433,9 +433,6 @@ static int nfs_create_rpc_client(struct nfs_client
*clp, int proto,
  */
 static void nfs_destroy_server(struct nfs_server *server)
 {
-	if (!IS_ERR(server->client_acl))
-		rpc_shutdown_client(server->client_acl);
-
 	if (!(server->flags & NFS_MOUNT_NONLM))
 		lockd_down();	/* release rpc.lockd */
 }
@@ -771,6 +768,9 @@ void nfs_free_server(struct nfs_server *server)

 	if (server->destroy != NULL)
 		server->destroy(server);
+
+	if (!IS_ERR(server->client_acl))
+		rpc_shutdown_client(server->client_acl);
 	if (!IS_ERR(server->client))
 		rpc_shutdown_client(server->client);

>From 0ce012c0868f3bfbe8778e1f291c75b238257dc3 Mon Sep 17 00:00:00 2001
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Date: Fri, 21 Sep 2007 08:33:55 +0200
Subject: [PATCH] Panic in blk_rq_map_sg() from CCISS driver

MAINLINE: a683d652d334a546be9175b894f42dbd8e399536

New scatter/gather list chaining [sg_next()] treats 'page' member of
struct scatterlist with low bit set [0x01] as a chain pointer to
another struct scatterlist [array].  The CCISS driver request function
passes an uninitialized, temporary, on-stack scatterlist array to
blk_rq_map_sq().  sg_next() interprets random data on the stack as a
chain pointer and eventually tries to de-reference an invalid pointer,
resulting in:

[<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
PGD 6090c3067 PUD 0
Oops: 0000 [1] SMP
last sysfs file: /block/cciss!c0d0/cciss!c0d0p1/dev
CPU 6
Modules linked in: ehci_hcd ohci_hcd uhci_hcd
Pid: 1, comm: init Not tainted 2.6.23-rc6-mm1 #3
RIP: 0010:[<ffffffff8031dd70>] [<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
RSP: 0018:ffff81060901f768 EFLAGS: 00010206
RAX: 000000040b161000 RBX: ffff81060901f7d8 RCX: 000000040b162c00
RDX: 0000000000000000 RSI: ffff81060b13a260 RDI: ffff81060b139600
RBP: 0000000000001400 R08: 00000000fffffffe R09: 0000000000000400
R10: 0000000000000000 R11: 000000040b163000 R12: ffff810102fe0000
R13: 0000000000000001 R14: 0000000000000001 R15: 00001e0000000000
FS: 00000000026108f0(0063) GS:ffff810409000b80(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000010000001e CR3: 00000006090c6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff81060901e000, task ffff810409020800)
last branch before last exception/interrupt
from [<ffffffff8031de0a>] blk_rq_map_sg+0x10a/0x170
to [<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
Stack: 000000018068ea00 ffff810102fe0000 0000000000000000 ffff810011400000
0000000000000002 0000000000000000 ffff81040b172000 ffffffff803acd3d
0000000000003ec1 ffff8106090d5000 ffff8106090d5000 ffff810102fe0000
Call Trace:
[<ffffffff803acd3d>] do_cciss_request+0x15d/0x4c0
[<ffffffff80298968>] new_slab+0x1c8/0x270
[<ffffffff80298ffd>] __slab_alloc+0x22d/0x470
[<ffffffff8027327b>] mempool_alloc+0x4b/0x130
[<ffffffff8032b21e>] cfq_set_request+0xee/0x380
[<ffffffff8027327b>] mempool_alloc+0x4b/0x130
[<ffffffff8031ff98>] get_request+0x168/0x360
[<ffffffff80331b0d>] rb_insert_color+0x8d/0x110
[<ffffffff8031cfd8>] elv_rb_add+0x58/0x60
[<ffffffff8032a329>] cfq_add_rq_rb+0x69/0xa0
[<ffffffff8031c1ab>] elv_merged_request+0x5b/0x60
[<ffffffff803224fd>] __make_request+0x23d/0x650
[<ffffffff80298ffd>] __slab_alloc+0x22d/0x470
[<ffffffff80270000>] generic_write_checks+0x140/0x190
[<ffffffff8031f012>] generic_make_request+0x1c2/0x3a0
<etc>
Kernel panic - not syncing: Attempted to kill init!

This patch initializes the tmp_sg array to zeroes.  Perhaps not the ultimate
fix, but an effective work-around.  I can now boot 23-rc6-mm1 on an HP
Proliant x86_64 with CCISS boot disk.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 132f76b..355fc17 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2568,6 +2568,7 @@ static void do_cciss_request(request_queue_t *q)
 	       (int)creq->nr_sectors);
 #endif				/* CCISS_DEBUG */

+	memset(tmp_sg, 0, sizeof(tmp_sg));
 	seg = blk_rq_map_sg(q, creq, tmp_sg);

 	/* get the DMA records for the setup */
>From 077e603aedf4827ceb1ef6901620b4faedcab6ee Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Mon, 4 Feb 2008 13:56:36 +0000
Subject: [PATCH] PCI: Fix fakephp deadlock

MAINLINE: 5c796ae7a7ebe56967ed9b9963d7c16d733635ff

This patch works around a problem in the fakephp driver when a process
writing "0" to a "power" sysfs file to fake removal of a PCI device ends
up deadlocking itself in the sysfs code.

The patch is functionally identical to the one in Linus' tree post 2.6.24:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5c796ae7a7ebe56967ed9b9963d7c16d733635ff

I have tested it on a 2.6.22 kernel.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 027f686..02a09d5 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 #include "../pci.h"

 #if !defined(MODULE)
@@ -63,10 +64,16 @@ struct dummy_slot {
 	struct list_head node;
 	struct hotplug_slot *slot;
 	struct pci_dev *dev;
+	struct work_struct remove_work;
+	unsigned long removed;
 };

 static int debug;
 static LIST_HEAD(slot_list);
+static struct workqueue_struct *dummyphp_wq;
+
+static void pci_rescan_worker(struct work_struct *work);
+static DECLARE_WORK(pci_rescan_work, pci_rescan_worker);

 static int enable_slot (struct hotplug_slot *slot);
 static int disable_slot (struct hotplug_slot *slot);
@@ -109,7 +116,7 @@ static int add_slot(struct pci_dev *dev)
 	slot->name = &dev->dev.bus_id[0];
 	dbg("slot->name = %s\n", slot->name);

-	dslot = kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);
+	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
 	if (!dslot)
 		goto error_info;

@@ -164,6 +171,14 @@ static void remove_slot(struct dummy_slot *dslot)
 		err("Problem unregistering a slot %s\n", dslot->slot->name);
 }

+/* called from the single-threaded workqueue handler to remove a slot */
+static void remove_slot_worker(struct work_struct *work)
+{
+	struct dummy_slot *dslot =
+		container_of(work, struct dummy_slot, remove_work);
+	remove_slot(dslot);
+}
+
 /**
  * Rescan slot.
  * Tries hard not to re-enable already existing devices
@@ -267,11 +282,17 @@ static inline void pci_rescan(void) {
 	pci_rescan_buses(&pci_root_buses);
 }

+/* called from the single-threaded workqueue handler to rescan all pci buses */
+static void pci_rescan_worker(struct work_struct *work)
+{
+	pci_rescan();
+}

 static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	/* mis-use enable_slot for rescanning of the pci bus */
-	pci_rescan();
+	cancel_work_sync(&pci_rescan_work);
+	queue_work(dummyphp_wq, &pci_rescan_work);
 	return -ENODEV;
 }

@@ -306,6 +327,10 @@ static int disable_slot(struct hotplug_slot *slot)
 		err("Can't remove PCI devices with other PCI devices behind it yet.\n");
 		return -ENODEV;
 	}
+	if (test_and_set_bit(0, &dslot->removed)) {
+		dbg("Slot already scheduled for removal\n");
+		return -ENODEV;
+	}
 	/* search for subfunctions and disable them first */
 	if (!(dslot->dev->devfn & 7)) {
 		for (func = 1; func < 8; func++) {
@@ -328,8 +353,9 @@ static int disable_slot(struct hotplug_slot *slot)
 	/* remove the device from the pci core */
 	pci_remove_bus_device(dslot->dev);

-	/* blow away this sysfs entry and other parts. */
-	remove_slot(dslot);
+	/* queue work item to blow away this sysfs entry and other parts. */
+	INIT_WORK(&dslot->remove_work, remove_slot_worker);
+	queue_work(dummyphp_wq, &dslot->remove_work);

 	return 0;
 }
@@ -340,6 +366,7 @@ static void cleanup_slots (void)
 	struct list_head *next;
 	struct dummy_slot *dslot;

+	destroy_workqueue(dummyphp_wq);
 	list_for_each_safe (tmp, next, &slot_list) {
 		dslot = list_entry (tmp, struct dummy_slot, node);
 		remove_slot(dslot);
@@ -351,6 +378,10 @@ static int __init dummyphp_init(void)
 {
 	info(DRIVER_DESC "\n");

+	dummyphp_wq = create_singlethread_workqueue(MY_NAME);
+	if (!dummyphp_wq)
+		return -ENOMEM;
+
 	return pci_scan_buses();
 }

>From 053a4418b8da611b1a8b750ffcda8411432b7ad7 Mon Sep 17 00:00:00 2001
From: Kees Cook <kees@ubuntu.com>
Date: Wed, 19 Sep 2007 05:46:32 -0700
Subject: [PATCH] pci: fix unterminated pci_device_id lists

pci: fix unterminated pci_device_id lists

mainline: 248bdd5efca5a113cbf443a993c69e53d370236b

Fix a couple drivers that do not correctly terminate their pci_device_id
lists.  This results in garbage being spewed into modules.pcimap when the
module happens to not have 28 NULL bytes following the table, and/or the
last PCI ID is actually truncated from the table when calculating the
modules.alias PCI aliases, cause those unfortunate device IDs to not
auto-load.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Acked-by: Corey Minyard <minyard@acm.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 78e1b96..eb894f8 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2214,7 +2214,8 @@ static int ipmi_pci_resume(struct pci_dev *pdev)

 static struct pci_device_id ipmi_pci_devices[] = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
-	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
+	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
+	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);

diff --git a/drivers/media/video/usbvision/usbvision-cards.c
b/drivers/media/video/usbvision/usbvision-cards.c
index 51ab265..31db1ed 100644
--- a/drivers/media/video/usbvision/usbvision-cards.c
+++ b/drivers/media/video/usbvision/usbvision-cards.c
@@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] = {
 	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
 	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
 	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
+	{ },    /* terminate list */
 };

 MODULE_DEVICE_TABLE (usb, usbvision_table);
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index cff969d..6f32a35 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -816,7 +816,8 @@ static void __devexit cafe_nand_remove(struct pci_dev *pdev)
 }

 static struct pci_device_id cafe_nand_tbl[] = {
-	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH <<
8, 0xFFFF0 }
+	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH <<
8, 0xFFFF0 },
+	{ 0, }
 };

 MODULE_DEVICE_TABLE(pci, cafe_nand_tbl);
>From b5cf6be2dfcb4ae3885edec574526221c58f0216 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <clameter@sgi.com>
Date: Sat, 22 Dec 2007 14:03:23 -0800
Subject: [PATCH] quicklists: do not release off node pages early

patch ed367fc3a7349b17354c7acef551533337764859 in mainline.

quicklists must keep even off node pages on the quicklists until the TLB
flush has been completed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/include/linux/quicklist.h b/include/linux/quicklist.h
index 9371c61..39b6671 100644
--- a/include/linux/quicklist.h
+++ b/include/linux/quicklist.h
@@ -56,14 +56,6 @@ static inline void __quicklist_free(int nr, void
(*dtor)(void *), void *p,
 	struct page *page)
 {
 	struct quicklist *q;
-	int nid = page_to_nid(page);
-
-	if (unlikely(nid != numa_node_id())) {
-		if (dtor)
-			dtor(p);
-		__free_page(page);
-		return;
-	}

 	q = &get_cpu_var(quicklist)[nr];
 	*(void **)p = q->page;
>From fcae8056673aa7b5b55d669fe5255ae76a93ae53 Mon Sep 17 00:00:00 2001
From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 16 Jan 2008 00:21:19 +0530
Subject: [PATCH] quicklists: Only consider memory that can be used
with GFP_KERNEL

patch 96990a4ae979df9e235d01097d6175759331e88c in mainline.

Quicklists calculates the size of the quicklists based on the number of
free pages.  This must be the number of free pages that can be allocated
with GFP_KERNEL.  node_page_state() includes the pages in ZONE_HIGHMEM and
ZONE_MOVABLE which may lead the quicklists to become too large causing OOM.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/mm/quicklist.c b/mm/quicklist.c
index ae8189c..3f703f7 100644
--- a/mm/quicklist.c
+++ b/mm/quicklist.c
@@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];
 static unsigned long max_pages(unsigned long min_pages)
 {
 	unsigned long node_free_pages, max;
+	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
+
+	node_free_pages =
+#ifdef CONFIG_ZONE_DMA
+		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
+#endif
+#ifdef CONFIG_ZONE_DMA32
+		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
+#endif
+		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);

-	node_free_pages = node_page_state(numa_node_id(),
-			NR_FREE_PAGES);
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
 	return max(max, min_pages);
 }
>From e38523fd7f35f485e8190b0ad286b8137a852b13 Mon Sep 17 00:00:00 2001
From: Mikael Pettersson <mikpe@it.uu.se>
Date: Wed, 16 Jan 2008 10:32:17 +0100
Subject: [PATCH] sata_promise: ASIC PRD table bug workaround

patch b9ccd4a90bbb964506f01b4bdcff4f50f8d5d334 in mainline.

Second-generation Promise SATA controllers have an ASIC bug
which can trigger if the last PRD entry is larger than 164 bytes,
resulting in intermittent errors and possible data corruption.

Work around this by replacing calls to ata_qc_prep() with a
private version that fills the PRD, checks the size of the
last entry, and if necessary splits it to avoid the bug.
Also reduce sg_tablesize by 1 to accommodate the new entry.

Tested on the second-generation SATA300 TX4 and SATA300 TX2plus,
and the first-generation PDC20378.

Thanks to Alexander Sabourenkov for verifying the bug by
studying the vendor driver, and for writing the initial patch
upon which this one is based.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 6dc0b01..1d90ce1 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -51,6 +51,7 @@
 enum {
 	PDC_MAX_PORTS		= 4,
 	PDC_MMIO_BAR		= 3,
+	PDC_MAX_PRD		= LIBATA_MAX_PRD - 1, /* -1 for ASIC PRD bug workaround */

 	/* register offsets */
 	PDC_FEATURE		= 0x04, /* Feature/Error reg (per port) */
@@ -157,7 +158,7 @@ static struct scsi_host_template pdc_ata_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= PDC_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -531,6 +532,84 @@ static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 	memcpy(buf+31, cdb, cdb_len);
 }

+/**
+ *	pdc_fill_sg - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command.
+ *	Make sure hardware does not choke on it.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void pdc_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+	const u32 SG_COUNT_ASIC_BUG = 41*4;
+
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			ap->prd[idx].addr = cpu_to_le32(addr);
+			ap->prd[idx].flags_len = cpu_to_le32(len & 0xffff);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	if (idx) {
+		u32 len = le32_to_cpu(ap->prd[idx - 1].flags_len);
+
+		if (len > SG_COUNT_ASIC_BUG) {
+			u32 addr;
+
+			VPRINTK("Splitting last PRD.\n");
+
+			addr = le32_to_cpu(ap->prd[idx - 1].addr);
+			ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
+
+			addr = addr + len - SG_COUNT_ASIC_BUG;
+			len = SG_COUNT_ASIC_BUG;
+			ap->prd[idx].addr = cpu_to_le32(addr);
+			ap->prd[idx].flags_len = cpu_to_le32(len);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+
+			idx++;
+		}
+
+		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	}
+}
+
 static void pdc_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct pdc_port_priv *pp = qc->ap->private_data;
@@ -540,7 +619,7 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)

 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
-		ata_qc_prep(qc);
+		pdc_fill_sg(qc);
 		/* fall through */

 	case ATA_PROT_NODATA:
@@ -556,11 +635,11 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 		break;

 	case ATA_PROT_ATAPI:
-		ata_qc_prep(qc);
+		pdc_fill_sg(qc);
 		break;

 	case ATA_PROT_ATAPI_DMA:
-		ata_qc_prep(qc);
+		pdc_fill_sg(qc);
 		/*FALLTHROUGH*/
 	case ATA_PROT_ATAPI_NODATA:
 		pdc_atapi_pkt(qc);
>From 3c565dcb45570eec3471b33ace87ecb4b51e70d4 Mon Sep 17 00:00:00 2001
From: Mikael Pettersson <mikpe@it.uu.se>
Date: Wed, 16 Jan 2008 10:31:22 +0100
Subject: [PATCH] sata_promise: FastTrack TX4200 is a second-generation chip

patch 7f9992a23190418592f0810900e4f91546ec41da in mainline.

This patch corrects sata_promise to classify FastTrack TX4200
(DID 3515/3519) as a second-generation chip. Promise's partial-
source FT TX4200 driver confirms this classification.

Treating it as a first-generation chip causes several problems:
1. Detection failures. This is a recent regression triggered by
   the hotplug-enabling changes in 2.6.23-rc1.
2. Various "failed to resume link for reset" warnings.

This patch fixes <http://bugzilla.kernel.org/show_bug.cgi?id=8936>.

Thanks to Stephen Ziemba for reporting the bug and for testing the fix.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 1d90ce1..681b76a 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -331,8 +331,8 @@ static const struct pci_device_id pdc_ata_pci_tbl[] = {

 	{ PCI_VDEVICE(PROMISE, 0x3318), board_20319 },
 	{ PCI_VDEVICE(PROMISE, 0x3319), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3515), board_20319 },
-	{ PCI_VDEVICE(PROMISE, 0x3519), board_20319 },
+	{ PCI_VDEVICE(PROMISE, 0x3515), board_40518 },
+	{ PCI_VDEVICE(PROMISE, 0x3519), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d17), board_40518 },
 	{ PCI_VDEVICE(PROMISE, 0x3d18), board_40518 },

>From 17ddbac1c59c8d184c8ceb0b5bd39e6a97f9e7a8 Mon Sep 17 00:00:00 2001
From: Mattia Dongili <malattia@linux.it>
Date: Sun, 12 Aug 2007 07:20:27 +0900
Subject: [PATCH] sony-laptop: call sonypi_compat_init earlier

sony-laptop: call sonypi_compat_init earlier

mainline: 015a916fbbf105bb15f4bbfd80c3b9b2f2e0d7db

sonypi_compat uses a kfifo that needs to be present before _SRS is
called to be able to cope with the IRQs triggered when setting
resources.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index ab2ca63..6d2d64f 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -2056,8 +2056,6 @@ static int sony_pic_remove(struct acpi_device
*device, int type)
 	struct sony_pic_ioport *io, *tmp_io;
 	struct sony_pic_irq *irq, *tmp_irq;

-	sonypi_compat_exit();
-
 	if (sony_pic_disable(device)) {
 		printk(KERN_ERR DRV_PFX "Couldn't disable device.\n");
 		return -ENXIO;
@@ -2067,6 +2065,8 @@ static int sony_pic_remove(struct acpi_device
*device, int type)
 	release_region(spic_dev.cur_ioport->io.minimum,
 			spic_dev.cur_ioport->io.address_length);

+	sonypi_compat_exit();
+
 	sony_laptop_remove_input();

 	/* pf attrs */
@@ -2132,6 +2132,9 @@ static int sony_pic_add(struct acpi_device *device)
 		goto err_free_resources;
 	}

+	if (sonypi_compat_init())
+		goto err_remove_input;
+
 	/* request io port */
 	list_for_each_entry(io, &spic_dev.ioports, list) {
 		if (request_region(io->io.minimum, io->io.address_length,
@@ -2146,7 +2149,7 @@ static int sony_pic_add(struct acpi_device *device)
 	if (!spic_dev.cur_ioport) {
 		printk(KERN_ERR DRV_PFX "Failed to request_region.\n");
 		result = -ENODEV;
-		goto err_remove_input;
+		goto err_remove_compat;
 	}

 	/* request IRQ */
@@ -2186,9 +2189,6 @@ static int sony_pic_add(struct acpi_device *device)
 	if (result)
 		goto err_remove_pf;

-	if (sonypi_compat_init())
-		goto err_remove_pf;
-
 	return 0;

 err_remove_pf:
@@ -2204,6 +2204,9 @@ err_release_region:
 	release_region(spic_dev.cur_ioport->io.minimum,
 			spic_dev.cur_ioport->io.address_length);

+err_remove_compat:
+	sonypi_compat_exit();
+
 err_remove_input:
 	sony_laptop_remove_input();

>From eddfe53b77e6c2008f4a2c46a179b7d8a63c8d71 Mon Sep 17 00:00:00 2001
From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Thu, 15 Nov 2007 03:47:27 -0800
Subject: [PATCH] Don't oops on MTU change.

[VIA_VELOCITY]: Don't oops on MTU change.

MAINLINE: bd7b3f34198071d8bec05180530c362f1800ba46

Simple mtu change when device is down.
Fix http://bugzilla.kernel.org/show_bug.cgi?id=9382.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index b670b97..63a2f81 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -1798,6 +1798,11 @@ static int velocity_change_mtu(struct
net_device *dev, int new_mtu)
 		return -EINVAL;
 	}

+	if (!netif_running(dev)) {
+		dev->mtu = new_mtu;
+		return 0;
+	}
+
 	if (new_mtu != oldmtu) {
 		spin_lock_irqsave(&vptr->lock, flags);

>From ed27e4a69a8c2b0eaa9fd7b3d74a0da95baa7780 Mon Sep 17 00:00:00 2001
From: Stephen Hemminger <shemminger@linux-foundation.org>
Date: Wed, 28 Nov 2007 22:20:16 -0800
Subject: [PATCH] via-velocity: don't oops on MTU change (resend)

via-velocity: don't oops on MTU change (resend)

mainline: 48f6b053613b62fed7a2fe3255e5568260a8d615

The VIA veloicty driver needs the following to allow changing MTU when down.
The buffer size needs to be computed when device is brought up, not when
device is initialized.  This also fixes a bug where the buffer size was
computed differently on change_mtu versus initial setting.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 63a2f81..431269e 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -1075,6 +1075,9 @@ static int velocity_init_rd_ring(struct
velocity_info *vptr)
 	int ret = -ENOMEM;
 	unsigned int rsize = sizeof(struct velocity_rd_info) *
 					vptr->options.numrx;
+	int mtu = vptr->dev->mtu;
+
+	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;

 	vptr->rd_info = kmalloc(rsize, GFP_KERNEL);
 	if(vptr->rd_info == NULL)
@@ -1733,8 +1736,6 @@ static int velocity_open(struct net_device *dev)
 	struct velocity_info *vptr = netdev_priv(dev);
 	int ret;

-	vptr->rx_buf_sz = (dev->mtu <= 1504 ? PKT_BUF_SZ : dev->mtu + 32);
-
 	ret = velocity_init_rings(vptr);
 	if (ret < 0)
 		goto out;
@@ -1813,12 +1814,6 @@ static int velocity_change_mtu(struct
net_device *dev, int new_mtu)
 		velocity_free_rd_ring(vptr);

 		dev->mtu = new_mtu;
-		if (new_mtu > 8192)
-			vptr->rx_buf_sz = 9 * 1024;
-		else if (new_mtu > 4096)
-			vptr->rx_buf_sz = 8192;
-		else
-			vptr->rx_buf_sz = 4 * 1024;

 		ret = velocity_init_rd_ring(vptr);
 		if (ret < 0)


-- 
Thanks,
Oliver

------=_Part_2166_29143688.1203267796108
Content-Type: application/x-bzip2; name=v2.6.22.19-queue.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=v2.6.22.19-queue.tar.bz2

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

------=_Part_2166_29143688.1203267796108--
