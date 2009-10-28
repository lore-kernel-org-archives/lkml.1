Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZJ1GHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZJ1GHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbZJ1GHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:07:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45489 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbZJ1GHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:07:16 -0400
Message-ID: <4AE7DF8E.3020607@gmail.com>
Date: Wed, 28 Oct 2009 07:07:10 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, opurdila@ixiacom.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH] net: fold network name hash (v2)
References: <9986527.24561256620662709.JavaMail.root@tahiti.vyatta.com>	<19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>	<20091026.222428.80364204.davem@davemloft.net>	<20091027102251.244ee681@nehalam> <20091027150436.56e673cd@nehalam>
In-Reply-To: <20091027150436.56e673cd@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 28 Oct 2009 07:07:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> The full_name_hash does not produce a value that is evenly distributed
> over the lower 8 bits. This causes name hash to be unbalanced with large
> number of names. There is a standard function to fold in upper bits
> so use that.
> 
> This is independent of possible improvements to full_name_hash()
> in future.

>  static inline struct hlist_head *dev_name_hash(struct net *net, const char *name)
>  {
>  	unsigned hash = full_name_hash(name, strnlen(name, IFNAMSIZ));
> -	return &net->dev_name_head[hash & ((1 << NETDEV_HASHBITS) - 1)];
> +	return &net->dev_name_head[hash_long(hash, NETDEV_HASHBITS)];
>  }
>  
>  static inline struct hlist_head *dev_index_hash(struct net *net, int ifindex)

full_name_hash() returns an "unsigned int", which is guaranteed to be 32 bits

You should therefore use hash_32(hash, NETDEV_HASHBITS),
not hash_long() that maps to hash_64() on 64 bit arches, which is
slower and certainly not any better with a 32bits input.



/* Compute the hash for a name string. */
static inline unsigned int
full_name_hash(const unsigned char *name, unsigned int len)
{
        unsigned long hash = init_name_hash();
        while (len--)
                hash = partial_name_hash(*name++, hash);
        return end_name_hash(hash);
}

static inline u32 hash_32(u32 val, unsigned int bits)
{
        /* On some cpus multiply is faster, on others gcc will do shifts */
        u32 hash = val * GOLDEN_RATIO_PRIME_32;

        /* High bits are more random, so use them. */
        return hash >> (32 - bits);
}


static inline u64 hash_64(u64 val, unsigned int bits)
{
        u64 hash = val;

        /*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
        u64 n = hash;
        n <<= 18;
        hash -= n;
        n <<= 33;
        hash -= n;
        n <<= 3;
        hash += n;
        n <<= 3;
        hash -= n;
        n <<= 4;
        hash += n;
        n <<= 2;
        hash += n;

        /* High bits are more random, so use them. */
        return hash >> (64 - bits);
}
