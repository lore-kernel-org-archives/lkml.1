Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXCSUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXCSUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXCSUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:25:29 -0400
Received: from waste.org ([66.93.16.53]:38938 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbXCSUZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:25:28 -0400
Date: Mon, 19 Mar 2007 15:12:43 -0500
From: Matt Mackall <mpm@selenic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070319201243.GV4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain> <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174331010.13341.548.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174331010.13341.548.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:03:30PM +0100, Thomas Gleixner wrote:
> Matt,
> 
> On Mon, 2007-03-19 at 12:08 -0500, Matt Mackall wrote:
> > On Sun, Mar 18, 2007 at 03:31:50PM -0500, Josh Boyer wrote:
> > > On Sun, Mar 18, 2007 at 02:18:12PM -0500, Matt Mackall wrote:
> > > > 
> > > > I'm well aware of all that. I wrote a NAND driver just last month.
> > > > Let's consider this table:
> > > > 
> > > > HARD drives                          MTD device
> > > > Consists of sectors                  Consists of eraseblocks
> > > > Sectors are small (512, 1024 bytes)  Eraseblocks are larger (32KiB, 128KiB)
> > > > read sector and write sector         read, write, and erase block
> > > > Bad sectors are re-mapped            Bad eraseblocks are not hidden
> > > > HDD sectors don't wear out	     Eraseblocks get worn-out
> > >  N/A                                   NAND flash addressed in pages
> > >  N/A                                   NAND flash has OOB areas
> > >  N/A (?)                               NAND flash requires ECC
> > 
> > Disks have OOB areas with ECC, it's just nicely hidden inside the
> > drive. They also typically have physical sectors bigger than 512
> > bytes, again hidden.
> 
> The difference is that the harddrive has an intellegent controller,
> which hides all this away. NAND FLASH has not and we have to do it in
> software.
> 
> > > > If the end goal is to end up with something that looks like a block
> > > > device (which seems to be implied by adding transparent wear leveling
> > > 
> > > Nope, not the end goal.  It's more about wear-leveling across the entire
> > > flash chip than it is presenting a "block like" device.
> > 
> > It seems to be about spanning devices and repartitioning as well.
> > Hence the analogy with LVM.
> 
> Yes, UBI is a kind of LVM for FLASH and we did think quite a time about
> reusing LVM before we went the UBI way.
> 
> > > > and bad block remapping), then I don't see any reason it can't be done
> > > > in device mapper. The 'smarts' of mtdblock could in fact be pulled up
> > > 
> > > There is nothing smart about mtdblock.  And mtdblock has nothing to do
> > > with UBI.
> > 
> > Note the scare quotes. Device mapper runs on top of a block device.
> > And mtdblock is currently the block interface that MTD exports. And it
> > has 'smarts' that hide handling of sub-eraseblock I/O. I'm clearly
> > talking about an approach that doesn't involve UBI at all.
> 
> MTD block has no 'smarts' at all. It is a stupid and broken hack, which
> you can utilize to lose data and wear your FLASH out. 

I explained precisely what I meant by 'smarts' and why I put it in
'smarts' in quotes. And here you are repeat that same exact damn thing
I responded to five lines up.

> > > > In the end, a block device is something which does random access
> > > > block-oriented I/O. Disk and NAND both fit that description.
> > > 
> > > NAND very much doesn't fit the "random access" part of that.  For writes
> > > you have to write in incrementing pages within eraseblocks.
> > 
> > And? You can't do I/O smaller than a sector on a disk.
> 
> Should we export block devices with 16/32/64/128 KiB size ?

Sure, why not?

> A disk _IS_ fundamentally different to FLASH and all the magic which is
> done inside of CF-Cards and USB-Sticks is just hiding this away.

And yet they're still both block devices. That our current block layer
doesn't handle one as well as the other is something we should fix
instead of inventing a whole new full-feature but incompatible block
layer on the side.

-- 
Mathematics is the supreme nostalgia of our time.
