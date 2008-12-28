Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYL1Xaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYL1Xaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYL1Xar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:30:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYL1Xar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:30:47 -0500
Date: Mon, 29 Dec 2008 00:30:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Message-ID: <20081228233028.GA14697@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu> <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com> <20081227173839.GA9793@elte.hu> <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain> <20081228232729.GA2158@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228232729.GA2158@elte.hu>
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

>   b2e2fe9: sparseirq: work around __weak alias bug

here's that fix, standalone too. Kamalesh, i think this should finally fix 
the crash you are seeing.

	Ingo

---------------->
>From b2e2fe99628c4f944c3075258e536197b5a4f3f8 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 29 Dec 2008 00:16:45 +0100
Subject: [PATCH] sparseirq: work around __weak alias bug

Impact: fix boot crash if the kernel is built with certain GCC versions

GCC has a bug with __weak alias functions: if the functions are in
the same compilation unit as their call site, GCC can decide to
inline them - and thus rob the linker of the opportunity to override
the weak alias with the real thing.

This can lead to the boot crash reported by Kamalesh Babulal:

 ACPI: Core revision 20080926
 Setting APIC routing to flat
 BUG: unable to handle kernel NULL pointer dereference at
 0000000000000000
 IP: [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
 PGD 0
 Oops: 0000 [#1] SMP
 [...]

So move the arch_init_chip_data() function from handle.c to manage.c.

Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/handle.c |    5 -----
 kernel/irq/manage.c |    9 +++++++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 157c04c..c20db0b 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -86,11 +86,6 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
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
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 46953a0..c2741b0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -261,6 +261,15 @@ void enable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(enable_irq);
 
+/*
+ * [ Not in kernel/irq/handle.c, so that GCC does not
+ *   inline the __weak alias: ]
+ */
+int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+{
+	return 0;
+}
+
 static int set_irq_wake_real(unsigned int irq, unsigned int on)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
