Return-Path: <linux-kernel-owner+w=401wt.eu-S1030400AbXBZTWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400AbXBZTWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030404AbXBZTWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:22:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36743
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030400AbXBZTWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:22:40 -0500
Date: Mon, 26 Feb 2007 11:22:39 -0800 (PST)
Message-Id: <20070226.112239.112290727.davem@davemloft.net>
To: tglx@linutronix.de
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, peter.keilty@hp.com
Subject: Re: [PATCH]: tick-sched.c build fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172394281.25076.361.camel@localhost.localdomain>
References: <20070224.214201.126577744.davem@davemloft.net>
	<1172394281.25076.361.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 25 Feb 2007 10:04:41 +0100

> On Sat, 2007-02-24 at 21:42 -0800, David Miller wrote:
> > While getting dynticks/hrtimers up on sparc64 I ran into
> > the following build problem.  If you use get_irq_regs() you
> > need to include asm/irq_regs.h
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Thanks for reviewing Thomas, I'll push the two bug fixes I
posted, with your ACKs, to Linus.

Two things remaining:

1) The change of clocksource_done_booting() to an fs_initcall()
   really is necessary.  Could you please push that to Linus?

2) I got bit by shifting problems (again) on sparc64.

Let me elaborate about #2.  Nobody writing these timer drivers
should be concerned by all of these details, I think, they will
get it wrong just as I did.

In my case a shift of 32 was too high for TSC based clockevent
on Niagara.

What we really should do is provide a clockevent_init_multshift()
or whatever that takes ticks_per_sec as an argument and this
function figured out an appropriate shift and multiplier to use.
It could be as simple as:

void clockevent_set_multshift(struct clock_event_device *edev, unsigned long hz)
{
	u64 mult;
	int shift = 32;

	while (1) {
		mult = div_sc(hz, NSEC_PER_SEC, shift);
		if (mult && (mult >> 32UL) == 0UL)
			break;

		shift--;
	}

	edev->shift = shift;
	edev->mult = (u32) mult;
}

With this, nobody will get bit by problems again.  We should
provide something similar, if not identical, for clocksources
too.  Perhaps we could even start trying at initial shift values
larger than 32.

What do you think?

Another thing I noticed is that clock_event_device->mult is
declared as an unsigned long, but it is clearly limited to
being a u32 as it is used as the second argument to do_div().

BTW, that's how I hit the Niagara shift issue, divide by zero
in clockevent_delta2ns() :-)
