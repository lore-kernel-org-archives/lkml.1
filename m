Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbXGDIyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbXGDIyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXGDIyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:54:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53892 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052AbXGDIyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:54:32 -0400
Date: Wed, 4 Jul 2007 14:24:03 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Ian McDonald <ian.mcdonald@jandi.co.nz>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch 3/3] Text Edit Lock - kprobes i386
Message-ID: <20070704085403.GA21207@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <20070703163818.785635235@polymtl.ca> <20070703164031.888938670@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703164031.888938670@polymtl.ca>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 12:38:22PM -0400, Mathieu Desnoyers wrote:
> Kprobes can use the text edit lock to insure mutual exclusion when edition the
> code and make sure the pages are writable.

Linus suggested for splitting ro-data and ro-text; And allow ro-text
only if kprobes is not configured.
Please see the discussion thread, URL given below
http://lkml.org/lkml/2007/6/20/436

This patch below allows to configure and mark the kernel text and
kernel data as read-only separately. Also kernel text
is configured read-only if kprobes is not configured.

Thanks
Prasanna

This patch allows to configure and mark the kernel text and
kernel data as read-only separately.

Signed-off-by: Prasanna S P. <prasanna@in.ibm.com>


 arch/i386/Kconfig.debug |    8 ++++++++
 arch/i386/mm/init.c     |   22 ++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff -puN arch/i386/Kconfig.debug~mark-kernel-text-data-ro-seperately-i386 arch/i386/Kconfig.debug
--- linux-2.6.22-rc6/arch/i386/Kconfig.debug~mark-kernel-text-data-ro-seperately-i386	2007-07-04 13:45:24.000000000 +0530
+++ linux-2.6.22-rc6-prasanna/arch/i386/Kconfig.debug	2007-07-04 13:52:31.000000000 +0530
@@ -56,6 +56,14 @@ config DEBUG_RODATA
 	  portion of the kernel code won't be covered by a 2MB TLB anymore.
 	  If in doubt, say "N".
 
+config DEBUG_ROTEXT
+	bool "Write protect kernel text"
+	depends on DEBUG_RODATA && !KPROBES
+	help
+	  Mark the kernel text as write-protected in the pagetables.
+	  Only allow this if kprobes is not configured.
+	  If in doubt, say "N".
+
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
diff -puN arch/i386/mm/init.c~mark-kernel-text-data-ro-seperately-i386 arch/i386/mm/init.c
--- linux-2.6.22-rc6/arch/i386/mm/init.c~mark-kernel-text-data-ro-seperately-i386	2007-07-04 13:45:24.000000000 +0530
+++ linux-2.6.22-rc6-prasanna/arch/i386/mm/init.c	2007-07-04 13:51:39.000000000 +0530
@@ -792,14 +792,11 @@ static int noinline do_test_wp_bit(void)
 	return flag;
 }
 
-#ifdef CONFIG_DEBUG_RODATA
-
-void mark_rodata_ro(void)
+static inline void mark_rwtext_ro(void)
 {
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_KPROBES
 #ifdef CONFIG_HOTPLUG_CPU
 	/* It must still be possible to apply SMP alternatives. */
 	if (num_possible_cpus() <= 1)
@@ -809,9 +806,22 @@ void mark_rodata_ro(void)
 		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
 		printk("Write protecting the kernel text: %luk\n", size >> 10);
 	}
+
+	/*
+	 * global_flush_tlb() will be called after marking the data as readonly.
+	 */
+}
+
+#ifdef CONFIG_DEBUG_RODATA
+
+void mark_rodata_ro(void)
+{
+	unsigned long start = PFN_ALIGN(_etext);
+	unsigned long size = (unsigned long)__end_rodata - start;
+
+#ifdef CONFIG_DEBUG_ROTEXT
+	mark_rwtext_ro();
 #endif
-	start += size;
-	size = (unsigned long)__end_rodata - start;
 	change_page_attr(virt_to_page(start),
 	                 size >> PAGE_SHIFT, PAGE_KERNEL_RO);
 	printk("Write protecting the kernel read-only data: %luk\n",

_
-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
