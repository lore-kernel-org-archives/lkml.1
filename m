Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbYAJH6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbYAJH6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYAJH6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:58:35 -0500
Received: from mail1.perex.cz ([212.20.107.53]:60859 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYAJH6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:58:34 -0500
Date: Thu, 10 Jan 2008 08:58:28 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Ondrej Zary <linux@rainbow-software.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
In-Reply-To: <47857A82.4050005@keyaccess.nl>
Message-ID: <Pine.LNX.4.61.0801100849290.30240@tm8103.perex-int.cz>
References: <200801092343.48726.linux@rainbow-software.org>
 <47857A82.4050005@keyaccess.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Rene Herman wrote:

> On 09-01-08 23:43, Ondrej Zary wrote:
> 
> Jaroslav -- in your role as ISA-PnP maintainer and Bjorn, in yours as 
> having been foollish enough to touch PnP recently:
> 
> > as hibernation (swsusp) started to work with my CPU, I found that my Turtle 
> > Beach Malibu stops working after resume from hibernation. It's caused by fact 
> > that the card is not enabled on the pnp layer during resume - and thus card 
> > registers are inaccessible (reads return FFs, writes go nowhere).
> > 
> > During resume, pnp_bus_resume() in drivers/pnp/driver.c is called for each pnp 
> > device. This function calls pnp_start_dev() only when the 
> > PNP_DRIVER_RES_DO_NOT_CHANGE bit is NOT seting pnp_drv->flags. But the cs4236 
> > driver in sound/isa/cs423x/cs4236.c explicitly sets the .flags to 
> > PNP_DRIVER_RES_DISABLE - it's value is 3 and that includes 
> > PNP_DRIVER_RES_DO_NOT_CHANGE bit.
> 
> Ehm. Isn't that a bit unexpected:
> 
> #define PNP_DRIVER_RES_DO_NOT_CHANGE    0x0001  /* do not change the state 
> of the device */
> #define PNP_DRIVER_RES_DISABLE          0x0003  /* ensure the device is 
> disabled */
> 
> I'd say that disabling is changing, so isn't this just a braino where 
> someone meant to write 2 instead of 3?

It's irrelevant. I think that condition in driver.c in suspend and resume 
callbacks is invalid, because PNP_DRIVER_RES_DO_NOT_CHANGE means that 
resources should not be changed in the pnp core but only in the driver, 
but in suspend/resume process are resources preserved, so the condition 
should be removed.

Author of this code is:

author Pierre Ossman <drzeus-list@drzeus.cx> Tue, 29 Nov 2005 09:09:32 +0100
committer Jaroslav Kysela <perex@suse.cz> Tue, 03 Jan 2006 12:31:30 +0100

    [ALSA] [PATCH] alsa: Improved PnP suspend support

    Also use the PnP functions to start/stop the devices during the suspend so
    that drivers will not have to duplicate this code.

    Cc: Adam Belay <ambx1@neo.rr.com>
    Cc: Jaroslav Kysela <perex@suse.cz>
    Cc: Takashi Iwai <tiwai@suse.de>

    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>


						Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

