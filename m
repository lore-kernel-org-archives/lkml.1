Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbXFNUm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbXFNUm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFNUmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:42:53 -0400
Received: from lazybastard.de ([212.112.238.170]:54937 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXFNUmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:42:52 -0400
Date: Thu, 14 Jun 2007 22:38:01 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Cc: DervishD <lkml@dervishd.net>
Subject: Re: ext2 on flash memory
Message-ID: <20070614203800.GG31984@lazybastard.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org> <20070614201714.GC1928@DervishD>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614201714.GC1928@DervishD>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 June 2007 22:17:14 +0200, DervishD wrote:
>  * Jörn Engel <joern@logfs.org> dixit:
> > So let us look at the problems and how they interact with filesystems.
> > 
> > 1. Write overhead
> > 
> > If a filesystem only writes a small amount of data, typically 512 or
> > 4096 bytes, smartmedia has to erase and write a full block.  Most
> > flashes used in embedded systems has block sizes of 128KiB or so.  Most
> > flashes used for smartmedia have 16KiB.  Writing 16KiB when the
> > filesystem only requests writing 4KiB increases the wear 4x and reduces
> > performance 4x.
> 
>     But this is not easily addressable by ext2... or FAT. Even if you
> use 16KiB blocks in ext2, sometimes you will be writing only 512 bytes.
> And FAT will be even worse, I imagine, when using 512-byte blocks. Won't
> buffer cache (under Linux) alleviate this problem?

Sometimes writing 512 bytes is not a big problem.  If 99% of the writes
are large, everything will be fine.  But with a 32x increase from 512
byte writes, those really should be rare.

> > 2. Wear leveling
> > 
> > Wear leveling happens implicitly by picking a different physical block
> > from the spares on each write.  However, some blocks are never used.  If
> > a physical block is mapped to a logical block that never gets written,
> > it is out of the rotation.  Two seperate 1024-block areas have their
> > internal wear leveling each, but nothing is spreading high wear from one
> > area to another.
> 
>     I thought that wear leveling wasn't local to a group of blocks. This
> means that you can destroy a flash memory by writing to the same
> positions... which is a very common usage pattern.

That is correct.  Noticing this will take a while, though.  Even the
worst chips sold today seem to have a manufacturer guarantee of 10.000
erases per block.  Across a 16MB area, that means you have to write
160GB of data to that one area before you enter the danger zone.
Significantly less with static data around, but still a lot.

And even when that happens, the chips doesn't suddenly explode on the
10.001st erase.  Your chances of getting correctable or uncorrectable
errors will increase, though.

For the majority of use cases, such a behaviour is good enough.  It
beats floppies hands down.  You will never wear them out with your
digital camera or mp3 player.  Using it instead of a hard disk in your
notebook may be a little risky, though.

> > 4. FAT requirement
> > 
> > When I claimed there was nothing more to smartmedia, I was actually
> > lying.  Smartmedia has the odd requirement that only FAT is supported as
> > a filesystem.  In fact, the specifications describe FAT in great detail.
> 
>     Right, but I've seen many people using their pendrives with ext2
> with no problems (e.g. for SLAX). So, what do you mean by "supported"?
> If a filesystem can be used with the memory, do you mean that wear
> leveling and other characteristics of the flash memory are tailored for
> FAT? or do you mean you cannot use reliably (read: you will lose data)
> other filesystems?

It doesn't matter much what I mean.  The question is how the
manufacturer of your device interpreted it.  Most likely ext2 will work
just fine within the limitations I've outlined.

What changes is the failure mode.  Floppies died from storing them in a
dark and cool place.  Some were sold brand-new and dead.  Disks die from
random, mostly mechanical, failures at a rate of 7% per years in a
Google setup.  Flash usually dies from writing to it, the more you write
the faster it dies.

So as long as you rarely write, pick any filesystem you like.  The
choice only matters when you write a lot.

> > a) Do wear leveling!
> > 
> > Smartmedia wear leveling is limited to within areas.  Any cross-device
> > wear leveling must be done by the filesystem.  FAT does that fairly
> > well.  The Ext family doesn't.
> 
>     Cross-device wear leveling? I don't understand, sorry O:)

Wear leveling across the whole device, not just one area.

>     Thanks for your explanation, it has been very educational :)

No worries!

Jörn

-- 
Homo Sapiens is a goal, not a description.
-- unknown
