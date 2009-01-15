Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbZAOPA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbZAOPA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 10:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZAOPAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 10:00:09 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44416 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZAOPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 10:00:08 -0500
Date: Thu, 15 Jan 2009 15:00:03 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
Message-ID: <20090115150003.GB6896@shadowen.org>
References: <1231268198-12556-1-git-send-email-apw@canonical.com> <20090112160519.3ba21848@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112160519.3ba21848@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 04:05:19PM +0100, Pierre Ossman wrote:
> On Tue,  6 Jan 2009 18:56:38 +0000
> Andy Whitcroft <apw@canonical.com> wrote:
> 
> > Currently we are using an explicit udev rule to trigger loading of the
> > mmc-block module when an MMC or SD card is detected:
> > 
> >     SUBSYSTEM=="mmc", RUN+="/sbin/modprobe -Qba mmc-block"
> > 
> > It makes much more sense for the mmc bus driver and the mmc-block module to
> > share MODALIAS information so that they are linked automatically.
> > 
> 
> First, I'd just like to state that I agree that the current situation
> is far from optimal. Things should "just work".
> 
> That said, the MMC/SD stuff is a bit of a mess (the entire ecosystem,
> not just the Linux implementation). The classical method of matching
> devices to drivers isn't a perfect fit here. There is simply no nice
> and proper layering.
> 
> So right now I think that udev (or equivalent system) is the cleanest
> solution. If nothing else, it means we don't have to create a kernel
> ABI that might be problematic to maintain in the future. Feel free to
> convince me I'm wrong though. :)

The problem is that the kernel has an internal dependancy for using these
cards on the mmc-block driver but that is not expressed by the kernel.
This means that we have to maintain an external dependancy in the udev
package.  Unfortuanatly that is is not versioned with the kernel so
that adds a per distro maintenance burden ensuring udev is in step with
the kernel.

> > Add MODALIAS attributes to the uevents as generated, and add the
> > corresponding MODULE_ALIAS marks to the mmc-block module so that it is
> > automatically loaded by udev.  I have followed the example set by the
> > SCSI subsystem in pushing out numeric typed aliases:
> > 
> > 	mmc:t-0xNN
> > 
> > Where NN is the MMC type as defined in include/linux/mmc/card.h.
> 
> Currently the only type that isn't matched is MMC_TYPE_SDIO. But that
> will probably change once we support combo cards. At that point, all
> types will result in mmc_block being loaded and we're basically back to
> always loading mmc_block on card insertion.
> 
> There is also the fact that type isn't the primary thing that mmc_block
> uses to determine if it can use the card. The more interesting thing is
> the command classes. But since those aren't defined for pure SDIO
> cards, it's not something we can sensibly use for MODALIAS.
> 
> In essence, the crappy design of MMC and SD means there is no decent
> identifier for the card at this level.

Yeah I can see how we might end up still loading the driver for all SDIO
cards once we support them correctly; possibly even for ones with no
storage if we are unable to tell from the underlying device.  The good
thing about expressing it this way is that should the kernel find out how
to do it we can modify the aliases and prevent the module loading on all
distros automatically.

> Your patch leaves room for adding things in the future, but it
> doesn't seem right adding an ABI with fields that we already know are
> pretty useless at identifying devices.
>
> Is the udev method causing practical problems, or is this a matter of
> trying to do things the proper way just for the sake of it?

It is about reducing external dependancies to simplify life for the
distro packagers.

Would it make more sense to simply use mmc: with no data as the MODALIAS
tag here.  And make mmc-block have mmc:* as an alias.  That way the
actual (useless) numeric data is not exposed but we still will load the
mmc-block module for everything exactly as we do with the udev rule.
This should still make things work from a distro point of view and not
expose anything which might then get relied on.  If we do it so extra
data can still be added later we won't prevent sane data being exposed
should we ever have any.

If you are happier with that I can re-spin the patches that way?

-apw
