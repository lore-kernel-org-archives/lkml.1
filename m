Return-Path: <linux-kernel-owner+w=401wt.eu-S1751287AbZJTITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbZJTITT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 04:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZJTITS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 04:19:18 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:48728 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZJTITR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 04:19:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19165.29312.300540.500942@pilspetsen.it.uu.se>
Date: Tue, 20 Oct 2009 10:19:12 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code
	generic
In-Reply-To: <alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>
References: <1255819715-19763-1-git-send-email-linus.walleij@stericsson.com>
	<alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner writes:
 > > +static inline void clockevent_set_clock(struct clock_event_device *dev, u32 hz)
 > > +{
 > > +	u64 temp;
 > > +	u32 shift;
 > > +
 > > +	/* Find a shift value */
 > > +	for (shift = 32; shift > 0; shift--) {
 > > +		temp = (u64) hz << shift;
 > > +		do_div(temp, NSEC_PER_SEC);
 > > +		if ((temp >> 32) == 0)
 > > +			break;
 > > +	}
 > > +	dev->shift = shift;
 > > +	dev->mult = (u32) temp;
 > > +}
 > > +
 > > +
 > > +static inline void clocksource_set_clock(struct clocksource *cs, u32 hz)
 > > +{
 > > +	u64 temp;
 > > +	u32 shift;
 > > +
 > > +	/* Find a shift value */
 > > +	for (shift = 32; shift > 0; shift--) {
 > > +		temp = (u64) NSEC_PER_SEC << shift;
 > > +		do_div(temp, hz);
 > > +		if ((temp >> 32) == 0)
 > > +			break;
 > > +	}
 > > +	cs->shift = shift;
 > > +	cs->mult = (u32) temp;
 > > +}
 > > +
 > 
 > So that's the same function twice, right ?

They are similar but not identical:

 > > +		temp = (u64) hz << shift;
 > > +		do_div(temp, NSEC_PER_SEC);

vs

 > > +		temp = (u64) NSEC_PER_SEC << shift;
 > > +		do_div(temp, hz);

I suppose both functions could be implemented by a suitably
parametric third function, but IMO that would just obscure things.

Making them non-inline I fully agree with.
