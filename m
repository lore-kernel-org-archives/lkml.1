Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYEDOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYEDOym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYEDOye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:54:34 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:33731 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbYEDOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:54:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8EAKtqHUhMROPA/2dsb2JhbACBU6gg
Date: Sun, 4 May 2008 10:54:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080504145430.GA23137@Krystal>
References: <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429014623.GA6284@Krystal> <481682D6.5010207@zytor.com> <20080429121839.GA29912@Krystal> <4817405D.2020400@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4817405D.2020400@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:20:59 up 65 days, 10:31,  3 users,  load average: 0.21, 0.29,
	0.36
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> I would also like to point out that maintaining a _separated_ piece of
>> code for each instrumentation site which would heavily depend on the
>> inner kernel data structures seems like a maintenance nightmare.
>
> Obviously doing this by hand is insane.  That was not my thought.
>

Great :)

>> I would be happy with a solution that doesn't depend on this gigantic
>> DWARF information and can be included in the kernel build process. See,
>> I think tracing is, primarily, a facility that the kernel should provide
>> to users so they can tune and find problems in their own applications.
>> From this POV, it would make sense to consider tracing as part of the
>> kernel code itself, not as a separated, kernel debugging oriented piece
>> of code. If you require per-site dynamic pieces of code, you are only
>> adding to the complexity of such a tracer. Actually, an active tracer
>> would trash the i-cache quite heavily due to these per-site pieces of
>> code. Given that users want a tracer that disturbs as little as
>> possible the normal system behavior, I don't think this "per-site"
>> pieces of code approach is that good.
>
> That's funny, given that's exactly what you have now.
>

The per-site pieces of code are only there to do the stack setup. I
really wonder if we could do this more efficiently from DWARF info.

> DWARF information is the way you get this stuff out of the compiler. That 
> is what it's *there for*.  If you don't want to keep it around you can 
> distill out the information you need and then remove it.  However, as I 
> have said about six times now:

About DWARF : I agree with Ingo that we might not want to depend on this
kind of information normally expected to be correct for debug uses in a
part of infrastructure that is not limited to debugging situation.
Continous performance monitoring is one of the use cases I have in mind.

Moreover, depending on DWARF info requires us to do
architecture-specific code from the beginning. The markers are designed
in such a way that any given new architecture can use the "architecture
agnostic" version of the markers, and then later implement the
optimizations. With about 27 architectures supported by the Linux
kernel, I think this approach makes sense. Looking at the number of
years it took to port something as "simple" as kprobes to 8 out of 27
architectures speaks for itself.

>
> THE RIGHT WAY TO DO THIS IS WITH COMPILER SUPPORT.
>

We totally agree on this about the jump-patching optimization. If the
jump-patching approach I proposed is too far-fetched, and if reading a
variable from memory at each tracing site is too expensive, I would
propose to use the standard "immediate values" flavor until gcc gives us
that kind support for patchable jump instructions.

> All these problems is because you're trying to do something behind the back 
> of the compiler, but not *completely* so.
>

Using the compiler for the markers (I am not talking about immediate
values, which is an optimization) is what gives us the ability to do an
architecture-agnostic version. The 19 architectures which still lacks
kprobes support tell me that it isn't such a bad way to go.

>> Instruction cache bloat inspection :
>> If a code region is placed with cache cold instructions (unlikely
>> branches), it should not increase the cache impact, since although we
>> might use one more cache line, it won't be often loaded in cache because
>> all the code that shares this cache line is unlikely.
>
> This is somewhat nice in theory; I've found that gcc tends to interlace 
> them pretty heavily and so the cache interference even of gcc "out of line" 
> code is sizable.

Following your own suggestion, why don't we fix gcc and make it
interleave unlikely blocks less heavily with hot blocks ?

> Furthermore, modern CPUs often speculatively fetch *both* 
> branches of a conditional.
>
> This is actually the biggest motivation for patching static branches.
>

Agreed. I'd like to find some info about which microarchitectures you
have in mind. Intel Core 2 ?


>> I therefore think that looking only at code size is misleading when
>> considering the cache impact of markers, since they have been designed
>> to put the bytes as far away as possible from cache-hot memory.
>
> Nice theory.  Doesn't work in practice as long as you rely on gcc 
> unlikey().
>
> 	-hpa

Let's fix gcc ! ;)

Cheers,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
