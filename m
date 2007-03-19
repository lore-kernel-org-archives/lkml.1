Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXCSUIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXCSUIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbXCSUIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:08:12 -0400
Received: from waste.org ([66.93.16.53]:35862 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbXCSUHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:07:21 -0400
Date: Mon, 19 Mar 2007 14:54:42 -0500
From: Matt Mackall <mpm@selenic.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070319195442.GT4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain> <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174328188.30079.46.camel@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 01:16:28PM -0500, Josh Boyer wrote:
> On Mon, 2007-03-19 at 12:08 -0500, Matt Mackall wrote:
> > 
> > > > If the end goal is to end up with something that looks like a block
> > > > device (which seems to be implied by adding transparent wear leveling
> > > 
> > > Nope, not the end goal.  It's more about wear-leveling across the entire
> > > flash chip than it is presenting a "block like" device.
> > 
> > It seems to be about spanning devices and repartitioning as well.
> > Hence the analogy with LVM.
> 
> Yes, it can span multiple MTDs which spreads the wear-leveling even
> more.  Yes, it can create/resize/remove volumes.  It does that
> differently than LVM, but the ideas are related.  I don't see the issue
> here I guess.

The issue is 14000 lines of patch to make a parallel subsystem.

> (UBI also has static volumes which LVM doesn't but that is an aside.)

If a static volume is simply a non-dynamic volume, then device mapper
can do that too. And countless other things. Which is not an aside.
UBI growing to do all the things that device mapper does is exactly
the thing we should be seeking to avoid.
 
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
> Ok, but what I'm saying is that using device mapper on top of mtdblock
> is not a good solution.  mtdblock caches writes within an eraseblock to
> a DRAM buffer of eraseblock size.  If you get a power failure before
> that is flushed out, you lose an entire eraseblock's worth of data.

Sigh. That's precisely why I talked about moving said smarts. This is
nothing that a higher level remapping layer can't address.
 
> That's why I suggested fixing the MTD layers that present block devices
> first in the part of my reply that you cut off.  It seems to me that
> you're really after getting flash to look like a block device, which
> would enable device mapper to be used for something similar to UBI.
> That's fine, but until someone does that work UBI fills a need, has
> users, and has an existing implementation.

False starts that get mainlined delay or prevent things getting done
right. The question is and remains "is UBI the right way to do
things?" Not "is UBI the easiest way to do things?" or "is UBI
something people have already adopted?"

If the right way is instead to extend the block layer and device
mapper to encompass the quirks of NAND in a sensible fashion, then UBI
should not go in.

Let me draw a picture so we have something to argue about:

                     iSCSI/nbd(6)
                          |
filesystem {        swap  |  ext3        ext3     jffs2
                      \   |   |            |       /
               /       \  | dm-crypt->snapshot(5) /
device mapper -|        \ \   |                  /
               |         partitioning           /
               |              |          partitioning(4)
               |        wear leveling(3)  /
               |              |          /
               |      block concatenation
               |       |    |    |     |
               \      bad block remapping(2)   
                       |    |    |     |
MTD raw block {     raw block devices with no smarts(1)
                      /     |     \      \
hardware {         NAND    NAND   NAND   NAND

Notes:
1. This would provide a block device that allowed writing pages and
   a secondary method for erasing whole blocks as well as a method for
   querying/setting out of band information.
2. This would hide erase blocks either by using an embedded table or
   out of band info. This could stack on top of block concatenation if
   desired.
3. This would provide wear leveling, and probably simultaneously
   provide relatively efficient and safe access to write sector 
   and page-sized I/O. Below this level, things had better be
   comfortable with the limitations of NAND if they want to work well.
4. JFFS2 has its own wear-leving scheme, as do several other
   filesystems, so they probably want to bypass this piece of the stack.
5. We don't reimplement higher pieces of the stack (dm-crypt,
   snapshot, etc.).
6. We make some things possible that simply aren't otherwise.

And this picture isn't even interesting yet. Imagine a dm-cache layer
that caches data read from disks in high-speed flash. Or using
dm-mirror to mirror writes to local flash over NBD or to a USB drive.
Neither of these can be done 'right' in a stack split between device
mapper and UBI.

-- 
Mathematics is the supreme nostalgia of our time.
