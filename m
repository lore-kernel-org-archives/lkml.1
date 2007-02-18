Return-Path: <linux-kernel-owner+w=401wt.eu-S965556AbXBRB7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965556AbXBRB7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXBRB7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:59:20 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49209 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965556AbXBRB7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:59:19 -0500
Date: Sat, 17 Feb 2007 20:04:30 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
Message-ID: <20070218020429.GE1038@crusty.rchland.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165751.5845.28503.sendpatchset@localhost.localdomain> <200702172214.55654.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702172214.55654.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 10:14:54PM +0100, Arnd Bergmann wrote:
> On Saturday 17 February 2007 17:57, Artem Bityutskiy wrote:
> > + * This unit is responsible for emulating MTD devices on top of UBI devices.
> > + * This sounds strange, but it is in fact quite useful to make legacy software
> > + * work on top of UBI. New software should use native UBI API instead.
> > + *
> > + * Gluebi emulated MTD devices of "MTD_UBIVOLUME" type. Their minimal I/O unit
> > + * size (mtd->writesize) is equivalent to the underlying flash minimal I/O
> > + * unit. The eraseblock size is equivalent to the logical UBI volume eraseblock
> > + * size.
> 
> This approach doesn't seem to make sense at all. If the MTD device interface
> is flawed, the right approach should be to fix that instead. After all,
> there are not many users of the MTD interface, so you should be able to
> adapt them.

No, the MTD interface isn't flawed.  gluebi is present to make things like
JFFS2 work on top of UBI volumes with very little adaptations.  If you go
changing _every_ MTD user to now use either an MTD device or a native UBI
device, then the code for those users just gets bloated.

> In fact, I would expect that there is much more reason to merge the existing
> MTD interface with the block interface in the kernel, but you now introduce
> a third interface that is unrelated to the first two, and make another
> conversion to convert it back?
> 
> Let's assume I want to use the wear levelling capabilities of UBI on top
> of an SD card, and use the ext3 file system on top of it. I get a stack of
> 
> 1. MMC
> 2. block2mtd
> 3. UBI
> 4. gluebi
> 5. mtdblock
> 6. VFS

Assuming your SD card isn't doing wear-leveling itself within the device,
yes that is what you would get.  Or you could do something slightly more sane
and use:

1. MMC
2. block2mtd
3. JFFS2

> when in an ideal world, it should just be
> 
> 1. MMC
> 2. UBI
> 3. VFS

This could perhaps still be done.  UBI has a general concept of an io_unit
so theoretically it could be adapted to work with the block layer in the
kernel.

josh
