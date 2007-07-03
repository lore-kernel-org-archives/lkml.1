Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbXGCLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbXGCLX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXGCLXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:23:19 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45292 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbXGCLXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:23:18 -0400
To: oliver@neukum.org
CC: miklos@szeredi.hu, linux-pm@lists.linux-foundation.org,
       benh@kernel.crashing.org, nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
In-reply-to: <200707031307.41366.oliver@neukum.org> (message from Oliver
	Neukum on Tue, 3 Jul 2007 13:07:39 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707030944.18702.oliver@neukum.org> <E1I5fug-0003ZS-00@dorka.pomaz.szeredi.hu> <200707031307.41366.oliver@neukum.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1I5gSu-0003f4-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jul 2007 13:22:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > So to summarize, the plan that makes things work with fuse is:
> > > > 
> > > >  - For STR, don't do the freezer thing.
> > > > 
> > > >  - For STD, don't sys_sync() after you froze
> > > > 
> > > > There might be -other- issues, but that should get you through some of
> > > 
> > > At the risk of repeating myself. Character device drivers are written
> > > with the assumption that normal io and suspend/resume do not race
> > > with each other due to the freezer.
> > > What do you intend to do about that?
> > 
> > Oliver, can you please explain your worries in a bit more detail?
> > 
> > I don't claim to know anything about how STR or hibernate works, but
> > neither seem to have any problem with I/O on the fuse device "racing"
> > with them.
> 
> The problem is not with fuse. The problem is generic in nature.
> 
> If you remove the freezer, user space remains active until the last CPU
> goes into suspend. It can do syscalls. Or do you know a clean way to exempt
> only the tasks fuse might use?

You are talking about hibernate, right?  Suspending (to ram) is
instantaneous, in that _after_ suspend no CPU is active obviously.

> Now device drivers have a guaranteed temporal sequence:
> 
> last io -> suspend() -> resume() [or disconnect()] -> new io
> 
> This is because suspend() is called after the freezer goes into action. If
> you remove the freezer, you need to deal with
> 
> 1. io to suspended devices
> 2. resume() assuming that the device is in the state suspend() left it
> 3. io changing a device's state while suspend is saving it
> 
> and you need to fix this for all device drivers, not just those fuse is
> involved with. Removing the freezer means doing a more or less full
> audit of every driver and additional locking in many drivers.

OK, this has _nothing_ at all to do with fuse then, and everything to
do with disk I/O.

Just because fuse is a filesystem, it doesn't have to do anything with
block devices, just like procfs doesn't either.

So removing the freezer from the hibernate path would be problematic,
but as I understand this is not what has been proposed, only removing
the freezer from the STR path, which should be OK.

Miklos
