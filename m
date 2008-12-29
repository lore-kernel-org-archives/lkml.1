Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbYL2JxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbYL2JxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 04:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYL2JxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 04:53:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbYL2JxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 04:53:06 -0500
Date: Mon, 29 Dec 2008 10:52:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081229095244.GA8715@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu> <495819A7.1040908@kernel.org> <49581F6E.6010205@kernel.org> <20081229094434.GD27293@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229094434.GD27293@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> By far the best solution is to move them into a different compilation 
> unit - i.e. your first patch - i'll apply that one.

your patch didnt apply, and it also missed the following detail: 
kernel/irq/ is only included on genirq architectures - not on some others. 
So i ended up with the refactored patch below.

	Ingo

---------------->
>From 18aa3101b32c90738182dba89d43f7c984e90e82 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Sun, 28 Dec 2008 16:01:13 -0800
Subject: [PATCH] sparseirq: move __weak symbols into separate compilation unit

GCC has a bug with __weak alias functions: if the functions are in
the same compilation unit as their call site, GCC can decide to
inline them - and thus rob the linker of the opportunity to override
the weak alias with the real thing.

So move all the IRQ handling related __weak symbols to kernel/irq/chip.c.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c         |   10 ----------
 kernel/irq/manage.c |    9 ---------
 kernel/softirq.c    |   20 ++++++++++++++++++++
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/init/main.c b/init/main.c
index c314aa1..2c183ab 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,16 +539,6 @@ void __init __weak thread_info_cache_init(void)
 {
 }
 
-int __init __weak arch_early_irq_init(void)
-{
-	return 0;
-}
-
-int __init __weak early_irq_init(void)
-{
-	return arch_early_irq_init();
-}
-
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c2741b0..46953a0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -261,15 +261,6 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
-/*
- * [ Not in kernel/irq/handle.c, so that GCC does not
- *   inline the __weak alias: ]
- */
-int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
-{
-	return 0;
-}
-
 static int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index e7c69a7..daf4635 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -797,3 +797,23 @@ int on_each_cpu(void (*func) (void *info), void *info, int wait)
 }
 EXPORT_SYMBOL(on_each_cpu);
 #endif
+
+/*
+ * [ These __weak aliases are kept in a separate compilation unit, so that
+ *   GCC does not inline them incorrectly. ]
+ */
+
+int __init __weak early_irq_init(void)
+{
+	return 0;
+}
+
+int __init __weak arch_early_irq_init(void)
+{
+	return 0;
+}
+
+int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+{
+	return 0;
+}
