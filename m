Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYFWVoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYFWVoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYFWVo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:44:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:15714 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbYFWVoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GRh80HYPfHs0zws8jaLyadPePIoDWwmwQZPnnMue34AekvsSMbUxtmsKXMGFTm8kE0
         YPmJXG27p/LGhjMt9NKB4ZCj+KGEe2M5yv6elpS6uQiwIjhwgCdww+29FM8S8csA+MPq
         hme6qA+TnYoI/C0mcooZ18ShJvGiBt+2GRcAA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Mon, 23 Jun 2008 23:45:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <1214203312.8011.246.camel@pasglop> <1214218047.8011.268.camel@pasglop>
In-Reply-To: <1214218047.8011.268.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232345.07621.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008, Benjamin Herrenschmidt wrote:
> On Mon, 2008-06-23 at 16:41 +1000, Benjamin Herrenschmidt wrote:
> > > Don't panic. It looks like it's something else in linux-next that's
> > > changing some ifdef's in the media-bay code which is causing that.
> > > 
> > > I managed to pull linux next at the merge point with your tree and
> > > things apply. I'll use that to test.
> > 
> > Ok, it doesn't work properly. It gets error trying to register
> > the IDE device. Booting with a CD drive in and no disk in the drive
> > gives the log below.
> > 
> > I've verified that it works without your patches. If I apply only patch
> > 1, it doesn't build due to some wrong construct in the probe code. I've
> > hand fixed it, but then I hit a BUG_ON in ide_probe_port() (line 773).
> > 
> > mediabay boot time messages (before IDE probing) are:
> 
> BTW. I didn't debug more today as I ran out of time but I'll do more
> tomorrow.
> 
> On a side note, we need to change the way the mediabay stuff works. I've
> started writing a pata_macio (ie. libata variant of the driver) a while

I (naively?) hope that you are using ide-pmac as a base (the driver looks
like a normal host driver now) and going to make the final API switch after
hardware specific changes are complete (so we will be able to use git-bisect
instead of guesswork combined with voodoo dance when dealing with potential
regressions :-).

> ago that I need to kick myself into finishing one of these days, and it
> will want something different than having the mediabay code poke into
> the IDE layer directly :-)
> 
> My current though is to add a media bay notification callback to the
> macio_device structure (the pci variants of the device are never hooked
> up on a media bay) and move the state query function to the macio core,
> the media bay driver being then responsible for calling into the macio
> core to update the state.

You may want to look at ACPI hotplug dock handling for inspiration
(if you haven't already).

> I still have to sort out some interesting locking issues vs. state
> changes around driver probe() but I think that's the way to go. Thus,
> the drivers/ide driver can do it's old ide core hackery locally and the
> libata variant do what is needed for libata locally too.

There is no longer any hackery on IDE core code side in 2.6.26, there are
just two nice methods: ide_port_unregister_devices() and ide_scan_port().

Therefore I would prefer to also update ide-pmac for new methods and just
add what is needed (if any) to IDE core code.

[ Please keep me in loop on these mediabay changes. ]

> It's been a bit low on my todo list as Apple stopped making machines
> with hotswap mediabays something like 8 years ago :-) The two I have
> still working are pretty scary old things and one of them is almost
> falling apart..

:)

Bart
