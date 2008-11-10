Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYKJWuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYKJWuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYKJWtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:49:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50675 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755049AbYKJWtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:49:53 -0500
Date: Mon, 10 Nov 2008 23:49:34 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ivan Vecera <ivecera@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, nhorman@redhat.com,
       jmarchan@redhat.com
Subject: Re: [PATCH] x86: call machine_shutdown and stop all CPUs in
	native_machine_halt
Message-ID: <20081110224934.GA2069@ucw.cz>
References: <1224504787-11403-1-git-send-email-ivecera@redhat.com> <20081020160058.GB22779@elte.hu> <48FDCCCB.2080103@redhat.com> <491316D9.20206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491316D9.20206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-06 17:10:01, Ivan Vecera wrote:
> Any comments?
> 
> Ivan
> 
> ---
> Ivan Vecera wrote:
> > Ingo Molnar wrote:
> >> the code in arch/x86/kernel/smp.c::stop_this_cpu() is very similar to 
> >> this and could be shared. You could move the stop_this_cpu() function to 
> >> arch/x86/kernel/process.c (out of smp.c), so that it can be used by 
> >> reboot.c.
> >>
> > Yes, this make sense. Here is the patch.
> > 
> > Ivan
> > 
> > ---
> >  arch/x86/kernel/process.c |   16 ++++++++++++++++
> >  arch/x86/kernel/reboot.c  |    5 +++++
> >  arch/x86/kernel/smp.c     |   13 -------------
> >  include/asm-x86/system.h  |    2 ++
> >  4 files changed, 23 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> > index c622772..af6904e 100644
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/pm.h>
> >  #include <linux/clockchips.h>
> >  #include <asm/system.h>
> > +#include <asm/apic.h>
> >  
> >  unsigned long idle_halt;
> >  EXPORT_SYMBOL(idle_halt);
> > @@ -122,6 +123,21 @@ void default_idle(void)
> >  EXPORT_SYMBOL(default_idle);
> >  #endif
> >  
> > +void stop_this_cpu(void *dummy)
> > +{
> > +	local_irq_disable();
> > +	/*
> > +	 * Remove this CPU:
> > +	 */
> > +	cpu_clear(smp_processor_id(), cpu_online_map);
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +	disable_local_APIC();
> > +#endif
> > +	if (hlt_works(smp_processor_id()))
> > +		for (;;) halt();
> > +	for (;;);
> > +}

Why the new ifdef? And while we are at it, why is it neccessary to
disable APIC for stopping CPU? (comment in code would be nice)

> > -static void stop_this_cpu(void *dummy)
> > -{
> > -	local_irq_disable();
> > -	/*
> > -	 * Remove this CPU:
> > -	 */
> > -	cpu_clear(smp_processor_id(), cpu_online_map);
> > -	disable_local_APIC();
> > -	if (hlt_works(smp_processor_id()))
> > -		for (;;) halt();
> > -	for (;;);
> > -}
> > -
> >  /*
> >   * this function calls the 'stop' function on all other CPUs in the system.
> >   */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
