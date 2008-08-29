Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYH2Knw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYH2Knw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbYH2Knl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:43:41 -0400
Received: from www.tglx.de ([62.245.132.106]:43939 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbYH2Knl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:43:41 -0400
Date: Fri, 29 Aug 2008 12:42:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Daniel J Blueman <daniel.blueman@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] debugobjects: fix lockdep warning #2
In-Reply-To: <20080828153214.GA27653@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0808291212100.3243@apollo.tec.linutronix.de>
References: <20080828153214.GA27653@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Vegard Nossum wrote:
> On Thu, Aug 28, 2008 at 3:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > could you resend the final patch please? It's a candidate for .27, if it
> > works out fine.
> 
> Here is the combined patch. I've tested it only briefly, and I am
> unsure of whether it still produces lockdep warnings for Daniel or
> not. I wish it would not be applied anywhere unless it was
> officially Reviewed-by: someone. In particular, I'm not quite
> steady with the irq-safe locking (Thomas might want to have a look).

The irq safe locking is the easy part :) Calling free_object w/o the
hash bucket lock held is fine as we removed it already from the bucket
and there is no other reference than the pointer we hold at that point.
 
>  
>  	printk(KERN_WARNING "ODEBUG: Out of memory. ODEBUG disabled\n");
>  
> +	/* XXX: Could probably be optimized by transplantation of more than
> +	 * one entry at a time. */
>  	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
>  		spin_lock_irqsave(&db->lock, flags);
>  		hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
>  			hlist_del(&obj->node);
> -			free_object(obj);
> +			hlist_add_head(&obj->node, &freelist);
>  		}
>  		spin_unlock_irqrestore(&db->lock, flags);
> +
> +		/* Now free them */
> +		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
> +			hlist_del(&obj->node);
> +			free_object(obj);
> +		}
>  	}
>  }

What you want is a helper function which moves the complete list from
one head to the other. I'll whip one up.

I'll push it through the tip tree.

Thanks,

	tglx
