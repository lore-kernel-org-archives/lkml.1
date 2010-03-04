Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0CDPZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:25:31 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42745 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab0CDPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:25:27 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Pavel Machek <pavel@ucw.cz>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       benh@kernel.crashing.org, mdharm-kernel@one-eyed-alien.net,
       linux-usb@vger.kernel.org, x0082077@ti.com, sshtylyov@ru.mvista.com,
       tom.leiming@gmail.com, bigeasy@linutronix.de, oliver@neukum.org,
       linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100304142704.GB6622@n2100.arm.linux.org.uk>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <20100303215437.GF2579@ucw.cz>
	 <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com>
	 <20100304135128.GA12191@atrey.karlin.mff.cuni.cz>
	 <1267712512.31654.176.camel@mulgrave.site>
	 <20100304142704.GB6622@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 15:25:23 +0000
Message-ID: <1267716323.6526.479.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 15:25:24.0896 (UTC) FILETIME=[E9754200:01CABBAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 14:27 +0000, Russell King - ARM Linux wrote:
> On Thu, Mar 04, 2010 at 07:51:52PM +0530, James Bottomley wrote:
> > On Thu, 2010-03-04 at 14:51 +0100, Pavel Machek wrote:
> > > Seems like ARM has requirement other architectures do not, that is
> > > a) not documented anywhere
> > > b) causes problems
> > >
> > > You could argue that performance improvement (how big is it, anyway?)
> > > is worth it, but this should be agreed to by wider community...
> >
> > Performance is always worth it provided we don't sacrifice correctness.
> > The thing which was discovered in this thread is basically that ARM is
> > handling deferred flushing (for D/I coherency) in a slightly different
> > way from everyone else ... once that's fixed, ARM will likely not have
> > the D/I problem, but we'll still have the libata (and other PIO systems)
> > D flushing issue.
> 
> I think you've got that backwards.
> 
> Reversing the meaning of PG_arch_1 will probably fix the D aliasing issue -
> since we'll interpret '0' to mean "page is dirty, it needs flushing before
> hitting userspace", whereas '1' means "page has been cleaned; there are no
> aliases."
> 
> This doesn not address the I/D coherency issue, where the Icache needs
> attention to get rid of speculatively loaded cache lines while old data
> was present in the cache.

The I-cache flushing is already handled in update_mmu_cache (or
set_pte_at in a future patch; I'm not talking about other issues on
ARM11MPCore here).

We always invalidate the I-cache currently (since we may have DMA
transfers and the page's D-cache is clean). As an optimisation, we could
use PG_arch_2 for I-cache but I don't think there is much performance
benefit compared to always invalidating the I-cache flushing.

My understanding from this long discussion is that we cannot get the
kernel modifying a page cache page which is already mapped in user space
(well, ptrace does this but we flush the cache there already).

-- 
Catalin

