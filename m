Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbYC3M2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbYC3M2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 08:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYC3M16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 08:27:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60623 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYC3M15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 08:27:57 -0400
Date: Sun, 30 Mar 2008 14:28:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Felix =?iso-8859-1?Q?M=F6ller?= <fm@opensuse.org>,
       Arthur Erhardt <erhardt@pit.physik.uni-tuebingen.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI PM: Restore the 2.6.24 suspend ordering
Message-ID: <20080330122838.GA7093@elf.ucw.cz>
References: <200803300319.08398.rjw@sisk.pl> <20080330111844.GA6247@elf.ucw.cz> <200803301358.39831.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803301358.39831.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Some time ago it turned out that our suspend code ordering broke
> > > some NVidia-based systems that hung if _PTS was executed with one of
> > > the PCI devices, specifically a USB controller, in a low power state.
> > > Then, it was noticed that the suspend code ordering was not compliant
> > > with ACPI 1.0, although it was compliant with ACPI 2.0 (and later),
> > > and it was argued that the code had to be changed for that reason
> > > (ref. http://bugzilla.kernel.org/show_bug.cgi?id=9528).  So we did,
> > > but evidently we did wrong, because it's now turning out that some
> > > systems have been broken by this change (refs.
> > > http://bugzilla.kernel.org/show_bug.cgi?id=10340 ,
> > > https://bugzilla.novell.com/show_bug.cgi?id=374217#c16).  [I said
> > > at that time that something like this might happend, but the majority
> > > of people involved thought that it was improbable due to the
> > > necessity to preserve the compliance of hardware with ACPI 1.0.]
> > > This actually is a quite serious regression from 2.6.24.
> > > 
> > > Moreover, the ACPI 1.0 ordering of suspend code introduced another
> > > issue that I have only noticed recently.  Namely, if the suspend of
> > > one of devices fails, the already suspended devices will be resumed
> > > without executing _WAK before, which leads to problems on some
> > > systems (for example, in such situations thermal management is
> > > broken on my HP nx6325).  Consequently, it also breaks suspend
> > > debugging on the affected systems.
> > > 
> > > Note also, that the requirement to execute _PTS before suspending
> > > devices does not really make sense, because the device in question
> > > may be put into a low power state at run time for a reason unrelated
> > > to a system-wide suspend.

Yes, but if we are putting them into lowpower state ourselves, we
should probably be doing that "by hand", without calling acpi
methods. _PTS may prepare something for acpi methods (which tell us
which PCI Dx state to put the device in at the very least).

> > > For the reasons outlined above, the change of the suspend ordering
> > > should be reverted, which is done by the patch below.
> > 
> > But this will break those few nvidia-based systems, no?
> > 
> > this may have been a good idea in -rc1 days, but we are in -rc7
> > now... and the patch is slightly big.
> 
> It's quite obvious, though.

Yes, but breaking systems between -rc7 and final is _very_ unnice.

> > What about something like: (hand-edited patch, sorry)
> 
> Well, I think that would be confusing.
> 
> The NVidia systems are broken anyway on 2.6.24.x, so we just don't fix them
> rather than break them and there are more reasons to do what the patch does
> (as pointed out in the changelog).  For example, your suggested patch doesn't
>  fix the error paths/debugging breakage described in the changelog.

But that should not be impossible to fix, right?

> I think we _can_ do something about the failing NVidia systems in the 2.6.26
> time frame, but that will require some more consideration.

We could simply blacklist them, no?
								Pavel

> >  Index: linux-2.6/drivers/acpi/sleep/main.c
> >  ===================================================================
> >  --- linux-2.6.orig/drivers/acpi/sleep/main.c
> >  +++ linux-2.6/drivers/acpi/sleep/main.c
> >  @@ -26,21 +26,6 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
> >   
> >   #ifdef CONFIG_PM_SLEEP
> >   static u32 acpi_target_sleep_state = ACPI_STATE_S0;
> >  static bool acpi_sleep_finish_wake_up;
> >  
> > - /*
> > -  * ACPI 2.0 and later want us to execute _PTS after suspending devices, so we
> > -  * allow the user to request that behavior by using the 'acpi_new_pts_ordering'
> > -  * kernel command line option that causes the following variable to be set.
> > -  */
> >  static bool new_pts_ordering = true;
> >  
> >  -static int __init acpi_new_pts_ordering(char *str)
> >  +static int __init acpi_old_pts_ordering(char *str)
> >  {
> >  	new_pts_ordering = false;
> >  	return 1;
> >  }
> >  -__setup("acpi_old_pts_ordering", acpi_old_pts_ordering);
> >  +__setup("acpi_new_pts_ordering", acpi_new_pts_ordering);
> >   #endif
> >  
> >   static int acpi_sleep_prepare(u32 acpi_state)
> >  Index: linux-2.6/Documentation/kernel-parameters.txt
> >  ===================================================================
> >  --- linux-2.6.orig/Documentation/kernel-parameters.txt
> >  +++ linux-2.6/Documentation/kernel-parameters.txt
> >  @@ -170,11 +170,6 @@ and is between 256 and 4096 characters. 
> >   	acpi_irq_isa=	[HW,ACPI] If irq_balance, mark listed IRQs used by ISA
> >   			Format: <irq>,<irq>...
> >   
> >  -	acpi_new_pts_ordering [HW,ACPI]
> >  +	acpi_old_pts_ordering [HW,ACPI]
> >  -			Enforce the ACPI 2.0 ordering of the _PTS control
> >  +			Enforce the ACPI 1.0 ordering of the _PTS control
> >  			method wrt putting devices into low power states
> >  -			default: pre ACPI 2.0 ordering of _PTS
> >  +			default: ACPI 2.0 ordering of _PTS
> >  
> >   	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
> >   
> >   	acpi_os_name=	[HW,ACPI] Tell ACPI BIOS the name of the OS
> > 
> 
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
