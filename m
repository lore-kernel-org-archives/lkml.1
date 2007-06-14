Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbXFNRuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbXFNRuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXFNRuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:50:02 -0400
Received: from lazybastard.de ([212.112.238.170]:49856 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbXFNRuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:50:00 -0400
Date: Thu, 14 Jun 2007 19:45:10 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070614174509.GB31984@lazybastard.org>
References: <20070611101319.GA14284@DervishD>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070611101319.GA14284@DervishD>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 June 2007 12:13:19 +0200, DervishD wrote:
> 
>     I was wondering: is there any reason not to use ext2 on an USB
> pendrive? Really my question is not only about USB pendrives, but any
> device whose storage is flash based. Let's assume that the device has a
> good quality flash memory with wear leveling and the like...

Reading through the thread I noticed a lot of guesswork and a total lack
of understanding about how the pendrive actually works.  Everyone treats
it is a black box that has "wear leveling".  So let me crack the box
open to some degree.

Nearly two years ago I have spoken to a person that reverse engineered
the behaviour of several chips used in pendrives.  At the time that
reverse engineering apparently covered most of the market.  The details
were quite lengthy but can be condensed to two words: Smartmedia format.

Smartmedia is a very simple format and can easily be studied.  Afaik
access to the specs only requires registration.  Alternatively one can
study drivers/usb/storage/alauda.c, which implements the format.  I will
summarize the important bits below, assuming the reader has a good
understanding about what flash is.


All flash memory is split into zones of usually 1024(1) erase blocks.
Within each zone, 1000 logical blocks are mapped to the 1024 physical
blocks.  That leaves 24 spare one.  Normally the spare blocks are erased
and contain no data.  The 1000 mapped physical blocks contain the
associated logical number somewhere in the OOB area.

Reading from smartmedia first requires reading all logical numbers from
all physical blocks.  With this information a simple map, essentially a
1024-entry array is created.  Once the map is set up, logical number get
translated to physical ones with a simple lookup.

Writing is slightly more complicated.  First one of the spare blocks is
selected.  New data is written to the spare block.  If only a partial
block is written, the remainder has to be copied from the old block.
After the new block is written, the old block is erased and becomes a
spare.

If the chip loses power during a write, several physical block may
contain the same logical number.  In that case the ECC information is
used to verify each of the blocks.  If one of the block was not written
completely, the other is used.  If one block has ECC errors, the other
is used.  If both are correct, a random one is used.

That's all there is to smartmedia format.  It is _very_ simple.  It is
also surprisingly efficient, although it does have some shortcomings.
So let us look at the problems and how they interact with filesystems.

1. Write overhead

If a filesystem only writes a small amount of data, typically 512 or
4096 bytes, smartmedia has to erase and write a full block.  Most
flashes used in embedded systems has block sizes of 128KiB or so.  Most
flashes used for smartmedia have 16KiB.  Writing 16KiB when the
filesystem only requests writing 4KiB increases the wear 4x and reduces
performance 4x.

2. Wear leveling

Wear leveling happens implicitly by picking a different physical block
from the spares on each write.  However, some blocks are never used.  If
a physical block is mapped to a logical block that never gets written,
it is out of the rotation.  Two seperate 1024-block areas have their
internal wear leveling each, but nothing is spreading high wear from one
area to another.

So if a theoretical filesystem would only ever write to the same logical
block, smartmedia can spead the wear over 25 blocks or less.  Less, if
any physical blocks are bad and cannot get used (2).

More realistically, if Ext3 is having a very hot area - the journal -
that area is not getting any wear leveling worth mentioning.  Journaling
filesystems on smartmedia are a bad idea.  Most journals are bigger than
a smartmedia area, which is usually 1000 * 16KiB.  The round-robin
access pattern of the journal already provides perfect wear leveling
_within that area_.  Smartmedia does not add anything.

3. Hidden caching

Some chip designers seem to have noticed the 4x write overhead and try
to outsmart the filesystem.  Their chips start writing the new block,
but don't copy data from the old block just yet.  Instead they wait for
further write requests, hoping to write adjacent data to the same block.

If the power fails while the chip is waiting for further data, smarmedia
format requires the unfinished block to get erased and its content to
get discarded.  What happens if the user just typed "sync" and yanks the
pendrive as soon as the command returns is anyone's guess.  How many
people ever considered their pendrives to perform caching and require
proper barriers?

4. FAT requirement

When I claimed there was nothing more to smartmedia, I was actually
lying.  Smartmedia has the odd requirement that only FAT is supported as
a filesystem.  In fact, the specifications describe FAT in great detail.
I have already seen FTLs(3) that deliberately look into the FAT and
pre-erase blocks if the corresponding files have been deleted from the
FAT.  Let's just hope they always detect non-FAT filesystems.


After all this, my recommendation for filesystems is to do several
things:

a) Do wear leveling!

Smartmedia wear leveling is limited to within areas.  Any cross-device
wear leveling must be done by the filesystem.  FAT does that fairly
well.  The Ext family doesn't.

b) Write aligned 16KiB blocks

Anything else will cause write overhead and kill both performance and
later the complete device.  Most hard disk filesystem do this anyway.
Any effort to reduce head seek time and rotational delay will also help
your pendrive.


(1) Some smaller chips have a single zone of 256 or 512 blocks instead.
    Also, the first block in the first zone gets special treatment, so
    the first zone effectively only has 1023 blocks.
(2) Most manufacturers specify that their chips has <3% bad blocks.  24
    spare blocks for 1000 logical ones makes 2.4%.  It is conceivable
    that the often-quoted <3% number is designed to work with
    smartmedia.
(3) Flash Translation Layers - any format that implements block device
    behaviour on flash memory.  Smartmedia is but one example, although
    a very popular one.

Jörn

-- 
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan
