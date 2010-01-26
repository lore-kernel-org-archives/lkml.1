Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641Ab0AZQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0AZQJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614Ab0AZQJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:09:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35891 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab0AZQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:09:16 -0500
Date: Tue, 26 Jan 2010 17:09:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
	mce_cpu_specific_poll
Message-ID: <20100126160913.GD6567@basil.fritz.box>
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <20100124100815.GA2895@liondog.tnic> <20100125131915.GA7801@basil.fritz.box> <20100126063343.GA18865@liondog.tnic> <4B5EB092.80901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5EB092.80901@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 06:06:26PM +0900, Hidetoshi Seto wrote:
> How about having a system file which can be maintained with kernel,
> e.g. like /proc/hwinfo, /sys/devices/platform/hwinfo, or directory
> with some files like /somewhere/hwinfo/{dmi,acpi,pci,...} etc.?

Why not do that in user space?

In fact it's often already done.

Just because we're kernel programmers doesn't mean that everything
needs to be solved inside the kernel.

> >> And since it's kernel
> >> based it cannot do most of the interesting reactions. And it doesn't
> >> have a usable interface to add user events.
> >>
> >> And yes having all that crap in syslog is completely useless, unless
> >> you're debugging code.
> > 
> > So basically, IMHO we need:
> > 
> > 1. Resilient error reporting that reliably pushes decoded error info to
> > userspace and/or network. That one might be tricky to do but we'll get
> > there.
> 
> I think it would be better to think "error" is a subset of "event",
> which could be reported if interested but otherwise be filtered.
> Use of TRACE_EVENT() for mce event aim such approach at least.

The whole trace event infrastructure right now is not really
aimed/useful for "always on low overhead background monitoring" like 
standard error handling requires.

In principle it could be probably fixed (although I'm a bit 
sceptical on the "low overhead" part), but I suspect the result
would be neither optimized for error handling nor optimized
for performance monitoring anymore. They simply have
very different requirements.

When you do full event tracing anyways it makes some sense to get events
for errors too, but that's a quite different use-case.

For the "standard" error handling I think we're better of with
something optimized for the job.

> > 2. Error severity grading and acting upon each type accordingly. This
> > might need to be vendor-specific.
> 
> I think you mean severity grading in kernel.
> Even if hardware reported an error and graded it as corrected, kernel
> can escalate the severity, likely based on some threshold.

I don't think the kernel should do that, it's so much a policy
decision and these are best kept as near the administrator
as possible (= user space)

That is for some cases it might make sense to have limited thresholds
in the kernel, but I suspect they are limited. Mostly it would
be the case when the hardware itselfs already keeps these counters.

> 
> > 3. Proper error format suiting all types of errors.
> 
> As mentioned in Andi's PDF, CPER format is one of good candidate
> available today, I think.

Yes for hardware errors. It's definitely not perfect and somewhat
overdesigned, but I'm not sure we could come up with a much better one.
At least a subset of it with some extensions might do. Also in some
cases the error is already in this format.

The advantage of it is that it's at least well understood and documented.

> > 4. Vendor-specific hooks where it is needed for in-kernel handling of
> > certain errors (L3 cache index disable, for example).
> 
> Some difficulty would be there to add such hook in the UE handling path,
> but anyway we can have it for the CE path.  Just need to be organized.
> 
> > 5. Error thresholding, representation, etc all done in userspace (maybe
> > even on a different machine).
> 
> (...BTW, how about putting mcelog tree under the /tools, Andi?)

I don't see the advantage. Linux has always been a collection
of packages, not a unified single big tree.  Also my current
impression is that the in tree user space builds don't work
very well.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
