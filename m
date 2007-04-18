Return-Path: <linux-kernel-owner+w=401wt.eu-S2993076AbXDRTZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993076AbXDRTZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993078AbXDRTZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:25:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:36633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993076AbXDRTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:25:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: {Spam?} Re: [PATCH][RFC] Kill off legacy power management stuff.
Date: Wed, 18 Apr 2007 15:24:16 -0400
User-Agent: KMail/1.9.5
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <20070413183054.08ca0dff.sfr@canb.auug.org.au> <Pine.LNX.4.64.0704140855270.10740@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704140855270.10740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181524.16980.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 April 2007 09:01, Robert P. J. Day wrote:
> On Fri, 13 Apr 2007, Stephen Rothwell wrote:
> 
> > On Fri, 13 Apr 2007 04:20:10 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> > >
> > > On Fri, 13 Apr 2007, Stephen Rothwell wrote:
> > > >
> > > > One thing that comes to mind is that you will need some way to
> > > > make sure that only one of ACPI and APM get initialized ...
> > >
> > > i don't see how that has anything to do with removing legacy PM
> > > support.  you can select both ACPI and APM *now*.  if that's a bad
> > > thing, then fixing it is a completely independent issue.
> >
> > Except your patch removes this hunk:
> >
> > @@ -2264,14 +2248,6 @@ static int __init apm_init(void)
> >  		apm_info.disabled = 1;
> >  		return -ENODEV;
> >  	}
> > -	if (PM_IS_ACTIVE()) {
> > -		printk(KERN_NOTICE "apm: overridden by ACPI.\n");
> > -		apm_info.disabled = 1;
> > -		return -ENODEV;
> > -	}
> > -#ifdef CONFIG_PM_LEGACY
> > -	pm_active = 1;
> > -#endif
> >
> > in apm.c and a similar piece of the ACPI initialisation that
> > prevented one initialising if the other had already initialised.
> 
> ah, just took a closer look at this.  from <linux/pm_legacy.h>:
> ...
> #ifdef CONFIG_PM_LEGACY
> ...
> #else
> #define PM_IS_ACTIVE() 0
> ...
> #endif
> 
> so if you choose not to configure legacy PM, that macro equates to
> false and that "if" construct in arch/i386/kernel/apm.c doesn't come
> into play, anyway.
> 
> so i re-iterate what i posted in my earlier e-mail -- if APM and ACPI
> want to avoid clashing, they have to do it without invoking anything
> related to legacy PM.

Here is how it should work.
CONFIG_ACPI and CONFIG_APM should both available in a kernel build.
However, at boot time, of ACPI is active, then APM should be disabled.

The pm_active flag used to handle this, but that method was BROKEN
when the CONFIG_PM_LEGACY #define was added.  Today, there are systems
(such as the Thinkpad T30) that will not boot if CONFIG_PM_LEGACY
is not defined.  The reason nobody is complaining is because the distros
are currently defining CONFIG_PM_LEGACY.  But when you nuke that option
and everything under it, this bug will be exposed and some systems will stop booting.

-Len
