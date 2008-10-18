Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYJRUrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYJRUrG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYJRUqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:46:55 -0400
Received: from server.drzeus.cx ([85.8.24.28]:37832 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127AbYJRUqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:46:54 -0400
Date: Sat, 18 Oct 2008 22:46:50 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SDHCI: timeout during data transfer
Message-ID: <20081018224650.2edff23c@mjolnir.drzeus.cx>
In-Reply-To: <68676e00810141413w384882dbg53af93a1b522e0d3@mail.gmail.com>
References: <20080923212459.GA13888@dreamland.darkstar.lan>
	<20081002101754.031d6710@mjolnir.drzeus.cx>
	<68676e00810030427g63c07643rf637ca894df795b2@mail.gmail.com>
	<20081012105227.513bb9a8@mjolnir.drzeus.cx>
	<68676e00810140234o5e85f438l18058c907a7c6260@mail.gmail.com>
	<68676e00810141413w384882dbg53af93a1b522e0d3@mail.gmail.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 23:13:39 +0200
"Luca Tettamanti" <kronos.it@gmail.com> wrote:

> 
> I finally managed to capture a failure with debug enabled, I'm
> attaching the log.

It seems to be a transfer error at least as it is in a completely
different area of the card compared to the first mail you sent.

> To recap:
> - heavy write loads sometimes result in a timeout
> - reads seem unaffected (I read the card multiple times without errors)

Looking at the dump, the controller seems to be doing the correct
thing. The timeout mandated by the SD specification is 250 ms, and that
time has passed if you look at the timestamps. If you look at some
other writes further down, the card takes around 220 ms for the writes.
IOW, it would seem that this card is cutting it a bit close and
sometimes goes over the alloted time.

> - doubling the timeout (as per my first patch) makes the timeout disappear

Since it is the card that's the problem here, not the controller, we'd
need to fix this in the core. Unfortunately the sdhci hardware is a bit
inflexible so any change I make will result in a doubling of the
timeout.

Could you try modifying line 283 of drivers/mmc/core/core.c where it
says "limit_us = 250000;" to 300000 instead?

> - windows doesn't suffer from the issue

Windows doesn't do proper handling of timeouts. It just sets the
maximum timeout and hopes for the best.

> 
> I've tested two other cards that do not show the problem, but they are
> not "high speed":
> 
> mmc0: new high speed SD card at address 0002 (troubles)
> vs:
> mmc0: new SD card at address e624 (OK)
> 

What's the vendor and model of the failing card?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
