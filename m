Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0BHJvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:51:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62388 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168Ab0BHJvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:51:44 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100208065519.GE1290@ucw.cz>
References: <20100208065519.GE1290@ucw.cz>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 08 Feb 2010 09:51:16 +0000
Message-Id: <1265622676.4020.19.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2010 09:51:18.0058 (UTC) FILETIME=[42B288A0:01CAA8A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-02-08 at 06:55 +0000, Pavel Machek wrote:
> > > So, let's put this in the HCD drivers and be done with it.
> >
> > The patch below is what fixes the I-D cache incoherency issues on ARM. I
> > don't particularly like the solution but it seems to be the only one
> > available.
> 
> Really? It looks like arm should just flush the caches when mapping
> executable page to the userspace.... you can't expect all the drivers
> to be modified like that...

We could of course flush the caches every time we get a page fault but
that's far from optimal, especially since DMA-capable drivers to do not
pollute the D-cache and don't need this extra flushing. Note that the
recent ARM processors have PIPT caches but separate for I and D and it's
the PIO drivers that pollute the D-cache.

The kernel API provides flush_dcache_page() to be called every time the
kernel writes to a page cache page. This is further optimised for
working in pair with update_mmu_cache() to delay the flushing until the
actual page is mapped into user space and this latter function is called
(which in general is not a cache maintenance function).

The problem with some PIO drivers and a filesystems like ext2 is that
there is no call to flush_dcache_page() when getting data into a page
cache page. Since the page isn't marked as dirty (PG_arch_1), a
subsequent call to update_mmu_cache() as a result of a page fault
doesn't flush the caches.

There is a flush_icache_page() function called from __do_fault(),
however, Documentation/cachetlb.txt states that all the functionality of
this function can be implemented in flush_dcache_page() and
update_mmu_cache(), hence this function is a no-op.

Please suggest a better solution that does not involve modifying generic
Linux code.

> Plus it does unneccessary flushes on x86, etc...

On x86, it should indeed be conditionally compiled based on
ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.

Regards.

-- 
Catalin

