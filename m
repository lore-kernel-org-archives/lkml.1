Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0CBXbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:31:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:51728 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab0CBXbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:31:42 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, santosh.shilimkar@ti.com,
       pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 10:29:54 +1100
Message-ID: <1267572594.2173.25.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 17:05 +0000, Catalin Marinas wrote:

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

I don't see the point of a "PIO" API. I would thus vote for 2 :-) Note
that flushing the D-cache isn't enough, you also need to invalidate the
I-cache as we discussed earlier, though you mostly get away if you don't
by luck.

There's also a question as to whether clearing PG_arch_1 is
flush_dcache_page() is really necessary or not.

> Option 2 above looks pretty appealing to me since it can be done in the
> ARM code exclusively. I've done some tests and it indeed solves the
> cache coherency with a rootfs on a USB stick. As Russell suggested, it
> can be optimised to mark a page as clean when the DMA API is involved to
> avoid duplicate flushing.

That wouldn't solve the need for invalidating the I-cache... Unless we
use another bit.

> It was also suggested to add a PG_arch_2 flag which would keep track of
> the I-cache status as well.
> 
> I can post a proposal to modify the cachetlb.txt document to reflect the
> issues we currently have on ARM.

Cheers,
Ben.

