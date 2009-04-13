Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZDMWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZDMWVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZDMWVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:21:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:53330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZDMWU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:20:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,181,1239001200"; 
   d="scan'208";a="447580548"
Date: Mon, 13 Apr 2009 15:20:58 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, Gary Hade <garyhade@us.ibm.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lcm@us.ibm.com" <lcm@us.ibm.com>, suresh.b.siddha@intel.com
Subject: [PATCH] irq, x86: Remove IRQ_DISABLED check in process context IRQ move
Message-ID: <20090413222058.GB8211@linux-os.sc.intel.com>
References: <20090408210735.GD11159@us.ibm.com> <m1r601fg9l.fsf@fess.ebiederm.org> <20090410200919.GA7242@us.ibm.com> <m1tz4wcgm8.fsf@fess.ebiederm.org> <86802c440904110051p3e071f8etd0792702c08d9ec5@mail.gmail.com> <m1myanbgiv.fsf@fess.ebiederm.org> <1239644495.4529.8580.camel@localhost.localdomain> <m1ab6kfkwj.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ab6kfkwj.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As discussed in the thread here
http://marc.info/?l=linux-kernel&m=123964468521142&w=2

On Fri, Apr 10, 2009 at 3:02 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> It looks like some additional bugs have slipped in since last I looked.
>
> set_irq_affinity does this:
> ifdef CONFIG_GENERIC_PENDING_IRQ
>        if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
>                cpumask_copy(desc->affinity, cpumask);
>                desc->chip->set_affinity(irq, cpumask);
>        } else {
>                desc->status |= IRQ_MOVE_PENDING;
>                cpumask_copy(desc->pending_mask, cpumask);
>        }
> #else
>
> That IRQ_DISABLED case is a software state and as such it has nothing to
> do with how safe it is to move an irq in process context.
>

"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> writes:
> On Sat, 2009-04-11 at 04:01 -0700, Eric W. Biederman wrote:
> >
> > If the goal is moving MSIs, we should modify the msi code to be safe
> > in process context and to set IRQ_MOVE_PCNTXT.
> >
> > The only reason we migrate MSIs in interrupt context today is that there
> > wasn't infrastructure for support migration both in interrupt context
> > and outside of it.
>
> Yes. The idea here was to force the MSI migration to happen in process
> context. One of the patches in the series did
>
>         disable_irq(dev->irq);
>         irq_set_affinity(dev->irq, cpumask_of(dev->cpu));
>         enable_irq(dev->irq);
>
> with the above patch adding irq/manage code check for interrupt disabled
> and moving the interrupt in process context.
>
> IIRC, there was no IRQ_MOVE_PCNTXT when we were developing this HPET
> code and we ended up having this ugly hack. IRQ_MOVE_PCNTXT was there
> when we eventually submitted the patch upstream. But, looks like I did a
> blind rebasing instead of using IRQ_MOVE_PCNTXT in hpet MSI code. That
> was my fault. Will send a patch to fix this ugliness.

Below patch fixes this. i.e., revert
commit 932775a4ab622e3c99bd59f14cc7d96722f79501
and add PCNTXT to HPET MSI setup. Also removes copying of desc->affinity
in generic code as set_affinity routines are doing it internally.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 kernel/irq/manage.c            |    5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 767fe7e..aaf8212 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3667,12 +3667,14 @@ int arch_setup_hpet_msi(unsigned int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	ret = msi_compose_msg(NULL, irq, &msg);
 	if (ret < 0)
 		return ret;
 
 	hpet_msi_write(irq, &msg);
+	desc->status |= IRQ_MOVE_PCNTXT;
 	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
 		"edge");
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7e2e7dd..2734eca 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -109,10 +109,9 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
-		cpumask_copy(desc->affinity, cpumask);
+	if (desc->status & IRQ_MOVE_PCNTXT)
 		desc->chip->set_affinity(irq, cpumask);
-	} else {
+	else {
 		desc->status |= IRQ_MOVE_PENDING;
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
-- 
1.6.0.6

