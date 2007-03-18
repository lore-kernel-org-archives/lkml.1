Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXCRTax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXCRTax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXCRTax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:30:53 -0400
Received: from waste.org ([66.93.16.53]:44410 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbXCRTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:30:51 -0400
Date: Sun, 18 Mar 2007 14:18:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070318191812.GM4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain> <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174236579.17249.6.camel@sauron>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 06:49:39PM +0200, Artem Bityutskiy wrote:
> On Sun, 2007-03-18 at 11:27 -0500, Matt Mackall wrote:
> > Forgive my ignorance, but why did you not implement the two features
> > above as device mapper layers instead? A device mapper can arbitrarily
> > transform I/O addresses and contents and has direct access to the
> > mapped device's ioctl interfaces, etc.
> 
> Just because UBI is designed for flash devices, not block devices. Note,
> UBI is not for MMC/USB stick/SC/etc flashes, which are used as block
> devices, but for _bare_ flashes.
> 
> Please, glance here to find more information about the different between
> flashes and block devices:
> 
> http://www.linux-mtd.infradead.org/faq/general.html#L_mtd_vs_hdd

I'm well aware of all that. I wrote a NAND driver just last month.
Let's consider this table:

HARD drives                          MTD device
Consists of sectors                  Consists of eraseblocks
Sectors are small (512, 1024 bytes)  Eraseblocks are larger (32KiB, 128KiB)
read sector and write sector         read, write, and erase block
Bad sectors are re-mapped            Bad eraseblocks are not hidden
HDD sectors don't wear out	     Eraseblocks get worn-out

If the end goal is to end up with something that looks like a block
device (which seems to be implied by adding transparent wear leveling
and bad block remapping), then I don't see any reason it can't be done
in device mapper. The 'smarts' of mtdblock could in fact be pulled up
a level. As I've pointed out already, you can already easily address
issues two, four, and five with device mapper layers.

If instead you still want the "NAND-ness" of the device exposed at the
top level so things can do raw eraseblock I/O more efficiently, then I
think instead of duplicating the device mapper framer, we should
instead think about how to integrate NAND devices more closely with
the block layer.

In the end, a block device is something which does random access
block-oriented I/O. Disk and NAND both fit that description.

-- 
Mathematics is the supreme nostalgia of our time.
