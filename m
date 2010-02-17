Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0BQTyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 14:54:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:51641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0BQTyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 14:54:13 -0500
Date: Wed, 17 Feb 2010 19:51:36 GMT
From: tip-bot for Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, sliakh.lkml@gmail.com,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       jiang@cs.ncsu.edu, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, sliakh.lkml@gmail.com,
       jmorris@namei.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       tglx@linutronix.de, jiang@cs.ncsu.edu
In-Reply-To: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
References: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: NX protection for kernel data
Message-ID: <tip-01ab31371da90a795b774d87edf2c21bb3a64dda@git.kernel.org>
Git-Commit-ID: 01ab31371da90a795b774d87edf2c21bb3a64dda
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 19:51:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01ab31371da90a795b774d87edf2c21bb3a64dda
Gitweb:     http://git.kernel.org/tip/01ab31371da90a795b774d87edf2c21bb3a64dda
Author:     Siarhei Liakh <sliakh.lkml@gmail.com>
AuthorDate: Sun, 31 Jan 2010 18:27:55 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 17 Feb 2010 10:11:24 -0800

x86, mm: NX protection for kernel data

This patch expands functionality of CONFIG_DEBUG_RODATA to set main
(static) kernel data area as NX.

The following steps are taken to achieve this:
1. Linker script is adjusted so .text always starts and ends on a page boundary
2. Linker script is adjusted so .rodata and .data always start and
end on a page boundary
3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
functionality: NX is set for all pages from _etext through _end.
4. mark_nxdata_nx() called from free_initmem() (after init has been released)
5. free_init_pages() sets released memory NX in arch/x86/mm/init.c

V1:  initial patch for 2.6.30
V2:  patch for 2.6.31-rc7
V3:  moved all code into arch/x86, adjusted credits
V4:  fixed ifdef, removed credits from CREDITS
V5:  fixed an address calculation bug in mark_nxdata_nx()
V6:  updated for compatibility with 2.6.33-rc5

Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: James Morris <jmorris@namei.org>
LKML-Reference: <817ecb6f1001311527w7914ab20sf15b800dcaa37df7@mail.gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/vmlinux.lds.S |    6 +++++-
 arch/x86/mm/init.c            |   21 ++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index f92a0da..2cb7369 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -69,7 +69,7 @@ jiffies_64 = jiffies;
 
 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
-	data PT_LOAD FLAGS(7);          /* RWE */
+	data PT_LOAD FLAGS(6);          /* RW_ */
 #ifdef CONFIG_X86_64
 	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
@@ -108,6 +108,8 @@ SECTIONS
 		IRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
+		/* .text should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of text section */
 		_etext = .;
 	} :text = 0x9090
@@ -143,6 +145,8 @@ SECTIONS
 		/* rarely changed data like cpu maps */
 		READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)
 
+		/* .data should occupy whole number of pages */
+		. = ALIGN(PAGE_SIZE);
 		/* End of data section */
 		_edata = .;
 	} :data
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d406c52..d613d0a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -356,9 +356,10 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
-	 * writeable first.
+	 * writeable and non-executable first.
 	 */
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+	set_memory_nx(begin, (end - begin) >> PAGE_SHIFT);
 
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
@@ -373,11 +374,29 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 #endif
 }
 
+void mark_nxdata_nx(void)
+{
+#ifdef CONFIG_DEBUG_RODATA
+	/*
+	 * When this called, init has already been executed and released,
+	 * so everything past _etext sould be NX.
+	 */
+	unsigned long start = PAGE_ALIGN((unsigned long)(&_etext));
+	unsigned long size = PAGE_ALIGN((unsigned long)(&_end)) - start;
+
+	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
+		start, size >> PAGE_SHIFT);
+	set_memory_nx(start, size >> PAGE_SHIFT);
+#endif
+}
+
 void free_initmem(void)
 {
 	free_init_pages("unused kernel memory",
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
+	/* Set kernel's data as NX */
+	mark_nxdata_nx();
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
