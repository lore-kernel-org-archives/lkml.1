Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYKMWBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYKMWBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYKMWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:01:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:14366 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYKMWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=fyDR7UY18VyoU3L+ClGAwHeYFdnfVGa1t/RUO9MhRXWGz41yDQj8Wy2mOGAgVxSNt3
         k9mmy28U7C0lsDxM0tlt4jCxEJDJclSDLggYnZb5/PYjpliKXUirb13wlWU5G7NV3hw7
         DaCGFj3oos3/pfJ8mNZiGqa95cWyKwVyXd8g0=
Message-ID: <86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>
Date: Thu, 13 Nov 2008 14:01:06 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, travis@sgi.com
In-Reply-To: <20081113131850.d94fb229.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491434FB.2050904@kernel.org>
	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	 <20081110094033.GL22392@elte.hu>
	 <20081110015511.453a801e.akpm@linux-foundation.org>
	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>
	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>
	 <491C8B38.9060901@kernel.org>
	 <20081113131850.d94fb229.akpm@linux-foundation.org>
X-Google-Sender-Auth: 62ae0b3fa35fffed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 1:18 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 13 Nov 2008 12:16:56 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> From: Yinghai Lu <yinghai@kernel.org>
>> Subject: sparseirq v13
>
> My overall view on this is that it takes some of the kernel's most
> fragile and most problem-dense code and makes it much more complex, and
> by adding new configuration options it significantly worsens our
> testing coverage.
>
> The patch is HHHHHUUUUUUUUUUGGGGGEEE!  Did it really need to be a
> single megapatch?
>
> Other architectures want (or have) sparse interrupts.  Are those guys
> paying attention here?
>
> I don't have a clue what all this does.  I hope those who will work on
> this code are sufficiently familiar with it all to be able to maintain
> it when there are close to zero comments in some of our most tricky and
> problem-prone code.
>
>>
>> ...
>>
>> +config SPARSE_IRQ
>> +     bool "Support sparse irq numbering"
>> +     depends on PCI_MSI || HT_IRQ
>> +     default y
>> +     help
>> +       This enables support for sparse irq, esp for msi/msi-x. the irq
>> +       number will be bus/dev/fn + 12bit. You may need if you have lots of
>> +       cards supports msi-x installed.
>> +
>> +       If you don't know what to do here, say Y.
>> +
>> +config MOVE_IRQ_DESC
>> +     bool "Move irq desc when changing irq smp_affinity"
>> +     depends on SPARSE_IRQ && SMP
>> +     default y
>> +     help
>> +       This enables moving irq_desc to cpu/node that irq will use handled.
>> +
>> +       If you don't know what to do here, say Y.
>
> Do these reeeealy have to exist?  How are users to know which to
> choose?  Which option will distros choose and why did we make them have
> to decide?

want to use that as marker, so later could split the patch to small
ones by enabling by steps.

>
>>
>> ...
>>
>> +{
>> +     struct irq_pin_list *pin;
>> +     int node;
>> +
>> +     if (cpu < 0)
>> +             cpu = smp_processor_id();
>> +     node = cpu_to_node(cpu);
>> +
>> +     pin = kzalloc_node(sizeof(*pin), GFP_KERNEL, node);
>
> It's a bug to call smp_processor_id() from preemptible code and it's a
> bug to use GFP_KERNEL in non-preemptible code.  How can this be?

the could should be executed in boot stage, only bsp is running, or
interrupt conext
via irq_complete_move

>
>> +     printk(KERN_DEBUG "  alloc irq_2_pin on cpu %d node %d\n", cpu, node);
>> +
>> +     return pin;
>> +}
>>
>>
>> ...
>>
>> -static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
>> +static struct irq_cfg *get_one_free_irq_cfg(int cpu)
>>  {
>> -     return irq_cfg(irq);
>> +     struct irq_cfg *cfg;
>> +     int node;
>> +
>> +     if (cpu < 0)
>> +             cpu = smp_processor_id();
>> +     node = cpu_to_node(cpu);
>> +
>> +     cfg = kzalloc_node(sizeof(*cfg), GFP_KERNEL, node);
>
> See above.
>
>> +     printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
>> +
>> +     return cfg;
>>  }
>
> So all callers of this function must test the return value and if it is
> NULL, take appropriate action.
>
> That is something which should have been documented in this function's
> interface description.  Only that doesn't exist.
>
> The one caller which I checked (arch_init_copy_chip_data()) fails to
> check for this and will oops.

will add one function to wrap it.

>
>>
>> ...
>>
>> +static void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
>> +{
>> +     struct irq_cfg *cfg = desc->chip_data;
>> +
>> +     if (!cfg->move_in_progress) {
>> +             /* it means that domain is not changed */
>> +             cpumask_t tmp;
>> +
>> +             cpus_and(tmp, desc->affinity, mask);
>> +             if (cpus_empty(tmp))
>> +                     cfg->move_desc_in_progress_in_same_domain = 1;
>> +     }
>
> Aren't we trying to avoid on-stack cpumask_t's?
>
> I'd have though that this one could be eliminated via the use of
> cpus_intersects()?

will change to that.

there some other in __assign_irq_vector...

>
>>  }
>> +#endif
>>
>> ...
>>
>>  static struct irq_chip lapic_chip __read_mostly = {
>>       .name           = "local-APIC",
>>       .mask           = mask_lapic_irq,
>> @@ -2574,7 +2834,9 @@ int timer_through_8259 __initdata;
>>   */
>>  static inline void __init check_timer(void)
>
> An inlined __init function makes little sense.

should be done other patch...?

>
>>
>> ...
>>
>> @@ -3306,10 +3590,13 @@ static void dmar_msi_set_affinity(unsign
>>       if (cpus_empty(tmp))
>>               return;
>
> `tmp' is always a bad choice of identifier.

other patch?

>
>>
>> ...
>>
>> --- linux-2.6.orig/arch/x86/mm/init_32.c
>> +++ linux-2.6/arch/x86/mm/init_32.c
>> @@ -66,6 +66,7 @@ static unsigned long __meminitdata table
>>  static unsigned long __meminitdata table_top;
>>
>>  static int __initdata after_init_bootmem;
>> +int after_bootmem;
>
> This isn't a very well-chosen identifier for an x86-specific global.

it is not used, will remove that.

>
>>
>> ...
>>
>> @@ -98,6 +126,7 @@ int __ht_create_irq(struct pci_dev *dev,
>>       int max_irq;
>>       int pos;
>>       int irq;
>> +     unsigned int irq_want;
>>
>>       pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
>>       if (!pos)
>> @@ -125,7 +154,12 @@ int __ht_create_irq(struct pci_dev *dev,
>>       cfg->msg.address_lo = 0xffffffff;
>>       cfg->msg.address_hi = 0xffffffff;
>>
>> +     irq_want = build_irq_for_pci_dev(dev);
>> +#ifdef CONFIG_SPARSE_IRQ
>> +     irq = create_irq_nr(irq_want + idx);
>> +#else
>>       irq = create_irq();
>> +#endif
>
> irq_want is unused if CONFIG_SPARSE_IRQ=n.
>
>>       if (irq <= 0) {
>>               kfree(cfg);
>> Index: linux-2.6/drivers/pci/intr_remapping.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/intr_remapping.c
>> +++ linux-2.6/drivers/pci/intr_remapping.c
>> @@ -19,17 +19,73 @@ struct irq_2_iommu {
>>       u8  irte_mask;
>>  };
>>
>> -static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
>> +#ifdef CONFIG_SPARSE_IRQ
>> +static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
>> +{
>> +     struct irq_2_iommu *iommu;
>> +     int node;
>> +
>> +     if (cpu < 0)
>> +             cpu = smp_processor_id();
>> +     node = cpu_to_node(cpu);
>> +
>> +     iommu = kzalloc_node(sizeof(*iommu), GFP_KERNEL, node);
>
> See above.
>
>> +     printk(KERN_DEBUG "alloc irq_2_iommu on cpu %d node %d\n", cpu, node);
>> +
>> +     return iommu;
>> +}
>>
>>
>> ...
>>
>> --- linux-2.6.orig/fs/proc/stat.c
>> +++ linux-2.6/fs/proc/stat.c
>> @@ -27,6 +27,9 @@ static int show_stat(struct seq_file *p,
>>       u64 sum = 0;
>>       struct timespec boottime;
>>       unsigned int per_irq_sum;
>> +#ifdef CONFIG_GENERIC_HARDIRQS
>> +     struct irq_desc *desc;
>> +#endif
>>
>>       user = nice = system = idle = iowait =
>>               irq = softirq = steal = cputime64_zero;
>> @@ -44,10 +47,9 @@ static int show_stat(struct seq_file *p,
>>               softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
>>               steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
>>               guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
>> -
>> -             for_each_irq_nr(j)
>> +             for_each_irq_desc(j, desc) {
>
> This won't compile if CONFIG_GENERIC_HARDIRQS=n, I suspect.
>
we have

#ifndef CONFIG_GENERIC_HARDIRQS
#include <asm/irq.h>
# define nr_irqs                NR_IRQS

# define for_each_irq_desc(irq, desc)           \
        for (irq = 0; irq < nr_irqs; irq++)
# define end_for_each_irq_desc()


>>                       sum += kstat_irqs_cpu(j, i);
>> -
>> +             } end_for_each_irq_desc();
>>               sum += arch_irq_stat_cpu(i);
>>       }
>>       sum += arch_irq_stat();
>> @@ -90,14 +92,17 @@ static int show_stat(struct seq_file *p,
>>       seq_printf(p, "intr %llu", (unsigned long long)sum);
>>
>>       /* sum again ? it could be updated? */
>> -     for_each_irq_nr(j) {
>> +     for_each_irq_desc(j, desc) {
>
> ditto.
>
>>
>> ...
>>
>> +#define end_for_each_irq_desc()
>> +#endif
>> +
>> +#define desc_chip_ack(irq, descp) desc->chip->ack(irq)
>> +#define desc_chip_mask(irq, descp) desc->chip->mask(irq)
>> +#define desc_chip_mask_ack(irq, descp) desc->chip->mask_ack(irq)
>> +#define desc_chip_unmask(irq, descp) desc->chip->unmask(irq)
>> +#define desc_chip_eoi(irq, descp) desc->chip->eoi(irq)
>
> Was it necessary to implement these as macros?

try to avoid bunch of #idef with different parameters that need to be passed.

>
>>
>> ...
>>
>> @@ -49,6 +56,299 @@ void handle_bad_irq(unsigned int irq, st
>>  int nr_irqs = NR_IRQS;
>>  EXPORT_SYMBOL_GPL(nr_irqs);
>>
>> +void __init __attribute__((weak)) arch_early_irq_init_work(void)
>> +{
>> +}
>> +
>> +#ifdef CONFIG_SPARSE_IRQ
>> +static struct irq_desc irq_desc_init = {
>> +     .irq        = -1U,
>
> Plain old `-1' would be better here.  It works in all cases and the
> reader doesn't need to go and check that this field really is an
> unsigned int and it won't need editing if that field gets changed to
> long
.
ok.

>
>> +     .status     = IRQ_DISABLED,
>> +     .chip       = &no_irq_chip,
>> +     .handle_irq = handle_bad_irq,
>> +     .depth      = 1,
>> +     .lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
>> +#ifdef CONFIG_SMP
>> +     .affinity   = CPU_MASK_ALL
>> +#endif
>> +};
>> +
>> +static void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>> +{
>> +     unsigned long bytes;
>> +     char *ptr;
>> +     int node;
>> +
>> +     /* Compute how many bytes we need per irq and allocate them */
>> +     bytes = nr * sizeof(unsigned int);
>> +
>> +     if (cpu < 0)
>> +             cpu = smp_processor_id();
>> +
>> +     node = cpu_to_node(cpu);
>> +     ptr = kzalloc_node(bytes, GFP_KERNEL, node);
>
> See above.
>
>> +     printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n", cpu, node);
>> +
>> +     desc->kstat_irqs = (unsigned int *)ptr;
>> +}
>> +
>>
>> ...
>>
>> +#endif
>> +/*
>> + * Protect the sparse_irqs_free freelist:
>> + */
>> +static DEFINE_SPINLOCK(sparse_irq_lock);
>> +LIST_HEAD(sparse_irqs_head);
>
> It's strange that the list is global and is accessed from other .c
> files, but the lock which protects it is static
.
only protect that when try to append the list. with rcu add tail.

>
>> +/*
>> + * The sparse irqs are in a hash-table as well, for fast lookup:
>> + */
>> +#define SPARSEIRQHASH_BITS          (13 - 1)
>> +#define SPARSEIRQHASH_SIZE          (1UL << SPARSEIRQHASH_BITS)
>> +#define __sparseirqhashfn(key)      hash_long((unsigned long)key, SPARSEIRQHASH_BITS)
>> +#define sparseirqhashentry(key)     (sparseirqhash_table + __sparseirqhashfn((key)))
>
> Why implement these via macros?

copied from sched.c

>
>> +static struct list_head sparseirqhash_table[SPARSEIRQHASH_SIZE];
>> +
>> +static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_smp = {
>> +     [0 ... NR_IRQS_LEGACY-1] = {
>> +             .irq        = -1U,
>> +             .status     = IRQ_DISABLED,
>> +             .chip       = &no_irq_chip,
>> +             .handle_irq = handle_bad_irq,
>> +             .depth      = 1,
>> +             .lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
>> +#ifdef CONFIG_SMP
>> +             .affinity   = CPU_MASK_ALL
>> +#endif
>> +     }
>> +};
>> +
>> +/* FIXME: use bootmem alloc ...*/
>> +static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
>
> Do these need to be 32-bit?  Maybe they'll fit in 16-bit, dunno.
>

struct irq_desc {
        unsigned int            irq;
#ifdef CONFIG_SPARSE_IRQ
        struct list_head        list;
        struct list_head        hash_entry;
        struct timer_rand_state *timer_rand_state;
        unsigned int            *kstat_irqs;

>> +void __init early_irq_init_work(void)
>
> The use of "_work" implies that this function is invoked by
> schedule_work().  But it isn't

ok, will remove it.

>
>> +{
>> +     struct irq_desc *desc;
>> +     int legacy_count;
>> +     int i;
>> +
>> +     /* init_work to init list for sparseirq */
>> +     for (i = 0; i < SPARSEIRQHASH_SIZE; i++)
>> +             INIT_LIST_HEAD(sparseirqhash_table + i);
>> +
>> +     desc = irq_desc_legacy;
>> +     legacy_count = ARRAY_SIZE(irq_desc_legacy);
>> +
>> +     for (i = 0; i < legacy_count; i++) {
>> +             struct list_head *hash_head;
>> +
>> +             hash_head = sparseirqhashentry(i);
>> +             desc[i].irq = i;
>> +             desc[i].kstat_irqs = kstat_irqs_legacy[i];
>> +             list_add_tail(&desc[i].hash_entry, hash_head);
>> +             list_add_tail(&desc[i].list, &sparse_irqs_head);
>> +     }
>> +
>> +     arch_early_irq_init_work();
>> +}
>> +
>>
>> ...
>>
>> +struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
>> +{
>> +     struct irq_desc *desc;
>> +     struct list_head *hash_head;
>> +     unsigned long flags;
>> +     int node;
>> +
>> +     desc = irq_to_desc(irq);
>> +     if (desc)
>> +             return desc;
>> +
>> +     hash_head = sparseirqhashentry(irq);
>> +
>> +     spin_lock_irqsave(&sparse_irq_lock, flags);
>> +
>> +     /*
>> +      * We have to do the hash-walk again, to avoid races
>> +      * with another CPU:
>> +      */
>> +     list_for_each_entry(desc, hash_head, hash_entry)
>> +             if (desc->irq == irq)
>> +                     goto out_unlock;
>> +
>> +     if (cpu < 0)
>> +             cpu = smp_processor_id();
>> +
>> +     node = cpu_to_node(cpu);
>> +     desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
>
> Oh for gawd's sake.  PLEASE read Documentation/SubmitChecklist.
> Carefully.  We've already discussed this.
there are 13 errors with checkpatch scripts. seems all about macro definition.

>
> You cannot do a GFP_KERNEL allocation under spin_lock_irqsave().
>
>> +     printk(KERN_DEBUG "  alloc irq_desc for %d aka %#x on cpu %d node %d\n",
>> +              irq, irq, cpu, node);
>> +     init_one_irq_desc(irq, desc, cpu);
>> +
>> +     /*
>> +      * We use RCU's safe list-add method to make
>> +      * parallel walking of the hash-list safe:
>> +      */
>> +     list_add_tail_rcu(&desc->hash_entry, hash_head);
>> +     /*
>> +      * Add it to the global list:
>> +      */
>> +     list_add_tail_rcu(&desc->list, &sparse_irqs_head);
>> +
>> +out_unlock:
>> +     spin_unlock_irqrestore(&sparse_irq_lock, flags);
>> +
>> +     return desc;
>> +}
>> +
>> +struct irq_desc *irq_to_desc_alloc(unsigned int irq)
>> +{
>> +     return irq_to_desc_alloc_cpu(irq, -1);
>> +}
>> +
>> +#ifdef CONFIG_MOVE_IRQ_DESC
>> +static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
>> +                                             int cpu)
>> +{
>> +     struct irq_desc *desc;
>> +     unsigned int irq;
>> +     struct list_head *hash_head;
>> +     unsigned long flags;
>> +     int node;
>> +
>> +     irq = old_desc->irq;
>> +
>> +     hash_head = sparseirqhashentry(irq);
>> +
>> +     spin_lock_irqsave(&sparse_irq_lock, flags);
>> +     /*
>> +      * We have to do the hash-walk again, to avoid races
>> +      * with another CPU:
>> +      */
>> +     list_for_each_entry(desc, hash_head, hash_entry)
>> +             if (desc->irq == irq && old_desc != desc)
>> +                     goto out_unlock;
>> +
>> +     if (cpu < 0)
>> +             cpu = smp_processor_id();
>> +
>> +     node = cpu_to_node(cpu);
>> +     desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
>
> Ditto.
>
> Also, the return value from the memory allocation attempt is not
> checked.
>
>> +     printk(KERN_DEBUG "  move irq_desc for %d aka %#x to cpu %d node %d\n",
>> +              irq, irq, cpu, node);
>> +
>> +     init_copy_one_irq_desc(irq, old_desc, desc, cpu);
>> +
>> +     list_replace_rcu(&old_desc->hash_entry, &desc->hash_entry);
>> +     list_replace_rcu(&old_desc->list, &desc->list);
>> +
>> +     /* free the old one */
>> +     free_one_irq_desc(old_desc);
>> +     kfree(old_desc);
>> +
>> +out_unlock:
>> +     spin_unlock_irqrestore(&sparse_irq_lock, flags);
>> +
>> +     return desc;
>> +}
>> +
>>
>> ...
>>
>> --- linux-2.6.orig/init/main.c
>> +++ linux-2.6/init/main.c
>> @@ -542,6 +542,15 @@ void __init __weak thread_info_cache_ini
>>  {
>>  }
>>
>> +void __init __attribute__((weak)) arch_early_irq_init_work(void)
>> +{
>> +}
>> +
>> +void __init __attribute__((weak)) early_irq_init_work(void)
>> +{
>> +     arch_early_irq_init_work();
>> +}
>
> Please use __weak

ok

thanks for reviewing.

YH
