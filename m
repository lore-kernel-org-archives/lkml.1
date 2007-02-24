Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbXBXAeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbXBXAeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXBXAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:34:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51925
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933283AbXBXAea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:34:30 -0500
Date: Fri, 23 Feb 2007 16:34:28 -0800 (PST)
Message-Id: <20070223.163428.104033815.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, peter.keilty@hp.com
Subject: Re: sparc generic time / clockevents
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172260279.6261.20.camel@localhost>
References: <1172224579.25076.219.camel@localhost.localdomain>
	<20070223.015520.125893182.davem@davemloft.net>
	<1172260279.6261.20.camel@localhost>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Fri, 23 Feb 2007 11:51:18 -0800

> Yea. I actually have some in-progress patches from Peter Keilty that
> convert ia64 and sparc64 time_interpolators to clocksources, then
> removes the time_interpolator code.
> 
> The ia64 conversion is more complicated due to the fsyscall asm, but I
> think the sparc64 conversion (below) is pretty straight forward. I've
> only built tested this, so I have no clue if it actually works. 
> 
> Any thoughts?

Hey John, I had to do this already in order to do the dynticks
port to sparc64, but nice to see another attempt :-)

Two things I did on my side:

+	.mask           = 0xffffffffffffffffLL,

I used CLOCKSOURCE_MASK(64) here.

+static cycle_t read_sparc64_cpuclock(void)
+{
+        return (cycle_t)get_cycles();
+}
 ...
+	.read           = read_sparc64_cpuclock,

You can just directly assign tick_ops->get_tick to .read at run-time
to avoid a stack frame and function call/return.

+	.shift          = 16,

These shift selections all seem rather arbitrary.

If it's not an arbitrary selection, it would be nice to have some
comments about how to go about choosing an appropriate shift.
I imagine the selections has to do with the possible range of
the frequencies the clocksource supports, and how much
accuracy you get for certain shift selections given that range.
