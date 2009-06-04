Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZFDPEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZFDPEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZFDPEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:04:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbZFDPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:04:00 -0400
Date: Thu, 4 Jun 2009 08:02:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <200906041554.37102.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Jun 2009, Rusty Russell wrote:
> >
> > Turn off HIGHMEM64G, please (and HIGHMEM4G too, for that matter - you
> > can't compare it to a no-highmem case).
> 
> Thanks, your point is demonstrated below.  I don't think HIGHMEM4G is 
> unreasonable for a distro tho, so I turned that on instead.

Well, I agree that HIGHMEM4G is a _reasonable_ thing to turn on.

The thing I disagree with is that it's at all valid to then compare to 
some all-software feature thing. HIGHMEM doesn't expand any esoteric 
capability that some people might use - it's about regular RAM for regular 
users.

And don't get me wrong - I don't like HIGHMEM. I detest the damn thing. I 
hated having to merge it, and I still hate it. It's a stupid, ugly, and 
very invasive config option. It's just that it's there to support a 
stupid, ugly and very annoying fundamental hardware problem.

So I think your minimum and maximum configs should at least _match_ in 
HIGHMEM. Limiting memory to not actually having any (with "mem=880M") will 
avoid the TLB flushing impact of HIGHMEM, which is clearly going to be the 
_bulk_ of the overhead, but HIGHMEM is still going to be noticeable on at 
least some microbenchmarks.

In other words, it's a lot like CONFIG_SMP, but at least CONFIG_SMP has a 
damn better reason for existing today than CONFIG_HIGHMEM.

That said, I suspect that now your context-switch test is likely no longer 
dominated by that thing, so looking at your numbers:

> minimal config: ~0.001280
> maximal config: ~0.002500	(with actual high mem)
> maximum config: ~0.001925     (with mem=880M)

and I think that change from 0.001280 - 0.001925 (rough averages by 
eye-balling it, I didn't actually calculate anything) is still quite 
interesting, but I do wonder how much of it ends up being due to just code 
generation issues for CONFIG_HIGHMEM and CONFIG_SMP.

> So we're paying a 48% overhead; microbenchmarks always suffer as code is added, 
> and we've added a lot of code with these options.

I do agree that microbenchmarks are interesting, and tend to show these 
kinds of things clearly. It's just that when you look at the scheduler, 
for example, something like SMP support is a _big_ issue, and even if we 
get rid of the worst synchronization overhead with "maxcpus=1" at least 
removing the "lock" prefixes, I'm not sure how relevant it is to say that 
the scheduler is slower with SMP support.

(The same way I don't think it's relevant or interesting to see that it's 
slower with HIGHMEM).

They are simply so fundamental features that the two aren't comparable. 
Why would anybody compare a UP scheduler with a SMP scheduler? It's simply 
not the same problem. What does it mean to say that one is 48% slower? 
That's like saying that a squirrell is 48% juicier than an orange - maybe 
it's true, but anybody who puts the two in a blender to compare them is 
kind of sick. The comparison is ugly and pointless.

Now, other feature comparisons are way more interesting. For example, if 
statistics gathering is a noticeable portion of the 48%, then that really 
is a very relevant comparison, since scheduler statistics is something 
that is in no way "fundamental" to the hardware base, and most people 
won't care.

So comparing a "scheduler statistics" overhead vs "minimal config" 
overhead is very clearly a sane thing to do. Now we're talking about a 
feature that most people - even if it was somehow hardware related - 
wouldn't use or care about.

IOW, even if it were to use hardware features (say, something like 
oprofile, which is at least partly very much about exposing actual 
physical features of the hardware), if it's not fundamental to the whole 
usage for a huge percentage of people, then it's a "optional feature", and 
seeing slowdown is a big deal.

Something like CONFIG_HIGHMEM* or CONFIG_SMP is not really what I'd ever 
call "optional feature", although I hope to Dog that CONFIG_HIGHMEM can 
some day be considered that some day.

		Linus
