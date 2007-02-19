Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXBSOA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXBSOA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbXBSOAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:00:25 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46374 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbXBSOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:00:23 -0500
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <200702182337.53314.arnd@arndb.de>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <200702180315.25067.arnd@arndb.de>
	 <20070218030217.GH1038@crusty.rchland.ibm.com>
	 <200702182337.53314.arnd@arndb.de>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 08:01:24 -0600
Message-Id: <1171893684.24204.12.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 23:37 +0100, Arnd Bergmann wrote:
> On Sunday 18 February 2007 04:02:17 Josh Boyer wrote:
> > On Sun, Feb 18, 2007 at 03:15:23AM +0100, Arnd Bergmann wrote:
> > > On Sunday 18 February 2007 03:04, Josh Boyer wrote:
> > > > No, the MTD interface isn't flawed.  gluebi is present to make things
> > > > like JFFS2 work on top of UBI volumes with very little adaptations.  If
> > > > you go changing _every_ MTD user to now use either an MTD device or a
> > > > native UBI device, then the code for those users just gets bloated.
> > >
> > > Right, that was my point. If the MTD API in the kernel is not flawed, why
> > > do we need the 'native' UBI interface? Just merge gluebi into UBI and
> > > get rid of the extra abstraction.
> >
> > That suggestion came up several times.  gluebi represents a compromise
> > between the two groups.  IIRC, the issue was that representing UBI volumes
> > as MTD devices only makes sense in the dynamic volume case.  Static UBI
> > volumes require special write/update handling and so there was a need for
> > a native interface anyway.
> 
> Which brings be back to my original point ;-)
> 
> I'm sure this has been discussed before, but I'd still like to understand
> what is so special with 'static UBI volumes' that they can't be used with
> a slightly extended MTD interface.

Since I personally loath the standard "RTFM" response, I'll try and
explain briefly.

Think of static volumes as containers for chunks of whole binary data.
You don't want partial updates to this data, or it's inconsistent.  So a
static volume must be written wholesale.  As UBI writes out the data,
each block has a field in the VID header with the data size and the CRC
for that block.

Take a vmlinux binary for example.  By putting that in a static UBI
volume, a bootloader can read each block in the volume in order, verify
the block CRC and know that the resulting reconstructed image is valid.
If the CRC doesn't match on a block, the data is invalid and the
bootloader can do whatever it determines to be the correct behavior.

One could arguably create a new MTD interface called "update" and
provide only that and the read function for static volumes.  But that is
essentially what has been done within UBI itself.  I won't speak for
Artem, who could explain much more than I as to why it was done the way
it currently is.

josh

