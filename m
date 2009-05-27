Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZE0A0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZE0A0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZE0A0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:26:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42530 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbZE0A03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:26:29 -0400
Date: Wed, 27 May 2009 09:26:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090527002615.GA8845@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	john stultz <johnstul@us.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <20090526061532.GD9188@linux-sh.org> <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com> <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org> <1243380303.3275.40.camel@localhost> <20090526234425.GB6295@linux-sh.org> <1243383730.3275.53.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243383730.3275.53.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 05:22:10PM -0700, john stultz wrote:
> On Wed, 2009-05-27 at 08:44 +0900, Paul Mundt wrote:
> > What would you recommend instead? We do not want to spin here, and if we
> > are in the middle of changing clocksources and returning jiffies anyways,
> > then this same issue pops up in the current sched_clock() implementation
> > regardless of whether we are testing for lock contention or not.
> > Likewise, even if we were to spin, the same situation exists if the new
> > clocksource does not have the _SCHED_CLOCK bit set and we have to fall
> > back on jiffies anyways, doesn't it?
> > 
> > Put another way, and unless I'm missing something obvious, if we ignore
> > my changes to sched_clock(), how is your concern not applicable to case
> > where we are changing clocksources and using generic sched_clock() as it
> > is today?
> 
> Well, Thomas' point that locking isn't necessary, as sched_clock()
> doesn't have to be correct, is probably right. 
> 
> So, I think a get_sched_clocksource() interface would be ideal (if we
> want to get academic at a later date, the pointer could be atomically
> updated, and we'd keep it valid for some time via an rcu like method).
> 
> Additionally, you can set the jiffies clocksource as a _SCHED_CLOCK
> clocksource and drop the jiffies fallback code completely.
> 
I thought about that initially as well, but in the case of the jiffies
clocksource, that won't handle INITIAL_JIFFIES, which we want to subtract
to make printk times sane.
