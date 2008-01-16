Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYAPRpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYAPRpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYAPRpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:45:44 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:41555 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYAPRpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:45:43 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jaroslav Kysela <perex@perex.cz>
Subject: Re: -mm: pnp-do-not-stop-start-devices-in-suspend-resume-path.patch breaks resuming isapnp cards
Date: Wed, 16 Jan 2008 10:46:03 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Rene Herman <rene.herman@keyaccess.nl>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@suse.cz>, Ondrej Zary <linux@rainbow-software.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
References: <200801092343.48726.linux@rainbow-software.org> <200801141526.57744.bjorn.helgaas@hp.com> <Pine.LNX.4.61.0801150842480.7446@tm8103.perex-int.cz>
In-Reply-To: <Pine.LNX.4.61.0801150842480.7446@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161046.05174.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 12:51:35 am Jaroslav Kysela wrote:
> On Mon, 14 Jan 2008, Bjorn Helgaas wrote:
> > On Saturday 12 January 2008 11:13:35 pm Rene Herman wrote:
> > > ... And, now that I have your attention, while it's 
> > > not important to the issue anymore with the tests removed as the submitted 
> > > patch did, do you have an opinion on (include/linux/pnp.h):
> > > 
> > > /* pnp driver flags */
> > > #define PNP_DRIVER_RES_DO_NOT_CHANGE    0x0001  /* do not change the state 
> > > of the device */
> > > #define PNP_DRIVER_RES_DISABLE          0x0003  /* ensure the device is 
> > > disabled */
> > > 
> > > I find DISABLE including DO_NOT_CHANGE rather unexpected...
> > 
> > I don't know the history of those flags, but I wish they didn't exist.
> 
> Ok, something to explain. These flags exists to allow drivers to 
> manually configure (override) PnP resources at init time - we know - for 
> example in ALSA - that some combinations simply does not work for all 
> soundcards.
>
> The DISABLE flags simply tells core PnP layer - driver will handle 
> resource allocation itself, don't do anything, just disable hw physically 
> and do not change (allocate) any resources. Value 0x03 is valid in this 
> semantics.

It looks like sound drivers use PNP_DRIVER_RES_DISABLE to say "ignore
what PNP tells us about resource usage and we'll just use the compiled-
in or command-line-specified resources".

The main reason to do that would be to work around BIOS defects or
to work around deficiencies in the Linux PNP infrastructure (e.g.,
maybe we erroneously place another device on top of the sound card
or something).

I'm just suspicious because PNP_DRIVER_RES_DISABLE is only used in
sound drivers.  If it's to work around BIOS defects, why wouldn't
other PNP drivers need it sometimes, too?  And wouldn't it be better
to use PNP quirks for BIOS workarounds?

> Unfortunately, suspend / resume complicates things a bit, but PnP core can 
> handle DO_NOT_CHANGE flag. But it will just mean - _preserve_ resource 
> allocation from last suspend state for this device and enable hw 
> physically before calling resume() callback.

When resuming, wouldn't we *always* want to preserve the resource
allocation from the last suspend, regardless of whether
PNP_DRIVER_RES_DO_NOT_CHANGE is specified?

Linux PNP definitely has issues with suspend/resume, and I suspect
this is one of them.

Bjorn
