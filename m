Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207Ab0AHMOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0AHMOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856Ab0AHMOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:14:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53934 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0AHMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:14:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N9jqmecnr2Ypj1V9JnpFyPRhB0QQIioV2E3UIfShKMBmHPJqnLPLZbwSUDHt4o/KPB
         /4zLnrbNugHbrQwh3VyFkIj1GnizhSBQeyVRdiZpnDgcl4OPQpzmTlIXTvdgCynnF8+1
         M0AYLaeCRVw7t7okKHGFyZwZZ7oHY5+oHValE=
Date: Fri, 8 Jan 2010 15:14:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] sparseirq: use radix_tree instead of ptrs array
Message-ID: <20100108121414.GB4967@lenovo>
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org> <1262951595-1729-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262951595-1729-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 03:53:14AM -0800, Yinghai Lu wrote:
> use radix_tree irq_desc_tree instead of irq_desc_ptrs.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  kernel/irq/handle.c |   47 ++++++++++++++++++++++-------------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)
> 
> Index: linux-2.6/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/handle.c
> +++ linux-2.6/kernel/irq/handle.c
> @@ -19,6 +19,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/rculist.h>
>  #include <linux/hash.h>
> +#include <linux/radix-tree.h>
>  #include <trace/events/irq.h>
>  
>  #include "internals.h"
> @@ -127,7 +128,23 @@ static void init_one_irq_desc(int irq, s
>   */
>  DEFINE_RAW_SPINLOCK(sparse_irq_lock);
>  
> -static struct irq_desc **irq_desc_ptrs __read_mostly;
> +static RADIX_TREE(irq_desc_tree, GFP_KERNEL);
> +
> +static void set_irq_desc(unsigned int irq, struct irq_desc *desc)
> +{
> +	radix_tree_insert(&irq_desc_tree, irq, desc);
> +}
> +
> +struct irq_desc *irq_to_desc(unsigned int irq)
> +{
> +	return radix_tree_lookup(&irq_desc_tree, irq);
> +}
> +
> +void replace_irq_desc(unsigned int irq, struct irq_desc *desc)
> +{
> +	radix_tree_delete(&irq_desc_tree, irq);
> +	radix_tree_insert(&irq_desc_tree, irq, desc);
> +}
>  
...

Hi Yinghai,

should not we printk\warn if radix_tree_insert() is get failed?
This is hardly (if ever) happen on machines with small number
of interrupts allocated but anyway.

Or I miss something?

	-- Cyrill
