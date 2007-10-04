Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbXJDDkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbXJDDkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 23:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXJDDkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 23:40:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756460AbXJDDkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 23:40:14 -0400
Date: Wed, 3 Oct 2007 20:39:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Neil Romig <neil@romig.demon.co.uk>,
       linux-kernel@vger.kernel.org, hyoshiok@miraclelinux.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: File corruption when using kernels 2.6.18+
In-Reply-To: <47045725.1070900@shaw.ca>
Message-ID: <alpine.LFD.0.999.0710032008190.3579@woody.linux-foundation.org>
References: <fa.VCoGTwbB+qeNlkBJ24MiuXcGSRA@ifi.uio.no>
 <fa.R+FhT6IGmV/dDweUt/MdSeA5YbQ@ifi.uio.no> <fa.7MxTIt/ik0uRFN/lMWUasYV/JyE@ifi.uio.no>
 <fa.YJ4uCPzXT5TQElSosyz98cpuMSc@ifi.uio.no> <fa.Tp9UUX9EYprQyLg0shgH1YG9DDM@ifi.uio.no>
 <fa.PzpJEEoLXfC+eOQZjTWjdf9vdnE@ifi.uio.no> <47045725.1070900@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Robert Hancock wrote:
> 
> Erratum 97: 128-Bit Streaming Stores May Cause Coherency Failure

The Intel-optimized memcpy doesn't use the SSE registers, just regular 
32-bit integer nontemporal stores (movnti). The reason is that the SSE 
state save is too expensive to be worth it.

So it's not that. Also, considering that it was a single-bit error in all 
the cases I saw, I wouldn't expect it to be a cache coherency problem, 
which I'd expect to corrupt a whole cacheline or possibly at least a whole 
access.

That said, bit corruption can be just about anything. It's certainly not 
impossible that it's a CPU bug.

But my first guess would be slightly dodgy motherboard, possibly coupled 
with a chipset that simply isn't very tolerant to any timing errors. If 
the motherboard traces to the DDR aren't impedance-matched, or if the 
traces don't have the same length, or if the capacitors that are supposed 
to handle spikes in burst current aren't up to snuff, you'll just get 
noisy lines.

And at some point, noisy lines means that you go from reliable operation 
to "oh, that bit didn't make it correctly".

Lowering the front-side bus frequency or altering the memory timings can 
help (ie doing things like running DDR-333 at DDR-266). Making sure that 
your power supply isn't even close to its limits is good. And choosing a 
motherboard and chipsets from a reliable manufacturer is more than a good 
idea.

The reason why it's interesting that the errors seemed to happen in the 
same byte-lane is that I think it's common policy to route data lines on 
the same layer, and matching trace length per group is very important, 
because you do signal clocking per-group, afaik. But on the other hand, 
multiple layers on the board are expensive, so people try to minimize 
them, and maybe you end up routing through a via to another layer - which 
then makes timing and capacitance harder.

Or there aren't ground lines close enough, or the data lines are too close 
to other lines and you get cross-talk etc etc.

No, I've not done board design, and I don't know what I'm talking about, 
but look at the interesting zig-zagging the data (and address) lines often 
do on the board. It often looks totally crazy ("why doesn't that line just 
go straight?"), but the thing is that the groups all need to have the same 
length, but the pins are all at different points, so you can't make the 
lines straight, or some of them would be much shorter than others.

And if something is border-line, it may work all of the time - *until* you 
hit specific patterns that cause lots of lines to wiggle around, and then 
a capacitor won't handle the extra current draw from switching, or 
cross-talk between lines hits you, and what used to work doesn't work any 
more.

I wish we all had ECC memory. That gets rid of a lot of worries.

			Linus
