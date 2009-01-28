Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZA1UVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZA1UVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZA1UVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:21:30 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41018 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZA1UV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=W/1HsZpSANijCJuZuF7VNTc5WaNLO3luIdN6daqm1JQGdHrSE41hGAS0iNOXlaNbOT
         oy+ZwsKZ0CbDc3w9L0/+zZipQFcFnuFtesOSyhEjwh89DyY6a3Yrk8NgTBJe18CMWqAe
         rYiyTkB+EdPZsx1qZZIuga0bDEsKBDcSiGE3c=
Date: Wed, 28 Jan 2009 23:21:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: trampoline_64.S - use predefined constants with
	simplification
Message-ID: <20090128202125.GA32555@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

We may use macros from processor-flags.h instead
of hardcoding bits. Actually it's not direct mapping
of old instructions with new ones -- BTS does change
CF flag while MOV does not. But i didn't find any
dependency on CF in this code.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review

 arch/x86/kernel/trampoline_64.S |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/trampoline_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/trampoline_64.S
+++ linux-2.6.git/arch/x86/kernel/trampoline_64.S
@@ -29,6 +29,7 @@
 #include <asm/page.h>
 #include <asm/msr.h>
 #include <asm/segment.h>
+#include <asm/processor-flags.h>
 
 .section .rodata, "a", @progbits
 
@@ -37,7 +38,7 @@
 ENTRY(trampoline_data)
 r_base = .
 	cli			# We should be safe anyway
-	wbinvd	
+	wbinvd
 	mov	%cs, %ax	# Code and data in the same place
 	mov	%ax, %ds
 	mov	%ax, %es
@@ -73,9 +74,8 @@ r_base = .
 	lidtl	tidt - r_base	# load idt with 0, 0
 	lgdtl	tgdt - r_base	# load gdt with whatever is appropriate
 
-	xor	%ax, %ax
-	inc	%ax		# protected mode (PE) bit
-	lmsw	%ax		# into protected mode
+	mov	$X86_CR0_PE, %ax	# protected mode (PE) bit
+	lmsw	%ax			# into protected mode
 
 	# flush prefetch and jump to startup_32
 	ljmpl	*(startup_32_vector - r_base)
@@ -86,9 +86,8 @@ startup_32:
 	movl	$__KERNEL_DS, %eax	# Initialize the %ds segment register
 	movl	%eax, %ds
 
-	xorl	%eax, %eax
-	btsl	$5, %eax		# Enable PAE mode
-	movl	%eax, %cr4
+	movl	$X86_CR4_PAE, %eax
+	movl	%eax, %cr4		# Enable PAE mode
 
 					# Setup trampoline 4 level pagetables
 	leal	(trampoline_level4_pgt - r_base)(%esi), %eax
@@ -99,9 +98,9 @@ startup_32:
 	xorl	%edx, %edx
 	wrmsr
 
-	xorl	%eax, %eax
-	btsl	$31, %eax		# Enable paging and in turn activate Long Mode
-	btsl	$0, %eax		# Enable protected mode
+	# Enable paging and in turn activate Long Mode
+	# Enable protected mode
+	movl	$(X86_CR0_PG | X86_CR0_PE), %eax
 	movl	%eax, %cr0
 
 	/*
