Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYIDS2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYIDS2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYIDS1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:27:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732AbYIDS1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:27:51 -0400
Date: Thu, 4 Sep 2008 11:26:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <20080904190728.59634020@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Alan Cox wrote:
>
> > (And yes, I do the latching - it's not reqlly required since I only depend 
> > on the MSB, and it actually makes for slightly lower precision, but it's 
> > the "safe" thing. And I figured out that the reason I thought that the 
> 
> Good job you don't. Various Cyrix/Geode chipsets have as errata #2
> 
> "Counter latch command is non-operational in the 8254 timer"

Yeah, I had some memory of latch issues. I wrote the thing originally 
without the latching, which is why the whole thing is designed to igore 
the low cycle count. I just decided that doing the latching shouldn't 
hurt that much, even if it ends up being just a 1us no-op.

It does mean that on any normal hardware, the expected error is roughly 
3us over 2048 PIT ticks, which if I do the math right (nominal PIT 
frequency: 1193182 Hz) is just under 0.2%. Or put another way, ~1750 ppm.

Not doing the latching should make the expected error go down to 2us.

Of course, the 2048 PIT ticks is just a random choice. It could be any 
multiple of 256 ticks, so that error can be made smaller. Maybe it's worth 
spending 10ms on this, and get it down by a factor of five (at which point 
the error on the PIT frequency is probably in the same order of 
magnitude).

			Linus
