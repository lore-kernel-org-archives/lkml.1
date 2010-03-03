Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab0CCKQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:16:35 -0500
Received: from www.tglx.de ([62.245.132.106]:46186 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0CCKQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:16:33 -0500
Date: Wed, 3 Mar 2010 11:16:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Madhusudhan <madhu.cr@ti.com>
cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
       linux-mmc@vger.kernel.org
Subject: RE: [PATCH] mmc: omap_hsmmc: Fix conditional locking
In-Reply-To: <010101caba72$1dd1d790$544ff780@am.dhcp.ti.com>
Message-ID: <alpine.LFD.2.00.1003030756120.4245@localhost.localdomain>
References: <alpine.LFD.2.00.1003011952470.4245@localhost.localdomain> <010101caba72$1dd1d790$544ff780@am.dhcp.ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Mar 2010, Madhusudhan wrote:
> > Conditional locking on (!in_interrupt()) is broken by design and there
> > is no reason to keep the host->irq_lock across the call to
> > mmc_request_done(). Also the host->protect_card magic hack does not
> > depend on the context
> > 
> 
> Can you please elaborate why the existing logic is broken?

Locks are only to be held to serialize data or state. 

The mmc_request_done() call does _NOT_ require that at all. So
dropping the lock there is the right thing to do.

Also conditional locking on in_interrupt() is generally a nono as it
relies on assumptions which are not necessarily true in all
circumstances. Just one simple example: interrupt threading will make
it explode nicely and it did already with the realtime patches
applied.

Such code constructs prevent us to do generic changes to the kernel
behaviour without any real good reason.

> It locks at the new request and unlocks just before issuing the cmd. Further
> IRQ handler has these calls hence the !in_interrupt check.

Aside of the conditional locking I have several issues with that code:

1) The code flow is massively unreadable:

   omap_hsmmc_start_command()
   {
	.....
	if (!in_interrupt())
	   spin_unlock_irq();
   }
 
   omap_hsmmc_request()
   {
	if (!in_interrupt())
	   spin_lock_irq();

	omap_hsmmc_start_command();
   }

We generally want to see the lock/unlock pairs in one function and not
having to figure out where the heck unlock happens.

2) The point of unlocking is patently wrong

   omap_hsmmc_start_command()
   {
	.....
	if (!in_interrupt())
	   spin_unlock_irq();
--->
	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
--->
        OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
   }

What happens, if you get a spurious interrupt here ? Same for SMP,
though you are probably protected by the core mmc code request
serialization there.

> How does this patch improve that? In fact with your patch for a data
> transfer cmd there are several lock-unlock calls.

1) The patch simply removes conditional locking and moves the lock
   sections to those places which protect something. Aside of that it
   makes the code easier to understand.

2) What's the point of not having those lock/unlocks ? On UP the
   spinlock is a NOOP anyway, so you won't even notice. On SMP you
   won't notice either, simply because the lock is cache hot and
   almost never contended.

Thanks,

	tglx
