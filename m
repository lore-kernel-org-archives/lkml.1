Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0BPJke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:40:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44278 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0BPJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:40:32 -0500
Date: Tue, 16 Feb 2010 09:39:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100216093946.GA13884@n2100.arm.linux.org.uk>
References: <20100208065519.GE1290@ucw.cz> <201002160922.47072.oliver@neukum.org> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7DBB@dbde02.ent.ti.com> <201002161007.20576.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002161007.20576.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 10:07:20AM +0100, Oliver Neukum wrote:
> Am Dienstag, 16. Februar 2010 09:55:55 schrieb Shilimkar, Santosh:
> > > Would you care to elaborate on the exact nature of the bug you are fixing?
> > On the OMAP4 (ARM cortex-a9) platform, the enumeration fails because control
> > transfer buffers are corrupted. On our platform, we use PIO mode for control 
> > transfers and DMA for bulk transfers.
> > 
> > The current stack performs dma cache maintenance even for the PIO transfers
> > which leads to the corruption issue. The control buffers are handled by CPU 
> > and they already coherent from CPU point of view.
> 
> How does the mapping corrupt buffers? It might impact performance, but why
> do you see corruption?

On map, buffers are cleaned if they're being used for DMA_TO_DEVICE and
DMA_BIDIRECTIONAL, or invalidated in the case of DMA_FROM_DEVICE.

However, because ARM CPUs can now speculatively prefetch, just leaving it
at that results in corruption of buffers used for DMA.  So we have to
invalidate DMA_FROM_DEVICE and DMA_BIDIRECTIONAL buffers on unmap to
ensure coherency with DMA operations.

If the CPU writes to a DMA_FROM_DEVICE buffer between map and unmap, the
writes can sit in the cache, and on unmap, they will be discarded.

Cleaning the cache on unmap is not an option; that too can lead to DMA
buffer corruption in the DMA case.

USB and associated host driver must abide by the DMA API buffer
ownership rules otherwise the result will be data corruption; either
that or USB/host driver people need to have a discussion with the
DMA API authors to remove this sensible "restriction".
