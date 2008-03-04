Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYCDUsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYCDUsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYCDUry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:47:54 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36799 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751680AbYCDUrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:47:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uP9Tz7hbAcGN4wKtGP0/x/XT7aK4X3sffl6s7XpD3m/QEZ+Cc+KslzE0cJfFVK2G0+vhcSgI7aOBNfx71HgGTVn2kmuEc4L0Pa02PRdvDH5uW1RV2hHlLsjHCZd1GeyFSGAiIy17K9zBXn0wHVQMdFI49L6ne+SgEoMDmdOJtdw=  ;
X-YMail-OSG: k27yn68VM1kPKfisuLxGKY7N0k8ls7e892V6elXtocLu5Ic97MizPN7ezSsjPAXb79.wiFHqUw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Remy Bohmer" <linux@bohmer.net>
Subject: Re: [PATCH] atmel_tc clocksource/clockevent code
Date: Tue, 4 Mar 2008 12:47:50 -0800
User-Agent: KMail/1.9.6
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>,
       "john stultz" <johnstul@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com> <1204636061-6275-2-git-send-email-hskinnemoen@atmel.com> <3efb10970803041142l4a03dbb9uf11651d4cc7dde96@mail.gmail.com>
In-Reply-To: <3efb10970803041142l4a03dbb9uf11651d4cc7dde96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041247.50877.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Remy Bohmer wrote:
> >  +/* For now, we always use the 32K clock ... this optimizes for NO_HZ,
> >  + * because using one of the divided clocks would usually mean the
> >  + * tick rate can never be less than several dozen Hz (vs 0.5 Hz).
> >  + *
> >  + * A divided clock could be good for high resolution timers, since
> >  + * 30.5 usec resolution can seem "low".
> 
> I want to comment on that.
>
> I noticed that on rm9200 the timer interrupt handler itself can cost
> about 50us to more than 100usec in itself (measured through ETM
> trace), combined with a worst case interrupt latency of about 75us.

Could you elaborate on where that 50-100 usec gets spent?  Does
the same issue happpen with the $SUBJECT patch (if you tweak the
clocksource ratings to use its clockevents on rm9200)?

I'd not think the timer IRQ logic accounts for much of that time,
and the rest of the instruction cycles would seem to be either
in genirq or gentime.  Unless the issue is that accessing that
particular hardware is slow, with clockdomain crossing etc ...
or that AT91 has way too many handlers sitting on IRQ-1.

If it's a gentime or genirq issue, that's somewhat amenable to
fixing ... and it would also impact the $SUBJECT patch both on
other AT91 ARM9 cores and on the AVR32 AP7 cores.


> So, a higher resolution than 30usec is useless on these cores, and
> setting timers on a frequency that high will just choke the processor
> in only handling timers...

Should the min_delta_ns be increased in at91rm9200_time.c then?
Right now, as you probably recall, it's at the lowest value
needed for correctness:  a smidgeon over two ticks (~ 72 nsec).

- Dave

