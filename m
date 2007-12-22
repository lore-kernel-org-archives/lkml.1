Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXLVJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXLVJYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXLVJYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:24:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbXLVJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:24:40 -0500
Date: Sat, 22 Dec 2007 01:22:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Richard Henderson <rth@twiddle.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI resource problems caused by improper address rounding
Message-Id: <20071222012205.231f23d6.akpm@linux-foundation.org>
In-Reply-To: <47671377.6000405@redhat.com>
References: <47671377.6000405@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 19:25:27 -0500 Chuck Ebbert <cebbert@redhat.com> wrote:

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
>  
>  	printk(KERN_INFO "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
>  		pci_mem_start, gapstart, gapsize);
> 
> 
> Here is the original changeset, taken from the Mercurial repo. It was
> merged in 2.6.14:
> 
> # HG changeset patch
> # User Daniel Ritz <daniel.ritz@gmx.ch>
> # Date 1126304746 -700
> # Node ID 51367d6e0b839be0b425a8f67c29f625b670f126
> # Parent f4852c862b04efc9f8e2c7913191f5f7d140d895
> [PATCH] Update PCI IOMEM allocation start
> 
> This fixes the problem with "Averatec 6240 pcmcia_socket0: unable to
> apply power", which was due to the CardBus IOMEM register region being
> allocated at an address that was actually inside the RAM window that had
> been reserved for video frame-buffers in an UMA setup.
> 
> The BIOS _should_ have marked that region reserved in the e820 memory
> descriptor tables, but did not.
> 
> It is fixed by rounding up the default starting address of PCI memory
> allocations, so that we leave a bigger gap after the final known memory
> location.  The amount of rounding depends on how big the unused memory
> gap is that we can allocate IOMEM from.
> 
> Based on example code by Linus.
> 
> Acked-by: Greg KH <greg@kroah.com>
> Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> 
> committer: Linus Torvalds <torvalds@g5.osdl.org> 1126304746 -0700
> 
> 
> --- a/arch/i386/kernel/setup.c	Fri Sep 09 22:28:40 2005 +0011
> +++ b/arch/i386/kernel/setup.c	Fri Sep 09 22:37:26 2005 +0011
> @@ -1300,7 +1300,7 @@ legacy_init_iomem_resources(struct resou
>   */
>  static void __init register_memory(void)
>  {
> -	unsigned long gapstart, gapsize;
> +	unsigned long gapstart, gapsize, round;
>  	unsigned long long last;
>  	int	      i;
>  
> @@ -1345,14 +1345,14 @@ static void __init register_memory(void)
>  	}
>  
>  	/*
> -	 * Start allocating dynamic PCI memory a bit into the gap,
> -	 * aligned up to the nearest megabyte.
> -	 *
> -	 * Question: should we try to pad it up a bit (do something
> -	 * like " + (gapsize >> 3)" in there too?). We now have the
> -	 * technology.
> +	 * See how much we want to round up: start off with
> +	 * rounding to the next 1MB area.
>  	 */
> -	pci_mem_start = (gapstart + 0xfffff) & ~0xfffff;
> +	round = 0x100000;
> +	while ((gapsize >> 4) > round)
> +		round += round;
> +	/* Fun with two's complement */
> +	pci_mem_start = (gapstart + round) & -round;
>  
>  	printk("Allocating PCI resources starting at %08lx (gap: %08lx:%08lx)\n",
>  		pci_mem_start, gapstart, gapsize);
> --- a/arch/x86_64/kernel/e820.c	Fri Sep 09 22:28:40 2005 +0011
> +++ b/arch/x86_64/kernel/e820.c	Fri Sep 09 22:37:26 2005 +0011
> @@ -567,7 +567,7 @@ unsigned long pci_mem_start = 0xaeedbabe
>   */
>  __init void e820_setup_gap(void)
>  {
> -	unsigned long gapstart, gapsize;
> +	unsigned long gapstart, gapsize, round;
>  	unsigned long last;
>  	int i;
>  	int found = 0;
> @@ -604,14 +604,14 @@ __init void e820_setup_gap(void)
>  	}
>  
>  	/*
> -	 * Start allocating dynamic PCI memory a bit into the gap,
> -	 * aligned up to the nearest megabyte.
> -	 *
> -	 * Question: should we try to pad it up a bit (do something
> -	 * like " + (gapsize >> 3)" in there too?). We now have the
> -	 * technology.
> +	 * See how much we want to round up: start off with
> +	 * rounding to the next 1MB area.
>  	 */
> -	pci_mem_start = (gapstart + 0xfffff) & ~0xfffff;
> +	round = 0x100000;
> +	while ((gapsize >> 4) > round)
> +		round += round;
> +	/* Fun with two's complement */
> +	pci_mem_start = (gapstart + round) & -round;
>  
>  	printk(KERN_INFO "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
>  		pci_mem_start, gapstart, gapsize);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
