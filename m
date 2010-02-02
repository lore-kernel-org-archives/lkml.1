Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0BBGjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:39:15 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51081 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0BBGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:39:12 -0500
Date: Tue, 2 Feb 2010 15:39:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100202063904.GK13428@linux-sh.org>
References: <20100129185434.GH19501@one-eyed-alien.net> <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 05:29:14PM +0000, Catalin Marinas wrote:
> On Fri, 2010-01-29 at 18:54 +0000, Matthew Dharm wrote:
> > HOWEVER, I firmly believe that the cache-management functions belong with
> > the driver that actually talks to the low-level hardware, as that's the
> > only place where you can be 100% certain of what cache operations are
> > needed.  After all, I think someone is working on a USB-over-IP transport,
> > and trying to manage cache at the usb-storage level in that scenario is
> > just silly.
> > 
> > So, let's put this in the HCD drivers and be done with it.
> 
> The patch below is what fixes the I-D cache incoherency issues on ARM. I
> don't particularly like the solution but it seems to be the only one
> available.
> 
> IMHO, Linux should have functions similar to the DMA API but for PIO
> drivers (e.g. pio_map_single/pio_unmap_single) that non-coherent
> architectures can define, otherwise being no-ops. Any thoughts?
> 
I would certainly be in favour of such a thing, particularly since on SH
we often find ourselves with coherent PIO and non-coherent MMIO.

This is however something that should be prototyped and submitted to
linux-arch for discussion.

> diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
> index 27b8f7c..4d3eeee 100644
> --- a/drivers/usb/host/isp1760-hcd.c
> +++ b/drivers/usb/host/isp1760-hcd.c
> @@ -18,6 +18,8 @@
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
>  #include <asm/unaligned.h>
> +#include <asm/cacheflush.h>
> +#include <asm/memory.h>
>  
asm/memory.h isn't a portable header. If you are including it for
virt_to_page(), linux/io.h should already bring that in via asm/io.h.
If arm doesn't bring in virt_to_page() through its asm/io.h, then fix the
headers there please.

FWIW I used the same fix you came up with on r8a66597_hcd and it fixed up
crashes we were seeing there, too.
