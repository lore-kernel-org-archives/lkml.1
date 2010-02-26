Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307Ab0BZQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:25:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64609 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965290Ab0BZQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:25:24 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad,Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Oliver Neukum <oliver@neukum.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar,Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1266979632.23523.1668.camel@pasglop>
References: <1266979632.23523.1668.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 26 Feb 2010 16:25:21 +0000
Message-ID: <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2010 16:25:22.0274 (UTC) FILETIME=[4B2F1420:01CAB700]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 02:47 +0000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-02-19 at 17:36 +0000, Catalin Marinas wrote:
> >
> > If a page is already mapped in user space, flush_dcache_page() on ARM
> > does the flushing rather than deferring it to update_mmu_cache().
> 
> This is for D-cache aliases on VIVT right ? Or are you still talking
> about I/D coherency on PIPT ARMs ? Because the later should not matter
> for already mapped userspace pages in the sense that if user space
> explicitely read() onto a page, it's up to userspace to cache clean that
> page before executing from it in my book :-)

I was still thinking about PIPT I/D coherency. The read() case you
mention is pretty clear, no need or the kernel to ensure coherency
(especially since writing is done via copy_to_user rather than to the
page cache page).

For mmap'ed pages (and present in the page cache), is it guaranteed that
the HCD driver won't write to it once it has been mapped into user
space? If that's the case, it may solve the problem by just reversing
the meaning of PG_arch_1 on ARM and assume that a newly allocated page
has dirty D-cache by default.

> > The PIO HCD drivers, however, don't call flush_dcache_page(). Is it possible
> > that the HCD could transfer data into a page cache page already mapped
> > in user space? My understanding is that the scenario above is possible.
> 
> It is but I'm not confident the responsibility for doing that cleanup
> is at the HCD level. That would impact a lot of HCD activities that
> don't need such flushing since the use of the page is purely in-kernel.
> 
> Though I suppose that could be optimized out in most case using the page
> use count.
> 
> But I still wonder whether it should be pushed down to the actual
> interface drivers, that's always been the case I believe. In fact, in
> the case of block ops, it's generally done at the BIO or even file
> system layer right ?

The filesystem layer does it only if it needs to touch the data written
by the block device (e.g. cramfs, jffs). Some block devices call
flush_dcache_page (like mmci.c) while some others don't (and those that
use DMA actually don't since the DMA API handles the flushing).

-- 
Catalin

