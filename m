Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0CBRr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:47:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56938 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab0CBRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:47:56 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, benh@kernel.crashing.org,
       bigeasy@linutronix.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       santosh.shilimkar@ti.com, pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 02 Mar 2010 17:47:52 +0000
Message-ID: <1267552072.15401.83.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2010 17:47:53.0691 (UTC) FILETIME=[7C1C5AB0:01CABA30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 17:05 +0000, Catalin Marinas wrote:
> On Tue, 2010-03-02 at 21:11 +0900, FUJITA Tomonori wrote:
> > On Sun, 28 Feb 2010 10:31:03 +0530
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > But the point of all of this is that I cache invalidation doesn't appear
> > > anywhere in the I/O path ... so  if we're getting I/D incoherency,
> > > there's some problem in the mm code (or there's a missing arch
> > > assumption ... like I cache gets moved in more aggressively than we
> > > expect).  Parisc is very sensitive to I/D incoherency, so we'd notice if
> > > there were a serious generic problem here.
> >
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
> 
> Option 2 above looks pretty appealing to me since it can be done in the
> ARM code exclusively. I've done some tests and it indeed solves the
> cache coherency with a rootfs on a USB stick. As Russell suggested, it
> can be optimised to mark a page as clean when the DMA API is involved to
> avoid duplicate flushing.

Actually, option 2 still has an issue - does not easily work on SMP
systems where cache maintenance operations aren't broadcast in hardware.
In this case (ARM11MPCore), flush_dcache_page() is implemented
non-lazily so that the flushing happens on the same processor that
dirtied the cache. But since with some drivers there is no call to this
function, it wouldn't make any difference.

A solution is to do something like read-for-ownership before flushing
the D-cache in update_mmu_cache() (or set_pte_at()).

-- 
Catalin

