Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0CEQxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:53:05 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63504 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941Ab0CEQxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:53:00 -0500
Subject: Re: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20100304214435.GJ13417@n2100.arm.linux.org.uk>
References: <20100304214435.GJ13417@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 05 Mar 2010 16:52:40 +0000
Message-ID: <1267807960.2581.5.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2010 16:52:41.0566 (UTC) FILETIME=[452B6FE0:01CABC84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 21:44 +0000, Russell King - ARM Linux wrote:
> On Thu, Mar 04, 2010 at 06:36:42PM +0000, Catalin Marinas wrote:
> > ARM: Assume new page cache pages have dirty D-cache
> >
> > From: Catalin Marinas <catalin.marinas@arm.com>
> >
> > There are places in Linux where writes to newly allocated page cache
> > pages happen without a subsequent call to flush_dcache_page() (several
> > PIO drivers including USB HCD). This patch changes the meaning of
> > PG_arch_1 to be PG_dcache_clean and always flush the D-cache for a newly
> > mapped page in update_mmu_cache().
> >
> > The patch also sets the PG_arch_1 bit in the DMA cache maintenance
> > function to avoid additional cache flushing in update_mmu_cache().
> 
> As I just realised, this is going to subject all pages placed into
> userspace with a D cache flush - even anonymous pages, and those
> which we've been careful to deal with the cache issues already (eg,
> via the COW page copying code.)
> 
> I think all the copypage functions need to set PG_dcache_clean on the
> new pages once their copy has completed.

As Ben said, I think we can set PG_dcache_clean in the
clear/copy_user_page() functions. My doubt with these functions is the
highmem cases where kunmap_atomic() only flushes the D-cache in one
situation, the other just calling kunmap_high() which doesn't seem to do
anything to the caches.

But for non-aliasing VIPT, do we actually need the D-cache flushing in
kunmap_atomic() or copy_user_page()? If we default to new page being
dirty, I think we can remove the cache cleaning from this function and
leave it for update_mmu_cache (or set_pte_at but that's for a different
patch).

-- 
Catalin

