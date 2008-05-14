Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbYENW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbYENW25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYENW2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:28:45 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33939 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbYENW2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:28:44 -0400
Date: Thu, 15 May 2008 01:27:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] ibmaem: Fix 64-bit division on 32-bit platforms
Message-ID: <20080514222704.GA11439@cs181133002.pp.htv.fi>
References: <20080508180858.GM16078@tree.beaverton.ibm.com> <20080508163443.a1e9ffe7.akpm@linux-foundation.org> <20080509045527.GI16404@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080509045527.GI16404@tree.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:55:27PM -0700, Darrick J. Wong wrote:
> On Thu, May 08, 2008 at 04:34:43PM -0700, Andrew Morton wrote:
> 
> > This driver is littered with 64-bit divides and doesn't link on i386.
> > I'll make it depend on CONFIG_64BIT for now.
> 
> Oops, sorry, I didn't remember that one can't do 64-bit division on
> i386.  The patch below fixes that.
> ---
> ibmaem: Fix 64-bit division on 32-bit platforms
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/ibmaem.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
> index 22fa7d6..f808ca3 100644
> --- a/drivers/hwmon/ibmaem.c
> +++ b/drivers/hwmon/ibmaem.c
>...
> @@ -864,9 +865,10 @@ static ssize_t aem_show_power(struct device *dev,
>...
>  	time = timespec_to_ns(&a) - timespec_to_ns(&b);
> -	time /= 1000;
> +	time = div_u64(time, 1000);
>  
> -	return sprintf(buf, "%llu\n", (after - before) * 1000000000 / time);
> +	return sprintf(buf, "%llu\n",
> +		       div64_u64((after - before) * 1000000000, time));
>  }
>...

What are you actually trying to do here?

Converting mJ/ns to uJ/s?

Or do you want to convert mJ/ns to Watt in which case you should
multiply "time" with 1000 instead of dividing it through 1000?

In any case you should only need one expensive 64bit division
and you can fold the operation with 1000 into the second division.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

