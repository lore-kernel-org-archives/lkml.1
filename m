Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYL2A3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYL2A3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYL2A27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:28:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:47765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbYL2A26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:28:58 -0500
Message-ID: <495819A7.1040908@kernel.org>
Date: Sun, 28 Dec 2008 16:28:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu>
In-Reply-To: <20081228233028.GA14697@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>   b2e2fe9: sparseirq: work around __weak alias bug
> 
> here's that fix, standalone too. Kamalesh, i think this should finally fix 
> the crash you are seeing.
> 
> 	Ingo
> 
> ---------------->
>>From b2e2fe99628c4f944c3075258e536197b5a4f3f8 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 29 Dec 2008 00:16:45 +0100
> Subject: [PATCH] sparseirq: work around __weak alias bug
> 
> Impact: fix boot crash if the kernel is built with certain GCC versions
> 
> GCC has a bug with __weak alias functions: if the functions are in
> the same compilation unit as their call site, GCC can decide to
> inline them - and thus rob the linker of the opportunity to override
> the weak alias with the real thing.
> 
> This can lead to the boot crash reported by Kamalesh Babulal:
> 
>  ACPI: Core revision 20080926
>  Setting APIC routing to flat
>  BUG: unable to handle kernel NULL pointer dereference at
>  0000000000000000
>  IP: [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
>  PGD 0
>  Oops: 0000 [#1] SMP
>  [...]
> 
> So move the arch_init_chip_data() function from handle.c to manage.c.

that is not enough.

need


[PATCH] sparseirq: mvoe two weak functions to chip.c

Impact: fix panic

some gcc compiler will remove the weak global blank function
Linus noted that we could move those function to other unit to workaround it.

try to workaround it:
1. one time path: add printk
2. multi time path: move to chip.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 init/main.c         |    9 +++------
 kernel/irq/chip.c   |   10 ++++++++++
 kernel/irq/handle.c |    5 -----
 3 files changed, 13 insertions(+), 11 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -542,14 +542,11 @@ void __init __weak thread_info_cache_ini
 {
 }
 
-int __init __weak arch_early_irq_init(void)
-{
-	return 0;
-}
-
 int __init __weak early_irq_init(void)
 {
-	return arch_early_irq_init();
+	printk(KERN_DEBUG "calling __weak early_irq_init()\n");
+
+	return 0;
 }
 
 asmlinkage void __init start_kernel(void)
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -18,6 +18,16 @@
 
 #include "internals.h"
 
+int __init __weak arch_early_irq_init(void)
+{
+	return 0;
+}
+
+int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+{
+	return 0;
+}
+
 /**
  *	dynamic_irq_init - initialize a dynamically allocated irq
  *	@irq:	irq number to initialize
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -86,11 +86,6 @@ void init_kstat_irqs(struct irq_desc *de
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
-int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
-{
-	return 0;
-}
-
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
