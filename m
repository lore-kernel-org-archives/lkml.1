Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYIDVKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYIDVKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYIDVKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:10:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYIDVKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:10:42 -0400
Date: Thu, 4 Sep 2008 14:09:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <20080904205236.GA3864@elte.hu>
Message-ID: <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>
 <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Ingo Molnar wrote:
> 
> hm, unless i'm missing something i think here we still have a small 
> window for an SMI or some virtualization delay to slip in and cause 
> massive inaccuracy: if the delay happens _after_ the last 
> pit_expect_msb() and _before_ the external get_cycles() call. Right?

Yes. I had the extra pit_expect_msb() originally, but decided that 
basically a single-instruction race for somethign that ran without 
any MSI for 15ms was a bit pointless.

But adding another pit_expect_msb() is certainly not wrong. 

However, this one is:

> +	/*
> +	 * The iteration assumes that expect never goes below zero:
> +	 */
> +	BUILD_BUG_ON(QUICK_PIT_ITERATIONS >= 0xff);

No it doesn't. "expect" is unsigned char and will happily wrap, as will 
the PIT timer. The fact that it is in "single shot" mode doesn't actually 
mean that the timer stops, it just affects what happens when it goes down 
to zero. 

So that BUILD_BUG_ON() is misleading and incorrect.

Of course, it is true that in _practice_ you would never actually want to 
delay that long, but the code as written should be perfectly happy to 
iterate arbitrarily many times. Of course, the actual final TSC 
multiply/divide calculations would overflow at some point, but that's much 
further down the line.

			Linus
