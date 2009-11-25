Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbZKYQRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbZKYQRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbZKYQRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:17:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33194 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZKYQRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:17:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NbXCHy/uuehtu6e60Q7IE5azS0ehYwSTQD8knY0ndkXIOinp5pXmbvpTfCrtf253jz
         NC7PdDaCSwbRvnNOVoJDYLcy2lGLOFmikg7UIojLa6VkiPUyE9OaAREtwO0em/DiARRa
         +zgroJCvuH/Qzck9bgA0/n8Ro94N6xKBtrBe4=
Subject: Re: Plan for adding XD support in mtd layer
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <20091125153458.GC10944@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop>
	 <20091121102542.GA21136@logfs.org> <1258894713.4127.4.camel@maxim-laptop>
	 <1259106610.28219.34.camel@maxim-laptop> <20091125104027.GB10944@logfs.org>
	 <1259155258.4875.17.camel@maxim-laptop>  <20091125153458.GC10944@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 18:17:46 +0200
Message-ID: <1259165866.10147.35.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 16:34 +0100, Jörn Engel wrote: 
> Hello Maxim
> 
> On Wed, 25 November 2009 15:20:58 +0200, Maxim Levitsky wrote:
> >
> > Currently jmicron support is found in aspire one.
> > My acer has ricoh device I know how works.
> 
> Those are card readers built into notebooks, right?  How are they
> attached?  Via PCI or USB?
Mostly in notebooks.
External readers usually implement standard mass-storage protocol.

They are usually PCI , however some USB devices work the same, for
example
alluda device that currently has two drivers in the kernel, one mtd for
raw access, and another self-contained USB driver that does FTL and
exposes device as an SCSI device.

> 
> > Other that work of Alex Dubov, I need to write the code, but I don't
> > want to repeat his mistake and write code that isn't accepted on basis
> > of lack for fitness in existing subsystems.
> 
> 
> > > > -> I need new mtd_info member for at least for card identification, and
> > > > will be nice to have zone/block/page size
> > > > This will be used by FTL and mtdchar to be exported to user space
> > > 
> > > Block and page size already exist as mtd->erasesize and mtd->writesize
> > > respectively.  I'm not sure whether the zone size should become part of
> > > the mtd interface - it looks more like a property of the ftl.
> > You didn't understand me.
> > I can't nether write nor erase individual blocks (writing is technically
> > possible, but is disallowed by recent XD spec (this is what Alex Dubov
> > says)
> > 
> > However I can _read_ individual sectors
> > sector is 512 bytes, block is usually around 32 sectors.
> 
> It has been a while since I looked at the spec, but I believe there are
> two parts to it.  The flash hardware allows block erases, sector reads
> and sector writes.  On top of that you have the FTL that adds further
> restrictions.
if this is the case, then no problems.
Alex said something about firmware bugs though, that I belive is
connected to raw block writes.

I also know that driver for my ricoh based controller does always block
based cow writes.

when I say block I mean area that can be erased independently, and it
consists of several 512 byte sectors.
(Very old incarnation of smartmedia format had 256 byte sectors that
were tied together in pairs)

> 
> If you use you xD card without the FTL, as a raw MTD device, you can do
> almost anything you want.  Format it with JFFS2, for example.  But if
> used _with_ the FTL, that card now has a corrupt format and may be
> unusable.
> 
> Or is the FTL already implemented in the card reader hardware?
No, I have to implement it.
And yes, XD can give ready to use testing ground for flash based file
systems, like JFFS2.

> 
> > > What userspace programs would need this information?  I can imagine some
> > > sort of xd_format or mkxd in case the card has been corrupted or used
> > > raw.  Anything else?
> > 
> > I can imagine a format application, a rescue application, and an debug
> > application that will show how healthy is the card.
> 
> Format and rescue certainly make sense.  I'm not sure how a debug
> application would measure the health, but maybe that's possible as well.
I can count bad sectors, ecc corrected sectors, see how many spares
remain in each block, etc...

> 
> > There are actually two pieces of the data.
> > One is an ID, a serial number that can be used for example by udev for
> > permanent mapping.
> 
> Ok, makes sense.
> 
> > Other is the media type, and this has to be used to know the sizes of
> > sectors, zones, pages, how many spares there are etc...
> 
> That would be available when using mtdchar or mtdblock to read the
> device.  Which ought to be enough for format, rescue and debug, I
> believe.

Yes this is enough, but how I expose media type in the mtd driver, there
is a field for that I missed?

And same question for the ID.

Note that media type /ID is _not_ stored on the media (well it is but is
not accessible that way)
There is need for special command to read it from the device.

> 
> > ECC corecting will be done in the base mtd driver, but userspace
> > application will be able to determine if block is good or bad.
> > If it is good, it can use oob information to determine of ECC correction
> > was applied or not, and report overall health of the card.
> 
> With mtdchar it is possible to do ECC correction in userspace as well.
> Not that I would consider it a good idea, but the information is
> certainly available and can be controlled if a compelling reason can be
> found.
Exactly.


Best regards,
Maxim Levitsky

