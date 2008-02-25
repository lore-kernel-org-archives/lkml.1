Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbYBYRv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbYBYRv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYBYRvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:51:19 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:29828 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752613AbYBYRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:51:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=fk4SAi4wW/pJ4JeVI7ljuDTpr5aU9Z2+TJ2/28rnoMdbX70nGWxhE8bqMhYsy0XeLBOh1Q82BLVQSpcrohgbisIns0JT6G6N/Txmew2hYw0OJLB85WNfU4J8YDJlkNCxa8ycxxWG3mo5/odQq1UT+biosqNJajb83iFPElyUIzY=  ;
X-YMail-OSG: lCU14RAVM1nw7gyjn_tSQVFrLWpMbqWXn4CvQZ_ridAhHyN9l_p8FV1wy74WVH4k.bXwN6xbFA--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Feb 2008 09:51:16 -0800
From: David Brownell <david-b@pacbell.net>
To: hskinnemoen@atmel.com
Subject: Re: [patch 2.6.25-rc2-git 2/2] atmel_tc clocksource/clockevent code
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200802221728.37910.david-b@pacbell.net>
 <20080224192122.46a49216@siona>
 <20080224234251.18B519B7DF@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20080225123146.61b68a51@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080225123146.61b68a51@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080225175116.A2C071E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +static cycle_t tc_get_cycles(void)
> > > > +{
> > > > +	unsigned long	flags;
> > > > +	u32		lower, upper;
> > > > +
> > > > +	raw_local_irq_save(flags);
> > >
> > > Why do you need to use the raw version?
> > 
> > This is part of the system timer code, and it should never be a
> > preemption point.  Plus I didn't want to waste any instruction
> > cycles in code that runs before e.g. the DBGU IRQ handler would
> > get called... observably, such extra cycles *do* hurt.
>
> I don't understand what you mean by preemption point, but I guess the
> non-raw version may consume some extra cycles when lockdep is enabled.

A preemption point is where CONFIG_PREEMPT kicks in task switching
logic; lockdep is different.


> If we really expect using TC as a clocksource but not as a clockevent
> is going to be a common usage, perhaps we should move the decision into
> Kconfig?

Maybe, but I already spent lots more time on this than I wanted.  :(

Another way to address that rm9200 issue would be to just rate
the TC clockevent source lower than the one based on the system
timer, so it's set up but never enabled ... and remember "t2_clk",
calling clk_enable() only when that clockevent device is active.

That would address one half of the suspend/resume equation too,
ensuring that clock is disabled during suspend...

The other half being:  how to clk_disable(t0_clk) during system
suspend?  (And t1_clk on some systems.)  There's currently no
clocksource.set_mode() call; evidently there's an assumption that
such counters cost no power, so they can always be left running.


> > > I don't think it is safe to assume that one clock per channel always
> > > means one irq per channel as well...
> > 
> > On current chips, that's how it works.
>
> Indeed. I just don't see any fundamental reason why it has to work that
> way, which is why I don't think we should depend on it.

AT91 chips share identifiers between clocks and interrupts; that's
fundamental, yes?

If some future chip works differently, that's a good time to change
things.  Otherwise I see little point in caring about such issues.

- Dave

