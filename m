Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZISHTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZISHTt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZISHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:19:46 -0400
Received: from waste.org ([173.11.57.241]:54186 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZISHTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:19:46 -0400
Subject: Re: [PATCH] random: kmalloc failure ignored in init_std_data()
From: Matt Mackall <mpm@selenic.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB42BAF.90204@gmail.com>
References: <4AB411D9.6070702@gmail.com> <1253319020.3364.180.camel@calx>
	 <4AB42BAF.90204@gmail.com>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 02:19:35 -0500
Message-Id: <1253344775.3364.183.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 02:54 +0200, Roel Kluin wrote:
> kmalloc may fail so build the array into the statically allocated
> pool structures instead.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this what you had in mind? (it builds)

Yes, looks good.

Acked-by: Matt Mackall <mpm@selenic.com>

> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index d8a9255..9012540 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -400,6 +400,8 @@ module_param(debug, bool, 0644);
>   *
>   **********************************************************************/
>  
> +#define EXTRACT_SIZE 10
> +
>  struct entropy_store;
>  struct entropy_store {
>  	/* read-only data: */
> @@ -414,7 +416,9 @@ struct entropy_store {
>  	unsigned add_ptr;
>  	int entropy_count;
>  	int input_rotate;
> -	__u8 *last_data;
> +#ifdef CONFIG_CRYPTO_FIPS
> +	__u8 last_data[EXTRACT_SIZE];
> +#endif
>  };
>  
>  static __u32 input_pool_data[INPUT_POOL_WORDS];
> @@ -714,8 +718,6 @@ void add_disk_randomness(struct gendisk *disk)
>  }
>  #endif
>  
> -#define EXTRACT_SIZE 10
> -
>  /*********************************************************************
>   *
>   * Entropy extraction routines
> @@ -951,9 +953,6 @@ static void init_std_data(struct entropy_store *r)
>  	now = ktime_get_real();
>  	mix_pool_bytes(r, &now, sizeof(now));
>  	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
> -	/* Enable continuous test in fips mode */
> -	if (fips_enabled)
> -		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
>  }
>  
>  static int rand_initialize(void)

-- 
http://selenic.com : development and support for Mercurial and Linux


