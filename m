Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0BEJZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:25:11 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37020 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0BEJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:25:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fnnpzXHe7sOaAhOo4Kl7L6FZvDwrrb41XEgNd/hiC/ETOHFsqqpRLY2D/NHz4+P8gH
         KvdHNeEkBAyWjxWXUxne+xu/RXUWYd+Y7PW5WZB82AHjGHN3DgBwlHKO3cfeKMzeugv/
         m79gTAHrF+NlDi7m+crrdy+1UZOxnUpioRues=
Subject: Re: [PATCH 10/17] MTD: nand: make reads using MTD_OOB_RAW affect
 only  ECC validation
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Alex Dubov <oakad@yahoo.com>,
       Artem Bityutskiy <dedekind1@gmail.com>, joern <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <acd2a5931002050056l119844f5s30c30ccfc1a15596@mail.gmail.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
	 <1265326257-4446-11-git-send-email-maximlevitsky@gmail.com>
	 <acd2a5931002050056l119844f5s30c30ccfc1a15596@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 11:25:01 +0200
Message-ID: <1265361901.15383.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-05 at 09:56 +0100, Vitaly Wool wrote: 
> On Fri, Feb 5, 2010 at 12:30 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
> > to the data buffer, however you would still need to specify the dummy oob buffer.
> >
> > This is only used in one place, but makes it hard to read data+oob without ECC
> > test, thus I removed that behavier, and fixed the user.
> >
> > Now MTD_OOB_RAW behaves like MTD_OOB_PLACE, but doesn't do ECC validation
> >
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/mtd/nand/nand_base.c |    5 -----
> >  drivers/mtd/nand/nand_bbt.c  |   26 ++++++++++++++++++++++----
> >  include/linux/mtd/mtd.h      |    4 +---
> >  3 files changed, 23 insertions(+), 12 deletions(-)
> 
> Could you please provide a clearer description of why you think this
> is necessary?

Sure.

I have two distinct buffers. One holds the data and is 512 bytes long,
other is the oob and is 16 bytes long.

I want to write these buffers to flash but without ECC

Currently I would have to allocate new buffer and copy both buffers
there.

Why I need it?

To make my SmartMedia FTL complete I need to add support for 256 byte
nands. These have 256 bytes per page and 8 bytes of oob.
However, pages are always written in pairs, forming 512 bytes sector.
Combined oob of first and second page is identical to the one that is
written to 512 byte page, thus its layout depends on page number.
Also I want the nand driver to have as little as possible smartmedia
dependencies, thus allow it to be used with any FTL, UBI, jffs2, etc..
Therefore I decided to make nand driver use standard oob layout and ECC
in case of 256 byte flash, but make my FTL bypass it.
It also happens to work with nandsim unmodified... :-)

Also, this makes the interface more orthogonal.
This feature is used in just one place too.

Best regards,
Maxim Levitsky

