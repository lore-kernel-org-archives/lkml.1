Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbYFWT3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbYFWT3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYFWT3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:29:31 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:13004 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYFWT3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:29:30 -0400
Date: Mon, 23 Jun 2008 22:29:19 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
	in kdump
Message-ID: <20080623192918.GB6989@il.ibm.com>
References: <1191962414.24134.68.camel@chandru> <47D5359D.5000909@in.ibm.com> <20080310090912.b9f34d27.akpm@linux-foundation.org> <200806211741.43703.chandru@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806211741.43703.chandru@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 05:41:43PM +0530, Chandru wrote:

> kdump kernel fails to boot with calgary iommu and aacraid driver on
> a x366 box. The ongoing dma's of aacraid from the first kernel
> continue to exist until the driver is loaded in the kdump
> kernel. Calgary is initialized prior to aacraid and creation of new
> tce tables causes wrong dma's to occur. Here we try to get the tce
> tables of the first kernel in kdump kernel and use them. While in
> the kdump kernel we do not allocate new tce tables but instead read
> the base address register contents of calgary iommu and use the
> tables that the registers point to. With these changes the kdump
> kernel and hence aacraid now boots normally.
> 
> Signed-off-by: Chandru Siddalingappa <chandru@in.ibm.com>

Hi Chandru,

I am not a big fan of this patch, but I guess it would do as a
stop-gap measure. However it is not appropriate for 2.6.26 and should
go in at the beginning of the 2.6.27 merge window. Also, minor
comments below.

> @@ -1206,9 +1213,14 @@ static int __init calgary_init(void)
>  	struct calgary_bus_info *info;
>  
>  	ret = calgary_locate_bbars();
> +

unneeded whitespace

> @@ -1256,6 +1268,24 @@ error:
>  	return ret;
>  }
>  
> +
> +/*
> + * calgary_init_bitmap_from_tce_table():
> + * Funtion for kdump case. In the second/kdump kernel initialize
> + * the bitmap based on the tce table entries obtained from first kernel
> + */
> +static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
> +{
> +	u64 *tp;
> +	unsigned int index;
> +	tp = ((u64 *)tbl->it_base);
> +	for (index = 0 ; index < tbl->it_size; index++) {
> +	if (*tp != 0x0)
> +		set_bit(index, tbl->it_map);
> +		tp++;
> +	}

I think the code is correct, but the indentation is misleading. Please
fix.

> +}
> +
>  static inline int __init determine_tce_table_size(u64 ram)
>  {
>  	int ret;
> @@ -1318,6 +1348,8 @@ static int __init build_detail_arrays(vo
>  	return 0;
>  }
>  
> +
> +

unneeded whitespace.

Cheers,
Muli
