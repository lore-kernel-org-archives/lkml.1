Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYD2MSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYD2MSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYD2MSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:18:43 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:48880 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355AbYD2MSm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:18:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAEANauFkhMROPA/2dsb2JhbACBU6sL
Date: Tue, 29 Apr 2008 08:18:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080429121839.GA29912@Krystal>
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429014623.GA6284@Krystal> <481682D6.5010207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <481682D6.5010207@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:47:32 up 60 days,  7:58,  3 users,  load average: 0.25, 0.95,
	0.93
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Peter, do you have something like the following code in mind ?
>
> Basically, although I was suggesting using a per-site dynamic piece of 
> code.  Data items may not necessarily be in registers.
>
>> I think the main differences between the code snippet down here and the
>> markers is that markers rely on the compiler to generate the stack
>> setup, and have this code a little bit closer to the function than what
>> I propose here, where I put the stack setup code in a "farfaraway"
>> section.  Moreover, markers are much simpler than what I show here.
>> And actually, markers can be deployed portably, with
>> architecture-specific optimizations refined later. This has to be
>> implemented all up front for any traced architecture. In addition,
>> dealing with weird types like unsigned long long can become a pain.
>> Also, due to fact that we are asking the compiler to put keep some
>> variables live in registers, I would be tempted to embed this in a block
>> controlled by an if() statement (conditional branch, like I use for the
>> markers) so we don't have to pay the penality of populating the
>> registers when not required if there are not live at the marker site.
>
> We're requesting to keep them *alive*, but not necessarily in registers 
> (that would be an "r" constraint.)
>

Interesting. Actually, I use the "g" constraint in the code I showed
you, so it might be more acceptable to put in the fast path without
requiring registers to be populated. The only cases that would generate
additional code would probably be arguments like :

/* multiple pointer dereference */
trace_mark(evname, "argname", ptr->stuff[index]->...);

/*
 * having to do some work to prepare the variable (calling a macro or
 * inline function which does more than just a pointer deref.
 */
trace_mark(evname, "argname", get_real_valueof(variable));

/* constants */
trace_mark(evname, "argname", 10000);

Those cases won't add code to the critial path with my current markers,
but it would with the inline assembly "g" constraint approach. Looking
at the "mm" instrumentation, where page_to_pfn, swp_offset and
get_swap_info_struct are used makes me think it would not be such a rare
case.

I would also like to point out that maintaining a _separated_ piece of
code for each instrumentation site which would heavily depend on the
inner kernel data structures seems like a maintenance nightmare. This is
why I am trying to get the instrumented site to export the meaningful
data, self-described, in a standardized way. We can then simply hook on
all the instrumented sites to either perform some in-kernel analysis on
the data (ftrace) or to export that to a userspace trace analyzer
(LTTV analyzing LTTng traces).

I would be happy with a solution that doesn't depend on this gigantic
DWARF information and can be included in the kernel build process. See,
I think tracing is, primarily, a facility that the kernel should provide
to users so they can tune and find problems in their own applications.
>From this POV, it would make sense to consider tracing as part of the
kernel code itself, not as a separated, kernel debugging oriented piece
of code. If you require per-site dynamic pieces of code, you are only
adding to the complexity of such a tracer. Actually, an active tracer
would trash the i-cache quite heavily due to these per-site pieces of
code. Given that users want a tracer that disturbs as little as
possible the normal system behavior, I don't think this "per-site"
pieces of code approach is that good.

So, in terms of complexity added to the kernel, i-cache impact of an
active tracer and maintainability, I think the register constraining
assembly isn't such a good approach. And why would we do that ? The real
contention point here seems to be to remove a few bytes from an unlikely
block. I think I should paste my reply to Ingo about d-cache, i-cache
and TLB impact of such code :

<quote>
> > I have not seen any counter argument for the in-depth analysis of the 
> > instruction cache impact of the optimized markers I've done. Arguing 
> > that the markers are "bloated" based only on "size kernel/sched.o" 
> > output is a bit misleading.
>
> uhm, i'm not sure what you mean - how else would you quantify bloat than
> to look at the size of the affected subsystem?
>
>       Ingo

Data cache bloat inspection :
If you use the "size" output, it will take into account all the data
placed in special sections. At link time, these sections are put
together far from the actual cache hot kernel data.

Instruction cache bloat inspection :
If a code region is placed with cache cold instructions (unlikely
branches), it should not increase the cache impact, since although we
might use one more cache line, it won't be often loaded in cache because
all the code that shares this cache line is unlikely.

TLB entries bloat :
If code is added in unlikely branches, the instruction size increase
could increase the number of TLB entries required to keep cache hot
code. However, in our case, adding 10 (hot) + 50 (cold) bytes to the
scheduler code per optimized marker would require 68 markers to occupy a
whole 4kB TLB entry. Statistically, we could suppose that adding less
than 34 markers to the scheduler should not use any supplementary TLB
entry.  Adding 3 markers is therefore very unlikely to increase the TLB
impact. Given we have about 1024 TLB entries, adding 1/25th of a TLB
entry to the cache hot kernel instructions should not matter much,
especially since it might be absorbed by alignment.

And since the kernel core code is placed in "Huge TLB pages" on many
architectures nowadays, I really don't think the impact of a few bytes
out of 4MB is significant.

I therefore think that looking only at code size is misleading when
considering the cache impact of markers, since they have been designed
to put the bytes as far away as possible from cache-hot memory.
</quote>

Mathieu

> 	-hpa

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
