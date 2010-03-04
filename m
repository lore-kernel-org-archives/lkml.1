Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0CDRed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:34:33 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56441 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169Ab0CDReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:34:31 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org, greg@kroah.com,
       x0082077@ti.com, sshtylyov@ru.mvista.com, benh@kernel.crashing.org,
       bigeasy@linutronix.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       santosh.shilimkar@ti.com, Pavel Machek <pavel@ucw.cz>,
       tom.leiming@gmail.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100304163023.GC13417@n2100.arm.linux.org.uk>
References: <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com>
	 <20100304154103.GA9384@linux-sh.org>
	 <20100304163023.GC13417@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 17:34:28 +0000
Message-ID: <1267724068.6526.499.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 17:34:29.0162 (UTC) FILETIME=[F16678A0:01CABBC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 16:30 +0000, Russell King - ARM Linux wrote:
> On Fri, Mar 05, 2010 at 12:41:03AM +0900, Paul Mundt wrote:
> > On Thu, Mar 04, 2010 at 03:29:38PM +0000, Catalin Marinas wrote:
> > > On Thu, 2010-03-04 at 14:21 +0000, James Bottomley wrote:
> > > > The thing which was discovered in this thread is basically that ARM is
> > > > handling deferred flushing (for D/I coherency) in a slightly different
> > > > way from everyone else ...
> > >
> > > Doing a grep for PG_dcache_dirty defined in terms of PG_arch_1 reveals
> > > that MIPS, Parisc, Score, SH and SPARC do similar things to ARM. PowerPC
> > > and IA-64 use PG_arch_1 as a clean rather than dirty bit.
> > 
> > SH used to use it as a PG_mapped which was roughly similar to the
> > PG_dcache_clean approach, at which point things like flushing for the PIO
> > case in the HCD wasn't necessary. It did result in rather aggressive over
> > flushing though, which is one of the reasons we elected to switch to
> > PG_dcache_dirty.
> >
> > Note that the PG_dcache_dirty semantics are also outlined in
> > Documentation/cachetlb.txt for PG_arch_1 usage, so it's hardly esoteric.
> 
> Indeed; the ARM approach was basically taken from Sparc64.
[...]
> The general critera (from memory) seems to be:
> - a virtual indexed aliasing cache (whether it be VIVT or VIPT aliasing)
> - write allocate caches show the problem better than read allocate only
> - using a block device for the filesystem
> - mmap'ing a page and immediately accessing the last few cache lines in
>   that page

It actually triggers easily with a non-aliasing VIPT cache (can't even
start /sbin/init). The main condition is for the caches to be in
write-allocate mode (and the processor to support this, i.e. Cortex-A9).

A simple test is to use an ext2/3 filesystem (cramfs, jffs2 etc.
wouldn't do since they call flush_dcache_page) on a compact flash card
using the pata_platform driver (and without commit 2d68b7fe55d9e19).

Other forms of triggering this is to use something like slram + ext2/3.

-- 
Catalin

