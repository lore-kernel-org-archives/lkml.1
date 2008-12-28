Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYL1XLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYL1XLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYL1XLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:11:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:51310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYL1XLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:11:21 -0500
Message-ID: <49580721.8010201@kernel.org>
Date: Sun, 28 Dec 2008 15:09:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333	smp_call_function_mask
References: <20081227071138.GA4530@linux.vnet.ibm.com> <4955DBBC.4070508@kernel.org> <20081227083758.GA12138@elte.hu> <20081227083936.GA12609@elte.hu> <20081227112125.GB4530@linux.vnet.ibm.com> <20081227112450.GA24150@elte.hu> <20081227115712.GC4530@linux.vnet.ibm.com> <20081227122632.GA18909@elte.hu> <20081227152918.GD4530@linux.vnet.ibm.com> <20081228125510.GA10387@elte.hu> <20081228161119.GA29660@linux.vnet.ibm.com>
In-Reply-To: <20081228161119.GA29660@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> * Ingo Molnar <mingo@elte.hu> [2008-12-28 13:55:10]:
> 
>> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>> Hi Ingo,
>>>
>>> 	kernel still crashes, with the updated patch.
>> hm, i thought we got all bugs fixed - could you try latest tip/master:
>>
>>   http://people.redhat.com/mingo/tip.git/README
>>
>> does it still crash in the same way? (if yes then please attach the new 
>> crashlog if it's easy to do)
>>
>> Thanks,
>>
>> 	Ingo
> 
> Hi Ingo/Yinghai,
> 
> 	I tried today's tip/master against 2.6.28, the kernel still crashes
> at boot up.

please try following patch on top of tip/master

YH

---

[PATCH] sparseirq: change arch_init_chip_data to pointer

Impact: fix panic

some gcc compiler will remove the weak global blank function

try to workaround it:
1. one time path: add printk
2. multi time path: change to function pointer

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/io_apic.c |    7 ++++++-
 include/linux/irq.h       |    2 +-
 init/main.c               |    4 ++++
 kernel/irq/handle.c       |    5 ++++-
 4 files changed, 15 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -170,6 +170,8 @@ static struct irq_cfg irq_cfgx[NR_IRQS]
 	[15] = { .vector = IRQ15_VECTOR, },
 };
 
+static int real_arch_init_chip_data(struct irq_desc *desc, int cpu);
+
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -189,6 +191,9 @@ int __init arch_early_irq_init(void)
 			cpumask_setall(cfg[i].domain);
 	}
 
+#ifdef CONFIG_SPARSE_IRQ
+	arch_init_chip_data = real_arch_init_chip_data;
+#endif
 	return 0;
 }
 
@@ -232,7 +237,7 @@ static struct irq_cfg *get_one_free_irq_
 	return cfg;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int cpu)
+static int real_arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
 	struct irq_cfg *cfg;
 
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -196,7 +196,7 @@ struct irq_desc {
 
 extern int early_irq_init(void);
 extern int arch_early_irq_init(void);
-extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern int (*arch_init_chip_data)(struct irq_desc *desc, int cpu);
 extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
 					struct irq_desc *desc, int cpu);
 extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -544,11 +544,15 @@ void __init __weak thread_info_cache_ini
 
 int __init __weak arch_early_irq_init(void)
 {
+	printk(KERN_DEBUG "calling __weak arch_early_irq_init()\n");
+
 	return 0;
 }
 
 int __init __weak early_irq_init(void)
 {
+	printk(KERN_DEBUG "calling __weak early_irq_init()\n");
+
 	return arch_early_irq_init();
 }
 
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -86,11 +86,14 @@ void init_kstat_irqs(struct irq_desc *de
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
-int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+static int weak_arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
 	return 0;
 }
 
+int (*arch_init_chip_data)(struct irq_desc *desc, int cpu) =
+			 weak_arch_init_chip_data;
+
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
