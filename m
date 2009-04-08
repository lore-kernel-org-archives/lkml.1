Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZDHX6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZDHX6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZDHX6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:58:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:38716 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbZDHX6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nmRLUOe4gDrsrWEUrOMRz3Xgi9pXikCRdZdXqD6hvByucdv+nkNz9J+G0bIsXXoYy2
         OaxiDAtG+kztMbeqFwwVJooSduqXgI2sk22j3CP+/gRpLP5fBztLowPsAbwnuo8Elrri
         RKcdPxB7xCl1CdvvGz40IlM96btDqn+VzlgwU=
MIME-Version: 1.0
In-Reply-To: <20090408233758.GB14412@us.ibm.com>
References: <20090408210735.GD11159@us.ibm.com>
	 <86802c440904081530i1b83e19ayddebd8b2f6d413af@mail.gmail.com>
	 <20090408233758.GB14412@us.ibm.com>
Date: Wed, 8 Apr 2009 16:58:01 -0700
Message-ID: <86802c440904081658v4d8a3a80jdd51e27e0f8e0a6d@mail.gmail.com>
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered 
	inactive device IRQ interrruption
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, lcm@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 4:37 PM, Gary Hade <garyhade@us.ibm.com> wrote:
> On Wed, Apr 08, 2009 at 03:30:15PM -0700, Yinghai Lu wrote:
>> On Wed, Apr 8, 2009 at 2:07 PM, Gary Hade <garyhade@us.ibm.com> wrote:
>> > Impact: Eliminates a race that can leave the system in an
>> >        unusable state
>> >
>> > During rapid offlining of multiple CPUs there is a chance
>> > that an IRQ affinity move destination CPU will be offlined
>> > before the IRQ affinity move initiated during the offlining
>> > of a previous CPU completes.  This can happen when the device
>> > is not very active and thus fails to generate the IRQ that is
>> > needed to complete the IRQ affinity move before the move
>> > destination CPU is offlined.  When this happens there is an
>> > -EBUSY return from __assign_irq_vector() during the offlining
>> > of the IRQ move destination CPU which prevents initiation of
>> > a new IRQ affinity move operation to an online CPU.  This
>> > leaves the IRQ affinity set to an offlined CPU.
>> >
>> > I have been able to reproduce the problem on some of our
>> > systems using the following script.  When the system is idle
>> > the problem often reproduces during the first CPU offlining
>> > sequence.
>> >
>> > #!/bin/sh
>> >
>> > SYS_CPU_DIR=/sys/devices/system/cpu
>> > VICTIM_IRQ=25
>> > IRQ_MASK=f0
>> >
>> > iteration=0
>> > while true; do
>> >  echo $iteration
>> >  echo $IRQ_MASK > /proc/irq/$VICTIM_IRQ/smp_affinity
>> >  for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
>> >    echo 0 > $cpudir/online
>> >  done
>> >  for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
>> >    echo 1 > $cpudir/online
>> >  done
>> >  iteration=`expr $iteration + 1`
>> > done
>> >
>> > The proposed fix takes advantage of the fact that when all
>> > CPUs in the old domain are offline there is nothing to be done
>> > by send_cleanup_vector() during the affinity move completion.
>> > So, we simply avoid setting cfg->move_in_progress preventing
>> > the above mentioned -EBUSY return from __assign_irq_vector().
>> > This allows initiation of a new IRQ affinity move to a CPU
>> > that is not going offline.
>> >
>> > Signed-off-by: Gary Hade <garyhade@us.ibm.com>
>> >
>> > ---
>> >  arch/x86/kernel/apic/io_apic.c |   11 ++++++++---
>> >  1 file changed, 8 insertions(+), 3 deletions(-)
>> >
>> > Index: linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c
>> > ===================================================================
>> > --- linux-2.6.30-rc1.orig/arch/x86/kernel/apic/io_apic.c        2009-04-08 09:23:00.000000000 -0700
>> > +++ linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c     2009-04-08 09:23:16.000000000 -0700
>> > @@ -363,7 +363,8 @@ set_extra_move_desc(struct irq_desc *des
>> >        struct irq_cfg *cfg = desc->chip_data;
>> >
>> >        if (!cfg->move_in_progress) {
>> > -               /* it means that domain is not changed */
>> > +               /* it means that domain has not changed or all CPUs
>> > +                * in old domain are offline */
>> >                if (!cpumask_intersects(desc->affinity, mask))
>> >                        cfg->move_desc_pending = 1;
>> >        }
>> > @@ -1262,8 +1263,11 @@ next:
>> >                current_vector = vector;
>> >                current_offset = offset;
>> >                if (old_vector) {
>> > -                       cfg->move_in_progress = 1;
>> >                        cpumask_copy(cfg->old_domain, cfg->domain);
>> > +                       if (cpumask_intersects(cfg->old_domain,
>> > +                                              cpu_online_mask)) {
>> > +                               cfg->move_in_progress = 1;
>> > +                       }
>> >                }
>> >                for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
>> >                        per_cpu(vector_irq, new_cpu)[vector] = irq;
>> > @@ -2492,7 +2496,8 @@ static void irq_complete_move(struct irq
>> >                if (likely(!cfg->move_desc_pending))
>> >                        return;
>> >
>> > -               /* domain has not changed, but affinity did */
>> > +               /* domain has not changed or all CPUs in old domain
>> > +                * are offline, but affinity changed */
>> >                me = smp_processor_id();
>> >                if (cpumask_test_cpu(me, desc->affinity)) {
>> >                        *descp = desc = move_irq_desc(desc, me);
>> > --
>>
>> so you mean during __assign_irq_vector(), cpu_online_mask get updated?
>
> No, the CPU being offlined is removed from cpu_online_mask
> earlier via a call to remove_cpu_from_maps() from
> cpu_disable_common().  This happens just before fixup_irqs()
> is called.
>
>> with your patch, how about that it just happen right after you check
>> that second time.
>>
>> it seems we are missing some lock_vector_lock() on the remove cpu from
>> online mask.
>
> The remove_cpu_from_maps() call in cpu_disable_common() is vector
> lock protected:
> void cpu_disable_common(void)
> {
>               < snip >
>        /* It's now safe to remove this processor from the online map */
>        lock_vector_lock();
>        remove_cpu_from_maps(cpu);
>        unlock_vector_lock();
>        fixup_irqs();
> }


__assign_irq_vector always has vector_lock locked...
so cpu_online_mask will not changed during, why do you need to check
that again in __assign_irq_vector ?

YH
