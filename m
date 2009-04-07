Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbZDGQDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbZDGQDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbZDGQDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:03:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50340 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345AbZDGQDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:03:09 -0400
From: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
To: David Brownell <david-b@pacbell.net>, Thomas Gleixner <tglx@linutronix.de>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Apr 2009 11:02:40 -0500
Subject: RE: [PATCH] MTD-NAND: Changes to read_page APIs to support
 NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Thread-Topic: [PATCH] MTD-NAND: Changes to read_page APIs to support
 NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Thread-Index: Acm3J3XwVfNpavHRRn6wapfksh5a2gAbPMfA
Message-ID: <7A436F7769CA33409C6B44B358BFFF0CFFAA90C0@dlee02.ent.ti.com>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com>
 <200904051556.05368.david-b@pacbell.net>
 <alpine.LFD.2.00.0904070042300.21577@localhost.localdomain>
 <200904061849.23110.david-b@pacbell.net>
In-Reply-To: <200904061849.23110.david-b@pacbell.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, David,

> -----Original Message-----
> From: David Brownell [mailto:david-b@pacbell.net]
> Sent: Monday, April 06, 2009 9:49 PM
> To: Thomas Gleixner
> Cc: Narnakaje, Snehaprabha; davinci-linux-open-
> source@linux.davincidsp.com; linux-mtd@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support
> NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
> 
> On Monday 06 April 2009, Thomas Gleixner wrote:
> > David, Sneha,
> >
> > I'm answering both mails in one go.
> >
> > On Sun, 5 Apr 2009, David Brownell wrote:
> >
> > > On Wednesday 01 April 2009, nsnehaprabha@ti.com wrote:
> > > > From: Sneha Narnakaje <nsnehaprabha@ti.com>
> > > >
> > > > The NAND controller on TI DaVinci DM355 supports NAND devices
> > > > with large page size (2K and 4K), but the HW ECC is handled
> > > > for every 512byte read/write chunks. The current HW_SYNDROME
> > > > read_page/write_page APIs in the NAND core (nand_base) use the
> > > > "infix OOB" scheme.
> >
> > For a damned good reason. If you want to use HW_SYNDROME mode then you
> > better have the syndrome right after the data.
> >
> > data - ecc - data - ecc ...
> >
> > That's how HW_SYNDROME generators work. It's not about the write side,
> > It's about the read side. You read n bytes of data and m btes of ecc
> > in _ONE_ go
> 
> Nit:  the current code issues up to four read_buf() calls there, not
> one; always at least two:  data, prepad, ecc, postpad (pads optional).
> The write side is relevant since it's got to issue matching writes.
> 
> Which causes another little issue:  the pre-pad may be ECC-protected,
> but parts of the MTD stack don't entirely seem prepared for that.  As
> in, it looks like some code assumes writing prepad won't affect ECC.
> They may write it ... causing up to 8*6 = 48 bits of ECC error in this
> case, more than can be corrected.  (I think that would be tools, not
> normal kernel code.)
> 
> 
> > and the hardware will tell you whether there is a bit flip
> > or not. You can even do full hardware error correction this way. And
> > it has been done.
> >
> > See also: http://linux-mtd.infradead.org/tech/mtdnand/x111.html#AEN140
> 
> That information is partially obsolete.  Those NAND_ECC_HWx_y
> constants are gone, the method names changed too.  And I think
> the current code tolerates BCH and other ECC schemes not just
> the Reed-Solomon subset.
> 
> FWIW, this hardware would be NAND_ECC_HW10_518; not one of those
> now-obsolete constants.  Yes; 518, == 512 + 6, so the data and
> "prepad" can all be ECC-protected.
> 
> And of course, the point of this patch is to support the read
> side *without* forcing that "choice" of "infix OOB".
> 
> 
> > > Makes me wonder if there should be a new NAND_ECC_HW_* mode,
> > > which doesn't use "infix OOB" ... since that's the problem.
> > >
> > > Given bugs recently uncovered in that area, it seems that
> > > these DaVinci chips may be the first to use ECC_HW_SYNDROME
> > > in multi-chunk mode (and thus "infix OOB" in its full glory,
> > > rather than single-chunk subset which matches traditional
> > > layout with OOB at the end).
> >
> > Sorry, HW_SYNDROME was used in multi chunk mode from the very
> > beginning. See above.
> 
> That's hard to believe; 52ff49df7fab18e56fa31b43143c4150c2547836
> merged today.  Lack of that pretty much trashed a 2 GByte NAND
> chip I have ... the standard raw page r/w calls ignored multi chunk
> layout issues, so the BBT detection lost horribly.  Trashed the
> existing BBT table -- EVERY TIME IT BOOTED.  Data corruption bugs
> like that, and "code in use", do not mix at all convincingly.
> 
> The main current in-tree HW_SYNDROME driver is cafe_nand ... which
> looks to force single-chunk mode.
> 
> Maybe bugs crept in over time.  The other two drivers using that
> code (referenced in the URL above) are from the days when large
> page chips weren't routine.  Diskonchip is now obsolete (and the
> docs I've found refer to 512 byte pages, single-chunk territory);
> and that "AND" flash (not NAND!) stuff is at best rare.  Hence my
> assumption that multi-chunk mode has never actually been used, even
> if the code has been in place.
> 
> 
> > If your device does not do that or you do not want to utilize it for
> > whatever reasons then just use the NAND_ECC_HW mode which lets you
> > place your ECC data where ever you want.
> 
> So you basically agree with my comment that this shouldn't use
> HW_SYNDROME code paths unless it uses the "infix OOB" scheme.
> 
> 
> SEPARATE ISSUE:  when is using that "infix OOB" appropriate?
> 
> > > > The core APIs overwrite NAND manufacturer's bad block meta
> > > > data, thus complicating the jobs of non-Linux NAND programmers
> > > > (end equipment manufacturering). These APIs also imply ECC
> > > > protection for the prepad bytes, causing nand raw_write
> > > > operations to fail.
> > >
> > > All of those seem like reasons to avoid NAND_ECC_HW_SYNDROME
> > > unless the ECC chunksize matches the page size ... that is,
> > > to only use it when "infix OOB" won't apply.
> >
> > Wrong, see above
> 
> Hardly.  It's clearly arguable; see my comments above, and even
> yours (!) about not wanting to use it for "whatever reasons".
> Like the reasons quoted right there... there are indeed downsides
> to this "infix OOB" approach, which could make it worth avoiding.
> 
> 
> > > I particularly dislike clobbering the bad block data, since
> > > once that's done it can't easily be recovered.  Preferable
> > > to leave those markers in place, so that the chip can still
> > > be re-initialized cleanly.
> >
> > And how do you utilize the "data-ecc-data-ecc..." scheme _WITHOUT_
> > clobbering the bad block marker bytes ???
> 
> You don't.  You'd use a different scheme.
> 
> 
> > That's why we have the bad block table mechanism.
> 
> Sure, when it works.  Of course it's _nice_ to be able to
> recreate such a table too, and treat a table-in-flash
> as just a boot accelerator.
> 
> Maybe "nice" matters only during development; maybe not.
> I was able to manually re-mark 256 MBytes as "block not
> actually bad", after hitting that BBT-corrupting bug above.
> (The other blocks ... I won't worry about for now.)
> 
> Now I think other folk won't see that *same* failure.
> So maybe the backup BBT will suffice to recover from
> such things in the future, in conjunction with system
> software which disallows (re)creation of BBT-in-flash
> from both Linux and the boot loader.
> 
> 
> > And this is not a Linux kernel hackers oddity,
> > just have a look at DiskOnChip devices which do exactly the same. It's
> > dictated by the hardware and there is nothing you can do about it -
> > aside of falling back to software ECC and giving up the HW
> > acceleration.
> 
> Or ... using patches like Sneha provided.
> 
> Or ... by using hardware like OMAP3, which seems to have
> hardware buffers for the ECC syndrome stuff.  Support for
> "normal" OOB layout (vs infix) from the hardware's BCH
> syndrome calculation/correction module, if I read right.
> 
> The "infix OOB" is a software policy.  Maybe it's natural
> to choose that with some hardware.  But it's not dictated
> hardware; as shown by Sneha's patches.
> 
> 
> > This patch is utter nonsense. The whole functionality is already
> > there. Just use the correct mode: NAND_ECC_HW. Place your ECC data
> > where you want or where your commercial counterparts want them to show
> > up. Using NAND_ECC_HW_SYNDROME for your case is just plain wrong.
> 
> Well, ISTR that you said otherwise above ... yeah, quoting you (above):
> 
> > > If your device does not do that or you do not want to utilize it for
> > > whatever reasons then just use the NAND_ECC_HW mode which lets you
> > > place your ECC data where ever you want.
> 
> And that's exactly what these patches do:  enable just such choices.
> The $SUBJECT patch would be needed to use NAND_ECC_HW with this 4-bit
> ECC hardware, and not be forced to "choose" the infix-OOB policy.

I had looked read_page/write_page APIs of the NAND_ECC_HW mode to see if we can use this mode for DaVinci DM355 device.

The read_page handler for NAND_ECC_HW mode reads the data and ECC from hardware for each chunk. It then reads the OOB and extracts ecc code from it, before using the ECC from hardware and ecc code from OOB for data correction.

On DaVinci DM355 device, we need to pass the ecc code/syndrome extracted from OOB area, in order to read the HW ECC for each data chunk. This is where we differ from NAND_ECC_HW mode.

The read_page/write_page APIs for NAND_ECC_HW_SYNDROME have the other problem that David mentioned - overwriting NAND manufacturers bad block meta data, when used with large page NAND chips. These APIs do not handle the "eccsteps" properly. The OOB is read/written after every data chunk, thus you actually have overwritten the factory bad block information, when these APIs handle the last data chunk. OOB should be read/written after the entire data (a page) is read/written.

Thanks
Sneha

> 
> 
> How strongly you believe in supporting those choices is yet another
> question.  But you should at least be arguing from real facts, not
> from mis-apprehensions.
> 
> - Dave
> 

