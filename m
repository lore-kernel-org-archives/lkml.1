Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbXJRBp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbXJRBp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbXJRBpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:45:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760964AbXJRBpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:45:19 -0400
Date: Wed, 17 Oct 2007 18:45:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: benh@kernel.crashing.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] synchronize_irq needs a barrier
Message-Id: <20071017184512.a1c647b2.akpm@linux-foundation.org>
In-Reply-To: <1192670742.12879.5.camel@pasglop>
References: <1192670742.12879.5.camel@pasglop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 11:25:42 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> synchronize_irq needs at the very least a compiler barrier and a
> read barrier on SMP,

Why?

> but there are enough cases around where a
> write barrier is also needed and it's not a hot path so I prefer
> using a full smp_mb() here.
> 
> It will degrade to a compiler barrier on !SMP.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Index: linux-work/kernel/irq/manage.c
> ===================================================================
> --- linux-work.orig/kernel/irq/manage.c	2007-10-18 11:22:16.000000000 +1000
> +++ linux-work/kernel/irq/manage.c	2007-10-18 11:22:20.000000000 +1000
> @@ -33,6 +33,7 @@ void synchronize_irq(unsigned int irq)
>  	if (irq >= NR_IRQS)
>  		return;
>  
> +	smp_mb();
>  	while (desc->status & IRQ_INPROGRESS)
>  		cpu_relax();
>  }

Anyone reading this code is going to ask "wtf is that for".  It needs a
comment telling them.


mb() is the new lock_kernel().  Sigh.
