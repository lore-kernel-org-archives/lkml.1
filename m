Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbXCTGV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbXCTGV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 02:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXCTGV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 02:21:29 -0400
Received: from www.osadl.org ([213.239.205.134]:59667 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752804AbXCTGV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 02:21:28 -0400
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
In-Reply-To: <20070320010529.GC4892@waste.org>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070320010529.GC4892@waste.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 07:28:21 +0100
Message-Id: <1174372101.13341.775.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 20:05 -0500, Matt Mackall wrote:
> On Tue, Mar 20, 2007 at 01:42:46AM +0100, Thomas Gleixner wrote:
> > On Mon, 2007-03-19 at 17:32 -0500, Matt Mackall wrote:
> > > This is exactly the same problem as booting on a desktop PC. But
> > > somehow LILO manages. My first Linux box had a hell of a lot less disk
> > > than the platform I bootstrapped (and wrote NAND drivers for) last
> > > month had in NAND.
> > 
> > No, it is not. You get the absolute sector address of your second stage
> > and this is a complete nobrainer. The translation is done in the DISK
> > device.
> 
> LILO and friends manage to boot systems that use software RAID and
> LVM. There are multiple methods. Some use block lists, some use tiny
> boot partitions, etc. All of them are applicable to controllerless NAND.

Yes, by using fixed addresses, which is not what I want.

> > You simply ignore the fact, that inside each disk, USB Stick, CF-CARD,
> > whatever - there is a more or less intellegent controller device, which
> > does the mapping to the physical storage location. There is _NO_ such
> > thing on a bare FLASH chip.
> 
> How many times do I have to tell you that I wrote a driver for
> controllerless NAND just last month?

Wow. I'm impressed because I'm pulling my opinion out of thin air.

> > How exactly does device mapper:
> > 
> > A) across device wear levelling ?
> 
> The same way UBI does, but encapsulated in a device mapper layer.

Does the device mapper do that ?

> > B) dynamic partitioning for FLASH aware file systems ?
>
> See above.

Does the device mapper do that ?

> > C) across device wear levelling for FLASH aware file systems ?
> 
> See above.

Look at your own drawing. 

> > D) background bit-flip corrections (copying affected blocks and recylce
> > the old one) ?
> 
> See above.

Repeating patterns do not impress me. Your drawing tells otherwise

> > E) allow position independent placement of the second stage bootloader ?
> 
> See way above to my LILO response.

Neither LILO nor GRUB have search capabilities for randomly located
second stage loaders.

> > > > You need to implement a clever journalling block device
> > > > emulator in order to keep the data alive and the FLASH not weared out
> > > > within no time. You need the wear levelling, otherwise you can throw
> > > > away your FLASH in no time.
> > > 
> > > And that's why it's in my picture.
> > 
> > Yes, it is in your picture, but:
> > 
> > 1) it excludes FLASH aware file systems and UBI does not.
> > 2) your picture does still not explain how it does achive the above A),
> > B), C), D) and E)
> > 
> > Your extra path for partitioning(4) and JFFS2 is just a weird hack,
> > which makes your proposal completely absurd.
> 
> No, it's just there to show the flexibility of device mapper. But I have
> the sneaking suspicion you have no idea how device mapper works.

Sigh. Layering violation == flexibility.

> In brief: device mapper takes one or more devices, applies a mapping
> to them, and returns a new device. For example, take various spans of
> /dev/hda1 and /dev/sda3 and present them as new-device1. Take
> new-device1 and transform it with dm-crypt to get new-device2. The
> kernel doesn't decide how to do this, any more than it decides where
> to mount your filesystems. Userspace does.

I know how it works. But your blurb does not answer any of my questions.

> > > > > 5. We don't reimplement higher pieces of the stack (dm-crypt,
> > > > >    snapshot, etc.).
> > > > 
> > > > Why should we reimplement that ?
> > > 
> > > So that you can get encryption and snapshot, etc.?
> > 
> > 1. On top of a clever block device.
> > 
> > 2. UBI can do snapshots by design.
> 
> Oh, so you HAVE reimplemented it.

No, it already works

> > 3. Encryption should be done on the VFS layer and not below the
> > filesystem layer. Doing it inside the block layer or the device mapper
> > is broken by design.
> 
> That's highly debatable and not a topic for this thread.

I see, you define, what has to be discussed.

	tglx


