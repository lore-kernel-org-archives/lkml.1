Return-Path: <linux-kernel-owner+w=401wt.eu-S932179Ab0A2QeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0A2QeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529Ab0A2QeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:34:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60734 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715Ab0A2QeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:34:10 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com>
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
	 <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 29 Jan 2010 16:34:03 +0000
Message-Id: <1264782843.4242.91.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2010 16:34:04.0435 (UTC) FILETIME=[DED98630:01CAA100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 16:23 +0000, Ming Lei wrote:
> 2010/1/29 Catalin Marinas <catalin.marinas@arm.com>:
> > I've been trying for some time to use a rootfs (ext2) on a USB memory
> > stick on ARM platforms but without any success. The USB HCD driver is
> > ISP1760 which doesn't use DMA.
> >
> > ARM has a Harvard cache architecture and what I get is incoherency
> > between the I and D caches. The CPU I'm using (ARM11MPCore) has PIPT
> > caches with D-cache lines allocation on write.
> >
> > Basically, when user space tries to execute from a new page, it faults
> > and the data is requested via the VFS layer, SCSI block device and USB
> > mass storage from the ISP1760 driver. The page is then mapped into user
> > space and update_mmu_cache() called.
> >
> > However, since the driver is PIO, the data copied from the USB device
> > into RAM gets stuck in the D-cache. On the above page requesting path
> > there is no call to flush_dcache_page() to handle D-cache maintenance
> > (for DMA drivers, that's handled by the DMA API).
> >
> > Since the USB mass storage code has the information about the USB driver
> 
> Sorry,  I am a little confused that usb mass storage has what information
> about DMA or PIO of low level usb transfer?

I was thinking about checking dev->bus->controller->dma_mask which the
code (though not the storage one) seems to imply that if the dma_mask is
0, the HCD driver is only capable of PIO.

That would be a more general solution rather than going through each HCD
driver since my understanding is that flush_dcache_page() is only needed
together with the mass storage support.

-- 
Catalin

