Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744Ab0A2ROw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0A2ROw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060Ab0A2ROv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:14:51 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64432 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab0A2ROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:14:50 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Ming Lei <tom.leiming@gmail.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <201001291741.11786.oliver@neukum.org>
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
	 <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com>
	 <1264782843.4242.91.camel@pc1117.cambridge.arm.com>
	 <201001291741.11786.oliver@neukum.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 29 Jan 2010 17:14:42 +0000
Message-Id: <1264785282.4242.109.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2010 17:14:43.0607 (UTC) FILETIME=[8CB5A270:01CAA106]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 16:41 +0000, Oliver Neukum wrote:
> Am Freitag, 29. Januar 2010 17:34:03 schrieb Catalin Marinas:
> 
> > I was thinking about checking dev->bus->controller->dma_mask which the
> > code (though not the storage one) seems to imply that if the dma_mask is
> > 0, the HCD driver is only capable of PIO.
> 
> That a HCD is capable of DMA need not imply that DMA is used for every
> transfer.

Actually the DMA drivers are safe in this respect only if the transfer
happens directly to a page cache page that may be (later) mapped into
user space. I'm not familiar with the USB drivers to fully understand
the data flow, so any help would be appreciated.

> > That would be a more general solution rather than going through each HCD
> > driver since my understanding is that flush_dcache_page() is only needed
> > together with the mass storage support.
> 
> What about ub, nfs or nbd over a USB<->ethernet converter?
> This, I am afraid is best solved at the HCD or glue layer.

NFS handles the cache flushing itself, so in this case there is no need
to duplicate the cache flushing at the HCD level. AFAICT, the HCD driver
may be used in several cases and it's only the storage case (via either
ub, mass storage etc.) that requires cache flushing. Is there a way to
differentiate between these at the HCD driver level?

Regarding nbd, is there any copying happening between the HCD driver
receiving the network packet from the USB-ethernet converter and the nbd
bio_vec buffers (most likely during the TCP/IP stack flow)? In this case
it would be for the nbd driver (doesn't seem to be the case now) to
flush the D-cache as the HCD flushing is not necessary as long as it
doesn't write directly to the page cache page.

The ub case is similar to the USB mass storage one, so they could both
benefit from flushing at the HCD driver level. But is this possible
without duplicating the flushing in the nfs case?

Regards.

-- 
Catalin

