Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZEEQs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZEEQs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbZEEQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:48:12 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:7780 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753821AbZEEQsK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:48:10 -0400
X-BigFish: VPS-5(zz1432R98dR1805M1442J936fJzz1202hzz3198u327alz32i6bh15fn61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ6JZV-01-6MS-01
Date: Tue, 5 May 2009 18:47:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090505164733.GA2868@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com> <87vdogbp4g.fsf@basil.nowhere.org> <20090505092238.GB29045@alberich.amd.com> <20090505093520.GL23223@one.firstfloor.org> <20090505104848.GC29045@alberich.amd.com> <20090505144027.GD29045@alberich.amd.com> <20090505153159.GN23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090505153159.GN23223@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 May 2009 16:47:56.0094 (UTC) FILETIME=[3D6FDDE0:01C9CDA1]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 05:31:59PM +0200, Andi Kleen wrote:
> On Tue, May 05, 2009 at 04:40:27PM +0200, Andreas Herrmann wrote:
> 
> I think the general problem with your patchset is that it seems
> more like a solution in search of a problem, instead of the proper other
> way around.

   <snip>

> > > First I must say it's unclear to me if CPU topology is really generally
> > > useful to export to the user.
> > 
> > I think it is useful.
> 
> You forgot to state for what?

You are kidding, aren't you? Isn't this obvious?
Why shouldn't a user be interested in stuff like core_siblings and
thread_siblings? Maybe a user want to make scheduling decisions based
on that and pin tasks accordingly?

  <snip>

> > (a) Are you saying that users have to check NUMA distances when they
> >     want to pin tasks on certain CPUs?
> 
> CPU == core ? No you just bind to that CPU. Was that a trick question?

Of course that was no trick question -- at most a stupid typo. (Sometimes
in Linux CPU == core.) So, no, sorry I meant "certain cores".
(And I meant not pinning to one core but to a set of cores).

  <snip>

> >     representing entire CPU topology in sysfs makes this obvious.
> 
> You didn't do that.

I partially did that and mentioned what else might be needed, see

http://marc.info/?l=linux-kernel&m=124145920830040

  <snip>

> > Yes, it's a new "special case" which can't be expressed in other ways.
> 
> You seem to assume that it's obviously useful to express. Perhaps
> I'm dumb, but can you explain for what?
> 
> > SLIT and SRAT are not sufficient.
> > 
> > The kernel 
> 
> Which part of the kernel?

I provided this info in my first reply to you. Here it is again:

  "The kernel needs to know this when accessing processor
   configuration space, when accessing shared MSRs or for counting
   northbridge specific events."

To translate this for you. Potential users are
- EDAC ;-)
- other MCA related stuff (e.g. L3 cache index disable)
- performance monitoring
- most probably everything that accesses processor configuration
  space and shared MSRs

I think it is best to store this information centrally instead of
letting each component figuring out which cores are on the
same node.

   <snip>

> The general problem is that you're trying to stretch an old ad-hoc
> hack (siblings etc. in /proc/cpuinfo) to a complicated new graph structure
> and the interface is just not up to that.

You didn't read all my mails regarding this topic.
The patches fixup sibling information for Magny-Cours. This info is
not only exposed to /proc/cpuinfo but also with cpu-topology
information in sysfs. I don't see why
/sys/devices/system/cpu/cpuX/topology is an old ad-hoc hack.

> As a exercise you can try to write a user space program that uses
> these fields to query the topology. It will be a mess.

You shouldn't try to use /proc/cpuinfo for that but instead look up
topology in /sys/devices/system/cpu/cpuX/topology. BTW, I have already
such a script and I am using it.

> We went through the same with the caches. Initially /proc/cpuinfo
> tried to express the caches. At some point it just became too messy
> and cpuinfo now only gives a very simplified "legacy" field and
> the real information is in /sys. It went into /sys because there 
> was a clear use case. If there's a clear use case for exposing
> complex CPU topology (so far that's still an open question
> due to lack of good examples) then also a new proper non hacky
> interface in /sys would make sense.

CPU topology is already in /sys.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


