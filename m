Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZDUVCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZDUVCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZDUVBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:01:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49721 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZDUVBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:01:49 -0400
Date: Tue, 21 Apr 2009 22:01:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, mdharm-usb@one-eyed-alien.net,
       linux-usb <linux-usb@vger.kernel.org>,
       usb-storage@lists.one-eyed-alien.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC][PATCH] fix sign extension with 1.5TB usb-storage LBD=y
Message-ID: <20090421210145.GF8633@ZenIV.linux.org.uk>
References: <1240347174.10627.20.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240347174.10627.20.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 01:52:54PM -0700, Dave Hansen wrote:
> This is with current git as of this morning, which is at v2.6.30-rc2.
> 
> I have a 1.5TB USB device which gets a bit angry when I plug it in.  It
> ends up with a scsi_disk->capacity of ffffffffaea87b30.  I tracked it
> down to the lba calculation in read_capacity_10():
> 
> 	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
>  		(buffer[2] << 8) | buffer[3];
> 
> lba is getting all 0xf's in its high 32 bits.  It seems odd that this
> would happen since 'buffer' is an 'unsigned char', but that is
> apparently what is going on.

Nothing odd here; you get unsigned char promoted to int (since the entire
range fits into the range of int), then calculations are carried within
int and in the end you have (overflown into negative) int sign-extended
into u64.

Solution is correct, but perhaps use of get_unaligned_be32(buffer) would be
better.
