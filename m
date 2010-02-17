Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab0BQP2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 10:28:01 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62556 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315Ab0BQP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 10:28:00 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1266397543.16346.264.camel@pasglop>
References: <20100208065519.GE1290@ucw.cz>
	 <1265628483.4020.63.camel@pc1117.cambridge.arm.com>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com>
	 <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 17 Feb 2010 15:27:55 +0000
Message-ID: <1266420475.16707.31.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2010 15:27:56.0778 (UTC) FILETIME=[C7CA5CA0:01CAAFE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 20:05 +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2010-02-16 at 09:22 +0100, Oliver Neukum wrote:
> > This seems wrong to me. Buffers for control transfers may be
> > transfered
> > by DMA, so the caches must be flushed on architectures whose caches
> > are not coherent with respect to DMA.
> > 
> > Would you care to elaborate on the exact nature of the bug you are
> > fixing?
> 
> I missed part of this thread, so forgive me if I'm a bit off here, but
> if the problem is indeed I$/D$ cache coherency vs. PIO transfers, then
> this is a long solved issue on other archs such as ppc (and I _think_
> sparc).

The thread I started was indeed regarding I/D cache coherency and PIO.
But it diverged into DMA issues a few days ago (should have been a new
thread).

> The way we do it, at least on powerpc which is PIPT, is to keep track on
> a per-page basis, whether a given page is clean for execution using
> PG_arch1 bit. This bit is cleared when a new page is popped into the
> page cache, and we clear it from flush_dcache_page() iirc (you may want
> to dbl check I don't have the code at hand right now, or rather, I do
> but I'm to lazy to look right now :-)

We do the same on ARM. The problem with most (all) HCD drivers that do
PIO is that they copy the data to the transfer buffer but there is no
call in this driver to flush_dcache_page(). The upper mass storage or
filesystem layers don't call this function either, so there isn't
anything that would set the PG_arch1 bit.

-- 
Catalin

