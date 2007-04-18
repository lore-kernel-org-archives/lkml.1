Return-Path: <linux-kernel-owner+w=401wt.eu-S2992584AbXDRUYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992584AbXDRUYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992609AbXDRUYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:24:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36691 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992584AbXDRUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:24:48 -0400
X-Originating-Ip: 64.172.16.227
Date: Wed, 18 Apr 2007 16:23:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Len Brown <lenb@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: {Spam?} Re: [PATCH][RFC] Kill off legacy power management stuff.
In-Reply-To: <200704181524.16980.lenb@kernel.org>
Message-ID: <Pine.LNX.4.64.0704181615510.18034@localhost.localdomain>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
 <20070413183054.08ca0dff.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0704140855270.10740@localhost.localdomain>
 <200704181524.16980.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Len Brown wrote:

> On Saturday 14 April 2007 09:01, Robert P. J. Day wrote:
> > On Fri, 13 Apr 2007, Stephen Rothwell wrote:
> >
> > > On Fri, 13 Apr 2007 04:20:10 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> > > >
> > > > On Fri, 13 Apr 2007, Stephen Rothwell wrote:
> > > > >
> > > > > One thing that comes to mind is that you will need some way to
> > > > > make sure that only one of ACPI and APM get initialized ...
> > > >
> > > > i don't see how that has anything to do with removing legacy PM
> > > > support.  you can select both ACPI and APM *now*.  if that's a bad
> > > > thing, then fixing it is a completely independent issue.
> > >
> > > Except your patch removes this hunk:
> > >
> > > @@ -2264,14 +2248,6 @@ static int __init apm_init(void)
> > >  		apm_info.disabled = 1;
> > >  		return -ENODEV;
> > >  	}
> > > -	if (PM_IS_ACTIVE()) {
> > > -		printk(KERN_NOTICE "apm: overridden by ACPI.\n");
> > > -		apm_info.disabled = 1;
> > > -		return -ENODEV;
> > > -	}
> > > -#ifdef CONFIG_PM_LEGACY
> > > -	pm_active = 1;
> > > -#endif
> > >
> > > in apm.c and a similar piece of the ACPI initialisation that
> > > prevented one initialising if the other had already initialised.
> >
> > ah, just took a closer look at this.  from <linux/pm_legacy.h>:
> > ...
> > #ifdef CONFIG_PM_LEGACY
> > ...
> > #else
> > #define PM_IS_ACTIVE() 0
> > ...
> > #endif
> >
> > so if you choose not to configure legacy PM, that macro equates to
> > false and that "if" construct in arch/i386/kernel/apm.c doesn't
> > come into play, anyway.
> >
> > so i re-iterate what i posted in my earlier e-mail -- if APM and
> > ACPI want to avoid clashing, they have to do it without invoking
> > anything related to legacy PM.
>
> Here is how it should work. CONFIG_ACPI and CONFIG_APM should both
> available in a kernel build. However, at boot time, of ACPI is
> active, then APM should be disabled.
>
> The pm_active flag used to handle this, but that method was BROKEN
> when the CONFIG_PM_LEGACY #define was added.  Today, there are
> systems (such as the Thinkpad T30) that will not boot if
> CONFIG_PM_LEGACY is not defined.  The reason nobody is complaining
> is because the distros are currently defining CONFIG_PM_LEGACY.
> But when you nuke that option and everything under it, this bug will
> be exposed and some systems will stop booting.

ok, i get it now and -- correct me if i'm wrong -- all my legacy PM
removal patch was doing was exposing a design boo-boo in which
APM/ACPI contention was being handled by a macro in a subsystem even
older than either of them, right?  so all that needs to be done is add
back in a contention solution of some kind that doesn't rely on that
ancient system, yes?

as for that thinkpad t30 situation, well, that's just borked, and
should be fixed.

rday

p.s.  at the risk of repeating myself repetitively, do we now agree
that what i was trying to remove *was* adequately ancient?  although
it's clear that it has to be done slightly more carefully than was
done in my initial patch.

p.p.s.  patch improvements that will let me avoid doing any of that
myself always welcome. :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
