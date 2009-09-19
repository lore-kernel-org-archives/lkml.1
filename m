Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZISALJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZISALJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 20:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZISALG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 20:11:06 -0400
Received: from waste.org ([173.11.57.241]:37169 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZISALF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 20:11:05 -0400
Subject: Re: [PATCH] random: kmalloc failure ignored in init_std_data()
From: Matt Mackall <mpm@selenic.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB411D9.6070702@gmail.com>
References: <4AB411D9.6070702@gmail.com>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 19:10:20 -0500
Message-Id: <1253319020.3364.180.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 01:03 +0200, Roel Kluin wrote:
> Clean up and error out if kmalloc() fails.

No thanks. Let's instead make it so it can't fail by building the array
into the statically allocated pool structures.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found with sed: http://kernelnewbies.org/roelkluin
> 
> Build tested. Please review
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index d8a9255..8a68be8 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -939,7 +939,7 @@ EXPORT_SYMBOL(get_random_bytes);
>   * data into the pool to prepare it for use. The pool is not cleared
>   * as that can only decrease the entropy in the pool.
>   */
> -static void init_std_data(struct entropy_store *r)
> +static int init_std_data(struct entropy_store *r)
>  {
>  	ktime_t now;
>  	unsigned long flags;
> @@ -952,16 +952,35 @@ static void init_std_data(struct entropy_store *r)
>  	mix_pool_bytes(r, &now, sizeof(now));
>  	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
>  	/* Enable continuous test in fips mode */
> -	if (fips_enabled)
> +	if (fips_enabled) {
>  		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
> +		if (r->last_data == NULL)
> +			return -ENOMEM;
> +	}
> +	return 0;
>  }
>  
>  static int rand_initialize(void)
>  {
> -	init_std_data(&input_pool);
> -	init_std_data(&blocking_pool);
> -	init_std_data(&nonblocking_pool);
> +	int ret;
> +	ret = init_std_data(&input_pool);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = init_std_data(&blocking_pool);
> +	if (ret != 0)
> +		goto free_ip_ld;
> +
> +	ret = init_std_data(&nonblocking_pool);
> +	if (ret != 0)
> +		goto free_bp_ld;
> +
>  	return 0;
> +free_bp_ld:
> +	kfree(blocking_pool.last_data);
> +free_ip_ld:
> +	kfree(input_pool.last_data);
> +	return ret;
>  }
>  module_init(rand_initialize);
>  
> @@ -1160,8 +1179,8 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
>  		/* Clear the entropy pool counters. */
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
> -		rand_initialize();
> -		return 0;
> +		retval = rand_initialize();
> +		return retval;
>  	default:
>  		return -EINVAL;
>  	}

-- 
http://selenic.com : development and support for Mercurial and Linux


