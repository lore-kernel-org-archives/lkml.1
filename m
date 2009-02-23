Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZBWAoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZBWAoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZBWAoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:44:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:44596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbZBWAoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:44:04 -0500
Message-ID: <49A1F132.8080004@kernel.org>
Date: Mon, 23 Feb 2009 09:43:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu> <499FA8D1.8030806@kernel.org> <499FAE55.8070801@kernel.org> <20090222193817.GC21320@elte.hu>
In-Reply-To: <20090222193817.GC21320@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Feb 2009 00:43:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> Heck no. It is absolutely crazy to complicate __pa()/__va() in 
> _any_ way just to 'save' one more 2MB dTLB.

Are __pa()/__va() that hot paths?  Or am I over-estimating the cost of
2MB dTLB?

> We'll use that TLB because that is what TLBs are for: to handle 
> mapped pages. Yes, in the percpu scheme we are working on we'll 
> have a 'dual' mapping for the static percpu area (on 64-bit) but 
> mapping aliases have been one of the most basic CPU features for 
> the past 15 years ...
> 
> Even a single NOP in the __pa()/__va() path is _more_ expensive 
> than that TLB, believe me.

Alright, I'll believe you.  That actually works very nice for me.  :-)

> Look at last year's cheap quad CPU:
> 
>  Data TLB: 4MB pages, 4-way associative, 32 entries
> 
> That's 32x2MB = 64MB of data reach. Our access patterns in the 
> kernel tend to be pretty focused as well, so 32 is more than 
> enough in practice.
> 
> Especially if the pte is cached a TLB fill is very cheap on 
> Intel CPUs. So even if we were trashing those 32 entries (which 
> we are generally not), having a dTLB for the percpu area is a 
> TLB entry well spent.
> 
> So lets just do the most simple and most straightforward mapping 
> approach which i suggested: it takes advantage of everything, is 
> very close to the best possible performance in the cached case - 
> and dont worry about hardware resources.

Alright, for NUMA, I'll just remap a large page.  For UMA, I already
wrote code to embed it existing large page nicely, so I'll keep it
that way.  The added code is only about 40 lines which is localized in
setup_percpu.c and all __init.  The NUMA remap also shouldn't take too
much code if the __pa/__va() trick isn't necessary.  I'll post the
patches soon.

> The moment you start worrying about hardware resources on that 
> level and start 'optimizing' it in software, you've already lost 
> it. It leads down to the path of soft-TLB handlers and other 
> sillyness. There's no way you can win such a race against 
> hardware fundamentals - at least at today's speed of advance in 
> the hw space.

Well, I was hoping for not introducing any performance regression
while converting to new allocator.  Performance penalty due to TLB
pressure is especially difficult to measure, so avoiding any addition
there makes accepting the new allocator much easier but I gotta admit
that I'm not an expert at x86 micro performance tuning.  If you think
the overhead is acceptable, I'm a happy camper.

Thanks.

-- 
tejun
