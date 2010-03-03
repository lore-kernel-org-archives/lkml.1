Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0CCVyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:54:55 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37352 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752346Ab0CCVyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:54:47 -0500
Date: Wed, 3 Mar 2010 22:54:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
       linux@arm.linux.org.uk, mdharm-kernel@one-eyed-alien.net,
       linux-usb@vger.kernel.org, x0082077@ti.com, sshtylyov@ru.mvista.com,
       tom.leiming@gmail.com, bigeasy@linutronix.de, oliver@neukum.org,
       linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, greg@kroah.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100303215437.GF2579@ucw.cz>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk> <1267316072.23523.1842.camel@pasglop> <1267333263.2762.11.camel@mulgrave.site> <20100302211049V.fujita.tomonori@lab.ntt.co.jp> <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'm not sure that there are some problems in the mm or common code. Is
> > this ARM's implementation issue? (Of course, the usb stack and the
> > driver's misuse of the DMA API needs to be fixed too).
> 
> Just to summarise - on ARM (PIPT / non-aliasing VIPT) there is I-cache
> invalidation for user pages in update_mmu_cache() (it could actually be
> in set_pte_at on SMP to avoid a race but that's for another thread). The
> D-cache is flushed by this function only if the PG_arch_1 bit is set.
> This bit is set in the ARM case by flush_dcache_page(), following the
> advice in Documentation/cachetlb.txt.
> 
> With some drivers (those doing PIO) or subsystems (SCSI mass storage
> over USB HCD), there is no call to flush_dcache_page() for page cache
> pages, hence the ARM implementation of update_mmu_cache() doesn't flush
> the D-cache (and only invalidating the I-cache doesn't help).
> 
> The viable solutions so far:
> 
>      1. Implement a PIO mapping API similar to the DMA API which takes
>         care of the D-cache flushing. This means that PIO drivers would
>         need to be modified to use an API like pio_kmap()/pio_kunmap()
>         before writing to a page cache page.
>      2. Invert the meaning of PG_arch_1 to denote a clean page. This
>         means that by default newly allocated page cache pages are
>         considered dirty and even if there isn't a call to
>         flush_dcache_page(), update_mmu_cache() would flush the D-cache.
>         This is the PowerPC approach.

What about option

3. Forget about PG_arch_1 and always do the flush?

How big is the performance impact? Note that current code does not
even *work* so working, 10% slower code will be an improvement.

								Pavel

(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
