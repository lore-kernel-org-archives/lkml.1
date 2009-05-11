Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZEKRbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZEKRbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZEKRbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:31:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:34546 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZEKRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:31:06 -0400
Message-ID: <4A0860D7.6010708@codemonkey.ws>
Date: Mon, 11 May 2009 12:31:03 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws> <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws> <4A0824C2.4000109@gmail.com>
In-Reply-To: <4A0824C2.4000109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> I specifically generalized my statement above because #1 I assume
> everyone here is smart enough to convert that nice round unit into the
> relevant figure.  And #2, there are multiple potential latency sources
> at play which we need to factor in when looking at the big picture.  For
> instance, the difference between PF exit, and an IO exit (2.58us on x86,
> to be precise).  Or whether you need to take a heavy-weight exit.  Or a
> context switch to qemu, the the kernel, back to qemu, and back to the
> vcpu).  Or acquire a mutex.  Or get head-of-lined on the VGA models IO. 
> I know you wish that this whole discussion would just go away, but these
> little "300ns here, 1600ns there" really add up in aggregate despite
> your dismissive attitude towards them.  And it doesn't take much to
> affect the results in a measurable way.  As stated, each 1us costs ~4%. 
> My motivation is to reduce as many of these sources as possible.
>
> So, yes, the delta from PIO to HC is 350ns.  Yes, this is a ~1.4%
> improvement.  So what?  Its still an improvement.  If that improvement
> were for free, would you object?  And we all know that this change isn't
> "free" because we have to change some code (+128/-0, to be exact).  But
> what is it specifically you are objecting to in the first place?  Adding
> hypercall support as an pv_ops primitive isn't exactly hard or complex,
> or even very much code.
>   

Where does 25us come from?  The number you post below are 33us and 
66us.  This is part of what's frustrating me in this thread.  Things are 
way too theoretical.  Saying that "if packet latency was 25us, then it 
would be a 1.4% improvement" is close to misleading.  The numbers you've 
posted are also measuring on-box speeds.  What really matters are 
off-box latencies and that's just going to exaggerate.

IIUC, if you switched vbus to using PIO today, you would go from 66us to 
to 65.65, which you'd round to 66us for on-box latencies.  Even if you 
didn't round, it's a 0.5% improvement in latency.

Adding hypercall support as a pv_ops primitive is adding a fair bit of 
complexity.  You need a hypercall fd mechanism to plumb this down to 
userspace otherwise, you can't support migration from in-kernel backend 
to non in-kernel backend.  You need some way to allocate hypercalls to 
particular devices which so far, has been completely ignored.  I've 
already mentioned why hypercalls are also unfortunate from a guest 
perspective.  They require kernel patching and this is almost certainly 
going to break at least Vista as a guest.  Certainly Windows 7.

So it's not at all fair to trivialize the complexity introduce here.  
I'm simply asking for justification to introduce this complexity.  I 
don't see why this is unfair for me to ask.

>> As a more general observation, we need numbers to justify an
>> optimization, not to justify not including an optimization.
>>
>> In other words, the burden is on you to present a scenario where this
>> optimization would result in a measurable improvement in a real world
>> work load.
>>     
>
> I have already done this.  You seem to have chosen to ignore my
> statements and results, but if you insist on rehashing:
>
> I started this project by analyzing system traces and finding some of
> the various bottlenecks in comparison to a native host.  Throughput was
> already pretty decent, but latency was pretty bad (and recently got
> *really* bad, but I know you already have a handle on whats causing
> that).  I digress...one of the conclusions of the research was that  I
> wanted to focus on building an IO subsystem designed to minimize the
> quantity of exits, minimize the cost of each exit, and shorten the
> end-to-end signaling path to achieve optimal performance.  I also wanted
> to build a system that was extensible enough to work with a variety of
> client types, on a variety of architectures, etc, so we would only need
> to solve these problems "once".  The end result was vbus, and the first
> working example was venet.  The measured performance data of this work
> was as follows:
>
> 802.x network, 9000 byte MTU,  2 8-core x86_64s connected back to back
> with Chelsio T3 10GE via crossover.
>
> Bare metal            : tput = 9717Mb/s, round-trip = 30396pps (33us rtt)
> Virtio-net (PCI)    : tput = 4578Mb/s, round-trip = 249pps (4016us rtt)
> Venet      (VBUS): tput = 5802Mb/s, round-trip = 15127 (66us rtt)
>
> For more details:  http://lkml.org/lkml/2009/4/21/408
>   

Sending out a massive infrastructure change that does things wildly 
differently from how they're done today without any indication of why 
those changes were necessary is disruptive.

If you could characterize all of the changes that vbus makes that are 
different from virtio, demonstrating at each stage why the change 
mattered and what benefit it brought, then we'd be having a completely 
different discussion.  I have no problem throwing away virtio today if 
there's something else better.

That's not what you've done though.  You wrote a bunch of code without 
understanding why virtio does things the way it does and then dropped it 
all on the list.  This isn't necessarily a bad exercise, but there's a 
ton of work necessary to determine which things vbus does differently 
actually matter.  I'm not saying that you shouldn't have done vbus, but 
I'm saying there's a bunch of analysis work that you haven't done that 
needs to be done before we start making any changes in upstream code.

I've been trying to argue why I don't think hypercalls are an important 
part of vbus from a performance perspective.   I've tried to demonstrate 
why I don't think this is an important part of vbus.  The frustration I 
have with this series is that you seem unwilling to compromise any 
aspect of vbus design.  I understand you've made your decisions  in vbus 
for some reasons and you think the way you've done things is better, but 
that's not enough.  We have virtio today, it provides greater 
functionality than vbus does, it supports multiple guest types, and it's 
gotten quite a lot of testing.  It has its warts, but most things that 
have been around for some time do.

> Now I know you have been quick in the past to dismiss my efforts, and to
> claim you can get the same results without needing the various tricks
> and optimizations I uncovered.  But quite frankly, until you post some
> patches for community review and comparison (as I have done), it's just
> meaningless talk.

I can just as easily say that until you post a full series that covers 
all of the functionality that virtio has today, vbus is just meaningless 
talk.  But I'm trying not to be dismissive in all of this because I do 
want to see you contribute to the KVM paravirtual IO infrastructure.  
Clearly, you have useful ideas.

We can't just go rewriting things without a clear understanding of why 
something's better.  What's missing is a detailed analysis of what 
virtio-net does today and what vbus does so that it's possible to draw 
some conclusions.

For instance, this could look like:

For a single packet delivery:

150ns are spent from PIO operation
320ns are spent in heavy-weight exit handler
150ns are spent transitioning to userspace
5us are spent contending on qemu_mutex
30us are spent copying data in tun/tap driver
40us are spent waiting for RX
...

For vbus, it would look like:

130ns are spent from HC instruction
100ns are spent signaling TX thread
...

But single packet delivery is just one part of the puzzle.  Bulk 
transfers are also important.  CPU consumption is important.  How we 
address things like live migration, non-privileged user initialization, 
and userspace plumbing are all also important.

Right now, the whole discussion around this series is wildly speculative 
and quite frankly, counter productive.  A few RTT benchmarks are not 
sufficient to make any kind of forward progress here.  I certainly like 
rewriting things as much as anyone else, but you need a substantial 
amount of justification for it that so far hasn't been presented.

Do you understand what my concerns are and why I don't want to just 
switch to a new large infrastructure?

Do you feel like you understand what sort of data I'm looking for to 
justify the changes vbus is proposing to make?  Is this something your 
willing to do because IMHO this is a prerequisite for any sort of merge 
consideration.  The analysis of the virtio-net side of things is just as 
important as the vbus side of things.

I've tried to explain this to you a number of times now and so far it 
doesn't seem like I've been successful.  If it isn't clear, please let 
me know.

Regards,

Anthony Liguori
