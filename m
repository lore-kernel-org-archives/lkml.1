Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYLZKIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYLZKIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 05:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYLZKIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 05:08:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:53548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYLZKId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 05:08:33 -0500
Message-ID: <4954AC7B.3020603@kernel.org>
Date: Fri, 26 Dec 2008 02:05:47 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, mingo@elte.hu
CC: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333	smp_call_function_mask
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au> <20081219105441.GA19750@linux.vnet.ibm.com> <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com> <20081219134636.GA11772@linux.vnet.ibm.com> <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com>
In-Reply-To: <20081226091217.GA5100@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> * Yinghai Lu <yinghai@kernel.org> [2008-12-24 12:34:41]:
> 
>> --
> 
> After the applying the patch, the kernel panic's with the same backtrace. The
> box is running Fedora 5 on it.
> 

please try...
Ingo, do we need to switch to use #idef and inline function instead?

YH


[PATCH] sparseirq: add printk to workaround compiler optimizing

Impact: fix panic on null pointer with sparseirq

some compiler seems to inline the weak global function.
try to workaround it

also remove duplicated arch_early_irq_init()
already have one weak copy in init/main.c

Signed-off-by: Yinghai <yinghai@kernel.org>

---
 init/main.c         |    2 ++
 kernel/irq/handle.c |    7 ++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -544,10 +544,12 @@ void __init __weak thread_info_cache_ini
 
 void __init __weak arch_early_irq_init(void)
 {
+	printk(KERN_DEBUG "calling __weak arch_early_irq_init\n");
 }
 
 void __init __weak early_irq_init(void)
 {
+	printk(KERN_DEBUG "calling __weak early_irq_init\n");
 	arch_early_irq_init();
 }
 
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -56,10 +56,6 @@ void handle_bad_irq(unsigned int irq, st
 int nr_irqs = NR_IRQS;
 EXPORT_SYMBOL_GPL(nr_irqs);
 
-void __init __attribute__((weak)) arch_early_irq_init(void)
-{
-}
-
 #ifdef CONFIG_SPARSE_IRQ
 static struct irq_desc irq_desc_init = {
 	.irq	    = -1,
@@ -90,8 +86,9 @@ void init_kstat_irqs(struct irq_desc *de
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
-void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
+void __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
+	printk(KERN_DEBUG "calling __weak arch_init_chip_data\n");
 }
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
