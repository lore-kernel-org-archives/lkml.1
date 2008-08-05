Return-Path: <linux-kernel-owner+w=401wt.eu-S1764866AbYHEVE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866AbYHEVE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbYHEVEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:04:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58612 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758946AbYHEVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:04:44 -0400
Date: Tue, 5 Aug 2008 21:46:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long
 Physical Sectors
Message-ID: <20080805214651.621263f5@lxorguk.ukuu.org.uk>
In-Reply-To: <1217957207-23116-3-git-send-email-matthew@wil.cx>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx>
	<1217957207-23116-3-git-send-email-matthew@wil.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Some commands are specified to transfer (a multiple of) 512 bytes of data
> + * while others transfer a multiple of the number of bytes in a sector.  This
> + * function knows which commands transfer how much data.

	static u32 ata_sector_or_block[]={...};

	if (test_bit(tf->cmd, &ata_sector_or_block))

looks so much more elegant than a giant switch statement and I suspect
produces far better code

> + * ATA supports sector sizes up to 2^33 - 1.  The reported sector size may
> + * not be a power of two.  The extra bytes are used for user-visible data
> + * integrity calculations.  Note this is not the same as the ECC which is
> + * accessed through the SCT Command Transport or READ / WRITE LONG.
> + */
> +static u64 ata_id_sect_size(const u16 *id)

word 106 is not defined in early ATA standards so it would be wise to
check that ATA8 is reported by the drive - and trust the relevant bits
for ATA7/8 as appropriate.

The drivers also need to know when a command is being issued which is a
funny shape as some hardware cannot do it because the internal state
machine knows the sector size and other stuff seems to need the internal
FIFO turning off or other things whacked repeatedly on the head to make
it work.

You also don't need to bother listing all the commands that don't have
data transfer phases as a sector size is meaningless there so we
shouldn't even bother doing a lookup for them. Indeed the more I look at
this the more it seems that keeping long complex ever out of date arrays
is the wrong way to do it.

We will also need a driver flag to indicate support in that HBA but that
is pretty trivial to add

Alan
