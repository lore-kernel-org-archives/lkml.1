Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZF0ANG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZF0ANG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 20:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZF0AMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 20:12:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791AbZF0AMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 20:12:55 -0400
Date: Fri, 26 Jun 2009 17:12:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, openezx-devel@lists.openezx.org,
       sameo@linux.intel.com
Subject: Re: [PATCH] PCAP RTC driver (for 2.6.32).
Message-Id: <20090626171216.7381f186.akpm@linux-foundation.org>
In-Reply-To: <1246060658.10360.336.camel@brutus>
References: <1245962749.10360.42.camel@brutus>
	<20090626132310.60665a98.akpm@linux-foundation.org>
	<1246060658.10360.336.camel@brutus>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 20:57:38 -0300 Daniel Ribeiro <drwyrm@gmail.com> wrote:

> Hi Andrew,
> 
> Em Sex, 2009-06-26 __s 13:23 -0700, Andrew Morton escreveu:
> > This could be coded more simply:
> > 
> > 	unsigned long rtc_events;
> > 
> > 	if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ))
> > 		rtc_events = RTC_IRQF | RTC_UF;
> > 	else if (irq == pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA))
> > 		rtc_events = RTC_IRQF | RTC_AF;
> 
> This would make gcc complain about rtc_events being used uninitialized.

So initialise it ;)

It's the "|=" which is strange and a bit misleading - it's a coding
trick which doesn't reflect what is happening at a functional level.

But it's a minor point.

> > SEC_PER_DAY is defined in include/linux/mfd/ezx-pcap.h.  It should not
> > be, because it is not specific to that driver and can be used elsewhere
> > in the kernel.
> > 
> > I'd suggest that we
> > 
> > - define SECS_PER_DAY in include/linux/time.h
> > 
> > - remove the private definitions of SECS_PER_DAY from
> >   arch/m68k/mac/misc, arch/parisc/include/asm/rtc.h,
> >   arch/ia64/hp/sim/boot/fw-emu.c, fs/udf/udftime.c, fs/fat/misc.c and
> >   wherever else it appears, make those files use the common definition
> > 
> > - migrate rtc-pcap.c from SEC_PER_DAY over to the common SECS_PER_DAY.
> > 
> > - Then do it all again for SECS_PER_MIN and SECS_PER_HOUR.
> > 
> > 
> > What a mess.
> 
> I can't work on this right now, but i will be happy to reserve some
> hours for this next month if nobody else does it before.

Well, whatever.  Lots of people could pick up this projectlet.

> > "tmp" is a poor identifier.  We had an opportunity here to use an
> > identifier which would communicate useful information to the reader. 
> > But we blew it and used the information-free "tmp" instead.
> > 
> > Something like
> > 
> > 	u32 time_of_day;	/* In seconds since midnight */
> > 
> > would be nice.  If that is indeed what the variable contains.  How
> > would I know?  It's called 'tmp" and is undescribed!
> 
> Hum.. I used tmp because the variable is reused and it may be "days
> since 1/1/1970" or "seconds since today's 00:00:00".

That's even worse!

> I will add some comments to make this clear.

It'd be clearest to create two appropriately-named variables.  This
shouldn't affect emitted code unless gcc is busted.

> I see that you have already added it to the -mm tree.

Yes, I often do that.  To get a bit of early testing and so the whole
thing doesn't get lost.  Also so that I remember that I've reviewed it
once.

> Do you prefer an
> incremental patch to address your comments or should I send a patch to
> replace the current version?

A replacement is OK at this early stage.  I will turn that into an
incremental here so that I can see what you did.

