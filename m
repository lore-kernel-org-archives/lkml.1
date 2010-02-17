Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0BQMa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 07:30:28 -0500
Received: from mail2.shareable.org ([80.68.89.115]:53309 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab0BQMaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 07:30:25 -0500
Date: Wed, 17 Feb 2010 12:29:59 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Oliver Neukum <oliver@neukum.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Ming Lei <tom.leiming@gmail.com>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100217122959.GA13177@shareable.org>
References: <20100208065519.GE1290@ucw.cz> <201002160922.47072.oliver@neukum.org> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7DBB@dbde02.ent.ti.com> <201002161007.20576.oliver@neukum.org> <20100216093946.GA13884@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100216093946.GA13884@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Tue, Feb 16, 2010 at 10:07:20AM +0100, Oliver Neukum wrote:
> > Am Dienstag, 16. Februar 2010 09:55:55 schrieb Shilimkar, Santosh:
> > > > Would you care to elaborate on the exact nature of the bug you are fixing?
> > > On the OMAP4 (ARM cortex-a9) platform, the enumeration fails because control
> > > transfer buffers are corrupted. On our platform, we use PIO mode for control 
> > > transfers and DMA for bulk transfers.
> > > 
> > > The current stack performs dma cache maintenance even for the PIO transfers
> > > which leads to the corruption issue. The control buffers are handled by CPU 
> > > and they already coherent from CPU point of view.
> > 
> > How does the mapping corrupt buffers? It might impact performance, but why
> > do you see corruption?
> 
> On map, buffers are cleaned if they're being used for DMA_TO_DEVICE and
> DMA_BIDIRECTIONAL, or invalidated in the case of DMA_FROM_DEVICE.
> 
> However, because ARM CPUs can now speculatively prefetch, just leaving it
> at that results in corruption of buffers used for DMA.  So we have to
> invalidate DMA_FROM_DEVICE and DMA_BIDIRECTIONAL buffers on unmap to
> ensure coherency with DMA operations.
> 
> If the CPU writes to a DMA_FROM_DEVICE buffer between map and unmap, the
> writes can sit in the cache, and on unmap, they will be discarded.
> 
> Cleaning the cache on unmap is not an option; that too can lead to DMA
> buffer corruption in the DMA case.

Provided the buffers are cleaned on map for
DMA_TO_DEVICE/DMA_BIDIRECTIONAL, I don't see how cleaning on unmap for
DMA_FROM_DEVICE/DMA_BIDIRECTIONAL can cause corruption.  The only way
to get dirty cache lines while mapped is if the CPU did PIO to them.
If it was real DMA, the second clean should be a no-op.  (Assume it's
all one or the other).

Can you explain why cleanining the cache on unmap (as well as map, in
DMA_BIDIRECTIONAL case) is not an option?  Just curious, because I
don't see what would go wrong.

> USB and associated host driver must abide by the DMA API buffer
> ownership rules otherwise the result will be data corruption; either
> that or USB/host driver people need to have a discussion with the
> DMA API authors to remove this sensible "restriction".

Just in case my question gives the wrong impression, I agree that the
DMA API must be followed. Additional flushes/cleans are not good for
performance either.

-- Jamie
