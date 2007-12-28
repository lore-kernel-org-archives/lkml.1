Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXL1HgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXL1HgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXL1Hfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:35:51 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49580 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbXL1Hft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:35:49 -0500
Message-ID: <4774A74B.3000105@linux.vnet.ibm.com>
Date: Fri, 28 Dec 2007 13:05:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
References: <47732C41.7000003@linux.vnet.ibm.com> <20071227134335O.fujita.tomonori@lab.ntt.co.jp> <47733C01.1080002@linux.vnet.ibm.com> <20071228143043U.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071228143043U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
[snip]
> Thanks,
> 
> Can you try this?
> 
> 
> diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
> index e7d8544..495575a 100644
> --- a/lib/iommu-helper.c
> +++ b/lib/iommu-helper.c
> @@ -8,15 +8,20 @@
>  static unsigned long find_next_zero_area(unsigned long *map,
>  					 unsigned long size,
>  					 unsigned long start,
> -					 unsigned int nr)
> +					 unsigned int nr,
> +					 unsigned long align_mask)
>  {
>  	unsigned long index, end, i;
>  again:
>  	index = find_next_zero_bit(map, size, start);
> +
> +	/* Align allocation */
> +	index = (index + align_mask) & ~align_mask;
> +
>  	end = index + nr;
> -	if (end > size)
> +	if (end >= size)
>  		return -1;
> -	for (i = index + 1; i < end; i++) {
> +	for (i = index; i < end; i++) {
>  		if (test_bit(i, map)) {
>  			start = i+1;
>  			goto again;
> @@ -50,9 +55,8 @@ unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
>  {
>  	unsigned long index;
>  again:
> -	index = find_next_zero_area(map, size, start, nr);
> +	index = find_next_zero_area(map, size, start, nr, align_mask);
>  	if (index != -1) {
> -		index = (index + align_mask) & ~align_mask;
>  		if (is_span_boundary(index, nr, shift, boundary_size)) {
>  			/* we could do more effectively */
>  			start = index + 1;

This on top of -mm? Or on top of the reverted iommu patch.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
