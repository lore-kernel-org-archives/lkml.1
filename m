Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYDXV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYDXV3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbYDXV3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:29:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59250 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbYDXV3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:29:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Date: Thu, 24 Apr 2008 23:30:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, pavel@ucw.cz
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <20080424105908.GW12774@kernel.dk> <481080A0.9050804@rtr.ca>
In-Reply-To: <481080A0.9050804@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804242330.01519.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 24 of April 2008, Mark Lord wrote:
> Jens Axboe wrote:
> > On Wed, Apr 23 2008, Mark Lord wrote:
> >> Jens Axboe wrote:
> >>> On Wed, Apr 23 2008, Mark Lord wrote:
> >>> ..
> >>>> The second bug, is that for the halt case at least,
> >>>> nobody waits for the other CPU to actually halt
> >>>> before continuing.. so we sometimes enter the shutdown
> >>>> code while other CPUs are still active.
> >>>>
> >>>> This causes some machines to hang at shutdown,
> >>>> unless CPU_HOTPLUG is configured and takes them offline
> >>>> before we get here.
> >>> I'm guessing there's a reason it doesn't pass '1' as the last argument,
> >>> because that would fix that issue?
> >> ..
> >>
> >> Undoubtedly -- perhaps the called CPU halts, and therefore cannot reply.  :)
> > 
> > Uhm yes, I guess stop_this_cpu() does exactly what the name implies :-)
> > 
> >> But some kind of pre-halt ack, perhaps plus a short delay by the caller
> >> after receipt of the ack, would probably suffice to kill that bug.
> >>
> >> But I really haven't studied this code enough to know,
> >> other than that it historically has been a sticky area
> >> to poke around in.
> > 
> > Something like this will close the window to right up until the point
> > where the other CPUs have 'almost' called halt().
> > 
> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> > index 5398385..94ec9bf 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -155,8 +155,9 @@ static void stop_this_cpu(void *dummy)
> >  	/*
> >  	 * Remove this CPU:
> >  	 */
> > -	cpu_clear(smp_processor_id(), cpu_online_map);
> >  	disable_local_APIC();
> > +	cpu_clear(smp_processor_id(), cpu_online_map);
> > +	smp_wmb();
> >  	if (hlt_works(smp_processor_id()))
> >  		for (;;) halt();
> >  	for (;;);
> > @@ -175,6 +176,12 @@ static void native_smp_send_stop(void)
> >  
> >  	local_irq_save(flags);
> >  	smp_call_function(stop_this_cpu, NULL, 0, 0);
> > +
> > +	while (cpus_weight(cpu_online_map) > 1) {
> > +		cpu_relax();
> > +		smp_rmb();
> > +	}
> > +
> >  	disable_local_APIC();
> >  	local_irq_restore(flags);
> >  }
> ..
> 
> Yup, that looks like it oughta work consistently.
> Now we just need to hear from some of the folks who
> have danced around this code in the past.
> 
> (added Pavel & Rafael to Cc:).

Well, it looks sane to me, but I'm not really an expert here.

Thanks,
Rafael
