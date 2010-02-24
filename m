Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0BXCs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 21:48:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:44013 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab0BXCsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 21:48:55 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
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
In-Reply-To: <1266601011.32546.48.camel@e102109-lin.cambridge.arm.com>
References: <1266445892.16346.306.camel@pasglop>
	 <1266599755.32546.38.camel@e102109-lin.cambridge.arm.com>
	 <1266601011.32546.48.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 13:47:12 +1100
Message-ID: <1266979632.23523.1668.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 17:36 +0000, Catalin Marinas wrote:
> 
> If a page is already mapped in user space, flush_dcache_page() on ARM
> does the flushing rather than deferring it to update_mmu_cache(). 

This is for D-cache aliases on VIVT right ? Or are you still talking
about I/D coherency on PIPT ARMs ? Because the later should not matter
for already mapped userspace pages in the sense that if user space
explicitely read() onto a page, it's up to userspace to cache clean that
page before executing from it in my book :-)

> The PIO HCD drivers, however, don't call flush_dcache_page(). Is it possible
> that the HCD could transfer data into a page cache page already mapped
> in user space? My understanding is that the scenario above is possible.

It is but I'm not confident the responsibility for doing that cleanup
is at the HCD level. That would impact a lot of HCD activities that
don't need such flushing since the use of the page is purely in-kernel.

Though I suppose that could be optimized out in most case using the page
use count.

But I still wonder whether it should be pushed down to the actual
interface drivers, that's always been the case I believe. In fact, in
the case of block ops, it's generally done at the BIO or even file
system layer right ?

Cheers,
Ben.


