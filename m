Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbYHFCXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbYHFCXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYHFCXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:23:13 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47069 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYHFCXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:23:12 -0400
Date: Tue, 5 Aug 2008 20:22:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long Physical Sectors
Message-ID: <20080806022255.GC2055@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx> <1217957207-23116-3-git-send-email-matthew@wil.cx> <20080805214651.621263f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805214651.621263f5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 09:46:51PM +0100, Alan Cox wrote:
> > + * Some commands are specified to transfer (a multiple of) 512 bytes of data
> > + * while others transfer a multiple of the number of bytes in a sector.  This
> > + * function knows which commands transfer how much data.
> 
> 	static u32 ata_sector_or_block[]={...};
> 
> 	if (test_bit(tf->cmd, &ata_sector_or_block))
> 
> looks so much more elegant than a giant switch statement and I suspect
> produces far better code

Probably ... I did consider it, but I think I was too influenced by the
existing READ/WRITE LONG code.

> > + * ATA supports sector sizes up to 2^33 - 1.  The reported sector size may
> > + * not be a power of two.  The extra bytes are used for user-visible data
> > + * integrity calculations.  Note this is not the same as the ECC which is
> > + * accessed through the SCT Command Transport or READ / WRITE LONG.
> > + */
> > +static u64 ata_id_sect_size(const u16 *id)
> 
> word 106 is not defined in early ATA standards so it would be wise to
> check that ATA8 is reported by the drive - and trust the relevant bits
> for ATA7/8 as appropriate.

I'm not sure that's necessary.  The spec says to check whether words are
valid by doing the & 0xc000 == 0x4000 test.

> The drivers also need to know when a command is being issued which is a
> funny shape as some hardware cannot do it because the internal state
> machine knows the sector size and other stuff seems to need the internal
> FIFO turning off or other things whacked repeatedly on the head to make
> it work.

Yes, I would expect some driver work to be required.  It only gets worse
once we implement the DIX-equivalent.  How do you suggest would be a
good migration path?  We could have the driver set a flag, or call into
the driver from the midlayer to check whether it can cope with a
particular sector size.

> You also don't need to bother listing all the commands that don't have
> data transfer phases as a sector size is meaningless there so we
> shouldn't even bother doing a lookup for them. Indeed the more I look at
> this the more it seems that keeping long complex ever out of date arrays
> is the wrong way to do it.

I didn't want to change behaviour.  We currently set sect_size to 512
for all commands (except READ LONG), and I didn't want to change that
for non-data commands.  I agree with you that it's not relevant.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
