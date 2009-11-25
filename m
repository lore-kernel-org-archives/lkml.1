Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbZKYU7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbZKYU7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZKYU7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:59:45 -0500
Received: from lazybastard.de ([212.112.238.170]:35410 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbZKYU7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:59:44 -0500
Date: Wed, 25 Nov 2009 21:59:43 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
Subject: Re: Plan for adding XD support in mtd layer
Message-ID: <20091125205942.GF10944@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop> <20091121102542.GA21136@logfs.org> <1258894713.4127.4.camel@maxim-laptop> <1259106610.28219.34.camel@maxim-laptop> <20091125104027.GB10944@logfs.org> <1259155258.4875.17.camel@maxim-laptop> <20091125153458.GC10944@logfs.org> <1259165866.10147.35.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259165866.10147.35.camel@maxim-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 November 2009 18:17:46 +0200, Maxim Levitsky wrote:
> On Wed, 2009-11-25 at 16:34 +0100, Jörn Engel wrote: 
> > 
> > Those are card readers built into notebooks, right?  How are they
> > attached?  Via PCI or USB?
> Mostly in notebooks.
> External readers usually implement standard mass-storage protocol.

Ok.  I guess I won't buy a new notebook just to test a driver then.

> They are usually PCI , however some USB devices work the same, for
> example
> alluda device that currently has two drivers in the kernel, one mtd for
> raw access, and another self-contained USB driver that does FTL and
> exposes device as an SCSI device.

Yes.  I've written the mtd driver for that one.

> > It has been a while since I looked at the spec, but I believe there are
> > two parts to it.  The flash hardware allows block erases, sector reads
> > and sector writes.  On top of that you have the FTL that adds further
> > restrictions.
> if this is the case, then no problems.
> Alex said something about firmware bugs though, that I belive is
> connected to raw block writes.
> 
> I also know that driver for my ricoh based controller does always block
> based cow writes.

If you only ever want to use the device with the FTL on top, that is
perfectly acceptable.  But it is an FTL restriction, not part of the
hardware.  Apart from firmware bugs, of course.

> when I say block I mean area that can be erased independently, and it
> consists of several 512 byte sectors.
> (Very old incarnation of smartmedia format had 256 byte sectors that
> were tied together in pairs)

Some also had 256 or 512 blocks per zone.  These days everything seems
to have 512+16 Byte sectors, 16 sectors per block, 1024 physical (1000
logical) blocks per zone and as many zones as the device can fit.  Or at
least that was the case two years ago.

> > Format and rescue certainly make sense.  I'm not sure how a debug
> > application would measure the health, but maybe that's possible as well.
> I can count bad sectors, ecc corrected sectors, see how many spares
> remain in each block, etc...

Iirc the number of bad blocks never changes.  Either a block is
factory-marked or it will stay in use forever.  A smart FTL could try to
store the erase count or the number of correctable/uncorrectable errors
for each block somewhere, but I don't believe it is done - or could be
done while staying compatible with the xD spec.

So that pretty much leaves the number of correctable/uncorrectable
errors currently on the device.

> > That would be available when using mtdchar or mtdblock to read the
> > device.  Which ought to be enough for format, rescue and debug, I
> > believe.
> 
> Yes this is enough, but how I expose media type in the mtd driver, there
> is a field for that I missed?
> 
> And same question for the ID.
> 
> Note that media type /ID is _not_ stored on the media (well it is but is
> not accessible that way)
> There is need for special command to read it from the device.

Right.  I forgot about that one.  In fact, I tried fairly hard to
forget. ;)

According to FMTP140E.PDF, CIS and IDI are stored in sector 0 or the
first non-defective block.  In other words, it can be read and written
normally, without any magic.  Certainly not the atrocities I tried not
to remember.

And even if there are some atrocities hidden, we can abtract them out in
the driver.  When reading/writing block 0, just do the magic
transparently.

Jörn

-- 
There are two ways of constructing a software design: one way is to make
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare
