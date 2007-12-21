Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbXLULhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbXLULhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 06:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXLULhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 06:37:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbXLULhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 06:37:09 -0500
Date: Fri, 21 Dec 2007 03:34:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-Id: <20071221033443.058b1b63.akpm@linux-foundation.org>
In-Reply-To: <20071221111207.GC29047@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	<20071220145415.f737e7f3.akpm@linux-foundation.org>
	<20071220234759.GA29776@elte.hu>
	<20071220161934.0f55029a.akpm@linux-foundation.org>
	<20071221003035.GA10123@elte.hu>
	<20071220164000.58c43b42.akpm@linux-foundation.org>
	<20071221102727.GB22452@elte.hu>
	<20071221024211.f4207136.akpm@linux-foundation.org>
	<20071221111207.GC29047@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 12:12:07 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I'd suggest that we add a local_read_flags() along with 
> > local_save_flags(). Then I can merge the parts of the patch which 
> > don't get destroyed by ongoing churn and then we can come in and clean 
> > up the stragglers later.
> 
> ah, indeed.
> 
> like the patch below? (Only local_save_flags() should be used by drivers 
> - but i stuck in the other variants as well for completeness.)
> 
> 	Ingo
> 
> -------------------->
> Subject: migration helpers for local_save_flags => local_read_flags rename
> From: Ingo Molnar <mingo@elte.hu>
> 
> prepare for renaming of all local_save_flags variants to local_read_flags,
> via migration helpers, as suggested by Andrew Morton.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/irqflags.h |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-x86.q/include/linux/irqflags.h
> ===================================================================
> --- linux-x86.q.orig/include/linux/irqflags.h
> +++ linux-x86.q/include/linux/irqflags.h
> @@ -93,4 +93,13 @@
>  #define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
>  #endif		/* CONFIG_X86 */
>  
> +/*
> + * Migration helpers - the proper API is the local_read_flags API.
> + * Will go away in v2.6.26.
> + */
> +#define local_save_flags		local_read_flags
> +#define __local_save_flags		__local_read_flags
> +#define raw_local_save_flags		raw_local_read_flags
> +#define __raw_local_save_flags		__raw_local_read_flags
> +

Looks good.  We also have local_irq_save(), raw_local_irq_save() and
__raw_local_irq_save() which might or might not disable interrupts.  (Do we
really need three flavours of these?)

I guess that people's understanding of spin_lock_irqsave() (note the
irqsave versus irq_save inconsistency) is sufficiently good for nobody to
get tripped up by local_irq_save().  But it's a poor name nonetheless.


It'd be nice to move away from macros too if poss?
