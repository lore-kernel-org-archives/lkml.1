Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZBGAvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZBGAvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZBGAu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:50:58 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41160 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZBGAu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:50:57 -0500
Date: Sat, 7 Feb 2009 00:50:15 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
In-Reply-To: <200902061445.11379.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.64.0902070040240.15875@blonde.anvils>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <200902060849.45851.jbarnes@virtuousgeek.org>
 <Pine.LNX.4.64.0902062205540.5710@blonde.anvils> <200902061445.11379.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Jesse Barnes wrote:
> 
> Yeah that should work.  I always hated this code (well most of X actually); we
> could probably clean up the logic a little.  If this works I'll send it
> out to the Xorg list for review.

Yes, thanks for restructuring it, I was rather itching to do so.

With the one small change below which I think you'll approve,
your patch works for me on the G5 - but I've not tested it on
other (x86) machines which were already working.

Hugh

> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center
> 
> diff --git a/hw/xfree86/os-support/bus/linuxPci.c b/hw/xfree86/os-support/bus/linuxPci.c
> index 263fd8f..fa0fc0a 100644
> --- a/hw/xfree86/os-support/bus/linuxPci.c
> +++ b/hw/xfree86/os-support/bus/linuxPci.c
> @@ -471,23 +471,18 @@ xf86MapDomainMemory(int ScreenNum, int Flags, struct pci_device *dev,
>      int fd = -1;
>      pointer addr;
>  
> -    /*
> -     * We use /proc/bus/pci on non-legacy addresses or if the Linux sysfs
> -     * legacy_mem interface is unavailable.
> -     */
> -    if ((Base > 1024*1024) || ((fd = linuxOpenLegacy(dev, "legacy_mem")) < 0))
> -	return linuxMapPci(ScreenNum, Flags, dev, Base, Size,
> -			   PCIIOC_MMAP_IS_MEM);
> -    else
> -	addr = mmap(NULL, Size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, Base);
> -
> -    if (fd >= 0)
> -	close(fd);
> -    if (addr == NULL || addr == MAP_FAILED) {
> -	perror("mmap failure");
> -	FatalError("xf86MapDomainMem():  mmap() failure\n");
> +    if (Base <= 1024*1024) {
> +        /* Try legacy_mem (may not be available or implemented) */
> +        if ((fd = linuxOpenLegacy(dev, "legacy_mem")) < 0) {

                                                         >=

> +            addr = mmap(NULL, Size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, Base);
> +            close(fd);
> +            if (addr && addr != MAP_FAILED)
> +                return addr;
> +        }
>      }
> -    return addr;
> +
> +    /* Fall back to old method if legacy_mem fails or Base >= 1M */
> +    return linuxMapPci(ScreenNum, Flags, dev, Base, Size, PCIIOC_MMAP_IS_MEM);
>  }
>  
>  /**
