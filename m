Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZHJWfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZHJWfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 18:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZHJWfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 18:35:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbZHJWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 18:35:40 -0400
Date: Mon, 10 Aug 2009 15:35:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: ralf@linux-mips.org, torvalds@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       ddaney@caviumnetworks.com
Subject: Re: [PATCH 1/2] MIPS: Octeon:  Add hardware RNG platform device.
Message-Id: <20090810153503.07dee9c4.akpm@linux-foundation.org>
In-Reply-To: <1249929025-29625-1-git-send-email-ddaney@caviumnetworks.com>
References: <4A806529.3060609@caviumnetworks.com>
	<1249929025-29625-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 11:30:24 -0700
David Daney <ddaney@caviumnetworks.com> wrote:

> Add a platform device for the Octeon Random Number Generator (RNG).
> 
> ...
>
>  device_initcall(octeon_cf_device_init);
> +
> +/* Octeon Random Number Generator.  */
> +static int __init octeon_rng_device_init(void)
> +{
> +	struct platform_device *pd;
> +	struct resource rng_resources[2];
> +	unsigned int res_count;
> +	int ret = 0;
> +
> +	memset(rng_resources, 0, sizeof(rng_resources));
> +	res_count = 0;
> +	rng_resources[res_count].flags = IORESOURCE_MEM;
> +	rng_resources[res_count].start = XKPHYS_TO_PHYS(CVMX_RNM_CTL_STATUS);
> +	rng_resources[res_count].end = rng_resources[res_count].start + 0xf;
> +	res_count++;
> +
> +	rng_resources[res_count].flags = IORESOURCE_MEM;
> +	rng_resources[res_count].start = cvmx_build_io_address(8, 0);
> +	rng_resources[res_count].end = rng_resources[res_count].start + 0x7;
> +	res_count++;

You could do

	strut resource rng_resources[2] = {
		{
			.flags = IORESOURCE_MEM,
			.start = XKPHYS_TO_PHYS(CVMX_RNM_CTL_STATUS),
	{etc}

here. 

> +	pd = platform_device_alloc("octeon_rng", -1);
> +	if (!pd) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = platform_device_add_resources(pd, rng_resources, res_count);

use ARRAY_SIZE() here.

> +	if (ret)
> +		goto fail;
> +
> +	ret = platform_device_add(pd);
> +	if (ret)
> +		goto fail;
> +
> +	return ret;
> +fail:
> +	platform_device_put(pd);
> +
> +out:
> +	return ret;
> +}

Or not bother ;)  It doesn't make any difference.

> --- /dev/null
> +++ b/arch/mips/include/asm/octeon/cvmx-rnm-defs.h
>
> ...
>
> +	uint64_t u64;
>
> ...
>

This file should include types.h (at least).

