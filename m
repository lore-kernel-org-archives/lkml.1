Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXCRUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXCRUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXCRUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:25:29 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35744 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbXCRUZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:25:27 -0400
Date: Sun, 18 Mar 2007 15:31:50 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070318203149.GC29295@crusty.rchland.ibm.com>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain> <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318191812.GM4892@waste.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 02:18:12PM -0500, Matt Mackall wrote:
> 
> I'm well aware of all that. I wrote a NAND driver just last month.
> Let's consider this table:
> 
> HARD drives                          MTD device
> Consists of sectors                  Consists of eraseblocks
> Sectors are small (512, 1024 bytes)  Eraseblocks are larger (32KiB, 128KiB)
> read sector and write sector         read, write, and erase block
> Bad sectors are re-mapped            Bad eraseblocks are not hidden
> HDD sectors don't wear out	     Eraseblocks get worn-out
 N/A                                   NAND flash addressed in pages
 N/A                                   NAND flash has OOB areas
 N/A (?)                               NAND flash requires ECC
 
> 
> If the end goal is to end up with something that looks like a block
> device (which seems to be implied by adding transparent wear leveling

Nope, not the end goal.  It's more about wear-leveling across the entire
flash chip than it is presenting a "block like" device.

> and bad block remapping), then I don't see any reason it can't be done
> in device mapper. The 'smarts' of mtdblock could in fact be pulled up

There is nothing smart about mtdblock.  And mtdblock has nothing to do
with UBI.

> a level. As I've pointed out already, you can already easily address
> issues two, four, and five with device mapper layers.
> 
> If instead you still want the "NAND-ness" of the device exposed at the
> top level so things can do raw eraseblock I/O more efficiently, then I
> think instead of duplicating the device mapper framer, we should
> instead think about how to integrate NAND devices more closely with
> the block layer.
> 
> In the end, a block device is something which does random access
> block-oriented I/O. Disk and NAND both fit that description.

NAND very much doesn't fit the "random access" part of that.  For writes
you have to write in incrementing pages within eraseblocks.

UBI is about maximizing the number of available eraseblocks to efficiently
wear-level across the largest possible area on a flash chip.  MTD itself
contains no higher-level capabilities to deal with this, and UBI uses the
underlying MTD device directly, not through ioctls.  This allows existing
flash specific users (e.g. JFFS2) to run on top of UBI with minimal changes.

Your idea does have some merit, however I believe your focus is misplaced.
Rather than convert UBI to device mapper and somehow try to make it work
through mtdblock (sic), perhaps what should be done is come up with a
better interface for MTD to present itself as a block device.  I would
still find that troubling though.

josh
