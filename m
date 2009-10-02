Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZJBBcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZJBBcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZJBBcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:50 -0400
Received: from kroah.org ([198.145.64.141]:32994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbZJBBcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:10 2009
Message-Id: <20091002012410.020718738@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [028/136] xen: check EFER for NX before setting up GDT mapping
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=xen-check-efer-for-nx-before-setting-up-gdt-mapping.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit b75fe4e5b869f8dbebd36df64a7fcda0c5b318ed upstream.

x86-64 assumes NX is available by default, so we need to
explicitly check for it before using NX.  Some first-generation
Intel x86-64 processors didn't support NX, and even recent systems
allow it to be disabled in BIOS.

[ Impact: prevent Xen crash on NX-less 64-bit machines ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/Makefile     |    1 +
 arch/x86/xen/enlighten.c |   10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -4,6 +4,7 @@ obj-y	:=  init.o init_$(BITS).o fault.o 
 # Make sure __phys_addr has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_ioremap.o		:= $(nostackp)
+CFLAGS_init.o			:= $(nostackp)
 
 obj-$(CONFIG_SMP)		+= tlb.o
 
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1083,6 +1083,11 @@ asmlinkage void __init xen_start_kernel(
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
+#ifdef CONFIG_X86_64
+	/* Work out if we support NX */
+	check_efer();
+#endif
+
 	xen_setup_features();
 
 	/* Get mfn list */
@@ -1123,11 +1128,6 @@ asmlinkage void __init xen_start_kernel(
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-#ifdef CONFIG_X86_64
-	/* Work out if we support NX */
-	check_efer();
-#endif
-
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];


