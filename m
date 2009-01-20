Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZATIN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZATIN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZATINs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:13:48 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:55001 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZATINr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:13:47 -0500
Message-ID: <497587B6.9010306@in.ibm.com>
Date: Tue, 20 Jan 2009 13:43:42 +0530
From: Chandru <chandru@in.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
References: <200812241325.49404.chandru@in.ibm.com> <200901161746.36584.chandru@in.ibm.com> <1232128377.27278.69.camel@nimitz> <200901191700.03580.chandru@in.ibm.com>
In-Reply-To: <200901191700.03580.chandru@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chandru wrote:
> In case either physbase or reserve_size are not page aligned and in addition
> if the following condition is also true
>
> node_ar.end_pfn = node->node_end_pfn = PFN_DOWN(physbase+reserve_size).
>
> we may hit the BUG_ON(end > bdata->node_low_pfn) in mark_bootmem_node() in
> mm/bootmem.c Hence pass the pfn that the physbase is part of and align
> reserve_size before calling reserve_bootmem_node().
>
> Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
>  arch/powerpc/mm/numa.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> --- linux-2.6.29-rc2/arch/powerpc/mm/numa.c.orig	2009-01-19 16:14:49.000000000 +0530
> +++ linux-2.6.29-rc2/arch/powerpc/mm/numa.c	2009-01-19 16:36:38.000000000 +0530
> @@ -901,7 +901,8 @@ static void mark_reserved_regions_for_ni
>  		get_node_active_region(start_pfn, &node_ar);
>  		while (start_pfn < end_pfn &&
>  			node_ar.start_pfn < node_ar.end_pfn) {
> -			unsigned long reserve_size = size;
> +			unsigned long reserve_size = (size >> PAGE_SHIFT) <<
> +								PAGE_SHIFT;
>  			/*
>  			 * if reserved region extends past active region
>  			 * then trim size to active region
> @@ -917,7 +918,8 @@ static void mark_reserved_regions_for_ni
>  				dbg("reserve_bootmem %lx %lx nid=%d\n",
>  					physbase, reserve_size, node_ar.nid);
>  				reserve_bootmem_node(NODE_DATA(node_ar.nid),
> -						physbase, reserve_size,
> +						(start_pfn << PAGE_SHIFT),
> +						reserve_size,
>  						BOOTMEM_DEFAULT);
>  			}
>  			/*
>   
does this patch look good ?, do you concur with it ?

thanks,
Chandru
