Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYDEBrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYDEBrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYDEBrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:47:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbYDEBrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:47:21 -0400
Date: Fri, 4 Apr 2008 18:46:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kyungmin Park" <kmpark@infradead.org>
Cc: "Josh Boyer" <jwboyer@gmail.com>, "David Brownell" <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       "Michael Trimarchi" <trimarchimichael@yahoo.it>,
       spi-devel-general@lists.sourceforge.net, dwmw2@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] jffs2 summary allocation
Message-Id: <20080404184615.deaf3122.akpm@linux-foundation.org>
In-Reply-To: <9c9fda240804041829r5a768b39n340926485aa12687@mail.gmail.com>
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com>
	<200804041609.41092.david-b@pacbell.net>
	<1207351282.3224.79.camel@vader.jdub.homelinux.org>
	<200804041658.38499.david-b@pacbell.net>
	<1207357870.3224.89.camel@vader.jdub.homelinux.org>
	<9c9fda240804041829r5a768b39n340926485aa12687@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2008 10:29:25 +0900 "Kyungmin Park" <kmpark@infradead.org> wrote:

> On Sat, Apr 5, 2008 at 10:11 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> > On Fri, 2008-04-04 at 16:58 -0700, David Brownell wrote:
> >  > On Friday 04 April 2008, Josh Boyer wrote:
> >  > >
> >  > > >   ... This means specifically that you may _not_ use the
> >  > > >   memory/addresses returned from vmalloc() for DMA.  ...
> >  > > >
> >  > > > So I'm rather surprised to see *ANY* kernel code trying to do
> >  > > > that.  That rule has been in effect for many, many years now.
> >  > >
> >  > > I don't think it was intentional.  You're going through several layers
> >  > > here:
> >  > >
> >  > > JFFS2 -> mtd parts -> mtd dataflash -> atmel_spi.
> >  > >
> >  > > Typically MTD drivers aren't doing DMAs to flash and JFFS2 has no idea
> >  > > which particular chip driver is being used because it's abstracted by
> >  > > MTD.
> >  >
> >  > That's true ... although I can imagine using DMA to
> >  > avoid dcache trashing if its setup cost is low enough,
> >  > with either NAND or NOR chips.
> >  >
> >  > Still:  in this context vmalloc() is wrong.
> >
> >  Agreed.  One issue is that the summary code allocates a buffer that
> >  equals the eraseblock size of the underlying MTD device.  For larger
> >  NAND chips, that may be up to 256KiB.  I believe this is within the
> >  allowable kmalloc size for most architectures these days, but the
> >  summary code is 3 years old and was likely expecting a smaller limit.
> >  And there is always the question on whether finding that much contiguous
> >  memory will be an issue.

Yes.  This is why I'm reluctant to whizz this patch into 2.6.25.  It'll
break more than it fixes.

> In MLC chips it goes up to 512KiB. It means it can't allocate the
> eraseblock size memory with kmalloc().
> In ARM environment I can't see the 256KiB or more memory allocation
> with kmalloc().
> So I now changed the kmalloc eraseblock to vmalloc at both jffs2 and mtd-utils.

Does this eraseblock really really really need to be a single
virtually-contiguous hunk of kernel memory?  Or was that just easy to do at
the time?



This problem comes up pretty often.  Rather than open-coding it yet again
it'd be nice to have a little bit of library code which manages an array of
pages and which has accessors for common operations like
read/write-u8/u16/u32/u64, memset, memcpy, etc.

Then again, given that this memory is often fed into IO subsystems, perhaps
we should do this by adding more accessors and helpers to
scatterlists/sg_table.  Unfortunately they're not presently well set up for
random access.
