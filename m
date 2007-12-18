Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXLRA6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXLRA6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXLRA63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:58:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbXLRA62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:58:28 -0500
Date: Mon, 17 Dec 2007 16:57:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <47671377.6000405@redhat.com>
Message-ID: <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Dec 2007, Chuck Ebbert wrote:
>
> Looks like a commit that I can't find in git due to the arch merge
> has broken PCI address assignment. This patch by Richard Henderson
> against 2.6.23 fixes it for x86_64:
> 
> --- linux-2.6.23.x86_64/arch/x86_64/kernel/e820.c	2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23.x86_64-rth/arch/x86_64/kernel/e820.c	2007-12-15 12:37:44.000000000 -0800
> @@ -718,8 +718,8 @@ __init void e820_setup_gap(void)
>  	while ((gapsize >> 4) > round)
>  		round += round;
>  	/* Fun with two's complement */
> -	pci_mem_start = (gapstart + round) & -round;
> +	pci_mem_start = (gapstart + round - 1) & -round;

No, it's very much meant to be that way.

We do *not* want to have the PCI memory abutthe end of memory exactly. So 
it leaves a gap in between "gapstart" and the actual start of PCI memory 
addressing very much on purpose.

In fact, the very commit (it's f0eca9626c6becb6fc56106b2e4287c6c784af3d in 
the kernel tree) you mention actually explicitly *explains* that, although 
maybe it's a bit indirect: if you start allocating PCI resources directly 
after the end-of-RAM thing, you can easily end up using addresses that are 
actually inside the magic stolen system RAM that is being used for UMA 
video etc.

So you very much want to have a buffer in between the end-of-RAM and the 
actual start of the region we try to allocate in. 

So why do you want them to be close, anyway? 

		Linus

PS. On a different topic: if you do

	git log --follow arch/x86/kernel/e820_64.c

you'd see the history past the renames in git. Or just do a "git blame -C" 
which will also follow renames (and copies).
