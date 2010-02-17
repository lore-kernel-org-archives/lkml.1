Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab0BQJ7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:59:54 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44685 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933742Ab0BQJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:59:51 -0500
Date: Wed, 17 Feb 2010 09:55:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100217095553.GA30033@n2100.arm.linux.org.uk>
References: <20100208065519.GE1290@ucw.cz> <1265628483.4020.63.camel@pc1117.cambridge.arm.com> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com> <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266397543.16346.264.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 08:05:43PM +1100, Benjamin Herrenschmidt wrote:
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

Nope.  It's to do with mapping a buffer for DMA, and then doing PIO
reads/writes to it.

With speculative prefetches, you have to deal with cache coherency with
hardware DMA on DMA unmap.  If you've written to the buffer in violation
of the DMA API buffer ownership rules, then your writes get thrown away
resulting in immediate data corruption.
