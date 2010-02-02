Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0BBLJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 06:09:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64904 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab0BBLJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:09:47 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20100202091139.GA3591@www.tglx.de>
References: <20100202091139.GA3591@www.tglx.de>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 11:09:34 +0000
Message-Id: <1265108974.12634.42.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 11:09:35.0764 (UTC) FILETIME=[34451540:01CAA3F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 09:11 +0000, Sebastian Andrzej Siewior wrote:
> * Catalin Marinas | 2010-02-01 17:29:14 [+0000]:
> >> So, let's put this in the HCD drivers and be done with it.
> 
> That is the correct place. MMC -hcd drivers for instance are doing this
> way.
> 
> >The patch below is what fixes the I-D cache incoherency issues on ARM. I
> >don't particularly like the solution but it seems to be the only one
> >available.
> 
> The PIO-MMC drivers walk through a scatter list via sg_miter_start() and
> friends. Those helpers take care of this automaticly.
> 
> >IMHO, Linux should have functions similar to the DMA API but for PIO
> >drivers (e.g. pio_map_single/pio_unmap_single) that non-coherent
> >architectures can define, otherwise being no-ops. Any thoughts?
> 
> What is wrong with flush_dcache_page() ? 

In this particular case, it's too many lines to do the virt_to_page for
the transfer buffer since the HCD driver doesn't have access to the
individual pages (via something like urb->sg). A better solution would
be to move such loop in a flush_dcache_range() function to make it
easier for drivers.

Apart from that, flush_dcache_page() doesn't have any data flow
information. Optimisations could be done on ARM if we know that the
kernel only intends to read from a page (no flushing necessary with a
non-aliasing D-cache).

> And I think linux-arch is the appropriate place.

For changes to the cache flushing API, yes, that's the right place. I'll
get there with a patch.
> 
> >diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
> >index 27b8f7c..4d3eeee 100644
> >--- a/drivers/usb/host/isp1760-hcd.c
> >+++ b/drivers/usb/host/isp1760-hcd.c
> >@@ -18,6 +18,8 @@
> > #include <linux/uaccess.h>
> > #include <linux/io.h>
> > #include <asm/unaligned.h>
> >+#include <asm/cacheflush.h>
> >+#include <asm/memory.h>
> 
> I'm fine with the patch generally but I don't like the asm headers.
> cacheflush.h is available on most architectures as far as I can see it but
> memory.h is only available on arm. So you break the build on !arm and
> therefore I NAK this.

Yes, that was already pointed out. I'll post a revised patch (until we
maybe get a better API for such things but that's for linux-arch).

Thanks.

-- 
Catalin

