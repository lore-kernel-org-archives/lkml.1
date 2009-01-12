Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZALOmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZALOmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZALOmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:42:38 -0500
Received: from cmpxchg.org ([85.214.51.133]:42635 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbZALOmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:42:37 -0500
Date: Mon, 12 Jan 2009 15:42:18 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Christophe Saout <christophe@saout.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: xen: fix too early kmalloc call
Message-ID: <20090112144218.GA18859@cmpxchg.org>
References: <496A4C8F.8070005@sgi.com> <20090112085302.GB21976@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112085302.GB21976@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 09:53:02AM +0100, Ingo Molnar wrote:
> 
> * Mike Travis <travis@sgi.com> wrote:
> 
> > Subject: xen: fix too early kmalloc call
> > 
> > From: Christophe Saout <christophe@saout.de> 
> > 
> > Impact: fixes bootup of xen.
> > 
> > Christophe reported the following problem:
> > 
> > >  (basically it seems that SLAB is not yet up, with earlyprintk it is
> > >  giving me an Oops in __kmalloc before)
> > 
> > Replace call to kmalloc with alloc_bootmem.
> > 
> > Also from Christophe:
> > > (me)
> > > > Or I could copy the text and submit it as a new patch?
> > >
> > > Yes, I would prefer that.  Also, my commit message was not really
> > > following Kernel standards and it's only a very simple change.
> > 
> > Signed-off-by: Mike Travis <travis@sgi.com>
> 
> i've applied the fix to tip/cpus4096, in the form below.
> 
> Please submit clean log messages. Your commit description was confused - 
> the patch is From: Christophe, but the message talks about Christophe in 
> the third person. Also, it included conversational bits that have no 
> value for the Git history.
> 
> 	Ingo
> 
> -------------------->
> >>From 28e08861b9afab4168b758fb7b95aa7a4da0f668 Mon Sep 17 00:00:00 2001
> From: Christophe Saout <christophe@saout.de>
> Date: Sun, 11 Jan 2009 11:46:23 -0800
> Subject: [PATCH] xen: fix too early kmalloc call
> 
> Impact: fix bootup crash on xen guests
> 
> SLAB is not yet up, with earlyprintk it is giving me an Oops in __kmalloc.
> 
> Replace call to kmalloc() with alloc_bootmem().
> 
> Reported-by: Christophe Saout <christophe@saout.de>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/xen/events.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index ed7527b..3141e14 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -26,6 +26,7 @@
>  #include <linux/irq.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
> +#include <linux/bootmem.h>
>  
>  #include <asm/ptrace.h>
>  #include <asm/irq.h>
> @@ -831,8 +832,8 @@ void __init xen_init_IRQ(void)
>  	int i;
>  	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
>  
> -	cpu_evtchn_mask_p = kmalloc(size, GFP_KERNEL);
> -	BUG_ON(cpu_evtchn_mask == NULL);
> +	cpu_evtchn_mask_p = alloc_bootmem(size);
> +	BUG_ON(cpu_evtchn_mask_p == NULL);

Impossible condition :-) alloc_bootmem() crashes before you could
catch it here.

	Hannes
