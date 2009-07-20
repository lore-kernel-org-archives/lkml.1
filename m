Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZGTLQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZGTLQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZGTLQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:16:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:55124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZGTLQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:16:31 -0400
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20090718153011.1de3af8e@infradead.org>
References: <1247873945.8334.67.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
	 <1247954978.14494.19.camel@work-vm> <20090718153011.1de3af8e@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 13:17:02 +0200
Message-Id: <1248088622.15751.8465.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 15:30 -0700, Arjan van de Ven wrote:
> On Sat, 18 Jul 2009 15:09:38 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > After talking with some application writers who want very fast, but
> > not fine-grained timestamps, I decided to try to implement a new
> > clock_ids to clock_gettime(): CLOCK_REALTIME_COARSE and
> > CLOCK_MONOTONIC_COARSE which returns the time at the last tick. This
> > is very fast as we don't have to access any hardware (which can be
> > very painful if you're using something like the acpi_pm clocksource),
> > and we can even use the vdso clock_gettime() method to avoid the
> > syscall. The only trade off is you only get low-res tick grained time
> > resolution.
> 
> Does this tie us to having a tick? I still have hope that we can get
> rid of the tick even when apps are running .... since with CFS we don't
> really need the tick for the scheduler anymore for example....

On the hardware side to make this happen we'd need a platform that has:

  - cheap, high-res, cross-cpu synced, clocksource
  - cheap, high-res, clockevents

Maybe power64, sparc64 and s390x qualify, but certainly nothing on x86
does.

Furthermore, on the software side we'd need a few modifications, such as
doing lazy accounting for things like u/s-time which currently rely on
the tick and moving the load-balancing into a hrtimer.

Also, even with the above done, we'd probably want to tinker with the
clockevent/hrtimer code and possibly use a second per-cpu hardware timer
for the scheduler, since doing the whole hrtimer rb-tree dance for every
context switch is simply way too expensive.

But even with all that manged, there's still other bits that rely on the
tick -- RCU being one of the more interesting ones.
