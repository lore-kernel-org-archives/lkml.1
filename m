Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYLEWCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYLEWCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYLEWC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:02:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbYLEWC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:02:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 23:01:44 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812051312160.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812051312160.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812052301.45450.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of December 2008, Linus Torvalds wrote:
> 
> On Thu, 4 Dec 2008, Linus Torvalds wrote:
> > 
> > The third thing that worries me is the _very_ early occurrence of
> > 
> > 	ACPI: Waking up from system sleep state S3
> > 	APIC error on CPU1: 00(40)
> > 	ACPI: EC: non-query interrupt received, switching to interrupt mode
> > 
> > Now, that "APIC error" thing is worrisome. It's worrisome for multiple 
> > reasons:
> > 
> >  - errors are never good (0x40 means "received illegal vector", whatever 
> >    caused _that_)
> > 
> >  - more importantly, it seems to imply that interrupts are enabled on 
> >    CPU1, and they sure as hell shouldn't be enabled at this stage!
> > 
> >    Do we perhaps have a SMP resume bug where we resume the other CPU's 
> >    with interrupts enabled?
> > 
> >  - the "ACPI: EC: non-query interrupt received, switching to interrupt 
> >    mode" thing is from ACPI, and _also_ implies that interrupts are on. 
> > 
> > Why are interrupts enabled that early? I really don't like seeing 
> > interrupts enabled before we've even done the basic PCI resume. 
> 
> Oh, I finally started looking more at this.
> 
> It's because the PCI layer uses the late resume for resuming. Which is 
> horrid. It really shouldn't. Resuming your device after interrupts were 
> enabled really sounds like a disaster. *Especially* if the device was 
> active before, either because of hibernation or simply because firmware 
> pre-initialized it to some "live" state (which could easily happen with 
> ethernet in particular).
> 
> I do wonder why the PCI layer wants to resume things so late. It sounds 
> totally insane to do things like resume the PCI bridge setup long *after* 
> you have resumed other devices early. So by doing the default resume late, 
> it just means that nobody can possibly use the early resume, and now 
> everybody needs to resume everything with interrupts already going full 
> blast.
> 
> IOW, the _sane_ thing would be to do something like the following patch 
> does, namely:
> 
>  - if the driver has a suspend or suspend_early function, _only_ call that 
>    (whether legacy or not)
> 
>  - otherwise, do the default suspend/resume late/early with interrupts 
>    disabled.
> 
> which means that by default, we'll do all save-restore of the PCI state 
> close to the actual CPU suspend event as possible.
> 
> Of course, hibernate probably depends on ->suspend() saving state, which 
> it won't. Again, if thats' the case, then that's just hibernate (again) 
> being totally fundamentally broken, and messing with STR functions. 

No, hibernate doesn't care whether ->suspend() or ->suspend_late() saves
the state, if that's what you mean.  Also, we have the hibernation-specific
callbacks in the new framework anyway.

> Rafael?

Well, actually I think we should go further and save the standard config
registers of _all_ PCI devices in the _late() callbacks (ie. with interrupts
disabled) and restore them in the _early() callbacks.

I don't really understand why pci_restore_state() is not called by the core
and every single driver calls it by itself.  Moreover, many of them
call pci_set_power_state(dev, PCI_D0) before calling pci_restore_state(),
although this is not really necessary, because they subsequently call
pci_enable_device() which calls pci_set_power_state(dev, PCI_D0) again.

IOW, I would split the resume of PCI devices into two parts, the first of
which will call pci_restore_state() with interrupts disabled and the second
will do the remaining stuff.

> I have neither tested the patch nor even tried to compile it - it's meant 
> to be an example and get people thinking about this, rather than anything 
> else.

I'm going to try it, though, and see what happens. ;-)

Thanks,
Rafael


> ---
>  drivers/pci/pci-driver.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index b4cdd69..6395983 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -346,8 +346,6 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
>  	if (drv && drv->suspend) {
>  		i = drv->suspend(pci_dev, state);
>  		suspend_report_result(drv->suspend, i);
> -	} else {
> -		pci_default_pm_suspend(pci_dev);
>  	}
>  	return i;
>  }
> @@ -361,7 +359,8 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
>  	if (drv && drv->suspend_late) {
>  		i = drv->suspend_late(pci_dev, state);
>  		suspend_report_result(drv->suspend_late, i);
> -	}
> +	} else if (!drv || !drv->suspend)
> +		pci_default_pm_suspend(pci_dev);
>  	return i;
>  }
>  
> @@ -373,8 +372,6 @@ static int pci_legacy_resume(struct device *dev)
>  
>  	if (drv && drv->resume)
>  		error = drv->resume(pci_dev);
> -	else
> -		error = pci_default_pm_resume(pci_dev);
>  	return error;
>  }
>  
> @@ -386,6 +383,8 @@ static int pci_legacy_resume_early(struct device *dev)
>  
>  	if (drv && drv->resume_early)
>  		error = drv->resume_early(pci_dev);
> +	else if (!drv || !drv->resume)
> +		error = pci_default_pm_resume(pci_dev);
>  	return error;
>  }
>  
> @@ -420,8 +419,6 @@ static int pci_pm_suspend(struct device *dev)
>  		if (drv->pm->suspend) {
>  			error = drv->pm->suspend(dev);
>  			suspend_report_result(drv->pm->suspend, error);
> -		} else {
> -			pci_default_pm_suspend(pci_dev);
>  		}
>  	} else {
>  		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
> @@ -441,7 +438,8 @@ static int pci_pm_suspend_noirq(struct device *dev)
>  		if (drv->pm->suspend_noirq) {
>  			error = drv->pm->suspend_noirq(dev);
>  			suspend_report_result(drv->pm->suspend_noirq, error);
> -		}
> +		} else if (!drv->pm->suspend)
> +			pci_default_pm_suspend(pci_dev);
>  	} else {
>  		error = pci_legacy_suspend_late(dev, PMSG_SUSPEND);
>  	}
> @@ -458,8 +456,7 @@ static int pci_pm_resume(struct device *dev)
>  	pci_fixup_device(pci_fixup_resume, pci_dev);
>  
>  	if (drv && drv->pm) {
> -		error = drv->pm->resume ? drv->pm->resume(dev) :
> -			pci_default_pm_resume(pci_dev);
> +		error = drv->pm->resume ? drv->pm->resume(dev) : 0;
>  	} else {
>  		error = pci_legacy_resume(dev);
>  	}
> @@ -467,6 +464,7 @@ static int pci_pm_resume(struct device *dev)
>  	return error;
>  }
>  
> +
>  static int pci_pm_resume_noirq(struct device *dev)
>  {
>  	struct pci_dev *pci_dev = to_pci_dev(dev);
> @@ -478,6 +476,8 @@ static int pci_pm_resume_noirq(struct device *dev)
>  	if (drv && drv->pm) {
>  		if (drv->pm->resume_noirq)
>  			error = drv->pm->resume_noirq(dev);
> +		else if (!drv->pm->resume)
> +			error = pci_default_pm_resume(pci_dev);
>  	} else {
>  		error = pci_legacy_resume_early(dev);
>  	}
> 
> 



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
