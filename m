Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbYD2PiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbYD2PiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYD2Phw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:37:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbYD2Phw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:37:52 -0400
Message-ID: <4817405D.2020400@zytor.com>
Date: Tue, 29 Apr 2008 08:35:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429014623.GA6284@Krystal> <481682D6.5010207@zytor.com> <20080429121839.GA29912@Krystal>
In-Reply-To: <20080429121839.GA29912@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> I would also like to point out that maintaining a _separated_ piece of
> code for each instrumentation site which would heavily depend on the
> inner kernel data structures seems like a maintenance nightmare.

Obviously doing this by hand is insane.  That was not my thought.

> I would be happy with a solution that doesn't depend on this gigantic
> DWARF information and can be included in the kernel build process. See,
> I think tracing is, primarily, a facility that the kernel should provide
> to users so they can tune and find problems in their own applications.
> From this POV, it would make sense to consider tracing as part of the
> kernel code itself, not as a separated, kernel debugging oriented piece
> of code. If you require per-site dynamic pieces of code, you are only
> adding to the complexity of such a tracer. Actually, an active tracer
> would trash the i-cache quite heavily due to these per-site pieces of
> code. Given that users want a tracer that disturbs as little as
> possible the normal system behavior, I don't think this "per-site"
> pieces of code approach is that good.

That's funny, given that's exactly what you have now.

DWARF information is the way you get this stuff out of the compiler. 
That is what it's *there for*.  If you don't want to keep it around you 
can distill out the information you need and then remove it.  However, 
as I have said about six times now:

THE RIGHT WAY TO DO THIS IS WITH COMPILER SUPPORT.

All these problems is because you're trying to do something behind the 
back of the compiler, but not *completely* so.

> Instruction cache bloat inspection :
> If a code region is placed with cache cold instructions (unlikely
> branches), it should not increase the cache impact, since although we
> might use one more cache line, it won't be often loaded in cache because
> all the code that shares this cache line is unlikely.

This is somewhat nice in theory; I've found that gcc tends to interlace 
them pretty heavily and so the cache interference even of gcc "out of 
line" code is sizable.  Furthermore, modern CPUs often speculatively 
fetch *both* branches of a conditional.

This is actually the biggest motivation for patching static branches.

> I therefore think that looking only at code size is misleading when
> considering the cache impact of markers, since they have been designed
> to put the bytes as far away as possible from cache-hot memory.

Nice theory.  Doesn't work in practice as long as you rely on gcc unlikey().

	-hpa
