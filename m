Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbXEXSTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbXEXSTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbXEXSTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:19:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXEXSS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:18:59 -0400
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace -
	Was: [cannot change thermal trip points]
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20070524143644.GA27364@srcf.ucam.org>
References: <200705202350.45145.lenb@kernel.org>
	 <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org>
	 <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org>
	 <20070521134046.GE8332@elf.ucw.cz> <20070521134553.GA7911@srcf.ucam.org>
	 <20070521224200.GF10714@elf.ucw.cz> <20070522003153.GA18162@srcf.ucam.org>
	 <1180016213.16396.74.camel@queen.suse.de>
	 <20070524143644.GA27364@srcf.ucam.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 24 May 2007 20:18:58 +0200
Message-Id: <1180030738.16396.158.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 15:36 +0100, Matthew Garrett wrote:
> On Thu, May 24, 2007 at 04:16:53PM +0200, Thomas Renninger wrote:
> 
> > I doubt it is impossible, would you mind sharing your knowledge why you
> > think it is impossible or point to some related discussion, pls.
> 
> Because, as Len has pointed out, you end up with two different ideas 
> about what the trip points are - the kernel's and the hardware's. That 
> works fine until some event in the firmware either forcibly 
> resynchronises the two or makes assumptions about the spec-compliance of 
> the interpreter.

Not sure what exactly you'd like to do in userspace, maybe you can be a
bit more precise here:
  a) Doing whole thermal management in userspace, reading temp, writing
     fan and cpufreq_max_freq, shutting down machine,...
  b) Workaround not switching on fans by double checking fan/temperature
     by a userspace daemon and try to finally trigger the switch by 
     writing to /proc/acpi/fan/state (or corresponding /sys,..)

IMO we need a some kind of fan watchdog like Henrique described
recently, maybe this could be put in userspace not sure.
Currently the fan can runs out of sync easily if the fan state is
changed behind the OSs back.


> > Yes, trip points are overridden by BIOS on HPs and what is the problem?
> > The workaround won't work for them, but it still does on others
> > (mainly on ThinkPads which have passive tp at about 89 C and critical on
> > 91 C).
> 
> You don't know whether the workaround will work or not
Hmm, I don't get the point. If it works it's great, if not you have a
problem anyway and can at least test a workaround.
>  until you've 
> performed a full audit of the platform firmware, which is going to 
> potentially change between BIOS versions. It's entirely legal for the 
> firmware to behave in this way, and even beneficial under various 
> circumstances.
But that's exactly what all these workarounds are for. You pass them if
you have a buggy BIOS. You wait for new BIOSes and hope that you can get
rid of the workaround...

> > I could imagine an implementation for this, that e.g. critical...active9
> > get module parameters. BIOS updates for trip points get ignored as soon
> > as one is set and you can only decrease a value. Nothing bad can happen
> > and it will make some people happy (yes it's hacky, violates the specs
> > and so on..., but some more people have a working machine). Will this
> > (or similar) get accepted?
> 
> The interface would need to be more complicated than that if you wanted 
> to be able to implement hysteresis, and there's the potential for 
> hardware damage if paramaters are set inappropriately. Even then, 
> there's no easy way of programatically determining whether it would work 
> on any given hardware.

The fact that 3 people complained rather fast for a patch in rc1-mm1,
looks like this is a workaround that is needed. I personally advised two
guys to use it with their ThinkPad in the summer and they are happy with
it.

I'd also like to have this a bit extended: be able to just modify
passive trip point.
IMO this is a very powerful feature allowing people a fanless system as
long as they have a cpufreq capable processor.

The idea having this in userspace is interesting. But as said rather
complicated to implement. The hysteresis implementation for passive
cooling works fine in kernel and is field tested, it should get used.

The problem with the ACPI spec is that it's rather complicated. This is
IMO mainly for a BIOS developer point of view for what I can say.
Therefore it's rather seldom picked up by BIOS vendors.
However for the kernel it's easy (to fake, to do) and it's working fine,
so why not making use of it?

IMO we should even provide a passive trip point (initially unused) when
there is no one defined by BIOS.

I agree that it's hard to find the temperature to not let the fan kick
in automatically. But it's really easy then for everyone to:
  - get a fanless system
  - workaround critical shutdowns
and all this is safe in respect to HW damage.

IMO this is an area where we can easily behave better than M$ does.

Maybe my first mails were a bit offending, don't know, we should get
this back to an objective discussion.

I especially like to have some comments from Len, before doing any work
for nothing (or before giving up):
   - Would such a passive trip point override be acceptable in any way
     (be it in userspace, kernel space or in whatever form -> to be 
     discussed)
   - Would such a workaround as I described in my mail before be 
     acceptable
   - If done in userspace, how should it look like exactly

Thanks,

   Thomas

