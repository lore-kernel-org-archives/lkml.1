Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZALPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZALPFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZALPFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:05:25 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:55009 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZALPFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:05:25 -0500
Date: Mon, 12 Jan 2009 16:05:19 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090112160519.3ba21848@mjolnir.drzeus.cx>
In-Reply-To: <1231268198-12556-1-git-send-email-apw@canonical.com>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Jan 2009 18:56:38 +0000
Andy Whitcroft <apw@canonical.com> wrote:

> Currently we are using an explicit udev rule to trigger loading of the
> mmc-block module when an MMC or SD card is detected:
> 
>     SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"
> 
> It makes much more sense for the mmc bus driver and the mmc-block module to
> share MODALIAS information so that they are linked automatically.
> 

First, I'd just like to state that I agree that the current situation
is far from optimal. Things should "just work".

That said, the MMC/SD stuff is a bit of a mess (the entire ecosystem,
not just the Linux implementation). The classical method of matching
devices to drivers isn't a perfect fit here. There is simply no nice
and proper layering.

So right now I think that udev (or equivalent system) is the cleanest
solution. If nothing else, it means we don't have to create a kernel
ABI that might be problematic to maintain in the future. Feel free to
convince me I'm wrong though. :)

> Add MODALIAS attributes to the uevents as generated, and add the
> corresponding MODULE_ALIAS marks to the mmc-block module so that it is
> automatically loaded by udev.  I have followed the example set by the
> SCSI subsystem in pushing out numeric typed aliases:
> 
> 	mmc:t-0xNN
> 
> Where NN is the MMC type as defined in include/linux/mmc/card.h.

Currently the only type that isn't matched is MMC_TYPE_SDIO. But that
will probably change once we support combo cards. At that point, all
types will result in mmc_block being loaded and we're basically back to
always loading mmc_block on card insertion.

There is also the fact that type isn't the primary thing that mmc_block
uses to determine if it can use the card. The more interesting thing is
the command classes. But since those aren't defined for pure SDIO
cards, it's not something we can sensibly use for MODALIAS.

In essence, the crappy design of MMC and SD means there is no decent
identifier for the card at this level.

Your patch leaves room for adding things in the future, but it
doesn't seem right adding an ABI with fields that we already know are
pretty useless at identifying devices.


Is the udev method causing practical problems, or is this a matter of
trying to do things the proper way just for the sake of it?


Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
