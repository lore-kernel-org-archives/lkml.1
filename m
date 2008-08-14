Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYHNUNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYHNUNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYHNUNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:13:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60269 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYHNUNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:13:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	<20080814132638.GA18743@elte.hu>
	<86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
Date: Thu, 14 Aug 2008 13:05:47 -0700
In-Reply-To: <86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 14 Aug 2008 12:01:49 -0700")
Message-ID: <m1ljyzcqg4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4955]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Thu, Aug 14, 2008 at 6:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> (lkml Cc:-ed)
>>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>>> v10: make the x86 32 bit support sparse_irq too.
>>>     also make remove irqbalance in kernel for 32 bit
>>>     and make 32 bit support per_cpu vector. so start merging or io_apic_xx.c
>>>
>>>     01-03 is some fix for current tree
>>>     04: is revert for one patch hide in sched/ and tip/master
>>>
>>> based on tip/master
>>>
>>> to do:
>>>     merge io_apic_xx.c
>>
>> ok, i've created a new tip/irq/sparseirq topic branch for this.
>>
>> Could you please send future updates against:
>>
>>   git-checkout tip/master
>>   git-merge tip/irq/sparseirq
>>
>> Not yet integrated into tip/master, i've still got some other backlog.
>>
>> A couple of observations about the general structure of the sparse irqs
>> code:
>>
>> - the new APIs should probably live in mm/bootmem.c not in init/main.c,
>>  and in bootmem.h. Also, it should be outlined clearly why this new API
>>  is needed as a wrapper ontop of existing bootmem mechanisms.
>
> move
> pre_alloc_dyn_array, per_cpu_dyn_array_size, per_cpu_alloc_dyn_array
> to mm/bootmem.c?
>
>>
>> - the #ifdef complications, while fine for migration, should be
>>  eliminated. Could we introduce some compatible form for the
>>  definition/allocation APIs that work even if an architecture still
>>  uses a flat irq array? That would remove most of the uglinesses.
> # git grep CONFIG_HAVE_DYN_ARRAY | wc -l
> 9
>
> #git grep CONFIG_HAVE_SPARSE_IRQ | wc -l
> 39
>
> arch/x86/kernel/io_apic_32.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
> arch/x86/kernel/io_apic_32.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> arch/x86/kernel/io_apic_64.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
> arch/x86/kernel/io_apic_64.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> arch/x86/kernel/irq_32.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> arch/x86/kernel/irq_64.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> drivers/char/random.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> drivers/char/random.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> drivers/pci/intr_remapping.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> drivers/pci/intr_remapping.c:#else /* !CONFIG_HAVE_SPARSE_IRQ */
> drivers/pci/intr_remapping.c:#ifndef    CONFIG_HAVE_SPARSE_IRQ
> fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#if defined(CONFIG_INTR_REMAP) &&
> defined(CONFIG_HAVE_SPARSE_IRQ)
> include/linux/irq.h:#ifndef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
> kernel/irq/handle.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/manage.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/manage.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/migration.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
>
> because try to avoid more api to be changed to take irq_desc as parameter.
>
>>
>> - some of the irq < 16 checks in x86 look a bit ugly, can we do anything
>>  about them?
>
> is_legacy_irq(irq) ? or legacy_irq(irq)?


>
>>
>> - i think as a final-ish commit we should just remove the dyn-array
>>  define and make all architectures use this facility. You converted
>>  most of them - how many are still missing? Sparse-irq is more
>>  intrusive so that should probably stay a Kconfig knob.
>
> so when config_sparse_irq is not selected, need to use dyn_array to
> allocate irq_desc and irq_cfg, or just static array?
>
>>
>> - there was one aspect of NR_IRQS that was nice and useful: it acted as
>>  a sanity check against BIOS bugs and driver bugs that pass in some
>>  irrealistically high irq number. Now we'll just try to allocate some
>>  really high IRQ and accept it. I _think_ there should be a single,
>>  simple 'absolute maximum IRQ number' define which should set the
>>  maximum possible IRQ number. Lets call it NR_IRQS_MAX or so, and set
>>  it to NR_CPUS*NR_IO_APICS*224 or so?

We may want an is_valid_isa_irq() for drivers.  Otherwise drivers
should not be passing in irqs.  And the request_irq path should
valid the irq number but it should not allocate it.  So we will
have failures with invalid irq numbers.

For acpi, mptables and the like we can easily have a check for some
reasonably high value if there is value in that.  Last I looked parts
of that code were using numbers like 1024 and 4096 already.

> when sparse_irq is used, irq is [0, -1U]
> driver could be irq_desc(irq) to check if irq is valid or not. and use
> irq_desc_with_new(new) to get a new one.

Note that request_irq should do this for free.

> when generic_hardirqs is not used (s390, m68k, sparc), we need to
> create some stubs in linux/interrupt.h for them

s390 is weird.  I'm not even convinced they use linux/interrupt.h

Yep.  If we need more than the proper checks in request_irq.

>> - i'm a bit worried about linecount increase in general:
>>
>>     247 files changed, 3671 insertions(+), 2052 deletions(-)
>>
>>  could we work on reducing that somewhat? The new infrastructure bits
>>  in mm/* and kernel/irq/* will be unavoidable, what we should
>>  concentrate on is to make usage of the new facility just as
>>  straightforward, easy and compact as the old irq_desc[] usages.
> before that we could use get_irq_desc() and get_irq_desc_without_new()
> and according to eric, i changed that to irq_desc_with_new and irq_desc().
>
> so the array irq_desc[] need to be changed to irq_descX[]
> ( or *irq_desc to *irq_descX for dyn_array)

My mistake.  irq_desc() is a bad name for the conversion method
because it conflicts like that.  I really just did not want something
wordy, or something that suggests you need to call put_irq_desc.  BothÜ
of which get_irq_desc() are.

What I wound up using in my tree is a little different.

I introduced an opaque/empty structure: struct irq to be used in places
where we need pointers instead of an integer irq number in the interfaces.

I have a version of the genirq api that works on struct irq instead of
unsigned int irq.

I have functions:
struct irq * to_irq(unsigned int nr);
struct irq_desc *to_idesc(struct irq *);
unsigned int irq_nr(struct irq *irq);

Is there any reason why the migration path for architectures can not be:
Until they are converted: 
#define NR_IRQS and use the irq_desc array.

If they are just using a dynamically allocated array.
#define NR_IRQS nr_irqs

Once we kill the array entirely.
#undef NR_IRQS or
#define NR_IRQS 0xfffff000

>>  A worst-case example is drivers/char/random.c: the
>>  CONFIG_HAVE_SPARSE_IRQ and CONFIG_HAVE_DYN_ARRAY #ifdef jungle is not
>>  acceptable. I think the best way out is to convert the whole kernel to
>>  the new facilities (as safely as possible, without breaking other
>>  architectures), and making sure that the end result is easy to
>>  understand and intuitive.
>
> # grep CONFIG_HAVE_ drivers/char/random.c
> #ifndef CONFIG_HAVE_SPARSE_IRQ
> #ifdef CONFIG_HAVE_DYN_ARRAY
> #ifndef CONFIG_HAVE_SPARSE_IRQ
>
> just want to make other arch is untouched.

It doesn't matter.  If you look only genirq arches use use random irqs.

Eric
