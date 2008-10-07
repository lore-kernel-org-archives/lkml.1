Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYJGHh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYJGHh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 03:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYJGHhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 03:37:48 -0400
Received: from smtp23.orange.fr ([80.12.242.50]:47018 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbYJGHhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 03:37:47 -0400
X-ME-UUID: 20081007073744490.77B411C00088@mwinf2349.orange.fr
Message-ID: <48EB11BB.2060704@cosmosbay.com>
Date: Tue, 07 Oct 2008 09:37:31 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       netdev@vger.kernel.org, Paul McKenney <paulmck@us.ibm.com>
Subject: Re: [patch][rfc] ddds: "dynamic dynamic data structure" algorithm,
 for adaptive dcache hash table sizing (resend)
References: <20081007064834.GA5959@wotan.suse.de> <20081007070225.GB5959@wotan.suse.de>
In-Reply-To: <20081007070225.GB5959@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin a écrit :
> (resending with correct netdev address)
> 
> Hi,
> 
> I thought I should quickly bring this patch up to date and write it up
> properly, because IMO it is still useful. I earlier had tried to turn the
> algorithm into a library that could be plugged into with specific lookup
> functions and such, but that got really nasty and also difficult to retain
> a really light fastpath. I don't think it is too nasty to open-code it...
> 
> Describe the "Dynamic dynamic data structure" (DDDS) algorithm, and implement
> adaptive dcache hash table sizing using DDDS.
> 
> The dcache hash size is increased to the next power of 2 if the number
> of dentries exceeds the current size of the dcache hash table. It is decreased
> in size if it is currently more than 3 times the number of dentries.
> 
> This might be a dumb thing to do. It also currently performs the hash resizing
> check for each dentry insertion/deletion, and calls the resizing in-line from
> there: that's bad, because resizing takes several RCU grace periods. Rather it
> should kick off a thread to do the resizing, or even have a background worker
> thread checking the sizes periodically and resizing if required.
> 
> With this algorithm, I can fit a whole kernel source and git tree in my dcache
> hash table that is still 1/8th the size it would be before the patch.
> 
> I'm cc'ing netdev because Dave did express some interest in using this for
> some networking hashes, and network guys in general are pretty cluey when it
> comes to hashes and such ;)
>

Thanks for reminding us this interesting stuff. And yes, IP route cache could use
same algo. That is particularly interesting because it has a /proc/net/rt_cache
accessor that needs to sequentially scan this hash table (potentialy with
many empty slots), while dcache doesnt have such killer.
 
>
> +static struct dcache_hash *alloc_dhash(int size)
> +{
> +	struct dcache_hash *dh;
> +	unsigned long bytes;
> +	unsigned int shift;
> +	int i;
> +
> +	shift = ilog2(size);
> +	BUG_ON(size != 1UL << shift);
> +	bytes = size * sizeof(struct hlist_head *);
> +
> +	dh = kmalloc(sizeof(struct dcache_hash), GFP_KERNEL);
> +	if (!dh)
> +		return NULL;
> +
> +	if (bytes <= PAGE_SIZE) {
> +		dh->table = kmalloc(bytes, GFP_KERNEL);
> +	} else {
> +		dh->table = vmalloc(bytes);
> +	}

Here we probably want to use a hashdist/NUMA enabled vmalloc().

That is, regardless of current numa policy of *this* thread,
we want to spread hash table on all nodes.

Also, struct dcache_hash being very small, you want to force it to
use an exclusive cache line, to be sure it wont share it with some 
higly modified data...

struct dcache_hash {
	struct hlist_head *table;
	unsigned int shift;
	unsigned int mask;
} __cacheline_aligned_in_smp;





