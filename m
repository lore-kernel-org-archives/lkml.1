Return-Path: <linux-kernel-owner+w=401wt.eu-S1763795AbXGYWpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763795AbXGYWpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbXGYWp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:45:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48928 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932350AbXGYWpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:45:25 -0400
Date: Thu, 26 Jul 2007 00:45:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Cedric Le Goater <clg@fr.ibm.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: 2.6.23-rc1-mm1: chipsfb_pci_suspend problem
Message-ID: <20070725224532.GA8950@elf.ucw.cz>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A7483C.60005@fr.ibm.com> <200707251548.10962.rjw@sisk.pl> <20070725132206.df77650f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725132206.df77650f.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> > > 
> > > from pm-move-definition-of-struct-pm_ops-to-suspendh.patch :
> > > 
> > > drivers/video/chipsfb.c: In function 'chipsfb_pci_suspend':
> > > drivers/video/chipsfb.c:461: error: 'PM_SUSPEND_MEM' undeclared (first use in this function)
> > > drivers/video/chipsfb.c:461: error: (Each undeclared identifier is reported only once
> > > drivers/video/chipsfb.c:461: error: for each function it appears in.)
> > 
> > Well, actually, this is a bug in chipsfb.c, as it shouldn't use PM_SUSPEND_MEM
> > in there, but PMSG_SUSPEND (patch untested).
> > 
> > ---
> >  drivers/video/chipsfb.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6.23-rc1/drivers/video/chipsfb.c
> > ===================================================================
> > --- linux-2.6.23-rc1.orig/drivers/video/chipsfb.c
> > +++ linux-2.6.23-rc1/drivers/video/chipsfb.c
> > @@ -458,7 +458,7 @@ static int chipsfb_pci_suspend(struct pc
> >  
> >  	if (state.event == pdev->dev.power.power_state.event)
> >  		return 0;
> > -	if (state.event != PM_SUSPEND_MEM)
> > +	if (state != PMSG_SUSPEND)
> >  		goto done;
> >  
> >  	acquire_console_sem();
> 
> For reasons which aren't immediately obvious, the compiler didn't like
> that: comparing with an immediate struct liek that is a bit tricky.

Yes, that was deliberate "type safety".

> This is equivalent, and works:
> 
> 
> --- a/drivers/video/chipsfb.c~chipsfb-use-correct-pm-state
> +++ a/drivers/video/chipsfb.c
> @@ -24,6 +24,7 @@
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
>  #include <linux/fb.h>
> +#include <linux/pm.h>
>  #include <linux/init.h>
>  #include <linux/pci.h>
>  #include <linux/console.h>
> @@ -458,7 +459,7 @@ static int chipsfb_pci_suspend(struct pc
>  
>  	if (state.event == pdev->dev.power.power_state.event)
>  		return 0;
> -	if (state.event != PM_SUSPEND_MEM)
> +	if (state.event != PM_EVENT_SUSPEND)

And this is indeed correct. ACK.

> Is this a 2.6.23 thing?

Should not hurt anything, i'd say so.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
