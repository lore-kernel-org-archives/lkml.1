Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZJ0Cp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZJ0Cp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZJ0Cpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:45:55 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37267 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZJ0Cpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:45:54 -0400
Message-ID: <4AE65EDE.8080605@gmail.com>
Date: Tue, 27 Oct 2009 03:45:50 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>,
       Al Viro <viro@zeniv.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: better name hash function
References: <200910252158.53921.opurdila@ixiacom.com>	<20091025214357.666350d2@nehalam> <20091026153656.25be4369@nehalam>
In-Reply-To: <20091026153656.25be4369@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 27 Oct 2009 03:45:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com>, Al Viro a écrit :
> --- a/include/linux/dcache.h	2009-10-26 14:58:45.220347300 -0700
> +++ b/include/linux/dcache.h	2009-10-26 15:12:15.004160122 -0700
> @@ -45,15 +45,28 @@ struct dentry_stat_t {
>  };
>  extern struct dentry_stat_t dentry_stat;
>  
> -/* Name hashing routines. Initial hash value */
> -/* Hash courtesy of the R5 hash in reiserfs modulo sign bits */
> -#define init_name_hash()		0
> +/*
> + * Fowler / Noll / Vo (FNV) Hash
> + * see: http://www.isthe.com/chongo/tech/comp/fnv/
> + */
> +#ifdef CONFIG_64BIT
> +#define FNV_PRIME  1099511628211ull
> +#define FNV1_INIT  14695981039346656037ull
> +#else
> +#define FNV_PRIME  16777619u
> +#define FNV1_INIT  2166136261u
> +#endif
> +
> +#define init_name_hash()	FNV1_INIT
>  
> -/* partial hash update function. Assume roughly 4 bits per character */
> +/* partial hash update function. */
>  static inline unsigned long
> -partial_name_hash(unsigned long c, unsigned long prevhash)
> +partial_name_hash(unsigned char c, unsigned long prevhash)
>  {
> -	return (prevhash + (c << 4) + (c >> 4)) * 11;
> +	prevhash ^= c;
> +	prevhash *= FNV_PRIME;
> +
> +	return prevhash;
>  }
>  
>  /*

OK, but thats strlen(name) X (long,long) multiplies.

I suspect you tested on recent x86_64 cpu.

Some arches might have slow multiplies, no ?

jhash() (and others) are optimized by compiler to use basic and fast operations.
jhash operates on blocs of 12 chars per round, so it might be a pretty good choice once
out-of-line (because its pretty large and full_name_hash() is now used by
a lot of call sites)

Please provide your test program source, so that other can test on various arches.

Thanks
