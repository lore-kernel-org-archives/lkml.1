Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbYIKLcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbYIKLcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYIKLcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:32:00 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:31583 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752351AbYIKLb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:31:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FYflC9Re7grYda/YRogWOy3+grKjTOGLiRQJELHRQJ+JUqtUimM6AyHnq9RvS/66WfB4wvoBMa6mm0e9lnleQ5O5bBCMqHwOcgrG9pF/Vss8ZQmqHYM8vjqTAht4c4vnOPbw5RhVWYBBNbZi1qQ4SUuGTsQepnZ7MAEjgoDr4wc=  ;
X-YMail-OSG: A1zLMogVM1kMAOQ_HmS3lmScFAn0jsya0673466vzJgfwwX5Zplxb5aVSt0c2Kq.HCSR5AsVjO15VsddUM2ironrj8LxYzQ8S4ICz0NmSB06jFRi2VulqIt3wPA7Q2QYPmVOw9pxx_G1Eeco7X5c8tiQ
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] [PATCH 9/9] memcg: percpu page cgroup lookup cache
Date: Thu, 11 Sep 2008 21:31:34 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com
References: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com> <20080911202407.752b5731.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080911202407.752b5731.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809112131.34414.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 21:24, KAMEZAWA Hiroyuki wrote:
> Use per-cpu cache for fast access to page_cgroup.
> This patch is for making fastpath faster.
>
> Because page_cgroup is accessed when the page is allocated/freed,
> we can assume several of continuous page_cgroup will be accessed soon.
> (If not interleaved on NUMA...but in such case, alloc/free itself is slow.)
>
> We cache some set of page_cgroup's base pointer on per-cpu area and
> use it when we hit.
>
> TODO:
>  - memory/cpu hotplug support.

How much does this help?


>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> ---
>  mm/page_cgroup.c |   47 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 45 insertions(+), 2 deletions(-)
>
> Index: mmtom-2.6.27-rc5+/mm/page_cgroup.c
> ===================================================================
> --- mmtom-2.6.27-rc5+.orig/mm/page_cgroup.c
> +++ mmtom-2.6.27-rc5+/mm/page_cgroup.c
> @@ -57,14 +57,26 @@ static int pcg_hashmask  __read_mostly;
>  #define PCG_HASHMASK		(pcg_hashmask)
>  #define PCG_HASHSIZE		(1 << pcg_hashshift)
>
> +#define PCG_CACHE_MAX_SLOT	(32)
> +#define PCG_CACHE_MASK		(PCG_CACHE_MAX_SLOT - 1)
> +struct percpu_page_cgroup_cache {
> +	struct {
> +		unsigned long	index;
> +		struct page_cgroup *base;
> +	} slots[PCG_CACHE_MAX_SLOT];
> +};
> +DEFINE_PER_CPU(struct percpu_page_cgroup_cache, pcg_cache);
> +
>  int pcg_hashfun(unsigned long index)
>  {
>  	return hash_long(index, pcg_hashshift);
>  }
>
> -struct page_cgroup *lookup_page_cgroup(unsigned long pfn)
> +noinline static struct page_cgroup *
> +__lookup_page_cgroup(struct percpu_page_cgroup_cache *pcc,unsigned long
> pfn) {
>  	unsigned long index = pfn >> ENTS_PER_CHUNK_SHIFT;
> +	int s = index & PCG_CACHE_MASK;
>  	struct pcg_hash *ent;
>  	struct pcg_hash_head *head;
>  	struct hlist_node *node;
> @@ -77,6 +89,8 @@ struct page_cgroup *lookup_page_cgroup(u
>  	hlist_for_each_entry(ent, node, &head->head, node) {
>  		if (ent->index == index) {
>  			pc = ent->map + pfn;
> +			pcc->slots[s].index = ent->index;
> +			pcc->slots[s].base = ent->map;
>  			break;
>  		}
>  	}
> @@ -84,6 +98,22 @@ struct page_cgroup *lookup_page_cgroup(u
>  	return pc;
>  }
>
> +struct page_cgroup *lookup_page_cgroup(unsigned long pfn)
> +{
> +	unsigned long index = pfn >> ENTS_PER_CHUNK_SHIFT;
> +	int hnum = (pfn >> ENTS_PER_CHUNK_SHIFT) & PCG_CACHE_MASK;
> +	struct percpu_page_cgroup_cache *pcc;
> +	struct page_cgroup *ret;
> +
> +	pcc = &get_cpu_var(pcg_cache);
> +	if (likely(pcc->slots[hnum].index == index))
> +		ret = pcc->slots[hnum].base + pfn;
> +	else
> +		ret = __lookup_page_cgroup(pcc, pfn);
> +	put_cpu_var(pcg_cache);
> +	return ret;
> +}
> +
>  static void __meminit alloc_page_cgroup(int node, unsigned long index)
>  {
>  	struct pcg_hash *ent;
> @@ -124,12 +154,23 @@ static void __meminit alloc_page_cgroup(
>  	return;
>  }
>
> +void clear_page_cgroup_cache_pcg(int cpu)
> +{
> +	struct percpu_page_cgroup_cache *pcc;
> +	int i;
> +
> +	pcc = &per_cpu(pcg_cache, cpu);
> +	for (i = 0; i <  PCG_CACHE_MAX_SLOT; i++) {
> +		pcc->slots[i].index = -1;
> +		pcc->slots[i].base = NULL;
> +	}
> +}
>
>  /* Called From mem_cgroup's initilization */
>  void __init page_cgroup_init(void)
>  {
>  	struct pcg_hash_head *head;
> -	int node, i;
> +	int node, cpu, i;
>  	unsigned long start, pfn, end, index, offset;
>  	long default_pcg_hash_size;
>
> @@ -174,5 +215,7 @@ void __init page_cgroup_init(void)
>  			}
>  		}
>  	}
> +	for_each_possible_cpu(cpu)
> +		clear_page_cgroup_cache_pcg(cpu);
>  	return;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
