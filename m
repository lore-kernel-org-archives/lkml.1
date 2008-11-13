Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYKMWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYKMWQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYKMWPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:15:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731AbYKMWPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:15:21 -0500
Date: Thu, 13 Nov 2008 14:13:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
Message-Id: <20081113141340.7e17bdca.akpm@linux-foundation.org>
In-Reply-To: <86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>
References: <491434FB.2050904@kernel.org>
	<86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	<20081110094033.GL22392@elte.hu>
	<20081110015511.453a801e.akpm@linux-foundation.org>
	<4918065A.6050402@kernel.org>
	<20081110100329.GA19970@elte.hu>
	<491A9F87.8040403@kernel.org>
	<20081112120814.GG11352@elte.hu>
	<491C8B38.9060901@kernel.org>
	<20081113131850.d94fb229.akpm@linux-foundation.org>
	<86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 14:01:06 -0800
"Yinghai Lu" <yinghai@kernel.org> wrote:

> On Thu, Nov 13, 2008 at 1:18 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 13 Nov 2008 12:16:56 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> >
> >> From: Yinghai Lu <yinghai@kernel.org>
> >> Subject: sparseirq v13
> >
> > My overall view on this is that it takes some of the kernel's most
> > fragile and most problem-dense code and makes it much more complex, and
> > by adding new configuration options it significantly worsens our
> > testing coverage.
> >
> > The patch is HHHHHUUUUUUUUUUGGGGGEEE!  Did it really need to be a
> > single megapatch?
> >
> > Other architectures want (or have) sparse interrupts.  Are those guys
> > paying attention here?
> >
> > I don't have a clue what all this does.  I hope those who will work on
> > this code are sufficiently familiar with it all to be able to maintain
> > it when there are close to zero comments in some of our most tricky and
> > problem-prone code.
> >
>
> ...
>
> >> +static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
> >
> > Do these need to be 32-bit?  Maybe they'll fit in 16-bit, dunno.
> >
> 
> struct irq_desc {
>         unsigned int            irq;
> #ifdef CONFIG_SPARSE_IRQ
>         struct list_head        list;
>         struct list_head        hash_entry;
>         struct timer_rand_state *timer_rand_state;
>         unsigned int            *kstat_irqs;

That doesn't address my question.

The above array can be very large.  Can we halve its size by using
16-bit quantities?  Will this code ever encounter IRQ numbers larger
than 65536?

> >> +struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
> >> +{
> >> +     struct irq_desc *desc;
> >> +     struct list_head *hash_head;
> >> +     unsigned long flags;
> >> +     int node;
> >> +
> >> +     desc = irq_to_desc(irq);
> >> +     if (desc)
> >> +             return desc;
> >> +
> >> +     hash_head = sparseirqhashentry(irq);
> >> +
> >> +     spin_lock_irqsave(&sparse_irq_lock, flags);
> >> +
> >> +     /*
> >> +      * We have to do the hash-walk again, to avoid races
> >> +      * with another CPU:
> >> +      */
> >> +     list_for_each_entry(desc, hash_head, hash_entry)
> >> +             if (desc->irq == irq)
> >> +                     goto out_unlock;
> >> +
> >> +     if (cpu < 0)
> >> +             cpu = smp_processor_id();
> >> +
> >> +     node = cpu_to_node(cpu);
> >> +     desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
> >
> > Oh for gawd's sake.  PLEASE read Documentation/SubmitChecklist.
> > Carefully.  We've already discussed this.
> there are 13 errors with checkpatch scripts. seems all about macro definition.

This has nothing to do with checkpatch.  Documentation/SubmitChecklist
covers much more than that.  In particular it descripbes various steps
which should be taken when runtime testing new code subissions.

> >
> > You cannot do a GFP_KERNEL allocation under spin_lock_irqsave().

Steps which would have detected this bug.


