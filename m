Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbXK0N7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbXK0N7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbXK0N7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:59:12 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3351 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbXK0N7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:59:11 -0500
Date: Tue, 27 Nov 2007 08:53:56 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@redhat.com>, hbabu@us.ibm.com, vgoyal@in.ibm.com,
       kexec@lists.infradead.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071127135356.GA31376@hmsreliant.think-freely.org>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <m1d4twmimu.fsf@ebiederm.dsl.xmission.com> <20071127131355.GA14887@hmsendeavour.rdu.redhat.com> <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 06:28:13AM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@redhat.com> writes:
> 
> > What makes you say this?  I don't see any need for interrupts prior to
> > calibrate_delay()
> 
> Yes.  calibrate_delay() is the first place we send interrupts over
> hypertransport.  However I/O still works.  Thus hypertransport from
> the first cpu is working, and hypertransport itself is working.
> 
> This is an interrupt specific problem not some generic hypertransport
> problem.
> 
Is it possible that the hypertansport bus can be in a state where I/O would
work, but not interrupt routing?  I confess my knoweldge of this system bus is
lacking.

> >> I agree that there is a problem.
> >> 
> >> The reliable fix is to totally skip the PIC interrupt mode and go directly
> >> to apic mode.
> >> 
> >> To make the code kexec on panic code path reliable we need to remove code
> >> not add it.
> >> 
> >> Frankly I think switching cpus is one of the least reliable things that
> >> we can do in general.
> >> 
> > I understand the sentiment here, but its not like we're adding additional
> > functionality with this patch.  We're already sending an IPI to all the
> > processors to halt them
> 
> And we don't care if they halt.  If they don't get the IPI we timeout.
> Making the IPI mandatory is a _singificant_ change.
> 
But how likely is a kdump kernel to work properly if an errant cpu is running
unhalted while we try to boot?   I understand your point regarding the
significance of the need for reliable IPI's, but in fairness, I think that we
rely on IPI delivery here, weather we want to or not. 

> The only reason that code is on the kexec on panic code path is that
> there is no other possible place we could put it.
> 
> > , we're just adding logic here so that we can detect the
> > boot cpu and use it to jump to the kexec image instead of halting.  I don't
> > think this is any less reliable that what we have currently.
> 
> It doesn't make things more reliable, and it adds code to a code path
> that already has to much code to be solid reliable (thus your
> problem). 
> 
> Putting the system back in PIC legacy mode on the kexec on panic path
> was supposed to be a short term hack until we could remove the need
> by always deliver interrupts in apic mode.
> 
> If you can't root cause your problem and figure out how the apics
> are misconfigured for legacy mode let's remove the need for going into
> to legacy PIC mode and do what we should be able to do reliably.  The
> reward is much higher, as we kill all possibility of restoring PIC
> mode wrong because we don't need to bother.
> 
I understand your suggestion, but to do that don't we need to do more than just
not move the apic to legacy pic mode?  It was my understanding that the ioapic
delivered timer interrupts to one cpu, who's interrupt handler then distributed
it to the other cpu's via IPI.  That suggests to me that we will need to
re-write the apic config so that the crashing processor is the target of the
ioapic interrupt delivery.

And if this is truly the case, I would really like to furhter understand why
this isn't working on this specific system before I implment anything.  Any
suggestions for how to further root cause this problem?

Regards
Neil

> Eric
