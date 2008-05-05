Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYEELBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYEELBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYEELAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 07:00:00 -0400
Received: from saeurebad.de ([85.214.36.134]:59728 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbYEEK77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:59:59 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Mon May  5 12:08:47 2008
Message-Id: <20080505100846.804585724@symbol.fehenstaub.lan>
References: <20080505095938.326928514@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Mon, 05 May 2008 11:59:41 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [rfc][patch 3/3] x86: Use bootmem2 on x86_32
Content-Disposition: inline; filename=bootmem2-migrate-x86_32.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight-forward migration to use bootmem2 on the author's computer.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -641,7 +641,9 @@ void __init setup_bootmem_allocator(void
 	/*
 	 * Initialize the boot-time allocator (with low memory only):
 	 */
-	bootmap_size = init_bootmem(min_low_pfn, max_low_pfn);
+	bootmem_register(0, max_low_pfn);
+	bootmap_size = bootmem_map_pages() << PAGE_SHIFT;
+	bootmem_setup(min_low_pfn);
 
 	register_bootmem_low_pages(max_low_pfn);
 
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -585,7 +585,7 @@ void __init mem_init(void)
 	}
 #endif
 	/* this will put all low memory onto the freelists */
-	totalram_pages += free_all_bootmem();
+	totalram_pages += bootmem_release();
 
 	reservedpages = 0;
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -24,6 +24,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_BOOTMEM2 if X86_32
 
 config DEFCONFIG_LIST
 	string

-- 

