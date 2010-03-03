Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0CCKVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:21:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63778 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab0CCKVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:21:51 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, linux-usb@vger.kernel.org,
       linux@arm.linux.org.uk, tom.leiming@gmail.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, greg@kroah.com, bigeasy@linutronix.de,
       oliver@neukum.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, santosh.shilimkar@ti.com,
       pavel@ucw.cz, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267572834.2173.28.camel@pasglop>
References: <20100226210030.GC23933@n2100.arm.linux.org.uk>
	 <1267316072.23523.1842.camel@pasglop>
	 <1267333263.2762.11.camel@mulgrave.site>
	 <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <1267552072.15401.83.camel@e102109-lin.cambridge.arm.com>
	 <1267572834.2173.28.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 03 Mar 2010 10:21:48 +0000
Message-ID: <1267611708.15589.52.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2010 10:21:49.0247 (UTC) FILETIME=[55AC0CF0:01CABABB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 23:33 +0000, Benjamin Herrenschmidt wrote:
> On Tue, 2010-03-02 at 17:47 +0000, Catalin Marinas wrote:
> >
> > Actually, option 2 still has an issue - does not easily work on SMP
> > systems where cache maintenance operations aren't broadcast in hardware.
> > In this case (ARM11MPCore), flush_dcache_page() is implemented
> > non-lazily so that the flushing happens on the same processor that
> > dirtied the cache. But since with some drivers there is no call to this
> > function, it wouldn't make any difference.
> 
> Also, option 1 would not solve the icache issue which has the same
> problem related to IPIs. 

Correct. But that's true for both options.

It would have been simpler if we had software TLBs.

> You -really- need to spank some HW folks here :-)

I think they got the message :). Cortex-A9 does it properly.

> > A solution is to do something like read-for-ownership before flushing
> > the D-cache in update_mmu_cache() (or set_pte_at()).
> 
> You might also want to experiment with not clearing PG_arch_1 in
> flush_dcache_page(). I'm not 100% convinced it is necessary and that may
> reduce the amount of flushing needed.

Could a file map page be swapped out (and the mapping removed), then the
page cache page modified (i.e. NFS filesystem) and flush_dcache_page()
called?

> Another thing is, on powerpc, we only do the cleaning when we try to
> execute from the pages. IE. We basically "filter out" exec permission
> when pages are not clean. At least on processors that support per-page
> exec permission. You may want to consider something like that as well.

For non-aliasing VIPT, I think that's a fair optimisation.

Thanks.

-- 
Catalin

