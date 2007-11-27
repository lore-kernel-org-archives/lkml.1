Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbXK0VH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbXK0VH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbXK0VHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:07:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbXK0VHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:07:12 -0500
Date: Tue, 27 Nov 2007 16:05:58 -0500
From: Neil Horman <nhorman@redhat.com>
To: Ben Woodard <woodard@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com, vgoyal@in.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071127210558.GI14887@hmsendeavour.rdu.redhat.com>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <200711271445.56792.ak@suse.de> <20071127142826.GB31376@hmsreliant.think-freely.org> <200711271543.11809.ak@suse.de> <20071127144856.GC31376@hmsreliant.think-freely.org> <m14pf7k8ns.fsf@ebiederm.dsl.xmission.com> <474C832C.1060903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474C832C.1060903@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 12:50:52PM -0800, Ben Woodard wrote:
> Eric W. Biederman wrote:
> >Neil Horman <nhorman@tuxdriver.com> writes:
> >
> >>So, it sounds to me then, like unless I'm willing to really re-write the 
> >>APIC
> >>setup code (which I don't feel qualified to do quite yet), that the 
> >>immediate
> >>solution would be to not rely on interrupts in legacy mode, which was 
> >>according
> >>to my understanding, what the use of the irqpoll command line option was
> >>supposed to enable.  Any thoughts as to why that might not be working in 
> >>this
> >>case, or suggested tests to determine a cause there?
> >
> >Hmm.  It looks like irqpoll expects to have at least one irq working.
> >I wonder if we can fix that.
> >
> >Looking at it from the other direction what does this line
> >from check_timer() look like when you boot a normal kernel?
> >
> >	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d 
> >	pin1=%d apic2=%d pin2=%d\n",
> >		cfg->vector, apic1, pin1, apic2, pin2);
> >
> 
> Here is what I get on a normal boot of the problem motherboard:
> 
> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> 

Ok, I think from what I understand of what we're reading here, the apic2 = -1
and pin2 = -1 indicate that the 8259 has no direct connection to any cpu, which
means that on shutdown disable_IO_APIC should take us into virtual wire mode.
As such enabling the APIC early in boot should fix us, but more consisely,
rewriting the entry in the IOAPIC to deliver int0 to the only running cpu should
accomplish the same goal for this problem.  Does that sound reasonable (at least
as a test to ensure we understand the problem) to everyone?

Neil


> 
> >I'm curious what values we see at boot for the legacy mode the first
> >time it is setup, and possibly what chipset you are on.
> >I know we have had a few times where we have failed to reprogram
> >the ioapic properly at shutdown.  So it can't hurt to look at
> >that possibility one last time.
> >
> >
> >For whatever it is worth my original attempt at using only the
> >apic mode was commit: f2b36db692b7ff6972320ad9839ae656a3b0ee3e
> >Looks like I didn't have an x86_64 version.
> >
> >It looks like about half the cleanups I needed was to decouple
> >smp cpu startup and apic initialization.  I think the hotplug cpu
> >case has done a more thorough version of that now.
> >
> >There was a bit of reshuffling needed to get the everything initialized
> >in the right order when we started apic mode sooner.
> >
> >Anyway I might just take another look at this if I can find enough
> >moments to string together.
> >
> >Eric
> >
> >_______________________________________________
> >kexec mailing list
> >kexec@lists.infradead.org
> >http://lists.infradead.org/mailman/listinfo/kexec
> 
> 
> -- 
> -ben
> -=-

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
