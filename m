Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZCZNig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZCZNig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZCZNi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:38:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21954 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbZCZNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:38:25 -0400
X-IronPort-AV: E=Sophos;i="4.38,426,1233550800"; 
   d="scan'208";a="45258109"
Subject: Re: [PATCH] clockevent: on resume program the next oneshot tick
	with the next actual event
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alex Zeffertt <Alex.Zeffertt@eu.citrix.com>,
       "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <49CAC0D6.3040301@goop.org>
References: <1237988429-26474-1-git-send-email-Ian.Campbell@citrix.com>
	 <49CA678A.30606@goop.org>
	 <1238003202.3691.174.camel@zakaz.uk.xensource.com>
	 <49CAC0D6.3040301@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Thu, 26 Mar 2009 13:37:40 +0000
Message-Id: <1238074660.3691.232.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2009 13:38:23.0038 (UTC) FILETIME=[220B3DE0:01C9AE18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 19:40 -0400, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > Hmm, yes I think so too. I misread tick_dev_program_event(), it seems
> > like it Does The Right Thing and I do see the Xen set_next_event hook
> > get called which I thought wasn't getting called earlier.
> >
> > Turns out the virtual timer IRQ isn't getting reinitialised before
> > tick_oneshot_resume runs so we are just missing the interrupt, doh!
> >   
> 
> While that ordering is a bug, I'm still not sure it completely explains 
> what we're seeing here.
> 
> In drivers/xen/manage.c:do_suspend() we call clock_was_set(), which has 
> the specific effect of causing all the timer events to get retriggered 
> on all cpus.

Not if CONFIG_HIGH_RES_TIMERS is not set, which I don't have. If I set
it then things work as expected even without the patch.

When CONFIG_HIGH_RES_TIMERS is set though the call to clock_was_set ends
up in hr_timer_force_reprogram, I'm not clear what the relationship
between hrtimers and ticks is, they both seem to call down to the
oneshot code eventually, so they must coexist somehow...

Ian.

>   This is necessary because we don't unplug/replug all the 
> cpus, and the normal sysdev_resume() timer resume only resumes the 
> current cpu (which is cpu 0 in this case).  It also deals with the 
> clocksource timebase shifting, as it will over suspend/resume (esp 
> suspend/reboot/resume, or suspend/migrate/resume).  Your patch will only 
> re-trigger the next cpu0 timer event, and leave the rest hanging without 
> a next event.
> 
> So the question is why does your patch help?
> 
> I'm seeing much worse symptoms on my test machine: the resumed domain is 
> just sitting there spinning dead with 100% cpu use.  I don't know if 
> this is related or something else.
> 
>     J
> 
> > Subject: xen: resume interrupts before system devices.
> >
> > otherwise the first timer interrupt after resume is missed and we never
> > get another.
> >
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> >
> > diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> > index 0489ea2..5269bb4 100644
> > --- a/drivers/xen/manage.c
> > +++ b/drivers/xen/manage.c
> > @@ -68,15 +68,15 @@ static int xen_suspend(void *data)
> >  	gnttab_resume();
> >  	xen_mm_unpin_all();
> >  
> > -	sysdev_resume();
> > -	device_power_up(PMSG_RESUME);
> > -
> >  	if (!*cancelled) {
> >  		xen_irq_resume();
> >  		xen_console_resume();
> >  		xen_timer_resume();
> >  	}
> >  
> > +	sysdev_resume();
> > +	device_power_up(PMSG_RESUME);
> > +
> >  	return 0;
> >  }
> >  
> >
> > Ian.
> >
> >
> >
> >   
> >>     J
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >>     
> >
> >   
> 

