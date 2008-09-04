Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYIDRx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYIDRx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbYIDRxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:53:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbYIDRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:53:46 -0400
Date: Thu, 4 Sep 2008 10:53:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alok Kataria <akataria@vmware.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <1220549961.11753.22.camel@alok-dev1>
Message-ID: <alpine.LFD.1.10.0809041044160.3400@nehalem.linux-foundation.org>
References: <20080904150339.896115280@linutronix.de>  <20080904153620.GC7120@elte.hu>  <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <1220549961.11753.22.camel@alok-dev1>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Alok Kataria wrote:
> 
> Looping for a smaller timeout is really going to strain things for
> Virtualization.

Can you check the patch I just sent out?

It loops for a _very_ short timeout, but on the other hand it should also 
absolutely immediately notice that it's getting the wrong expected values 
under virtualization, and the fast case will then fail early. 

It then falls back on the slow case, but I don't think you can avoid that 
under virtualization.

> Even on native hardware if you reduce the  timeout to less than 10ms it
> may result in errors in the range of 2500ppm on a 2GHz systems when
> calibrating against pmtimer/hpet, this is far worse than what NTP can
> correct, afaik NTP can handle errors only upto 500ppm. And IMHO that is
> the reason why we had a timeout of 50ms before (since it limits the
> maximum theoretical error to 500ppm)

I would not mind at all having the more precise thing happen _later_, 
especially if we can do it incrementally.

One of the problems with the TSC calibration is that we need it fairly 
early (for things like usleep()), and it needs to be in the right 
ballpark. It definitely does not need to be in the parts-per-million 
range, it needs to be in the "within a few percent" range.

(To make matters worse, the TSC isn't then even used in practice for 
real-time clocks, because of variable frequency and/or halting in idle 
states. So the actual real-time clock will actually be based on HPET or 
PM_TIMER anyway most of the time).

		Linus
