Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0BQWd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:33:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:40457 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab0BQWd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:33:26 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Oliver Neukum <oliver@neukum.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100217204404.GD30033@n2100.arm.linux.org.uk>
References: <20100208065519.GE1290@ucw.cz>
	 <1265628483.4020.63.camel@pc1117.cambridge.arm.com>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
	 <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop>
	 <1266420475.16707.31.camel@e102109-lin.cambridge.arm.com>
	 <1266439020.16346.285.camel@pasglop>
	 <20100217204404.GD30033@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 09:31:32 +1100
Message-ID: <1266445892.16346.306.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 20:44 +0000, Russell King - ARM Linux wrote:
> No, because that'd probably bugger up the Sparc64 method of delaying
> flush_dcache_page.
> 
> This method works as follows:
> 
> - a page cache page is allocated - this has PG_arch_1 clear.
> 
> - IO happens on it and it's placed into the page cache.  PG_arch_1 is
>   still clear.
> 
> - someone calls read()/write() which accesses the page.  The generic
>   file IO layers call flush_dcache_page() in response to
> read()/write()
>   fs calls.  flush_dcache_page() spots that the page is not yet mapped
>   into userspace, and sets PG_arch_1 to mark the fact that the kernel
>   mapping is dirty.
> 
> - when someone maps the page, we check PG_arch_1 in update_mmu_cache.
>   If PG_arch_1 is set, we flush the kernel mapping.
> 
> Clearly, if we go around having drivers clearing PG_arch_1, this is
> going to break horribly. 

Ok, you do things very differently than us on ppc then. We clear
PG_arch_1 in flush_dcache_page(), and we set it when the page has been
cache cleaned for execution.

We assume that anybody that dirties a page in the kernel will call
flush_dcache_page() which removes our PG_arch_1 bit thus marking the
page "dirty".

Note that from experience, doing the check & flushes in
update_mmu_cache() is racy on SMP. At least for I$/D$, we have the case
where processor one does set_pte followed by update_mmu_cache(). The
later isn't done yet but processor 2 sees the PTE now and starts using
it, cache hasn't been fully flushed yet. You may avoid that race in some
ways, but on ppc, I've stopped using that.

I now do things directly in set_pte_at(). In fact, that's why I want
your patch to change update_mmu_cache() to take a PTE pointer :-) Since
my set_pte_at() can now remove the _PAGE_EXEC bit, I need
update_mmu_cache() to re-read the PTE before it updates the hash table
or TLB.

Cheers,
Ben.

