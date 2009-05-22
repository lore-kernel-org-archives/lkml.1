Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZEVMHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZEVMHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZEVMGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:06:52 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3650 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZEVMGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:06:51 -0400
Date: Fri, 22 May 2009 08:06:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090522120608.GA24949@hash.localnet>
References: <20090312061047.GA13401@silver.sucs.org> <20090313095213.GA14250@silver.sucs.org> <20090320131437.GA30120@hash.localnet> <20090329142432.GA15578@sucs.org> <20090329151401.GA26510@hash.localnet> <20090331083041.GA19657@sucs.org> <20090513214416.GA4492@sucs.org> <20090515040904.GA32357@hash.localnet> <20090518100540.GB21150@sucs.org> <20090522093930.GA15375@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522093930.GA15375@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 10:39:31AM +0100, Sitsofe Wheeler wrote:
> The poison message has not reappeared but this morning there was a
> sudden break in the connection. Only toggling the wifi via rfkill
> brought things back to life. dmesg below:
> 
> [   71.445152] wlan0: associated
> [ 5771.345217] ath5k phy0: noise floor calibration timeout (2412MHz)
> [ 5774.632085] wlan0: no probe response from AP 00:01:38:d6:0b:4f - disassociating

Card got into a bad state here somehow, 

> [ 5774.869703] ath5k phy0: failed to wakeup the MAC Chip
> [ 5774.869717] ath5k phy0: can't reset hardware (-5)

-EIO, a really bad state (we're doing a lot of resets, not sure
offhand why -- maybe just the calibration timer since it doesn't
look like the channel is changing as would happen in a scan).  

When we see this either card isn't getting any power (e.g. due
to rfkill, but I think that happened later here) or card just
isn't responding.  Seems we should give up after a while rather
than spamming the log forever.

> [ 5834.122061] ath5k 0000:01:00.0: PCI INT A disabled

I take it this is when you hit rfkill, which also did an rmmod and
probably disconnected it from the bus?

> [ 5836.901310] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]

and here's where you turned it back on...

> Another weird thing that I've noticed with 2.6.30 kernels (although it
> might be happening with older ones) is that periodically (maybe once a
> day) the packet loss between the computer and the access point will
> become very high and will stay that way until the computer is rebooted.
> I do not know if toggling via rfkill will also solve that problem.

It sounds like a similar case.  There's a patch on the way (I don't
think has hit 2.6.30 yet) that fixes a regression that can affect
calibration in 802.11g mode.

-- 
Bob Copeland %% www.bobcopeland.com

