Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYA1KfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYA1KfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:35:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYA1Key
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:34:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYA1Kex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:34:53 -0500
Date: Mon, 28 Jan 2008 11:34:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86_64: mark x86_cpu_to_node_map_init to __initdata
	like other xx_init
Message-ID: <20080128103439.GC24010@elte.hu>
References: <200801280116.54810.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801280116.54810.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> -int x86_cpu_to_node_map_init[NR_CPUS] = {
> +int x86_cpu_to_node_map_init[NR_CPUS] __initdata = {
>  	[0 ... NR_CPUS-1] = NUMA_NO_NODE
>  };

i remember some linker warning here. While this array should indeed only 
be used in early init, that decision is dynamic and our linker warnings 
do not notice it. There's a special marker for such cases: 
__initdata_refok. But ... i'm slightly nervous about turning off a vital 
warning like that.

Sam, it would be nice to have a DEBUG_INITDATA mode of operation: in 
this case free_initmem() would not truly free those pages but would 
unmap them via:

   kernel_map_pages(page, nrpages, 0);

could be made dependent on DEBUG_PAGEALLOC.

If this debugging is enabled then if any code references it, we get a 
hard page fault. If we had a debug mode like that then bugs in this area 
would not go unnoticed.

Or perhaps just make this part of normal DEBUG_PAGEALLOC. Like the patch 
below on top of latest x86.git. Hm?

	Ingo

------------------->
Subject: x86: init memory debugging
From: Ingo Molnar <mingo@elte.hu>

debug incorrect/late access to init memory, by permanently unmapping
the init memory ranges. Depends on CONFIG_DEBUG_PAGEALLOC=y.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |   12 ++++++++++++
 arch/x86/mm/init_64.c |   11 +++++++++++
 2 files changed, 23 insertions(+)

Index: linux-x86.q/arch/x86/mm/init_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/init_32.c
+++ linux-x86.q/arch/x86/mm/init_32.c
@@ -794,6 +794,18 @@ void free_init_pages(char *what, unsigne
 	unsigned long addr;
 
 	/*
+	 * If debugging page accesses then do not free this memory but
+	 * mark them not present - any buggy init-section access will
+	 * create a kernel page fault:
+	 */
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
+		begin, PAGE_ALIGN(end));
+	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
+	return;
+#endif
+	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
+	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
 	 * writeable first.
Index: linux-x86.q/arch/x86/mm/init_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/init_64.c
+++ linux-x86.q/arch/x86/mm/init_64.c
@@ -580,6 +580,17 @@ void free_init_pages(char *what, unsigne
 	if (begin >= end)
 		return;
 
+	/*
+	 * If debugging page accesses then do not free this memory but
+	 * mark them not present - any buggy init-section access will
+	 * create a kernel page fault:
+	 */
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
+		begin, PAGE_ALIGN(end));
+	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
+	return;
+#endif
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
 	for (addr = begin; addr < end; addr += PAGE_SIZE) {
