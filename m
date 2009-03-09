Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZCIKsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZCIKsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZCIKsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:48:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37682 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZCIKsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:48:36 -0400
Date: Mon, 9 Mar 2009 11:48:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jim Paris <jim@jtan.com>, Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing
	video       RAM as block device
Message-ID: <20090309104833.GM11787@kernel.dk>
References: <20090305083701.GQ11787@kernel.dk> <alpine.LRH.2.00.0903051146440.2618@vixen.sonytel.be> <20090305110940.GY11787@kernel.dk> <alpine.LRH.2.00.0903051325450.2618@vixen.sonytel.be> <20090306074639.GN11787@kernel.dk> <alpine.LRH.2.00.0903061347360.16809@vixen.sonytel.be> <20090306125832.GX11787@kernel.dk> <alpine.LRH.2.00.0903061525340.16809@vixen.sonytel.be> <20090306190350.GD11787@kernel.dk> <alpine.LRH.2.00.0903091142500.19484@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903091142500.19484@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09 2009, Geert Uytterhoeven wrote:
> On Fri, 6 Mar 2009, Jens Axboe wrote:
> > On Fri, Mar 06 2009, Geert Uytterhoeven wrote:
> > > On Fri, 6 Mar 2009, Jens Axboe wrote:
> > > > On Fri, Mar 06 2009, Geert Uytterhoeven wrote:
> > > > > On Fri, 6 Mar 2009, Jens Axboe wrote:
> > > > > > On Thu, Mar 05 2009, Geert Uytterhoeven wrote:
> > > > > > > But then I noticed ps3vram_make_request() may be called concurrently,
> > > > > > > so I had to add a mutex to avoid data corruption. This slows the
> > > > > > > driver down, and in the end, the version with a thread turns out to be
> > > > > > > ca. 1% faster. The version without a thread is about 50 lines less
> > > > > > > code, though.
> > > > > >
> > > > > > That is correct, ->make_request_fn may get reentered. I'm not surprised
> > > > > > that performance dropped if you just shoved everything under a mutex.
> > > > > > You could be a little more smart and queue concurrent bio's for
> > > > > > processing when the current one is complete though, there are several
> > > > > > approaches there that be a lot faster than going all the way through the
> > > > > > IO stack and scheduler just to avoid concurrency.
> > > > >
> > > > > Yes, using a spinlock and queueing requests on a list if the driver is
> > > > > busy can be done after 2.6.29...
> > > >
> > > > Certainly. Even just replacing your current mutex with a spinlock during
> > > > the memcpy() would surely be a lot faster. Or even just grabbing the
> > > > mutex before calling into the write for the duration of the bio. The way
> > > > you do it is certain context switch death :-)
> > >
> > > It's not just the memcpy(). ps3vram_{up,down}load() call msleep(), so
> > > I cannot use a spinlock.
> >
> > Ah right, I hadn't looked close enough. But putting the mutex_lock()
> > outside of the bio_for_each_segment() is going to be much faster than
> > getting/releasing it for each segment.
> 
> It doesn't seem to make any measurable difference, so I'm gonna leave it for
> now.

It will depend on where the bio's are coming from. If they are all
single segment, then there will be no difference. If they contain
multiple segments, you reduce the lock/release by that amount.

But yeah, just leave it as-is for now. You can send a final patch for
inclusion though. Unless I'm mistaken, I only saw the original and then
an incremental patch for changing it to ->make_request_fn?

-- 
Jens Axboe

