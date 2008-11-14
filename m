Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbYKNGrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbYKNGrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 01:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbYKNGrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 01:47:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYKNGrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 01:47:15 -0500
Date: Thu, 13 Nov 2008 22:46:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v14
Message-Id: <20081113224644.46c376f9.akpm@linux-foundation.org>
In-Reply-To: <491D1AC1.1000408@kernel.org>
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
	<20081113141340.7e17bdca.akpm@linux-foundation.org>
	<491CAD20.9020202@kernel.org>
	<20081113145846.bef2bb90.akpm@linux-foundation.org>
	<491D1AC1.1000408@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 22:29:21 -0800 Yinghai Lu <yinghai@kernel.org> wrote:

> address some Andrew's concerns.
> 
> ...
>
> +static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
> +{
> +	struct irq_pin_list *pin;
> +	int node;
> +
> +	node = cpu_to_node(cpu);
> +
> +	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
> +	printk(KERN_DEBUG "  alloc irq_2_pin on cpu %d node %d\n", cpu, node);
> +	BUG_ON(!pin);
> +
> +	return pin;
> +}

GFP_ATOMIC allocation attempts are unreliable - much more so than
GFP_KERNEL.  GFP_ATOMIC allocations can and do fail.  With the above
code, such a failure will crash the machine.

The code should handle this error and recover gracefully.

>
> ...
>
> +static struct irq_cfg *get_one_free_irq_cfg(int cpu)
> +{
> +	struct irq_cfg *cfg;
> +	int node;
> +
> +	node = cpu_to_node(cpu);
> +
> +	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
> +	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
> +	BUG_ON(!cfg);
> +
> +	return cfg;
>  }

Ditto

> ...
>
> +static struct irq_2_iommu *get_one_free_irq_2_iommu(int cpu)
> +{
> +	struct irq_2_iommu *iommu;
> +	int node;
> +
> +	node = cpu_to_node(cpu);
> +
> +	iommu = kzalloc_node(sizeof(*iommu), GFP_ATOMIC, node);
> +	printk(KERN_DEBUG "alloc irq_2_iommu on cpu %d node %d\n", cpu, node);
> +
> +	return iommu;
> +}

I spent some time trying to work out whether the callers handle failure
here but I got lost in a twisty maze.

> ...
>
> +static void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
> +{
> +	unsigned long bytes;
> +	char *ptr;
> +	int node;
> +
> +	/* Compute how many bytes we need per irq and allocate them */
> +	bytes = nr * sizeof(unsigned int);
> +
> +	node = cpu_to_node(cpu);
> +	ptr = kzalloc_node(bytes, GFP_ATOMIC, node);
> +	printk(KERN_DEBUG "  alloc kstat_irqs on cpu %d node %d\n", cpu, node);
> +	BUG_ON(!ptr);
> +
> +	desc->kstat_irqs = (unsigned int *)ptr;
> +}

Ditto.

>
> ...
>
> +struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
> +{
> +	struct irq_desc *desc;
> +	struct list_head *hash_head;
> +	unsigned long flags;
> +	int node;
> +
> +	desc = irq_to_desc(irq);
> +	if (desc)
> +		return desc;
> +
> +	hash_head = sparseirqhashentry(irq);
> +
> +	spin_lock_irqsave(&sparse_irq_lock, flags);
> +
> +	/*
> +	 * We have to do the hash-walk again, to avoid races
> +	 * with another CPU:
> +	 */
> +	list_for_each_entry(desc, hash_head, hash_entry) {
> +		if (desc->irq == irq)
> +			goto out_unlock;
> +	}
> +
> +	node = cpu_to_node(cpu);
> +	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> +	printk(KERN_DEBUG "  alloc irq_desc for %d aka %#x on cpu %d node %d\n",
> +		 irq, irq, cpu, node);
> +	BUG_ON(!desc);

Ditto.

> +	init_one_irq_desc(irq, desc, cpu);
> +
> +	/*
> +	 * We use RCU's safe list-add method to make
> +	 * parallel walking of the hash-list safe:
> +	 */
> +	list_add_tail_rcu(&desc->hash_entry, hash_head);
> +	/*
> +	 * Add it to the global list:
> +	 */
> +	list_add_tail_rcu(&desc->list, &sparse_irqs_head);
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&sparse_irq_lock, flags);
> +
> +	return desc;
> +}
> +
>
> ...
>
> +static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
> +						int cpu)
> +{
> +	struct irq_desc *desc;
> +	unsigned int irq;
> +	struct list_head *hash_head;
> +	unsigned long flags;
> +	int node;
> +
> +	irq = old_desc->irq;
> +
> +	hash_head = sparseirqhashentry(irq);
> +
> +	spin_lock_irqsave(&sparse_irq_lock, flags);
> +	/*
> +	 * We have to do the hash-walk again, to avoid races
> +	 * with another CPU:
> +	 */
> +	list_for_each_entry(desc, hash_head, hash_entry) {
> +		if (desc->irq == irq && old_desc != desc)
> +			goto out_unlock;
> +	}
> +
> +	node = cpu_to_node(cpu);
> +	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> +	printk(KERN_DEBUG "  move irq_desc for %d aka %#x to cpu %d node %d\n",
> +		 irq, irq, cpu, node);
> +	BUG_ON(!desc);

Ditto.

> +	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
> +
> +	list_replace_rcu(&old_desc->hash_entry, &desc->hash_entry);
> +	list_replace_rcu(&old_desc->list, &desc->list);
> +
> +	/* free the old one */
> +	free_one_irq_desc(old_desc);
> +	kfree(old_desc);
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&sparse_irq_lock, flags);
> +
> +	return desc;
> +}
> +


