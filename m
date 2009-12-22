Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZLVTtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZLVTtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZLVTtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:49:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZLVTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:49:45 -0500
Subject: Re: RFC: A proposal for power capping through forced idle in the
 Linux  Kernel
From: Peter Zijlstra <peterz@infradead.org>
To: tytso@mit.edu
Cc: Andi Kleen <andi@firstfloor.org>, Salman Qazi <sqazi@google.com>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>,
       lenb@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20091214235151.GG4867@thunk.org>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	 <876389xhuk.fsf@basil.nowhere.org>  <20091214235151.GG4867@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:48:15 +0100
Message-ID: <1261511295.4937.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 18:51 -0500, tytso@mit.edu wrote:
> On Tue, Dec 15, 2009 at 12:21:07AM +0100, Andi Kleen wrote:
> > Salman Qazi <sqazi@google.com> writes:
> > >
> > > We'd like to get as much of our stuff upstream as we can.  Given that
> > > this is a somewhat sizable chunk of work, it would be impolite of me
> > > to just send out a bunch of patches without hearing the concerns of
> > > the community.  What are your thoughts on our design and what do we
> > > need to change to get this to be more acceptable to the community?  I
> > > also would like to know if there are any existing pieces of
> > > infrastructure that this can utilize.
> > 
> > There were a lot of discussions on this a few months ago in context
> > of the ACPI 4 "power aggregator" which is a similar (perhaps
> > slightly less sophisticated) concept. 
> > 
> > While there was a lot of talk about teaching the scheduler about this 
> > the end result was just a driver which just starts real time threads
> > and then idles in them. This is in current mainline.
> > 
> > It might be a good idea to review these discussions in the archives.
> 
> It should be noted that most of the heat from those discussions was
> over adding the ACPI 4 mechanism to accept requests from the hardware
> platform to add idle cycles in the case of thermal/power emergencies,
> before we had the scheduler improvements to be able to do so in the
> most efficient way possible.  See the description of commit 8e0af5141:
> 
>    ACPI 4.0 created the logical "processor aggregator device" as a
>    mechinism for platforms to ask the OS to force otherwise busy
>    processors to enter (power saving) idle.
> 
>    The intent is to lower power consumption to ride-out transient
>    electrical and thermal emergencies, rather than powering off the
>    server....
> 
>    Vaidyanathan Srinivasan has proposed scheduler enhancements to
>    allow injecting idle time into the system. This driver doesn't
>    depend on those enhancements, but could cut over to them when they
>    are available.
> 
>    Peter Z. does not favor upstreaming this driver until the those
>    scheduler enhancements are in place. However, we favor upstreaming
>    this driver now because it is useful now, and can be enhanced over
>    time.
> 
> It looks to me that scheme that Salman has proposed for adding idle
> cycles is quite sophisticated, probably more than Vaidyanathan's, and
> the main difference is that Google wants the ability to be able to
> control the system's power/thermal envelope from userspace, as opposed
> to letting the hardware request in an emergency situation.  This makes
> sense, if you are trying to balance the power/thermal requirements
> across a large number of systems, as opposed to responding to a local
> power/thermal emergency signalled from the platform's firmware.
> 
> So it would seem to me that Salman's suggestions are very similar to
> what Peter requested before this commit went in (over his objections).

Right, so the power scheduling guys from IBM were working on something
sensible in this regard, which with a feedback control interface should
provide adequate controls to manage power consumption in a rack.

So their solution is to pack tasks into smaller sched domains allowing
up to an overload parameter, this nicely works together with things like
cpusets which can partition the load-balancing system.

[ If you configure your system into 1-cpu load-balance domains then
  this will of course fail, but then that's exactly what you asked for ]

Also, since it affects SCHED_OTHER tasks only, it does not affect
determinism of RT tasks.

So what this needs is a cluster controller increasing/decreasing the
overload numbers as the power consumption gets near/far from the limit.

The problem with the ACPI 4.0 spec is that it only signals a single 'do
something' or we'll kill you hard 'soon'. Which is kinda useless.



