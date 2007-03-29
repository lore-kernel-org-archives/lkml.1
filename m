Return-Path: <linux-kernel-owner+w=401wt.eu-S934148AbXC2T7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbXC2T7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 15:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934149AbXC2T7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 15:59:20 -0400
Received: from waste.org ([66.93.16.53]:49585 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934148AbXC2T7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 15:59:19 -0400
Date: Thu, 29 Mar 2007 14:46:04 -0500
From: Matt Mackall <mpm@selenic.com>
To: Mariusz =?utf-8?Q?Koz=C5=82owski?= <m.kozlowski@tuxland.pl>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: 2.6.21-rc5-mm1
Message-ID: <20070329194604.GH4892@waste.org>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <200703292001.41255.m.kozlowski@tuxland.pl> <20070329182146.GE4892@waste.org> <200703292055.26117.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703292055.26117.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 08:55:25PM +0200, Mariusz Kozłowski wrote:
> > > > > > > 	I run 2.6.21-rc4-mm1 with no hangs for a week.
> > > > > > > Then when 2.6.21-rc5-mm1 showed up so I switched to it. Unfortunately
> > > > > > > today my laptop hunged twice in a similar way as described here:
> > > > > > > 
> > > > > > > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
> > > > > > 
> > > > > > It's not good that we went backwards between those two releases.
> > > > > > 
> > > > > > > The difference is that it happened when I closed the lid in my laptop.
> > > > > > > When reopend it the box was frozen (ACPI?). Again disk I/O was dead
> > > > > > > so nothing was found in syslog.
> > > > > > 
> > > > > > Adrian, does this look like any of the bugs whcih you're monitoring?
> > > > > >...
> > > > > 
> > > > > Is it also present in 2.6.21-rc5?
> > > > 
> > > > Don't know. I usualy test -mm series. Will test tommorow and let you know
> > > > after some reasonable uptime.
> > > > 
> > > > > Is it also present with CONFIG_NO_HZ=n?
> > > > 
> > > > Don't know. Did not try recently. Will let you know.
> > > > 
> > > > It takes time as these hangs are not easy to trigger. With 2.6.21-rc2-mm1
> > > > it was easy -> push the system and watch it die in minutes. With
> > > > 2.6.21-rc5-mm1 it takes hours (3 hangs in ~15 hours) and not sure how to
> > > > trigger it. It just happens from time to time.
> > > 
> > > Ok. CONGIG_NO_HZ=n and uptime ~12 hours, netconsole loaded, and no hangs
> > > ... until I moved my laptop. The same scenario happened yesterday during the
> > > last hang. I started playing and repeating some steps which I naturally do when
> > > I move my laptop.
> > > 
> > > An hour later I came to this -> steps to hang 2.6.21-rc5-mm1 on my laptop:
> > > 1. boot the system and login as root
> > > 2. load netconsole (insmod netconole.ko netconsole=blah... blah...)
> > > 3. unplug the cable (link goes down)
> > > 4. system is frozen until forced to reboot
> > > 
> > > This is verified and repeatable _every_ single time I tried. Unfortunately
> > > the last thing seen on the screen before system is frozen is 'eth0: link down'.
> > > So my guess is that when hunting for hangs I found something else that can hang
> > > my laptop (netconsole that is).
> > 
> > Which NIC do you have? Odds are that the driver is doing that printk
> > while holding a driver-internal spinlock that causes it to deadlock
> > when netpoll tries to send that message out.
> 
> 8139too was in use. This is from lspci:
> 
> 00:12.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
>         Subsystem: Sony Corporation Unknown device 8158
>         Flags: bus master, medium devsel, latency 64, IRQ 11
>         I/O ports at 9c00 [size=256]
>         Memory at f0404c00 (32-bit, non-prefetchable) [size=512]
>         Capabilities: [50] Power Management version 2

Yep, that's a known problem with this driver:

http://lkml.org/lkml/2007/2/17/222

This was a known theoretical problem with netconsole from the start
but I'm actually not aware of any other drivers that have run into it.
My preferred fix is to create a netconsole_disable/enable API for
drivers that have this sort of reentrancy problem.

-- 
Mathematics is the supreme nostalgia of our time.
