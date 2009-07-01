Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZGAMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZGAMvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZGAMvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:51:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:49960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGAMve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:51:34 -0400
Message-ID: <4A4B5C32.1010009@kernel.org>
Date: Wed, 01 Jul 2009 21:53:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <4A4A9DC6.6020003@kernel.org> <20090701064250.GM6760@one.firstfloor.org> <4A4B38C5.1070504@kernel.org> <20090701122312.GP6760@one.firstfloor.org>
In-Reply-To: <20090701122312.GP6760@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 12:51:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andi.

Andi Kleen wrote:
> On Wed, Jul 01, 2009 at 07:21:57PM +0900, Tejun Heo wrote:
>>> using possible per cpu data I picked in current git: icmp.c
>> I was talking about percpu allocator proper.  Yeap, the major work
>> would be in auditing and converting for_each_possible_cpu() users.
> 
> and testing. that's the hard part. cpu hotplug is normally not well
> tested. Any code change that requires lots of new code for 
> it will be a problem because that code will then likely bitrot.

It would be nice to have something to test cpu on/offlining
automatically.  Something which keeps bringing cpus up and down as the
system goes through stress testing.

[--snip--]
>> too difficult.  I wouldn't know for sure before I actually try tho.
> 
> I think it's clear that you haven't tried yet :)

No I haven't yet.  I had a pretty good idea about how to implement it
in percpu allocator but haven't really looked at the users.  So, yeap,
it's quite possible that I'm under estimating the problem.  Oh well,
let's see.  Thanks for the warnings.

> I wrote quite a few per cpu callback handlers over the years and
> in my experience they are all nasty code with subtle races. The problem
> is that instead of having a single subset init function which
> is just single threaded and doesn't need to worry about races
> you now have multi threaded init, which tends to be a can of worms.

I tried a couple (didn't end up sending them out) and yeah they could
be quite painful.  Bringing up part usually isn't as painful as the
other way tho.

> I think a far saner strategy than rewriting every user of DEFINE_PER_CPU,
> ending up with lots of badly tested code is to:

But I don't think it would be that drastic.  Most users are quite
simple.

> - Fix the few large size percpu pigs that are problematic today to
> allocate in a callback.
> - Then once the per cpu data in all configurations is <200k (better
> <100 in the non debug builds) again just keep pre-allocating like we
> always did
> - Possibly adjust the vmalloc area on 32bit based on the possible
> CPU map at the cost of the direct mapping, to make sure there's
> always enough mapping space.

I think it's something we eventually need to do.  There already are
cases where lack of scalable and performant percpu allocation leads to
design restrictions and between many core cpus and virtualization the
requirements are becoming more varied.

Thanks.

-- 
tejun
