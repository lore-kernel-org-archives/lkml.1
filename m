Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYJIPzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYJIPzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYJIPy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:54:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:60122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYJIPy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:54:58 -0400
Message-ID: <48EE291F.2010704@kernel.org>
Date: Thu, 09 Oct 2008 08:54:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: bibo mao <bibo.mao@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/1] combine two adjacent mtrr region with the same type
References: <fbd277f20810090121m41e87a8eg9e6b7a1d4ec62776@mail.gmail.com>
In-Reply-To: <fbd277f20810090121m41e87a8eg9e6b7a1d4ec62776@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bibo mao wrote:
> This patch is to combine two adjacent mtrr region with the same type.
> 
>  kernel/cpu/mtrr/main.c          |   17 +++++++++++++++--
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> Signed-off-by: bibo mao <bibo.mao@gmail.com>
> 
> -------------------------------------------------------------------------------
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index 6e212f3..c3adf83 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -305,7 +305,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
>  {
>  	int i, j, replace, error;
>  	mtrr_type ltype;
> -	unsigned long lbase, lsize;
> +	unsigned long lbase, lsize, newbase;
> 
>  	if (!mtrr_if)
>  		return -ENXIO;
> @@ -344,7 +344,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
>  	mutex_lock(&mtrr_mutex);
>  	for (i = 0; i < num_var_ranges; ++i) {
>  		mtrr_if->get(i, &lbase, &lsize, &ltype);
> -		if (!lsize || base > lbase + lsize - 1 || base + size - 1 < lbase)
> +		if (!lsize || base > lbase + lsize || base + size < lbase)
>  			continue;
>  		/*  At this point we know there is some kind of overlap/enclosure  */
>  		if (base < lbase || base + size - 1 > lbase + lsize - 1) {
> @@ -356,6 +356,19 @@ int mtrr_add_page(unsigned long base, unsigned long size,
>  				}
>  				else if (types_compatible(type, ltype))
>  					continue;
> +			} else if ((base == lbase + lsize) || (lbase ==base + size)) {
> +				if (type != ltype)
> +					continue;
this path seems not right...

do you need

                if (ltype != type) {
                        if (types_compatible(type, ltype))
                                continue;
                        printk (KERN_WARNING "mtrr: type mismatch for %lx000,%lx000 old: %s new: %s\n",
                             base, size, mtrr_attrib_to_str(ltype),
                             mtrr_attrib_to_str(type));
                        goto out;
                }
?




> +				/* New region adjacent with an existing region  */
> +				newbase = (base < lbase) ? base : lbase;
> +				if (!mtrr_if->validate_add_page(newbase,lsize + size,type) &&
> +				   mtrr_if->get_free_region(newbase, lsize + size, replace)>=0) {
> +					base = newbase;
> +					size += lsize;
> +					replace = i;
> +					continue;
> +				} else
> +					continue;
>  			}
>  			printk(KERN_WARNING
>  			       "mtrr: 0x%lx000,0x%lx000 overlaps existing"

better to have some test case...

YH
