Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYFWKsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYFWKsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYFWKrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:47:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:59560 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbYFWKrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:47:52 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1214203312.8011.246.camel@pasglop>
References: <200806162124.43005.bzolnier@gmail.com>
	 <1213673979.8129.156.camel@pasglop> <1213674572.8129.159.camel@pasglop>
	 <200806171141.08865.bzolnier@gmail.com> <1214199343.8011.230.camel@pasglop>
	 <1214200453.8011.232.camel@pasglop>  <1214203312.8011.246.camel@pasglop>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 20:47:27 +1000
Message-Id: <1214218047.8011.268.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 16:41 +1000, Benjamin Herrenschmidt wrote:
> > Don't panic. It looks like it's something else in linux-next that's
> > changing some ifdef's in the media-bay code which is causing that.
> > 
> > I managed to pull linux next at the merge point with your tree and
> > things apply. I'll use that to test.
> 
> Ok, it doesn't work properly. It gets error trying to register
> the IDE device. Booting with a CD drive in and no disk in the drive
> gives the log below.
> 
> I've verified that it works without your patches. If I apply only patch
> 1, it doesn't build due to some wrong construct in the probe code. I've
> hand fixed it, but then I hit a BUG_ON in ide_probe_port() (line 773).
> 
> mediabay boot time messages (before IDE probing) are:

BTW. I didn't debug more today as I ran out of time but I'll do more
tomorrow.

On a side note, we need to change the way the mediabay stuff works. I've
started writing a pata_macio (ie. libata variant of the driver) a while
ago that I need to kick myself into finishing one of these days, and it
will want something different than having the mediabay code poke into
the IDE layer directly :-)

My current though is to add a media bay notification callback to the
macio_device structure (the pci variants of the device are never hooked
up on a media bay) and move the state query function to the macio core,
the media bay driver being then responsible for calling into the macio
core to update the state.

I still have to sort out some interesting locking issues vs. state
changes around driver probe() but I think that's the way to go. Thus,
the drivers/ide driver can do it's old ide core hackery locally and the
libata variant do what is needed for libata locally too.

It's been a bit low on my todo list as Apple stopped making machines
with hotswap mediabays something like 8 years ago :-) The two I have
still working are pretty scary old things and one of them is almost
falling apart..

Cheers,
Ben.

