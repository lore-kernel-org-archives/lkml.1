Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbZJOMAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbZJOMAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZJOMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:00:15 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35301 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757499AbZJOMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:00:13 -0400
Subject: Re: [PATCH] [ARM] force dcache flush if dcache_dirty bit set
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-arm-kernel@lists.infradead.org,
       David Miller <davem@davemloft.net>, Nitin Gupta <ngupta@vflare.org>
In-Reply-To: <1255540229.15103.50.camel@pc1117.cambridge.arm.com>
References: <1255337423-3158-1-git-send-email-ngupta@vflare.org>
	 <20091012090710.GA29310@n2100.arm.linux.org.uk>
	 <20091012.023744.157085851.davem@davemloft.net>
	 <20091012100023.GC29310@n2100.arm.linux.org.uk>
	 <Pine.LNX.4.64.0910121634170.7327@sister.anvils>
	 <20091012170312.GB9453@flint.arm.linux.org.uk>
	 <20091013020752.GB5736@linux-sh.org>
	 <1255540229.15103.50.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 15 Oct 2009 12:59:13 +0100
Message-Id: <1255607953.10164.63.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2009 11:59:14.0196 (UTC) FILETIME=[EA1D3D40:01CA4D8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 18:10 +0100, Catalin Marinas wrote:
> On Tue, 2009-10-13 at 11:07 +0900, Paul Mundt wrote:
> > On Mon, Oct 12, 2009 at 06:03:12PM +0100, Russell King wrote:
> > > I don't see that there should have been any bearing on whether a page
> > > has a mapping or not when we get to update_mmu_cache.  The issue here
> > > is that > if PG_arch_1 is set on a page, then we didn't flush it at
> > > the time when we believed it was appropriate to do so. <
> > > 
> > > Tell me I'm wrong (having only just sent it to Linus...)
> > 
> > Having looked at the ARM fix, in the !mapping case do you not need the
> > I-cache flush on vma->vm_flags & VM_EXEC? Or is the presumption that
> > flush_icache_page()-type action doesn't need to be undertaken by
> > flush_dcache_page()/update_mmu_cache() when there is no page_mapping()?
> 
> If I understand Nitin's scenario correctly, I think it should also
> invalidate the I-cache.
> 
> For executable anonymous pages containing, it's the user app writing the
> code (JIT etc.) and it calls an ARM-specific syscall for I and D cache
> maintenance. If such page is read back from swap, following Nitin's
> scenario, the I-cache would need to be invalidated as well otherwise it
> can have stale entries.

We can have a scenario where I-cache invalidation would not help on ARM.
Some apps may temporarily change protection from RX to RW to write some
data (not instructions) to a page containing code. If Nitin's scenario
happens when the page is RW, the VM_EXEC wouldn't be set, hence no
I-cache invalidation.

The app would later do mprotect(RX) but on some ARM processors
flush_cache_range() is a no-op and therefore no cache flushing. What
other architectures with Harvard caches do for mprotect(RX)? Is this
assumed to invalidate the I-cache?

(we have another I-D cache coherency problem on ARM with COW text pages
following a RX -> RW -> write data -> RX scenario and there are a few
solutions for this, though none of them optimal with the current cache
flushing API, especially with the read-implies-exec ELF personality)

-- 
Catalin

