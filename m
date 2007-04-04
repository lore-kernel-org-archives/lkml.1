Return-Path: <linux-kernel-owner+w=401wt.eu-S1422722AbXDDSYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422722AbXDDSYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992753AbXDDSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:23:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422746AbXDDSW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:22:59 -0400
Date: Wed, 4 Apr 2007 11:19:30 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Rob Sims <lkml-z@robsims.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andreas =?UTF-8?B?QWxsZ8O2d2Vy?= <andreas.allgoewer@web.de>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>
Subject: Re: sky2 PHY setup
Message-ID: <20070404111930.46321146@freekitty>
In-Reply-To: <20070327032406.GA25659@robsims.com>
References: <20070202102705.3cf028a6@freekitty>
	<20070202210934.GM1693@cip.informatik.uni-erlangen.de>
	<20070202151601.677ec5d9@freekitty>
	<20070203073012.GO1693@cip.informatik.uni-erlangen.de>
	<20070205090429.31d7bd32@freekitty>
	<20070222193611.GR20035@cip.informatik.uni-erlangen.de>
	<20070316002912.GB17594@cip.informatik.uni-erlangen.de>
	<20070316095932.5e920222@freekitty>
	<20070316203645.GA24699@robsims.com>
	<20070316141648.15d7ff75@freekitty>
	<20070327032406.GA25659@robsims.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 21:24:06 -0600
Rob Sims <lkml-z@robsims.com> wrote:

> On Fri, Mar 16, 2007 at 02:16:48PM -0700, Stephen Hemminger wrote:
> > On Fri, 16 Mar 2007 14:36:45 -0600
> > Rob Sims <lkml-z@robsims.com> wrote:
> 
> > > Are there some debug hooks that can be activated?  My sky2 stops
> > > responding (very light load) about twice a day.  The netdev watchdog
> > > notices after a while and is able to reactivate the interface:
> 
> > > Mar 15 13:28:12 btd kernel: NETDEV WATCHDOG: eth0: transmit timed out
> > > Mar 15 13:28:12 btd kernel: sky2 eth0: tx timeout
> > > Mar 15 13:28:12 btd kernel: sky2 eth0: transmit ring 458 .. 435 report=458 done=458
> > > Mar 15 13:28:12 btd kernel: sky2 eth0: disabling interface
> > > Mar 15 13:28:12 btd kernel: sky2 eth0: enabling interface
> > > Mar 15 13:28:12 btd kernel: sky2 eth0: ram buffer 48K
> > > Mar 15 13:28:15 btd kernel: sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
> > 
> > Use ethtool -S to if there are any pause frames, etc. See if frames are
> > still making it into PHY statistics but not being received.
> > 
> > Use ethtool -d to dump registers. Need current version of ethtool with decode logic.
> > 
> > Then look for things like is Ram buffer read/write pointer changing?
> > 
> > Is GMAC stuck in pause:
> > 
> > Normal is:
> > 	GMAC 1
> > 	Status                       0x5010  (see GM_GPSR_XXX in sky2.h)
> > 	Control                      0x1800
> > 
> > Stuck is
> > 	GMAC 1
> > 	Status			     0x5810 (or 0x5A10)
> 
> First, here's the described hang in action, on the Core2 Duo on a 1Gb
> hub:
> GMAC 1 Status/Control remains at 0x5010/0x1800 until module is removed.
> Read/write buffer pointers are changing.  Full ethtool output in
> http://www.robsims.com/sky2.netmon.log.gz
> 
> This machine was also having major throughput problems - 17 kB/s.
> Rebooting brought it to ~ 20 MB/s.  Booting into a kernel with the
> proprietary sk98lin kernel module showed ~ 80MB/s.  Finally, returning
> to sky2 gave 117 MB/s.  Tests run using netcat, dd, /dev/zero, and
> /dev/null, transmitting from the problem box to an e1000 via a Netgear
> GS108.  No hangs were observed during the "load test."

The vendor driver does not do hardware flow control correctly. It ignores
Tx pause frames.

Were you using Jumbo MTU?

> I also had a hang on a Pentium 4 w/sky2, 100Mb/s hub.  I neglected to
> try removing and re-inserting the module before rebooting.
> GMAC 1
> Status                       0xF004
This is [100mbit] [Full duplex] [Tx flow control disabled] [link up] 
	[Rx flow control disabled]

> Control                      0x1800
	[TX enabled] [Rx enabled]

You might have over run the hub and it wedged.  Try doing:
	ethtool -r eth0
that forces a down/up


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
