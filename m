Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZDNOHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZDNOHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZDNOHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:07:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:39292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbZDNOHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:07:23 -0400
Date: Tue, 14 Apr 2009 14:06:34 GMT
From: "tip-bot for Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, lcm@us.ibm.com, shaohua.li@intel.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, lcm@us.ibm.com, shaohua.li@intel.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090413222058.GB8211@linux-os.sc.intel.com>
References: <20090413222058.GB8211@linux-os.sc.intel.com>
Subject: [tip:irq/urgent] x86, irq: Remove IRQ_DISABLED check in process context IRQ move
Message-ID: <tip-6ec3cfeca04622e3d80c9270191cd7f5f88214af@git.kernel.org>
Git-Commit-ID: 6ec3cfeca04622e3d80c9270191cd7f5f88214af
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 14:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ec3cfeca04622e3d80c9270191cd7f5f88214af
Gitweb:     http://git.kernel.org/tip/6ec3cfeca04622e3d80c9270191cd7f5f88214af
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Mon, 13 Apr 2009 15:20:58 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 15:21:13 +0200

x86, irq: Remove IRQ_DISABLED check in process context IRQ move

As discussed in the thread here:

  http://marc.info/?l=linux-kernel&m=123964468521142&w=2

Eric W. Biederman observed:

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

[...]

>
> The only reason we migrate MSIs in interrupt context today is that there
> wasn't infrastructure for support migration both in interrupt context
> and outside of it.

Yes. The idea here was to force the MSI migration to happen in process
context. One of the patches in the series did

        disable_irq(dev->irq);
        irq_set_affinity(dev->irq, cpumask_of(dev->cpu));
        enable_irq(dev->irq);

with the above patch adding irq/manage code check for interrupt disabled
and moving the interrupt in process context.

IIRC, there was no IRQ_MOVE_PCNTXT when we were developing this HPET
code and we ended up having this ugly hack. IRQ_MOVE_PCNTXT was there
when we eventually submitted the patch upstream. But, looks like I did a
blind rebasing instead of using IRQ_MOVE_PCNTXT in hpet MSI code.

Below patch fixes this. i.e., revert commit 932775a4ab622e3c99bd59f14cc
and add PCNTXT to HPET MSI setup. Also removes copying of desc->affinity
in generic code as set_affinity routines are doing it internally.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Li Shaohua" <shaohua.li@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: "lcm@us.ibm.com" <lcm@us.ibm.com>
Cc: suresh.b.siddha@intel.com
LKML-Reference: <20090413222058.GB8211@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 kernel/irq/manage.c            |    5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a2789e4..30da617 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3670,12 +3670,14 @@ int arch_setup_hpet_msi(unsigned int irq)
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
