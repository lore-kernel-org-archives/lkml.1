Return-Path: <linux-kernel-owner+w=401wt.eu-S934753AbZDJLnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbZDJLnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761221AbZDJLmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:42:51 -0400
Received: from www.tglx.de ([62.245.132.106]:56928 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbZDJLmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:42:50 -0400
Date: Fri, 10 Apr 2009 13:41:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic:
 swapper/0/0x10000100
In-Reply-To: <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>  <20090409212028.7b2aa88c.akpm@linux-foundation.org> <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Maciej Rutecki wrote:

> 2009/4/10 Andrew Morton <akpm@linux-foundation.org>
> 
> > Did this get fixed?
> 
> On 2.6.30-rc1-git3 still the same:
> [  162.541793] BUG: scheduling while atomic: swapper/0/0x10000100

Yikes.	

0x10000100
       ^----- softirq count leaked.

We have a check for that in do_softirq, but none in do_IRQ. Can you
please apply the patch below and test whether it triggers ?

Thanks,

	tglx
---
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index c3fe010..d164396 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -206,6 +206,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	/* high bit used in ret_from_ code  */
 	unsigned vector = ~regs->orig_ax;
 	unsigned irq;
+	int prev_count = preempt_count();
 
 	exit_idle();
 	irq_enter();
@@ -225,6 +226,13 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 
 	irq_exit();
 
+	if (unlikely(prev_count != preempt_count())) {
+		printk(KERN_ERR "huh, entered interrupt %d"
+		       "with preempt_count %08x, exited with %08x?\n", irq,
+		       prev_count, preempt_count());
+		preempt_count() = prev_count;
+	}
+
 	set_irq_regs(old_regs);
 	return 1;
 }

