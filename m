Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0CCKkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:40:22 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65491 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab0CCKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:40:20 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, santosh.shilimkar@ti.com,
       pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267572594.2173.25.camel@pasglop>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <1267572594.2173.25.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 03 Mar 2010 10:40:17 +0000
Message-ID: <1267612817.15589.55.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2010 10:40:18.0545 (UTC) FILETIME=[EADD7E10:01CABABD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 23:29 +0000, Benjamin Herrenschmidt wrote:
> On Tue, 2010-03-02 at 17:05 +0000, Catalin Marinas wrote:
> 
> > The viable solutions so far:
> >
> >      1. Implement a PIO mapping API similar to the DMA API which takes
> >         care of the D-cache flushing. This means that PIO drivers would
> >         need to be modified to use an API like pio_kmap()/pio_kunmap()
> >         before writing to a page cache page.
> >      2. Invert the meaning of PG_arch_1 to denote a clean page. This
> >         means that by default newly allocated page cache pages are
> >         considered dirty and even if there isn't a call to
> >         flush_dcache_page(), update_mmu_cache() would flush the D-cache.
> >         This is the PowerPC approach.
[...]
> > Option 2 above looks pretty appealing to me since it can be done in the
> > ARM code exclusively. I've done some tests and it indeed solves the
> > cache coherency with a rootfs on a USB stick. As Russell suggested, it
> > can be optimised to mark a page as clean when the DMA API is involved to
> > avoid duplicate flushing.
> 
> That wouldn't solve the need for invalidating the I-cache... Unless we
> use another bit.

Indeed. We currently always invalidate the I-cache when the page is
mapped. With PG_arch_2, we could optimise this but I'm not sure it is
worth since I think we only get an update_mmu_cache() call for a page
(unless it is unmapped and re-mapped again).

-- 
Catalin

