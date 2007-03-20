Return-Path: <linux-kernel-owner+w=401wt.eu-S965291AbXCTBSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbXCTBSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965684AbXCTBSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:18:20 -0400
Received: from waste.org ([66.93.16.53]:43836 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291AbXCTBST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:18:19 -0400
Date: Mon, 19 Mar 2007 20:05:29 -0500
From: Matt Mackall <mpm@selenic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070320010529.GC4892@waste.org>
References: <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174351366.13341.739.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 01:42:46AM +0100, Thomas Gleixner wrote:
> On Mon, 2007-03-19 at 17:32 -0500, Matt Mackall wrote:
> > > > If a static volume is simply a non-dynamic volume, then device mapper
> > > > can do that too. And countless other things. Which is not an aside.
> > > > UBI growing to do all the things that device mapper does is exactly
> > > > the thing we should be seeking to avoid.
> > > 
> > > No it can't and device mapper sits on top of block devices. FLASH is no
> > > block device. Period.
> > 
> > Which of the following two properties does it lack?
> > 
> > - discrete blocks
> > - non-sequential access to blocks
> > 
> > When you do the obvious s/blocks/eraseblocks/, this appears to be
> > true.
> 
> It appears to be, but it is not. You enforce semantics on a device,
> which it does not have.
> 
> > Saying "but I can't do I/O smaller than the blocksize" doesn't change
> > this any more than it would for disks.
> 
> There is a huge difference. Disk block size is 512 byte and FLASH block
> size is min 16KiB and up to 256KiB.
> 
> Just do the math:
> 
> Write sampling data streams in 2KiB chunks to your uber devicemapper on
> a 1GiB device with 64KiB erase block size:
> 
> Fine grained FLASH aware writes allow 32 chunks in a block without
> erasing the block.
> 
> Your method erases the block 32 times to write the same amount of data.

Sigh. That's the current /dev/mtdblock method, not my method. You're too
fixated on what you think I'm saying to hear what I'm saying.

> > Saying "but I can do smaller I/O efficiently in some circumstances"
> > also doesn't change it.
> 
> We can do it under _any_ circumstances and that _does_ change it.
> Implementing a clever block device layer on top of UBI is simple and
> would provide FLASH page sized I/O, i.e. 2Kib in the above example.

Yes. I know. I've written a complete (non-Linux) FTL. I know what's
entailed.
 
> > In historical UNIX, some tapes were block devices too. Because they
> > supported seek().
> 
> I'm impressed. How exactly are "some tapes" comparable to FLASH chips ?
> 
> Your next proposal is to throw away MTD-utils and use "mt" instead ?

Don't be an ass. I'm pointing out that not all block devices are disks.
 
> > > Device mapper can not provide a simple easy to decode scheme for boot
> > > loaders. We need to be able to boot out of 512 - 2048 byte of NAND FLASH
> > > and be able to find the kernel or second stage boot loader in this
> > > unordered device.
> > > 
> > > And no, fixed addresses do not work. Do you want to implement device
> > > mapper into your Initialial Bootloader stage ?
> > 
> > This is exactly the same problem as booting on a desktop PC. But
> > somehow LILO manages. My first Linux box had a hell of a lot less disk
> > than the platform I bootstrapped (and wrote NAND drivers for) last
> > month had in NAND.
> 
> No, it is not. You get the absolute sector address of your second stage
> and this is a complete nobrainer. The translation is done in the DISK
> device.

LILO and friends manage to boot systems that use software RAID and
LVM. There are multiple methods. Some use block lists, some use tiny
boot partitions, etc. All of them are applicable to controllerless NAND.

> You simply ignore the fact, that inside each disk, USB Stick, CF-CARD,
> whatever - there is a more or less intellegent controller device, which
> does the mapping to the physical storage location. There is _NO_ such
> thing on a bare FLASH chip.

How many times do I have to tell you that I wrote a driver for
controllerless NAND just last month?

> How exactly does device mapper:
> 
> A) across device wear levelling ?

The same way UBI does, but encapsulated in a device mapper layer.

> B) dynamic partitioning for FLASH aware file systems ?

See above.

> C) across device wear levelling for FLASH aware file systems ?

See above.

> D) background bit-flip corrections (copying affected blocks and recylce
> the old one) ?

See above.

> E) allow position independent placement of the second stage bootloader ?

See way above to my LILO response.

> > > You need to implement a clever journalling block device
> > > emulator in order to keep the data alive and the FLASH not weared out
> > > within no time. You need the wear levelling, otherwise you can throw
> > > away your FLASH in no time.
> > 
> > And that's why it's in my picture.
> 
> Yes, it is in your picture, but:
> 
> 1) it excludes FLASH aware file systems and UBI does not.
> 2) your picture does still not explain how it does achive the above A),
> B), C), D) and E)
> 
> Your extra path for partitioning(4) and JFFS2 is just a weird hack,
> which makes your proposal completely absurd.

No, it's just there to show the flexibility of device mapper. But I have
the sneaking suspicion you have no idea how device mapper works.

In brief: device mapper takes one or more devices, applies a mapping
to them, and returns a new device. For example, take various spans of
/dev/hda1 and /dev/sda3 and present them as new-device1. Take
new-device1 and transform it with dm-crypt to get new-device2. The
kernel doesn't decide how to do this, any more than it decides where
to mount your filesystems. Userspace does.
 
> > > > 5. We don't reimplement higher pieces of the stack (dm-crypt,
> > > >    snapshot, etc.).
> > > 
> > > Why should we reimplement that ?
> > 
> > So that you can get encryption and snapshot, etc.?
> 
> 1. On top of a clever block device.
> 
> 2. UBI can do snapshots by design.

Oh, so you HAVE reimplemented it.

> 3. Encryption should be done on the VFS layer and not below the
> filesystem layer. Doing it inside the block layer or the device mapper
> is broken by design.

That's highly debatable and not a topic for this thread.

-- 
Mathematics is the supreme nostalgia of our time.
