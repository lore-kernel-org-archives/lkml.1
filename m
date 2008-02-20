Return-Path: <linux-kernel-owner+w=401wt.eu-S934129AbYBTUbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbYBTUbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933836AbYBTUbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:31:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375AbYBTUbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:31:11 -0500
Date: Wed, 20 Feb 2008 15:30:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: mingo@elte.hu
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch 1/3] x86_64: CPA, fix cache attribute inconsistency
	bug, v2.6.22 backport
Message-ID: <20080220203018.GD7415@redhat.com>
References: <20080215195508.GA12405@elte.hu> <20080215195821.GA15432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215195821.GA15432@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 08:58:22PM +0100, Ingo Molnar wrote:
> 
> fix CPA cache attribute bug in v2.6.23. When phys_base is nonzero
> (when CONFIG_RELOCATABLE=y) then change_page_attr_addr() miscalculates
> the secondary alias address by -14 MB (depending on the configured
> offset).
> 
> The default 64-bit kernels of Fedora and Ubuntu are affected:
> 
>    $ grep RELOCA /boot/config-2.6.23.9-85.fc8
>      CONFIG_RELOCATABLE=y
> 
>    $ grep RELOC /boot/config-2.6.22-14-generic
>      CONFIG_RELOCATABLE=y
> 
> and probably on many other distros as well.
> 
> the bug affects all pages in the first 40 MB of physical RAM that
> are allocated by some subsystem that does ioremap_nocache() on them:
> 
>        if (__pa(address) < KERNEL_TEXT_SIZE) {
> 
> Hence we might leave page table entries with inconsistent cache
> attributes around (pages mapped at both UnCacheable and Write-Back),
> and we can also set the wrong kernel text pages to UnCacheable.
> 
> the effects of this bug can be random slowdowns and other misbehavior.
> If for example AGP allocates its aperture pages into the first 40 MB
> of physical RAM, then the -14 MB bug might mark random kernel texto
> pages as uncacheable, slowing down a random portion of the 64-bit
> kernel until the AGP driver is unloaded.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86_64/mm/pageattr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-tmp/arch/x86_64/mm/pageattr.c
> ===================================================================
> --- linux-tmp.orig/arch/x86_64/mm/pageattr.c
> +++ linux-tmp/arch/x86_64/mm/pageattr.c
> @@ -204,7 +204,7 @@ int change_page_attr_addr(unsigned long 
>  		if (__pa(address) < KERNEL_TEXT_SIZE) {

Hi Ingo,

Should we change above condition also to something like following.

kernel_phys_start = __pa(__START_KERNEL_map) + phys_base
kernel_phys_end = kernel_phys_start + KERNEL_TEXT_SIZE

if (__pa(address) >= kernel_phys_start
	&& __pa(address) <= kernel_phys_end)  

Looks like we are trying to see if a physical page has been mapped
by kernel text/data region also then change the caching attributes there too.

In case of relocatable kernel, not necessarily first 40MB will be mapped by
the kernel text/data region, If boot loader decides to load kernel
at a higher address and phys_base is non-zero.

Thanks
Vivek
