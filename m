Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZEZUYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZEZUYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZEZUXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:23:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43607 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbZEZUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:23:52 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: john stultz <johnstul@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1243348681.23657.14.camel@twins>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>
Content-Type: text/plain
Date: Tue, 26 May 2009 13:23:43 -0700
Message-Id: <1243369423.3275.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 16:38 +0200, Peter Zijlstra wrote:
> Added the generic clock and timer folks to CC.
> 
> On Tue, 2009-05-26 at 16:31 +0200, Linus Walleij wrote:
> > 2009/5/26 Paul Mundt <lethal@linux-sh.org>:
> > 
> > >  */
> > >  unsigned long long __attribute__((weak)) sched_clock(void)
> > >  {
> > > +       /*
> > > +        * Use the current clocksource when it becomes available later in
> > > +        * the boot process, and ensure that it has a high enough rating
> > > +        * to make it suitable for general use.
> > > +        */
> > > +       if (clock && clock->rating >= 100)
> > > +               return cyc2ns(clock, clocksource_read(clock));

I'm not super familiar with the recent sched_clock changes, but how will
this work if the clocksource wraps (ACPI PM wraps every 2-5 seconds).

Also there's no locking here, so the clocksource could change under you.

Further, checking for rating being greater then 100 really doesn't mean
anything. Probably need to check if the clocksource is continuous
instead.

Overall, I'd probably suggest thinking this through a bit more. At some
point doing this right will cause sched_clock() to be basically the same
as ktime_get(). So why not just use that instead of remaking it?

thanks
-john


