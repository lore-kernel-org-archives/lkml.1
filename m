Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbXFTREg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbXFTREg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXFTRE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:04:27 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:33546 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbXFTRE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:04:27 -0400
Date: Wed, 20 Jun 2007 19:04:24 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Alexander Gabert <pappy@gentoo.org>
Cc: Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       linux-kernel@vger.kernel.org, hardened@gentoo.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel
 2.6.21.5
Message-Id: <20070620190424.cf718ea1.dada1@cosmosbay.com>
In-Reply-To: <467948F5.3010709@gentoo.org>
References: <4675C678.3080807@gentoo.org>
	<1182128803.22999.9.camel@laptopd505.fenrus.org>
	<4675DFA8.6060703@gentoo.org>
	<1182130680.22999.13.camel@laptopd505.fenrus.org>
	<4676601A.7070209@gentoo.org>
	<467948F5.3010709@gentoo.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 17:34:13 +0200
Alexander Gabert <pappy@gentoo.org> wrote:

> Hi,

Hello Alexander

> 
> http://dev.gentoo.org/~pappy/kernel/linux-2.6.21.5-get_urandom_long-AT_ENTROPY.patch
> 
> this patch adds the function drivers/char/random.c:get_random_long()
> and adds an AT_ENTROPY field in the auxv without config option
> (the config option was removed as suggested by Arjan on LKML).
> 
> README: get_random_long() and AT_ENTROPY support for auxv
> NAME: Alexander Gabert
> EMAIL: pappy@gentoo.org
> 
> 
> 
> diff -Nru linux-2.6.21.5.ORIG/drivers/char/random.c 
> linux-2.6.21.5/drivers/char/random.c
> --- linux-2.6.21.5.ORIG/drivers/char/random.c    2007-06-11 
> 20:37:06.000000000 +0200
> +++ linux-2.6.21.5/drivers/char/random.c    2007-06-20 
> 17:00:35.000000000 +0200
> @@ -1654,6 +1654,53 @@
>  }
>  
>  /*
> + * get_random_long() returns a randomized unsigned long word.
> + * It recycles it's entropy cache for a given time period and
> + * uses half_md4_transform to generate a unique return value.
> + * Every REKEY_INTERVAL the cache is reloaded with fresh
> + * randomization data using get_random_bytes().
> + * This function is not intended for strong cryptographic routines.
> + */
> +unsigned long get_random_long(void)
> +{
> +  /* remember the last time we refreshed the cache with random entropy */
> +  static time_t   rekey_time;
> +
> +  time_t          t;
> +
> +  /*
> +   * the following data in the buffer is unchanged during REKEY_INTERVAL:
> +   * |----|----|KKKK|KKKK|KKKK|KKKK|KKKK|KKKK|----|----|----|----|
> +   * ___0____1____2____3____4____5____6____7____8____9___10___11__
> +   *
> +   * the following data is updated during the first half_md4_transform call
> +   * |----|YYYY|----|----|----|----|----|----|ZZZZ|ZZZZ|ZZZZ|ZZZZ|
> +   * ___0____1____2____3____4____5____6____7____8____9___10___11__
> +   *
> +   * the following data is updated during the second half_md4_transform
> +   * |XXXX|----|----|----|----|----|----|----|ZZZZ|ZZZZ|ZZZZ|ZZZZ|
> +   * ___0____1____2____3____4____5____6____7____8____9___10___11__
> +   */
> +  static __u32    entropycache[12];
> +
> +  /* get the current time in seconds */
> +  t = get_seconds();
> +
> +  /* check for REKEY_INTERVAL */
> +  if (t && (!rekey_time || ((t - rekey_time) > REKEY_INTERVAL))) {
> +    rekey_time = t;
> +    /* refresh with random entropy */
> +    get_random_bytes(entropycache, sizeof(entropycache));
> +  }

Maybe this rekeying can be added in rekey_seq_generator(), so that you dont have to test rekey_time each time get_random_long() is called. You probably could refresh only 8 values, not the full 12 values.

> +
> +  /* transform the buffer to a new state, thus generating new return 
> value */
> +  entropycache[1] = half_md4_transform(entropycache+8, entropycache);
> +  entropycache[0] = half_md4_transform(entropycache+8, entropycache);
> +
> +  return *(unsigned long *)entropycache;

This is not valid on some arches, as entropycache[] alignment (u32 -> 4) might be smaller then alignment for a long (4 or 8). 

This also adds about 400 instructions (half_md4_transform() is about 200 instructions, about 700 bytes of code on x86_64) in exec() path, but this is probably minor given the cost of exec()

I am not sure why you unconditionally call half_md4_transform() twice, since the entropycache[1] wont be used on 32bits platforms.

I suggest spliting your entropycache into two parts :

One part, with 8 u32, that is read_mostly (and shared by all cpus), updated once every 300 seconds in rekey_seq_generator()
static u32 entropycache_shared[8] __read_mostly;

One part, with (16/sizeof(long)) long, percpu to avoid false sharing between cpus.
static DEFINE_PER_CPU(unsigned long , entropycache_pcpu)[16 / sizeof(unsigned long)];

then call half_md4_transform() once :

half_md4_transform((u32 *)entropycache_pcpu, entropycache_shared);
return entropycache_pcpu[0];

