Return-Path: <linux-kernel-owner+w=401wt.eu-S1030808AbXCTAfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030808AbXCTAfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030807AbXCTAfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:35:44 -0400
Received: from www.osadl.org ([213.239.205.134]:55114 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030808AbXCTAfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:35:43 -0400
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
In-Reply-To: <20070319223205.GZ4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 01:42:46 +0100
Message-Id: <1174351366.13341.739.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 17:32 -0500, Matt Mackall wrote:
> > > If a static volume is simply a non-dynamic volume, then device mapper
> > > can do that too. And countless other things. Which is not an aside.
> > > UBI growing to do all the things that device mapper does is exactly
> > > the thing we should be seeking to avoid.
> > 
> > No it can't and device mapper sits on top of block devices. FLASH is no
> > block device. Period.
> 
> Which of the following two properties does it lack?
> 
> - discrete blocks
> - non-sequential access to blocks
> 
> When you do the obvious s/blocks/eraseblocks/, this appears to be
> true.

It appears to be, but it is not. You enforce semantics on a device,
which it does not have.

> Saying "but I can't do I/O smaller than the blocksize" doesn't change
> this any more than it would for disks.

There is a huge difference. Disk block size is 512 byte and FLASH block
size is min 16KiB and up to 256KiB.

Just do the math:

Write sampling data streams in 2KiB chunks to your uber devicemapper on
a 1GiB device with 64KiB erase block size:

Fine grained FLASH aware writes allow 32 chunks in a block without
erasing the block.

Your method erases the block 32 times to write the same amount of data.

Result: You wear out the flash 32 times faster. Cool feature.

> Saying "but I can do smaller I/O efficiently in some circumstances"
> also doesn't change it.

We can do it under _any_ circumstances and that _does_ change it.
Implementing a clever block device layer on top of UBI is simple and
would provide FLASH page sized I/O, i.e. 2Kib in the above example.

> In historical UNIX, some tapes were block devices too. Because they
> supported seek().

I'm impressed. How exactly are "some tapes" comparable to FLASH chips ?

Your next proposal is to throw away MTD-utils and use "mt" instead ?

> > Device mapper can not provide a simple easy to decode scheme for boot
> > loaders. We need to be able to boot out of 512 - 2048 byte of NAND FLASH
> > and be able to find the kernel or second stage boot loader in this
> > unordered device.
> > 
> > And no, fixed addresses do not work. Do you want to implement device
> > mapper into your Initialial Bootloader stage ?
> 
> This is exactly the same problem as booting on a desktop PC. But
> somehow LILO manages. My first Linux box had a hell of a lot less disk
> than the platform I bootstrapped (and wrote NAND drivers for) last
> month had in NAND.

No, it is not. You get the absolute sector address of your second stage
and this is a complete nobrainer. The translation is done in the DISK
device.

You simply ignore the fact, that inside each disk, USB Stick, CF-CARD,
whatever - there is a more or less intellegent controller device, which
does the mapping to the physical storage location. There is _NO_ such
thing on a bare FLASH chip.

It does not matter, whether your embedded device had more NAND space
than my old CP/M machines floppy. It simply matters, that even the old
CP/M floppy device had some rudimentary intellence on board.

Furthermore I want to be able to get the bitflip correction on my second
stage loader / kernel in the same safe way as we do it for everything
else and still be able to bootstrap that from an extremly small
bootloader.

> > > If the right way is instead to extend the block layer and device
> > > mapper to encompass the quirks of NAND in a sensible fashion, then UBI
> > > should not go in.
> > 
> > No, block layer on top of FLASH needs 80% of the functionality of UBI in
> > the first place.
> 
> Incorrect. A block-based filesystem on top of flash needs this
> functionality. But a block device suitable to device mapper layering
> (which then provides the functionality) does not.

How exactly does device mapper:

A) across device wear levelling ?
B) dynamic partitioning for FLASH aware file systems ?
C) across device wear levelling for FLASH aware file systems ?
D) background bit-flip corrections (copying affected blocks and recylce
the old one) ?
E) allow position independent placement of the second stage bootloader ?

> > You need to implement a clever journalling block device
> > emulator in order to keep the data alive and the FLASH not weared out
> > within no time. You need the wear levelling, otherwise you can throw
> > away your FLASH in no time.
> 
> And that's why it's in my picture.

Yes, it is in your picture, but:

1) it excludes FLASH aware file systems and UBI does not.
2) your picture does still not explain how it does achive the above A),
B), C), D) and E)

Your extra path for partitioning(4) and JFFS2 is just a weird hack,
which makes your proposal completely absurd.

> > > Let me draw a picture so we have something to argue about:
> > > 
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
> > > Notes:


Let me draw an UBI picture:

                                   VFS -Layer
                                       |               
                             (Future VFS-crypto)			
                            /                    \
                           |                      |
          ______ device mapper / fs               |
        /                 |                       |
      /                   |                       |
     |          Do whatever you don't             |
     |          want to do with FLASH             |
     |          whether it makes sense            |
     |          or not.                           |
     |                     |                      |
Block layer   UBI block device    Flash aware filesystems
     |                      \    /
   device                    \  /
   driver                      |
     |                         |
_____|_______                  |
|           |                  |
| Device    |                 UBI
| resident  |                  |
| "UBI"     |                  |
|___________|                  |
                               |                     
                            MTD-CORE
                               |      
                       nand base driver
                    /          |         \
             device driver  device driver  device driver
                   |              |
                 NAND            NAND          NAND

No notes: it's simple and self explaining.

> > > 1. This would provide a block device that allowed writing pages and
> > >    a secondary method for erasing whole blocks as well as a method for
> > >    querying/setting out of band information.
> > 
> > Forget about OOB data. OOB data is reserved for ECC. Please read the
> > recommendations of the NAND FLASH manufacturers. NAND gets less reliable
> > with higher density devices and smaller processes.
> > 
> > > 2. This would hide erase blocks either by using an embedded table or
> > >    out of band info. This could stack on top of block concatenation if
> > >    desired.
> > 
> > Hide erase blocks ? UBI does not hide anything. It maps logical
> > eraseblocks, which are exposed to the clients to arbitrary physical
> > eraseblocks on the FLASH device in order to provide across device wear
> > levelling.
> 
> Sorry, I meant hiding bad blocks here. That's why this layer was
> labeled "bad block remapping".

Oh well, a seperate bad block remapper. And how is the logical mapping
of wear levelled erase blocks done ?

> > > 3. This would provide wear leveling, and probably simultaneously
> > >    provide relatively efficient and safe access to write sector 
> > >    and page-sized I/O. Below this level, things had better be
> > >    comfortable with the limitations of NAND if they want to work well.
> > 
> > I don't see how this provides across device wear levelling.
> 
> Because the layer immediately beneath it ("block concatenation") takes
> N devices and presents one logical device.

And how is the wear levelling done on this logical device in
devicemapper ? 

How is ensured, that the wear average is maintained also across the
partitions which are used by JFFS2 or other FLASH aware filesystems ?

> > > 4. JFFS2 has its own wear-leving scheme, as do several other
> > >    filesystems, so they probably want to bypass this piece of the stack.
> > 
> > JFFS2 on top of UBI delegates the wear levelling to UBI, as JFFS2s own
> > wear levelling sucks. 
> 
> Ok, fine. How about LogFS, then?

LogFS can easily leverage UBI's wear algorithm.

> > > 5. We don't reimplement higher pieces of the stack (dm-crypt,
> > >    snapshot, etc.).
> > 
> > Why should we reimplement that ?
> 
> So that you can get encryption and snapshot, etc.?

1. On top of a clever block device.

2. UBI can do snapshots by design.

3. Encryption should be done on the VFS layer and not below the
filesystem layer. Doing it inside the block layer or the device mapper
is broken by design.

> > > 6. We make some things possible that simply aren't otherwise.
> > >
> > > And this picture isn't even interesting yet. Imagine a dm-cache layer
> > > that caches data read from disks in high-speed flash. Or using
> > > dm-mirror to mirror writes to local flash over NBD or to a USB drive.
> > > Neither of these can be done 'right' in a stack split between device
> > > mapper and UBI.
> > 
> > Err. Implement a clever block layer on top of UBI and use all the
> > goodies you want including device mapper.
> 
> If I wanted to have both device mapper and device mapper's little
> brother in my kernel, I wouldn't have started this thread.

You still did not explain how devicemapper does:

- across device wear levelling
- dynamic partitioning for FLASH aware file systems
- across device wear levelling for FLASH aware file systems
- simple boot loader support
- fine grained I/O

UBI is not devicemappers little brother. It is the software version of
the silicon in a CF-CARD / USB-Stick, but it does a better job and
allows clever usage of FLASH aside of enforcing eraseblock sized I/O
units. Does your CF-Card / USB-Stick do that ? 

Just think about the 1GiB USB stick, which would present you 64KiB I/O
units instead of 2KiB ones.

Your signature is a nice intellectual signboard, but the ancient simple
rule of three just tells me, that you are off by factor 32.

	tglx


