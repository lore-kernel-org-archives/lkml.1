Return-Path: <linux-kernel-owner+w=401wt.eu-S1946387AbXBCH4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946387AbXBCH4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 02:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946388AbXBCH4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 02:56:43 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44359 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946387AbXBCH4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 02:56:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070202170500.57b6c3a3.akpm@linux-foundation.org>
	<1170487929.3073.988.camel@laptopd505.fenrus.org>
Date: Sat, 03 Feb 2007 00:55:11 -0700
In-Reply-To: <1170487929.3073.988.camel@laptopd505.fenrus.org> (Arjan van de
	Ven's message of "Sat, 03 Feb 2007 08:32:09 +0100")
Message-ID: <m1d54r3cbk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

>> > Once the migration operation is complete we know we will receive
>> > no more interrupts on this vector so the irq pending state for
>> > this irq will no longer be updated.  If the irq is not pending and
>> > we are in the intermediate state we immediately free the vector,
>> > otherwise in we free the vector in do_IRQ when the pending irq
>> > arrives.
>> 
>> So is this a for-2.6.20 thing?  The bug was present in 2.6.19, so
>> I assume it doesn't affect many people?
>
> I got a few reports of this; irqbalance may trigger this kernel bug it
> seems... I would suggest to consider this for 2.6.20 since it's a
> hard-hang case


Yes.  The bug I fixed will not happen if you don't migrate irqs.

At the very least we want the patch below (already in -mm)
that makes it not a hard hang case.

Subject: [PATCH] x86_64:  Survive having no irq mapping for a vector

Occasionally the kernel has bugs that result in no irq being
found for a given cpu vector.  If we acknowledge the irq
the system has a good chance of continuing even though we dropped
an missed an irq message.  If we continue to simply print a
message and drop and not acknowledge the irq the system is
likely to become non-responsive shortly there after.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/irq.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 0c06af6..648055a 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -120,9 +120,14 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 
 	if (likely(irq < NR_IRQS))
 		generic_handle_irq(irq);
-	else if (printk_ratelimit())
-		printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
-			__func__, smp_processor_id(), vector);
+	else {
+		if (!disable_apic)
+			ack_APIC_irq();
+
+		if (printk_ratelimit())
+			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
+				__func__, smp_processor_id(), vector);
+	}
 
 	irq_exit();
 
-- 
1.4.4.1.g278f

