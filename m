Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbZEKJ5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbZEKJ5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbZEKJyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:54:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:53926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757970AbZEKJyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:54:19 -0400
Date: Mon, 11 May 2009 09:53:42 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49BF0978.40605@kernel.org>
References: <49BF0978.40605@kernel.org>
Subject: [tip:x86/mm] x86: clean up and and print out initial max_pfn_mapped
Message-ID: <tip-80989ce0643c1034822f3e339ed8d790b649abe1@git.kernel.org>
Git-Commit-ID: 80989ce0643c1034822f3e339ed8d790b649abe1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:53:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80989ce0643c1034822f3e339ed8d790b649abe1
Gitweb:     http://git.kernel.org/tip/80989ce0643c1034822f3e339ed8d790b649abe1
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 9 May 2009 23:47:42 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 11:11:12 +0200

x86: clean up and and print out initial max_pfn_mapped

Do this so we can check the range that is mapped before
init_memory_mapping().

To be able to print out meaningful info, we first have to fix
64-bit to have max_pfn_mapped assigned before that call. This
also unifies the code-path a bit.

[ Impact: print more debug info, cleanup ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49BF0978.40605@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup.c |    4 ++++
 arch/x86/mm/init.c      |    7 +++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0d77e56..4031d6c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -862,12 +862,16 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 #endif
 
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
 	setup_bios_corruption_check();
 #endif
 
+	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
+			max_pfn_mapped<<PAGE_SHIFT);
+
 	reserve_brk();
 
 	/* max_pfn_mapped is updated here */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 95f5ecf..92d2108 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -132,12 +132,11 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	 */
 #ifdef CONFIG_X86_32
 	start = 0x7000;
-	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
-#else /* CONFIG_X86_64 */
+#else
 	start = 0x8000;
-	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 #endif
+	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+					tables, PAGE_SIZE);
 	if (e820_table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
