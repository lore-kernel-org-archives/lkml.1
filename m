Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYHUEEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYHUEEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYHUED6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:03:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbYHUED5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:03:57 -0400
Date: Wed, 20 Aug 2008 21:03:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sparse_irq need spin_lock in alloc
Message-Id: <20080820210336.3e6ffd6d.akpm@linux-foundation.org>
In-Reply-To: <1219290385-4976-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219290385-4976-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 20:46:25 -0700 Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> acording to Suresh Siddha, we should have spin_lock around it
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/io_apic.c |    6 ++++++
>  kernel/irq/handle.c       |    7 +++++++
>  2 files changed, 13 insertions(+)
> 
> Index: linux-2.6/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/handle.c
> +++ linux-2.6/kernel/irq/handle.c
> @@ -166,6 +166,9 @@ struct irq_desc *irq_to_desc(unsigned in
>  	}
>  	return NULL;
>  }
> +
> +static DEFINE_SPINLOCK(sparse_irq_lock);
> +
>  struct irq_desc *irq_to_desc_alloc(unsigned int irq)
>  {
>  	struct irq_desc *desc, *desc_pri;
> @@ -182,6 +185,7 @@ struct irq_desc *irq_to_desc_alloc(unsig
>  		count++;
>  	}
>  
> +	spin_lock(&sparse_irq_lock);
>  	/*
>  	 *  we run out of pre-allocate ones, allocate more
>  	 */
> @@ -223,6 +227,9 @@ struct irq_desc *irq_to_desc_alloc(unsig
>  	else
>  		sparse_irqs = desc;
>  	desc->irq = irq;
> +
> +	spin_unlock(&sparse_irq_lock);
> +
>  	printk(KERN_DEBUG "found new irq_desc for irq %d\n", desc->irq);
>  #ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
>  	{
> Index: linux-2.6/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/io_apic.c
> +++ linux-2.6/arch/x86/kernel/io_apic.c
> @@ -210,6 +210,8 @@ static struct irq_cfg *irq_cfg(unsigned
>  	return NULL;
>  }
>  
> +static DEFINE_SPINLOCK(irq_cfg_lock);
> +
>  static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
>  {
>  	struct irq_cfg *cfg, *cfg_pri;
> @@ -226,6 +228,7 @@ static struct irq_cfg *irq_cfg_alloc(uns
>  		count++;
>  	}
>  
> +	spin_lock(&irq_cfg_lock);
>  	if (!irq_cfgx_free) {
>  		unsigned long phys;
>  		unsigned long total_bytes;
> @@ -263,6 +266,9 @@ static struct irq_cfg *irq_cfg_alloc(uns
>  	else
>  		irq_cfgx = cfg;
>  	cfg->irq = irq;
> +
> +	spin_unlock(&irq_cfg_lock);
> +
>  	printk(KERN_DEBUG "found new irq_cfg for irq %d\n", cfg->irq);
>  #ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
>  	{

Each of these locks can be made local to the function in which they are
used (and hence they should be made local).

It would be nice to add a comment explaining what they are protecting,
unless that is obvious (I didn't look).

