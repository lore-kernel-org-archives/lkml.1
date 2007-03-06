Return-Path: <linux-kernel-owner+w=401wt.eu-S933934AbXCFEUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934AbXCFEUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 23:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933935AbXCFEUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 23:20:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933934AbXCFEUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 23:20:32 -0500
Date: Mon, 5 Mar 2007 20:17:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, sdhci-devel@list.drzeus.cx,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
Message-Id: <20070305201707.8d8a092e.akpm@linux-foundation.org>
In-Reply-To: <45EC351B.2020206@rtr.ca>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015031.GF3441@stusta.de>
	<45EB9DC6.8010403@rtr.ca>
	<45EB9E72.6040107@rtr.ca>
	<45EBAC73.7010600@drzeus.cx>
	<45EC2851.7020905@rtr.ca>
	<45EC351B.2020206@rtr.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2007 10:19:55 -0500 Mark Lord <lkml@rtr.ca> wrote:

> The interrupt is shared with another device, which resumes
> earlier than the sdhci controller, and generates an interrupt.
> 
> The sdhci interrupt handler runs, sees 0xffffffff in its own
> device's interrupt status, and tries to handle it..
> The reason for the 0xffffffff is that the device is still
> suspended, and *all* regs are reading back 0xffffffff.
> 
> So.. the suspend routine should de-register the irq handler,
> and the resume routine should re-register it again.
> 
> Or perhaps a simpler kludge like this one, which fixes it for me:
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com>
> ---
> --- linux/drivers/mmc/sdhci.c.orig	2007-03-02 15:06:31.000000000 -0500
> +++ linux/drivers/mmc/sdhci.c	2007-03-05 10:13:51.000000000 -0500
> @@ -994,7 +994,7 @@
>  
>  	intmask = readl(host->ioaddr + SDHCI_INT_STATUS);
>  
> -	if (!intmask) {
> +	if (!intmask || intmask == 0xffffffff) {
>  		result = IRQ_NONE;
>  		goto out;
>  	}

This is actually pretty standard handling for a lot of drivers: any
device which can appear on a cardbus or other hot-unpluggable bus and which
shares interupts needs such treatment.

I don't know whether anything which this driver drives could ever appear on
such a bus, but I'm inclined to just apply it into 2.6.21.

(I'm also inclined to drop the darned mmc tree - am getting rather tired of
people moving their files all over the tree all the time).

