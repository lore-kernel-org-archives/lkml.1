Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYE0TvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYE0TvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYE0TvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:51:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35029 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbYE0TvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:51:12 -0400
Date: Tue, 27 May 2008 12:50:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Alan Cox <alan@redhat.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080527125041.0fc28fd4@infradead.org>
In-Reply-To: <20080527155942.7693c360@gaivota>
References: <20080522223700.2f103a14@core>
	<20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
	<20080526181027.1ff9c758@gaivota>
	<20080526220154.GA15487@devserv.devel.redhat.com>
	<20080527101039.1c0a3804@gaivota>
	<20080527094144.1189826a@bike.lwn.net>
	<20080527133100.6a9302fb@gaivota>
	<20080527103755.1fd67ec1@bike.lwn.net>
	<20080527155942.7693c360@gaivota>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 15:59:42 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> On Tue, 27 May 2008 10:37:55 -0600
> Jonathan Corbet <corbet@lwn.net> wrote:
> 
> > On Tue, 27 May 2008 13:31:00 -0300
> > Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > 
> > > Since the other methods don't explicitly call BKL (and, AFAIK,
> > > kernel open handler don't call it neither), if a program 1 is
> > > opening a device and initializing some data, and a program 2
> > > starts doing ioctl, interrupting program 1 execution in the
> > > middle of a data initialization procedure, you may have a race
> > > condition, since some devices initialize some device global data
> > > during open [1].
> > 
> > In fact, 2.6.26 and prior kernels *do* acquire the BKL on open (for
> > char devices) - that's the behavior that the bkl-removal tree is
> > there to do away with.  So, for example, I've pushed that
> > acquisition down into video_open() instead. 
> > 
> > So, for now, open() is serialized against ioctl() in video
> > drivers.  As soon as you take the BKL out of ioctl(), though, that
> > won't happen, unless the mutex you use is also acquired in the open
> > path.
> 
> Ok.
> 
> A few drivers seem to be almost read to work without BKL. 
> 
> For example, em28xx has already a lock at the operations that change
> values at "dev" struct, including open() method. However, since the
> lock is not called at get operations, it needs to be fixed. I would
> also change it from mutex to a read/write semaphore, since two (or
> more) get operations can safely happen in parallel.
> 
\

please don't use rw/sems just because there MIGHT be parallel.
THey're more expensive than mutexes by quite a bit and you get a lot
less checking from lockdep. They make sense for very specific, very
read biased, contended cases. But please don't use them "just
because"...

