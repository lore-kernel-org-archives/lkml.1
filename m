Return-Path: <linux-kernel-owner+w=401wt.eu-S1030528AbXCSVbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbXCSVbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXCSVbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:31:00 -0400
Received: from www.osadl.org ([213.239.205.134]:50399 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964988AbXCSVa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:30:59 -0400
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
In-Reply-To: <20070319195442.GT4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 22:05:29 +0100
Message-Id: <1174338329.13341.633.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 14:54 -0500, Matt Mackall wrote:
> > (UBI also has static volumes which LVM doesn't but that is an aside.)
> 
> If a static volume is simply a non-dynamic volume, then device mapper
> can do that too. And countless other things. Which is not an aside.
> UBI growing to do all the things that device mapper does is exactly
> the thing we should be seeking to avoid.

No it can't and device mapper sits on top of block devices. FLASH is no
block device. Period.
 
Device mapper can not provide a simple easy to decode scheme for boot
loaders. We need to be able to boot out of 512 - 2048 byte of NAND FLASH
and be able to find the kernel or second stage boot loader in this
unordered device.

And no, fixed addresses do not work. Do you want to implement device
mapper into your Initialial Bootloader stage ?

> > That's why I suggested fixing the MTD layers that present block devices
> > first in the part of my reply that you cut off.  It seems to me that
> > you're really after getting flash to look like a block device, which
> > would enable device mapper to be used for something similar to UBI.
> > That's fine, but until someone does that work UBI fills a need, has
> > users, and has an existing implementation.
> 
> False starts that get mainlined delay or prevent things getting done
> right. The question is and remains "is UBI the right way to do
> things?" Not "is UBI the easiest way to do things?" or "is UBI
> something people have already adopted?"
> 
> If the right way is instead to extend the block layer and device
> mapper to encompass the quirks of NAND in a sensible fashion, then UBI
> should not go in.

No, block layer on top of FLASH needs 80% of the functionality of UBI in
the first place. You need to implement a clever journalling block device
emulator in order to keep the data alive and the FLASH not weared out
within no time. You need the wear levelling, otherwise you can throw
away your FLASH in no time.

> Let me draw a picture so we have something to argue about:
> 
>                      iSCSI/nbd(6)
>                           |
> filesystem {        swap  |  ext3        ext3     jffs2
>                       \   |   |            |       /
>                /       \  | dm-crypt->snapshot(5) /
> device mapper -|        \ \   |                  /
>                |         partitioning           /
>                |              |          partitioning(4)
>                |        wear leveling(3)  /
>                |              |          /
>                |      block concatenation
>                |       |    |    |     |
>                \      bad block remapping(2)   
>                        |    |    |     |
> MTD raw block {     raw block devices with no smarts(1)
>                       /     |     \      \
> hardware {         NAND    NAND   NAND   NAND
> 
> Notes:
> 1. This would provide a block device that allowed writing pages and
>    a secondary method for erasing whole blocks as well as a method for
>    querying/setting out of band information.

Forget about OOB data. OOB data is reserved for ECC. Please read the
recommendations of the NAND FLASH manufacturers. NAND gets less reliable
with higher density devices and smaller processes.

> 2. This would hide erase blocks either by using an embedded table or
>    out of band info. This could stack on top of block concatenation if
>    desired.

Hide erase blocks ? UBI does not hide anything. It maps logical
eraseblocks, which are exposed to the clients to arbitrary physical
eraseblocks on the FLASH device in order to provide across device wear
levelling.

This is fundamentaly different to device mapper. 

> 3. This would provide wear leveling, and probably simultaneously
>    provide relatively efficient and safe access to write sector 
>    and page-sized I/O. Below this level, things had better be
>    comfortable with the limitations of NAND if they want to work well.

I don't see how this provides across device wear levelling.

> 4. JFFS2 has its own wear-leving scheme, as do several other
>    filesystems, so they probably want to bypass this piece of the stack.

JFFS2 on top of UBI delegates the wear levelling to UBI, as JFFS2s own
wear levelling sucks. 

> 5. We don't reimplement higher pieces of the stack (dm-crypt,
>    snapshot, etc.).

Why should we reimplement that ?

> 6. We make some things possible that simply aren't otherwise.
>
> And this picture isn't even interesting yet. Imagine a dm-cache layer
> that caches data read from disks in high-speed flash. Or using
> dm-mirror to mirror writes to local flash over NBD or to a USB drive.
> Neither of these can be done 'right' in a stack split between device
> mapper and UBI.

Err. Implement a clever block layer on top of UBI and use all the
goodies you want including device mapper.

	tglx


