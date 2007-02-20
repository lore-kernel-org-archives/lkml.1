Return-Path: <linux-kernel-owner+w=401wt.eu-S964958AbXBTOzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958AbXBTOzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964969AbXBTOzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:55:51 -0500
Received: from thunk.org ([69.25.196.29]:35646 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbXBTOzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:55:50 -0500
Date: Tue, 20 Feb 2007 09:55:03 -0500
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070220145503.GC3170@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171976753.4039.27.camel@sauron>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 03:05:53PM +0200, Artem Bityutskiy wrote:
> On Mon, 2007-02-19 at 10:54 +0000, Christoph Hellwig wrote:
> > On Sat, Feb 17, 2007 at 06:54:49PM +0200, Artem Bityutskiy wrote:
> > > +#ifndef __UBI_UBI_H__
> > > +#define __UBI_UBI_H__
> > > +
> > > +#include <linux/mtd/ubi.h>
> > > +
> > > +/* Version of this UBI implementation */
> > > +#define UBI_VERSION 1
> > We shouldn't have versions for inkernel interfaces.
> 
> What do you mean? It is internal version just for future help: if we
> develop incompatible UBI2 the old UBI will reject the new images.

In that case it's not an *implementation* version number, but rather
an on-disk *format* version number.  There's a difference.  It's also
often not used much, since another way of dealing with the problem is
to mark major each on-disk version with a different magic number.
(Many new filesystems these also will use an 8-byte magic string, such
as "UBI-FS1\n" so that it's a bit users who look at an image using a
hex editor to see what the heck it is, and also since with a longer
magic string there is less likelihood of an accidental collision given
that we don't have a central registry of magic numbers.)

BTW, it's kind of silly to use an enum here:

/*
 * Magic numbers of the UBI headers.
 *
 * @UBI_EC_HDR_MAGIC: erase counter header magic number (ASCII "UBI#")
 * @UBI_VID_HDR_MAGIC: volume identifier header magic number (ASCII "UBI!")
 */
enum {
	UBI_EC_HDR_MAGIC  = 0x55424923,
	UBI_VID_HDR_MAGIC = 0x55424921
};

Why isn't this being done via #define?  It's not like this is any kind
of an enumerated type, especially since it's being installed into a
32bit type, and not even an enum type.

Also while taking another look at your patches, note that that your
mix of C99 types and your UBI magic types is a bad idea:

struct ubi_ec_hdr {
	ubi32_t magic;
	uint8_t version;
	uint8_t padding1[3];
	ubi64_t ec; /* Warning: the current limit is 31-bit anyway! */
	ubi32_t vid_hdr_offset;
	...

It appears that the reason why you are doing this is because you think
you need the (packed) attribute.  Not needed; Linux assumes all over
the place 16, 32, and 64 types are packed.  If Linux is ever compiled
on an architecture where this isn't true, the compiler will probably
need to be fixed so these assumptions are true, since all manner of
things will break.

It would be much better to use __be32 and __be64, so you get better
type checking, and you will catch bugs caused by forgetting to use
be32_to_cpu, et. al.

BTW, it might also be a good idea to run UBI through sparse to catch bugs.

							- Ted
