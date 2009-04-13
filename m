Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbZDMURr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbZDMURr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZDMURi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:17:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34910 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZDMURh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:17:37 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
References: <20090408210745.GE11159@us.ibm.com>
	<86802c440904081503k545bf7b4n3d44aa3c9d101e0d@mail.gmail.com>
	<20090408230820.GA14412@us.ibm.com>
	<86802c440904102346lfbc85f2w4508bded0572ec58@mail.gmail.com>
	<20090413193717.GB8393@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 13 Apr 2009 13:17:29 -0700
In-Reply-To: <20090413193717.GB8393@us.ibm.com> (Gary Hade's message of "Mon\, 13 Apr 2009 12\:37\:17 -0700")
Message-ID: <m1bpr0e2au.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gary Hade <garyhade@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered active device IRQ interrruption
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> On Fri, Apr 10, 2009 at 11:46:39PM -0700, Yinghai Lu wrote:
>> On Wed, Apr 8, 2009 at 4:08 PM, Gary Hade <garyhade@us.ibm.com> wrote:
>> > On Wed, Apr 08, 2009 at 03:03:49PM -0700, Yinghai Lu wrote:
>> >> On Wed, Apr 8, 2009 at 2:07 PM, Gary Hade <garyhade@us.ibm.com> wrote:
>> >> > Impact: Eliminates an issue that can leave the system in an
>> >> >        unusable state.
>> >> >
>> >> > This patch addresses an issue where device generated IRQs
>> >> > are no longer seen by the kernel following IRQ affinity
>> >> > migration while the device is generating IRQs at a high rate.
>> >> > We have seen this problem happen when IRQ affinities are
>> >> > adjusted in response to CPU offlining but I believe it
>> >> > could also happen in during user initiated IRQ affinity
>> >> > changes unrelated to CPU offlining. e.g. while the
>> >> > irqbalance daemon is adjusting IRQ affinities when the
>> >> > system is heavily loaded.
>> >> >
>> >> > I have been able to consistently reproduce the problem on
>> >> > some of our systems by running the following script (VICTIM_IRQ
>> >> > specifies the IRQ for the aic94xx device) while a single instance
>> >> > of the command
>> >> >  # while true; do find / -exec file {} \;; done
>> >> > is keeping the filesystem activity and IRQ rate reasonably high.
>> >> >
>> >> > #!/bin/sh
>> >> >
>> >> > SYS_CPU_DIR=/sys/devices/system/cpu
>> >> > VICTIM_IRQ=25
>> >> > IRQ_MASK=f0
>> >> >
>> >> > iteration=0
>> >> > while true; do
>> >> >  echo $iteration
>> >> >  echo $IRQ_MASK > /proc/irq/$VICTIM_IRQ/smp_affinity
>> >> >  for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
>> >> >    echo 0 > $cpudir/online
>> >> >  done
>> >> >  for cpudir in $SYS_CPU_DIR/cpu[1-9] $SYS_CPU_DIR/cpu??; do
>> >> >    echo 1 > $cpudir/online
>> >> >  done
>> >> >  iteration=`expr $iteration + 1`
>> >> > done
>> >> >
>> >> > The root cause is a known issue already addressed for some
>> >> > code paths [e.g. ack_apic_level() and the now obsolete
>> >> > migrate_irq_remapped_level_desc()] where the ioapic can
>> >> > misbehave when the I/O redirection table register is written
>> >> > while the Remote IRR bit is set.
>> >> >
>> >> > The proposed fix uses the same avoidance method and much
>> >> > of same code that the Interrupt Remapping code previously
>> >> > used to avoid the same problem.
>> >> >
>> >> > Signed-off-by: Gary Hade <garyhade@us.ibm.com>
>> >> >
>> >> > ---
>> >> >  arch/x86/kernel/apic/io_apic.c |   72 ++++++++++++++++++++++++++++++-
>> >> >  1 file changed, 71 insertions(+), 1 deletion(-)
>> >> >
>> >> > Index: linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c
>> >> > ===================================================================
>> >> > --- linux-2.6.30-rc1.orig/arch/x86/kernel/apic/io_apic.c        2009-04-08 09:24:11.000000000 -0700
>> >> > +++ linux-2.6.30-rc1/arch/x86/kernel/apic/io_apic.c     2009-04-08 09:24:23.000000000 -0700
>> >> > @@ -2331,7 +2331,8 @@ set_desc_affinity(struct irq_desc *desc,
>> >> >  }
>> >> >
>> >> >  static void
>> >> > -set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
>> >> > +set_ioapic_irq_affinity_desc(struct irq_desc *desc,
>> >> > +                            const struct cpumask *mask)
>> >> >  {
>> >> >        struct irq_cfg *cfg;
>> >> >        unsigned long flags;
>> >> > @@ -2352,6 +2353,75 @@ set_ioapic_affinity_irq_desc(struct irq_
>> >> >  }
>> >> >
>> >> >  static void
>> >> > +delayed_irq_move(struct work_struct *work)
>> >> > +{
>> >> > +       unsigned int irq;
>> >> > +       struct irq_desc *desc;
>> >> > +
>> >> > +       for_each_irq_desc(irq, desc) {
>> >> > +               if (desc->status & IRQ_MOVE_PENDING) {
>> >> > +                       unsigned long flags;
>> >> > +
>> >> > +                       spin_lock_irqsave(&desc->lock, flags);
>> >> > +                       if (!desc->chip->set_affinity ||
>> >> > +                           !(desc->status & IRQ_MOVE_PENDING)) {
>> >> > +                               desc->status &= ~IRQ_MOVE_PENDING;
>> >> > +                               spin_unlock_irqrestore(&desc->lock, flags);
>> >> > +                               continue;
>> >> > +                       }
>> >> > +
>> >> > +                       desc->chip->set_affinity(irq, desc->pending_mask);
>> >> > +                       spin_unlock_irqrestore(&desc->lock, flags);
>> >> > +               }
>> >> > +       }
>> >> > +}
>> >> > +
>> >> > +static DECLARE_DELAYED_WORK(delayed_irq_move_work, delayed_irq_move);
>> >> > +
>> >> > +static void
>> >> > +set_ioapic_irq_affinity_level_desc(struct irq_desc *desc)
>> >> > +{
>> >> > +
>> >> > +       struct irq_cfg *cfg = desc->chip_data;
>> >> > +
>> >> > +       mask_IO_APIC_irq_desc(desc);
>> >> > +
>> >> > +       if (io_apic_level_ack_pending(cfg)) {
>> >> > +               /*
>> >> > +                * Interrupt in progress. Migrating irq now will change
>> >> > +                * the vector information in the IO-APIC RTE which will
>> >> > +                * confuse the EOI broadcast performed by cpu.
>> >> > +                * So, we delay the irq migration.
>> >> > +                */
>> >> > +               schedule_delayed_work(&delayed_irq_move_work, 1);
>> >> > +               goto unmask;
>> >> > +       }
>> >> > +
>> >> > +       /* Interrupt not in progress. we can change the vector
>> >> > +        * information in the IO-APIC RTE. */
>> >> > +       set_ioapic_irq_affinity_desc(desc, desc->pending_mask);
>> >> > +
>> >> > +       desc->status &= ~IRQ_MOVE_PENDING;
>> >> > +       cpumask_clear(desc->pending_mask);
>> >> > +
>> >> > +unmask:
>> >> > +       unmask_IO_APIC_irq_desc(desc);
>> >> > +}
>> >> > +
>> >> > +static void
>> >> > +set_ioapic_affinity_irq_desc(struct irq_desc *desc,
>> >> > +                            const struct cpumask *mask)
>> >> > +{
>> >> > +       if (desc->status & IRQ_LEVEL) {
>> >> > +               desc->status |= IRQ_MOVE_PENDING;
>> >> > +               cpumask_copy(desc->pending_mask, mask);
>> >> > +               set_ioapic_irq_affinity_level_desc(desc);
>> >> > +               return;
>> >> > +       }
>> >> > +       set_ioapic_irq_affinity_desc(desc, mask);
>> >> > +}
>> >> > +
>> >> > +static void
>> >> >  set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
>> >> >  {
>> >> >        struct irq_desc *desc;
>> >> > --
>> >>
>> >> it seems, ack_apic_level() already checked io_apic_level_ack_pending()
>> >>
>> >>                 cfg = desc->chip_data;
>> >>                 if (!io_apic_level_ack_pending(cfg))
>> >>                         move_masked_irq(irq);
>> >>                 unmask_IO_APIC_irq_desc(desc);
>> >
>> > Yes, I have actually observed instances where the command
>> >   `echo $IRQ_MASK > /proc/irq/$VICTIM_IRQ/smp_affinity`
>> > in the above test script failed to modify the affinity due to
>> > a debug printk confirmed non-zero return from io_apic_level_ack_pending()
>> > at this location.  However, this is definitely not catching all the cases.
>> > This was confirmed this with a printk in __target_IO_APIC_irq() that would
>> > sometimes shows the Remote IRR bit set before the io_apic_modify() call.
>> > e.g.
>> > __target_IO_APIC_irq: XXX before io_apic_modify irq=25 vector=0xd9 reg=0x1e0d9
>> 
>> 
>> that is strange,  before that irq is masked,
>> 
>> #ifdef CONFIG_GENERIC_PENDING_IRQ
>>         /* If we are moving the irq we need to mask it */
>>         if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
>>                 do_unmask_irq = 1;
>>                 mask_IO_APIC_irq_desc(desc);
>>         }
>> #endif
>
> When the device is very actively generating IRQs I suspect
> that __target_IO_APIC_irq() is sometimes visited (via CPU
> offline motivated path) before the IRQ is masked at this location.
> I believe the vulnerability window is actually a bit larger
> because it spans this mask_IO_APIC_irq_desc() call.

I don't think it makes sense to debate how broken fixup_irqs is.
The code is fundamentally wrong, if you don't have code that
can migrate an irq in process context.

Not playing games when Remote_IRR is set is the easy part.  As
that is required on correctly functioning hardware.   Unless
your ioapic has the magic acknowledge register.

The hard part is that ioapic to put it politely are fragile
things so you have to handle them just so.  It is possible to
wedge the state machines into a unrecoverable mess on most
common ioapic implementations.  Not sending the ack when
the ioapic is ready to receive it is easy by comparison.

Eric
