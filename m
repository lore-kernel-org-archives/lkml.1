Return-Path: <linux-kernel-owner+w=401wt.eu-S1761556AbXK1QAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbXK1QAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 11:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760991AbXK1QAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 11:00:39 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2682 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbXK1QAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 11:00:38 -0500
Date: Wed, 28 Nov 2007 10:54:35 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Neil Horman <nhorman@redhat.com>
Cc: Ben Woodard <woodard@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       vgoyal@in.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071128155435.GA21165@hmsendeavour.rdu.redhat.com>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <200711271445.56792.ak@suse.de> <20071127142826.GB31376@hmsreliant.think-freely.org> <200711271543.11809.ak@suse.de> <20071127144856.GC31376@hmsreliant.think-freely.org> <m14pf7k8ns.fsf@ebiederm.dsl.xmission.com> <474C832C.1060903@redhat.com> <20071127210558.GI14887@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127210558.GI14887@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 04:05:58PM -0500, Neil Horman wrote:
> On Tue, Nov 27, 2007 at 12:50:52PM -0800, Ben Woodard wrote:
> > Eric W. Biederman wrote:
> > >Neil Horman <nhorman@tuxdriver.com> writes:
> > >
> > >>So, it sounds to me then, like unless I'm willing to really re-write the 
> > >>APIC
> > >>setup code (which I don't feel qualified to do quite yet), that the 
> > >>immediate
> > >>solution would be to not rely on interrupts in legacy mode, which was 
> > >>according
> > >>to my understanding, what the use of the irqpoll command line option was
> > >>supposed to enable.  Any thoughts as to why that might not be working in 
> > >>this
> > >>case, or suggested tests to determine a cause there?
> > >
> > >Hmm.  It looks like irqpoll expects to have at least one irq working.
> > >I wonder if we can fix that.
> > >
> > >Looking at it from the other direction what does this line
> > >from check_timer() look like when you boot a normal kernel?
> > >
> > >	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d 
> > >	pin1=%d apic2=%d pin2=%d\n",
> > >		cfg->vector, apic1, pin1, apic2, pin2);
> > >
> > 
> > Here is what I get on a normal boot of the problem motherboard:
> > 
> > ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> > 
> 
> Ok, I think from what I understand of what we're reading here, the apic2 = -1
> and pin2 = -1 indicate that the 8259 has no direct connection to any cpu, which
> means that on shutdown disable_IO_APIC should take us into virtual wire mode.
> As such enabling the APIC early in boot should fix us, but more consisely,
> rewriting the entry in the IOAPIC to deliver int0 to the only running cpu should
> accomplish the same goal for this problem.  Does that sound reasonable (at least
> as a test to ensure we understand the problem) to everyone?
> 
> Neil
> 

I'm sorry to reply to myself, but I think I actually had this backwards.  The
fact that the 8259 does not get reported as being routed through the ioapic,
means that in disable_IO_APIC during a crash shutdown, we do _not_ go into
virtual wire mode.  Instead we simply disable the LVT0 on the ioapic (which as I
understand it from above is the  timer interrupt), and we trust the 8259 to
route the interrupt to the appropriate cpu.  If the 8259 is hardwired to deliver
interrupts to cpu0 only, then we do in fact need to switch processors during
shutdown.  Perhaps what we need to do is detect if the 8259 is not routed
through the ioapic on shutdown, and if it is, only them implement my patch to
jump to the bsp.

Thoughts?

Neil

> 
> > 
> > >I'm curious what values we see at boot for the legacy mode the first
> > >time it is setup, and possibly what chipset you are on.
> > >I know we have had a few times where we have failed to reprogram
> > >the ioapic properly at shutdown.  So it can't hurt to look at
> > >that possibility one last time.
> > >
> > >
> > >For whatever it is worth my original attempt at using only the
> > >apic mode was commit: f2b36db692b7ff6972320ad9839ae656a3b0ee3e
> > >Looks like I didn't have an x86_64 version.
> > >
> > >It looks like about half the cleanups I needed was to decouple
> > >smp cpu startup and apic initialization.  I think the hotplug cpu
> > >case has done a more thorough version of that now.
> > >
> > >There was a bit of reshuffling needed to get the everything initialized
> > >in the right order when we started apic mode sooner.
> > >
> > >Anyway I might just take another look at this if I can find enough
> > >moments to string together.
> > >
> > >Eric
> > >
> > >_______________________________________________
> > >kexec mailing list
> > >kexec@lists.infradead.org
> > >http://lists.infradead.org/mailman/listinfo/kexec
> > 
> > 
> > -- 
> > -ben
> > -=-
> 
> -- 
> /***************************************************
>  *Neil Horman
>  *Software Engineer
>  *Red Hat, Inc.
>  *nhorman@redhat.com
>  *gpg keyid: 1024D / 0x92A74FA1
>  *http://pgp.mit.edu
>  ***************************************************/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
/***************************************************
 *Neil Horman
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
