Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbXE3BtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbXE3BtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXE3Bsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:48:33 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:30473 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXE3Bsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:48:30 -0400
Date: Tue, 29 May 2007 18:47:02 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/5] x86: initial fixmap support
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705291847.02900.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/5] x86: initial fixmap support

From: "Eric W. Biederman" <ebiederm@xmission.com>

needed to get fixed virtual address for USB debug port and earlycon with mmio.

Signed-off-by: Eric W. Biderman <ebiderman@xmisson.com>
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index f74dfc4..8271466 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -168,6 +168,12 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 .section .init.text,"ax",@progbits
 #endif
 
+	/* Do an early initialization of the fixmap area */
+	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
+	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
+	addl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
+	movl %eax, 4092(%edx)
+
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
@@ -507,6 +513,8 @@ ENTRY(_stext)
 .section ".bss.page_aligned","w"
 ENTRY(swapper_pg_dir)
 	.fill 1024,4,0
+ENTRY(swapper_pg_pmd)
+	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
 
diff --git a/arch/x86_64/kernel/head.S b/arch/x86_64/kernel/head.S
index 1fab487..941c84b 100644
--- a/arch/x86_64/kernel/head.S
+++ b/arch/x86_64/kernel/head.S
@@ -73,7 +73,11 @@ startup_64:
 	addq	%rbp, init_level4_pgt + (511*8)(%rip)
 
 	addq	%rbp, level3_ident_pgt + 0(%rip)
+
 	addq	%rbp, level3_kernel_pgt + (510*8)(%rip)
+	addq	%rbp, level3_kernel_pgt + (511*8)(%rip)
+
+	addq	%rbp, level2_fixmap_pgt + (506*8)(%rip)
 
 	/* Add an Identity mapping if I am above 1G */
 	leaq	_text(%rip), %rdi
@@ -314,7 +318,16 @@ NEXT_PAGE(level3_kernel_pgt)
 	.fill	510,8,0
 	/* (2^48-(2*1024*1024*1024)-((2^39)*511))/(2^30) = 510 */
 	.quad	level2_kernel_pgt - __START_KERNEL_map + _KERNPG_TABLE
-	.fill	1,8,0
+	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
+
+NEXT_PAGE(level2_fixmap_pgt)
+	.fill	506,8,0
+	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
+	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
+	.fill	5,8,0
+
+NEXT_PAGE(level1_fixmap_pgt)
+	.fill	512,8,0
 
 NEXT_PAGE(level2_ident_pgt)
 	/* Since I easily can, map the first 1G.
