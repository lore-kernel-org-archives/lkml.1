Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZBQTFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZBQTFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZBQTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:05:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbZBQTFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:05:11 -0500
Date: Tue, 17 Feb 2009 11:04:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/genirq] irq: refactor and clean up the free_irq() code
 flow
In-Reply-To: <tip-ae88a23b32fa7e0dc9fa7ce735966e68eb41b0bc@kernel.org>
Message-ID: <alpine.LFD.2.00.0902171101080.21686@localhost.localdomain>
References: <tip-ae88a23b32fa7e0dc9fa7ce735966e68eb41b0bc@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Feb 2009, Ingo Molnar wrote:
>  	struct irq_desc *desc = irq_to_desc(irq);
> -	struct irqaction **p;
> +	struct irqaction *action, **p, **pp;

The whole reason for 'pp' seems to be the confusing loop:

>  	for (;;) {
> +		action = *p;
> +		pp = p;
> +
> +		if (!action) {
> +			WARN(1, "Trying to free already-free IRQ %d\n", irq);
> +			spin_unlock_irqrestore(&desc->lock, flags);
> +
> +			return;
> +		}
>  
> +		p = &action->next;
> +		if (action->dev_id != dev_id)
> +			continue;
>  
> +		break;
> +	}
> +	/* Found it - now remove it from the list of entries: */
> +	*pp = action->next;

Where the need for 'pp' would go away if you'd just write it as

		if (action->dev_id == dev_id)
			break;
		p = &action->next;
	}
	*p = action->next;

instead. Which also makes it both shorter and more readable.

		Linus
