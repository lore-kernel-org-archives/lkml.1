Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbXCSS4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbXCSS4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXCSS4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:56:30 -0400
Received: from www.osadl.org ([213.239.205.134]:37353 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751672AbXCSS42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:56:28 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Matt Mackall <mpm@selenic.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319170838.GP4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 20:03:30 +0100
Message-Id: <1174331010.13341.548.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

On Mon, 2007-03-19 at 12:08 -0500, Matt Mackall wrote:
> On Sun, Mar 18, 2007 at 03:31:50PM -0500, Josh Boyer wrote:
> > On Sun, Mar 18, 2007 at 02:18:12PM -0500, Matt Mackall wrote:
> > > 
> > > I'm well aware of all that. I wrote a NAND driver just last month.
> > > Let's consider this table:
> > > 
> > > HARD drives                          MTD device
> > > Consists of sectors                  Consists of eraseblocks
> > > Sectors are small (512, 1024 bytes)  Eraseblocks are larger (32KiB, 128KiB)
> > > read sector and write sector         read, write, and erase block
> > > Bad sectors are re-mapped            Bad eraseblocks are not hidden
> > > HDD sectors don't wear out	     Eraseblocks get worn-out
> >  N/A                                   NAND flash addressed in pages
> >  N/A                                   NAND flash has OOB areas
> >  N/A (?)                               NAND flash requires ECC
> 
> Disks have OOB areas with ECC, it's just nicely hidden inside the
> drive. They also typically have physical sectors bigger than 512
> bytes, again hidden.

The difference is that the harddrive has an intellegent controller,
which hides all this away. NAND FLASH has not and we have to do it in
software.

> > > If the end goal is to end up with something that looks like a block
> > > device (which seems to be implied by adding transparent wear leveling
> > 
> > Nope, not the end goal.  It's more about wear-leveling across the entire
> > flash chip than it is presenting a "block like" device.
> 
> It seems to be about spanning devices and repartitioning as well.
> Hence the analogy with LVM.

Yes, UBI is a kind of LVM for FLASH and we did think quite a time about
reusing LVM before we went the UBI way.

> > > and bad block remapping), then I don't see any reason it can't be done
> > > in device mapper. The 'smarts' of mtdblock could in fact be pulled up
> > 
> > There is nothing smart about mtdblock.  And mtdblock has nothing to do
> > with UBI.
> 
> Note the scare quotes. Device mapper runs on top of a block device.
> And mtdblock is currently the block interface that MTD exports. And it
> has 'smarts' that hide handling of sub-eraseblock I/O. I'm clearly
> talking about an approach that doesn't involve UBI at all.

MTD block has no 'smarts' at all. It is a stupid and broken hack, which
you can utilize to lose data and wear your FLASH out. 

> > > In the end, a block device is something which does random access
> > > block-oriented I/O. Disk and NAND both fit that description.
> > 
> > NAND very much doesn't fit the "random access" part of that.  For writes
> > you have to write in incrementing pages within eraseblocks.
> 
> And? You can't do I/O smaller than a sector on a disk.

Should we export block devices with 16/32/64/128 KiB size ? If not, we
would need to put a lot of clever functionality into the mtd block
device code, which we decided to put into UBI, so FLASH aware file
systems can use this shared functionality too.

If someone wants to implement an intellegent mtd block device, which
allows to run arbitrary filesystems, then it should be done on top of
UBI. It's not rocket science, but nobody bothers as we have functional
FLASH filesystems which do their job better w/o any notion of a block
device.

A disk _IS_ fundamentally different to FLASH and all the magic which is
done inside of CF-Cards and USB-Sticks is just hiding this away. Most of
the controller chips in these devices are broken and I would never ever
store any important data on such.

The main points of UBI are:

- wear levelling across the complete device
- background handling of bitflips
- safe updates
- handling of static volumes, which are easily accessible for
bootloaders

Nothing of this is anyway near of LVM and disks. The only LVM alike
feature is dynamic creation/deletion/resizing of volumes.

	tglx


