Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYGHXc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYGHXc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbYGHXP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:28 -0400
Received: from gw.goop.org ([64.81.55.164]:51215 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 22 of 55] xen64: add xen-head code to head_64.S
X-Mercurial-Node: cd8b436c2b6da877bc0389c9e4cbc900f0961833
Message-Id: <cd8b436c2b6da877bc03.1215554804@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Xen entrypoint and ELF notes to head_64.S.  Adapts xen-head.S
to compile either 32-bit or 64-bit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/asm-offsets_64.c |    3 +++
 arch/x86/kernel/head_64.S        |    1 +
 arch/x86/xen/xen-head.S          |   15 +++++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -131,5 +131,8 @@
 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
+
+	BLANK();
+	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
 	return 0;
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -401,6 +401,7 @@
 	/* This must match the first entry in level2_kernel_pgt */
 	.quad   0x0000000000000000
 
+#include "../../x86/xen/xen-head.S"
 	
 	.section .bss, "aw", @nobits
 	.align L1_CACHE_BYTES
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -8,15 +8,21 @@
 
 #include <asm/boot.h>
 #include <asm/asm.h>
+#include <asm/page.h>
 
 #include <xen/interface/elfnote.h>
 #include <asm/xen/interface.h>
 
 	__INIT
 ENTRY(startup_xen)
-	movl %esi,xen_start_info
 	cld
-	movl $(init_thread_union+THREAD_SIZE),%esp
+#ifdef CONFIG_X86_32
+	mov %esi,xen_start_info
+	mov $init_thread_union+THREAD_SIZE,%esp
+#else
+	mov %rsi,xen_start_info
+	mov $init_thread_union+THREAD_SIZE,%rsp
+#endif
 	jmp xen_start_kernel
 
 	__FINIT
@@ -30,7 +36,11 @@
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
 	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
+#ifdef CONFIG_X86_32
 	ELFNOTE(Xen, XEN_ELFNOTE_VIRT_BASE,      _ASM_PTR __PAGE_OFFSET)
+#else
+	ELFNOTE(Xen, XEN_ELFNOTE_VIRT_BASE,      _ASM_PTR __START_KERNEL_map)
+#endif
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
 	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
 	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
@@ -40,5 +50,6 @@
 		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
 	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
 	ELFNOTE(Xen, XEN_ELFNOTE_HV_START_LOW,   _ASM_PTR __HYPERVISOR_VIRT_START)
+	ELFNOTE(Xen, XEN_ELFNOTE_PADDR_OFFSET,   _ASM_PTR 0)
 
 #endif /*CONFIG_XEN */


