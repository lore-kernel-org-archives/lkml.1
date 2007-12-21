Return-Path: <linux-kernel-owner+w=401wt.eu-S1765530AbXLUAmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530AbXLUAmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbXLUAmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:42:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756603AbXLUAmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:42:42 -0500
Date: Thu, 20 Dec 2007 16:40:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-Id: <20071220164000.58c43b42.akpm@linux-foundation.org>
In-Reply-To: <20071221003035.GA10123@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	<20071220145415.f737e7f3.akpm@linux-foundation.org>
	<20071220234759.GA29776@elte.hu>
	<20071220161934.0f55029a.akpm@linux-foundation.org>
	<20071221003035.GA10123@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 01:30:35 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 21 Dec 2007 00:47:59 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > >  		__raw_spin_lock(&die.lock);
> > > >  		raw_local_save_flags(flags);
> > > > -		die.lock_owner = smp_processor_id();
> > > > +		die.lock_owner = raw_smp_processor_id();
> > > 
> > > we just disabled irqs with raw_local_save_flags().
> > 
> > <chases x86 spaghetti for a while>
> > 
> > raw_local_save_flags() doesn't disable interrupts?
> 
> argh. Indeed! (I wanted us to fix that misleading name eons ago, to 

The naming of those functions is truly awful and it goes back to year 0.

> *_save_flags_only(), but some stupid bikeshed painting discussion 
> prevented it from ever happening.)

local_read_flags().

> that should have been raw_local_irq_save(flags)!

So raw_local_save_flags() and raw_local_irq_save() have different semantics.

omigawd, what have we done?

> but ... why is it done like that? Why do we first take the die.lock and 
> disable interrupts afterwards? It's highly weird. 64-bit does it all 
> correctly in traps_64.c, so unification will help us out - but so far 
> perhaps the patch below we should do in 2.6.24?
> 
> 	Ingo
> 
> ------------>
> Subject: x86: fix die() to not be preemptible
> From: Ingo Molnar <mingo@elte.hu>
> 
> Andrew "Eagle Eye" Morton noticed that we use raw_local_save_flags()
> instead of raw_local_irq_save(flags) in die().
> 
> do it correctly - and first disable interrupts, then take the spinlock.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/traps_32.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> Index: linux-x86.q/arch/x86/kernel/traps_32.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/traps_32.c
> +++ linux-x86.q/arch/x86/kernel/traps_32.c
> @@ -373,14 +373,13 @@ void die(const char * str, struct pt_reg
>  
>  	if (die.lock_owner != raw_smp_processor_id()) {
>  		console_verbose();
> +		raw_local_irq_save(flags);
>  		__raw_spin_lock(&die.lock);
> -		raw_local_save_flags(flags);
>  		die.lock_owner = smp_processor_id();
>  		die.lock_owner_depth = 0;
>  		bust_spinlocks(1);
> -	}
> -	else
> -		raw_local_save_flags(flags);
> +	} else
> +		raw_local_irq_save(flags);
>  
>  	if (++die.lock_owner_depth < 3) {
>  		unsigned long esp;

Looks sane.

I suppose there's some reason why we can't just use spin_lock_irqsave(). 
But that reason was either so obvious or so unimportant that a comment was
not needed.  Sigh.
