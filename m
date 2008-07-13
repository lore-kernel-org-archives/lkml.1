Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYGMUvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYGMUvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYGMUvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:51:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48961 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbYGMUvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:51:31 -0400
Message-ID: <487A6AD0.5000506@firstfloor.org>
Date: Sun, 13 Jul 2008 22:51:28 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com> <20080710071640.5035cd70@infradead.org> <874p6t25n5.fsf@basil.nowhere.org> <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com> <487A4DFC.5090701@firstfloor.org> <20080713203250.GA6925@elte.hu>
In-Reply-To: <20080713203250.GA6925@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> with this patch, my 256g system still use gbpages for 1g-3g, 4g-256g
>> 256GB certainly qualifies as "large system". But as Linus always says: 
>> Linux is not for servers only. Ignoring the small systems makes you 
>> look bad.
> 
> Yinghai is hard at work fixing long-time crappiness of the x86 memory 
> setup code on 32-bit and 64-bit x86 alike. Contrary to your suggestion 
> he has not been "ignoring small systems" in any way - he has done the 
> exact opposite: Yinghai has fixed a ton of small-system bugs and 
> usability annoyances along the way.

I haven't read them all so I have no real opinion on those.

As a general comment I must admit I am a little uneasy with extensive
changes in early boot up because this code is hard to test completely
and fragile (that is why I was always conservative in this area).

But we'll see how it fares and it's your decision anyways
(but of course people will also blame you, not me, if it goes wrong ;-)

> Your attempt trying to cast this much-needed cleanup, fixing and 
> robustization effort into a negative light is as pityful as it is wrong.

First I was only commenting on one specific patch, nothing more.

My point is full rounding to 4K on all corners is wasteful because the
CPUs have to handle that case anyways and every split costs precious
TLB entries in direct mapping accesses.

And on small systems this hurts more because a much larger fraction
of their mapped memory will be affected by this. Yes on a large system like his
256GB box it's more a rounding error (although one that can also cause
weird performance hickups there when suddenly some kernel internal
operation that happens to hit the wrong memory takes much longer).

And I might be old fashioned, but I still think minimizing TLB misses
in the kernel is still quite important since the TLBs of modern x86
CPUs are still comparatively small.

btw that is why I was  also quite disappointed that the new cpa eliminated
reassembly. It means that on a long uptime system even with moderate
traffic of CPA page allocation/free eventually the completely direct mapping
will be all 4K. And there will be TLB miss galore on each system call
when user space is TLB intensive.

Ok in that light Yinghai's patch is perhaps not so bad after longer
uptime in that scenario. Still performance directly after boot up is
also something that shouldn't be ignored and I'm still hopefully that
reassembly will be readded at some point anyways.

-Andi

