Return-Path: <linux-kernel-owner+w=401wt.eu-S1030810AbXCTAgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030810AbXCTAgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030814AbXCTAgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:36:38 -0400
Received: from www.osadl.org ([213.239.205.134]:55123 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030812AbXCTAgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:36:37 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Matt Mackall <mpm@selenic.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319213628.GW4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 01:43:41 +0100
Message-Id: <1174351422.13341.740.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 16:36 -0500, Matt Mackall wrote:
> On Mon, Mar 19, 2007 at 11:06:33PM +0200, Artem Bityutskiy wrote:
> > On Mon, 2007-03-19 at 14:54 -0500, Matt Mackall wrote:
> > > The issue is 14000 lines of patch to make a parallel subsystem.
> > 
> > Parallel system exists since very long. One is
> > flash->SW_or_HW_FTL->all_blkdev_stuff. The other is MTD->JFFS2. Think
> > about _why_ there are 2 of them. Hint - reliability, performance. Your
> > ranting basically says that only the first one makes sense. This is not
> > true.
> 
> A better way would be for MTD to deliver a block dev with a rich
> enough interface for JFFS2 to use efficiently in the first place. Yes,
> I know that can't be done with the current block dev layer. But that's
> what the source is for.

Why the hell would JFFS2 need a block device interface ? 

What's the gain ?

> > We enhance the second branch, not the first, please, realize this. Both
> > branches have their user base, and have always had.
> > 
> > >                      iSCSI/nbd(6)
> > >                           |
> > > filesystem {        swap  |  ext3        ext3     jffs2
> > >                       \   |   |            |       /
> > >                /       \  | dm-crypt->snapshot(5) /
> > > device mapper -|        \ \   |                  /
> > >                |         partitioning           /
> > >                |              |          partitioning(4)
> > >                |        wear leveling(3)  /
> > >                |              |          /
> > >                |      block concatenation
> > >                |       |    |    |     |
> > >                \      bad block remapping(2)   
> > >                        |    |    |     |
> > > MTD raw block {     raw block devices with no smarts(1)
> > >                       /     |     \      \
> > > hardware {         NAND    NAND   NAND   NAND
> > 
> > Matt, as I pointed in the first mail, flash != block device. 
> 
> And as I pointed out, you're wrong. It is both block oriented
> (eraseBLOCK??) and random access. That's what a block device is. The
> fact that it doesn't look like the other things that Linux currently
> calls a block device and supports well is another matter.

It does well matter, as it is not a block device. It is a FLASH device
and you can do as much comparisons of eraseBLOCK as you want, you do not
turn FLASH into a DISK. 

Again: Disks (including CF-Cards and USB-Sticks) have intellegent
controllers, which abstract the hardware oddities away and present you a
block device.

> > In your picture I see NAND->MTD raw block. So am I right that you
> > assume that we already have a decent FTL? The fact is that we do
> > not.
> 
> No. Look at the picture for more than two seconds, please. 
> 
> I can tell you didn't do this because you didn't manage to find (1)
> which explicitly says "with no smarts". And you also cut out the footnote
> where I explained what I meant by "with no smarts".
>
> Find the spots marked (2) and (3). These are your FTL. 

And where please are (2) and (3) inside of device mapper ?

> > Please, bear in mind that decent FTL is difficult and an FS on top of
> > FTL is slow, FTL hits performance considerably.
> 
> ...and if you'd actually looked at the picture, you'd have seen JFFS2
> bypassing it. Along with another footnote explaining it.

The (4) partitioning and JFFS2 on top is a step back from the current
UBI functionality. Now we can have resizable partitioning even for JFFS2
and JFFS2 can utilize the UBI wear levelling, which is way better than
the crude heuristics of JFFS2.

You want to force FLASH into device mapper for some strange and no
obvious reason. Just the coincidence of "eraseBLOCK" and "BLOCKdevice"
is not really convincing. 

You impose the usage of eraseblock size on FLASH, which is simply wrong:

DISK has a 1:1 relationship of "eraseblock" and minimal I/O. FLASH has
not. I did the math in a different mail and I'm not buying your factor
32 FLASH life time reduction for the price of having a bunch of lines of
code less in the kernel.

If you really consider to run ext3, xfs or whatever on top of FLASH,
please go and do the homework on CF-Cards and USB-Sticks. Run them into
the fast wearout death. And device mapper does not help anything to
avoid that. Running ext3 on top of FLASH with a minimal I/O size of
erase block size is simply braindead.

	tglx


