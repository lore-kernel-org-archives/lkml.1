Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbZCaGc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbZCaGc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZCaGcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:32:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:20489 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZCaGcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:32:17 -0400
Subject: Re: [PATCHv4] MTD: New ioctl calls for >4GiB device support
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <a95a62fe0903301814k75ce56f5xef0a04c5c188012@mail.gmail.com>
References: <a95a62fe0903301814k75ce56f5xef0a04c5c188012@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Mar 2009 09:31:40 +0300
Message-Id: <1238481100.20906.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Mar 2009 06:31:41.0985 (UTC) FILETIME=[5AB15110:01C9B1CA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 18:14 -0700, Kevin Cernekee wrote:
>  #define MTD_ABSENT		0
>  #define MTD_RAM			1
>  #define MTD_ROM			2
> @@ -50,14 +64,25 @@ struct mtd_oob_buf {
>  struct mtd_info_user {
>  	uint8_t type;
>  	uint32_t flags;
> -	uint32_t size;	 // Total size of the MTD
> +	uint32_t size;			/* Total size of the MTD */
> +	uint32_t erasesize;
> +	uint32_t writesize;
> +	uint32_t oobsize;		/* OOB bytes per page (e.g. 16) */
> +	uint32_t ecctype;		/* Obsolete, always reports -1 */
> +	uint32_t eccsize;		/* Obsolete, always reports 0 */
> +};
> +
> +struct mtd_info_user64 {
> +	uint32_t type;
> +	uint32_t flags;
> +	uint64_t size;			/* Total size of the MTD */
> +	uint32_t res0;
>  	uint32_t erasesize;
> +	uint32_t res1;
>  	uint32_t writesize;
> -	uint32_t oobsize;   // Amount of OOB data per block (e.g. 16)
> -	/* The below two fields are obsolete and broken, do not use them
> -	 * (TODO: remove at some point) */
> -	uint32_t ecctype;
> -	uint32_t eccsize;
> +	uint32_t res2;
> +	uint32_t oobsize;		/* OOB bytes per page (e.g. 16) */
> +	uint32_t res3[32];
>  };
> 
>  struct region_info_user {
> @@ -68,6 +93,18 @@ struct region_info_user {
>  	uint32_t regionindex;
>  };
> 
> +struct region_info_user64 {
> +	uint64_t offset;		/* At which this region starts,
> +					 * from the beginning of the MTD */
> +	uint32_t res0;
> +	uint32_t erasesize;		/* For this region */
> +	uint32_t res1;
> +	uint32_t numblocks;		/* Number of blocks in this region */
> +	uint32_t res2;
> +	uint32_t regionindex;
> +	uint32_t res3[16];
> +};

Your arguments vs. ioctls are valid, but sysfs is still better, because
ioctls are not very extendible. E.g., UBI utilities need sub-page size,
but ioctl's do not provide it, and I have no possibility to ask the
kernel about this. And I cannot add it, at least to old ioctls. With
sysfs, I can just add a sysfs file. This is much better.

David Brownell send 2 patches very recently which add sysfs to
MTD. I would recommend you to take them and work on top, and export
information via sysfs, still...

Thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

