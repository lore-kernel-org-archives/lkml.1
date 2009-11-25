Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbZKYOT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbZKYOT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934665AbZKYOT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:19:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:44315 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934542AbZKYOT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:19:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aloe5bNDmP6Whgt0cC0ITy9CTSIlFbhmlHxJraLT5PxVJ9HwpCCxezGVjAjXxwy9iA
         zJ59awcoUNoIN4KkE91zg1HxrVuFd/uo9Yuy3FRyjlhKChKp5CuZC1BaEKWoaP0nLaC6
         aawf10SkBby+HmG2N+YWTX/jmOJJNWlp3sg9A=
Subject: Re: Plan for adding XD support in mtd layer
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <20091125104027.GB10944@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop>
	 <20091121102542.GA21136@logfs.org> <1258894713.4127.4.camel@maxim-laptop>
	 <1259106610.28219.34.camel@maxim-laptop> <20091125104027.GB10944@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 15:20:58 +0200
Message-ID: <1259155258.4875.17.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 11:40 +0100, Jörn Engel wrote: 
> On Wed, 25 November 2009 01:50:10 +0200, Maxim Levitsky wrote:
> > 
> > Chip driver:
> > 
> > no problems with that, in fact ricoh controller I reverse engineered is
> > very similar conceptually
> > to jmicron.
> > I can take original jmicron driver almost verbatim.
> > This will live in new sub folder of mtd and call into base XD driver
> 
> Ok.  Is the code available somewhere or can you send it?  And what
> devices would one have to buy to test it?
Currently jmicron support is found in aspire one.
My acer has ricoh device I know how works.
Alex dubov said that TI has interest in a driver.
As soon as core is written and accepted, writing drivers will be very
easy if one has documentation.

I also plan to write a 'dummy' driver to test subsystem against.

Other that work of Alex Dubov, I need to write the code, but I don't
want to repeat his mistake and write code that isn't accepted on basis
of lack for fitness in existing subsystems.

> 
> > Base XD mtd driver:
> > 
> > * No way to tell that readsize = 512, but write & erase size isn't.
> > Not such a big deal, since higher level FTL driver can hardcode that
> > assumption, and access via mtdblk isn't necessary, since FTL will
> > replace it for XD, and the raw access will be done through mtdchar.
> > 
> > * it is possible to export 'extra' via oob. FTL will use that, and will
> > be available to user via char device
> > 
> > * No need to export CIF block, it will be available for user via char
> > device by scanning the device (using a new utility)
> > 
> > 
> > -> I need new mtd_info member for at least for card identification, and
> > will be nice to have zone/block/page size
> > This will be used by FTL and mtdchar to be exported to user space
> 
> Block and page size already exist as mtd->erasesize and mtd->writesize
> respectively.  I'm not sure whether the zone size should become part of
> the mtd interface - it looks more like a property of the ftl.
You didn't understand me.
I can't nether write nor erase individual blocks (writing is technically
possible, but is disallowed by recent XD spec (this is what Alex Dubov
says)

However I can _read_ individual sectors
sector is 512 bytes, block is usually around 32 sectors.


> 
> > FTL driver:
> > 
> > I will write new XD/smartmedia FTL driver.
> > 
> > * Will read ID/type from device and do all the work based on that,
> > (figure page size/zone count/block size, etc...) or will get that info
> > from mtd driver 
> > 
> > * Will cache read/writes (this will overlap with mtdblk)
> > 
> > * Will provide normal block level access to filesystems, and user.
> > (using common block device of course)
> > 
> > * No debugging information or/and device specific ioctls.
> > 
> > 
> > Char driver:
> > 
> > * Already exists, and I will need to modify it, so I could read ID/media
> > type
> > Also would be nice to pass info about sizes (zones/pages/blocks) to
> > userspace 
> > If not, I will put translation table to userspace utility based on media
> > ID
> 
> What userspace programs would need this information?  I can imagine some
> sort of xd_format or mkxd in case the card has been corrupted or used
> raw.  Anything else?

I can imagine a format application, a rescue application, and an debug
application that will show how healthy is the card.

There are actually two pieces of the data.
One is an ID, a serial number that can be used for example by udev for
permanent mapping.

Other is the media type, and this has to be used to know the sizes of
sectors, zones, pages, how many spares there are etc...



> 
> > Userspace utility:
> > * Will allow user to read FTL maps (based on oob), Media ID, CIF, all
> > using char device
> 
> What would this be needed for?
A rescue operation, of just for curiosity...
Also to edit CIF to bypass vendor lock-in as explained in Wikipedia
article

Access via mtdblock can be used to use the card as raw device too.

ECC corecting will be done in the base mtd driver, but userspace
application will be able to determine if block is good or bad.
If it is good, it can use oob information to determine of ECC correction
was applied or not, and report overall health of the card.


Thus I think that XD can be integrated in the core quite easily with
only minor modifications.


Best regards,
Maxim Levitsky


