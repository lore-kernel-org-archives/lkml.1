Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZLVMkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZLVMkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZLVMkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:40:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38266 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZLVMki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:40:38 -0500
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] slab: initialize unused alien cache entry as NULL at alloc_alien_cache().
From: Andi Kleen <andi@firstfloor.org>
References: <4B30BDA8.1070904@linux.intel.com>
Date: Tue, 22 Dec 2009 13:40:34 +0100
In-Reply-To: <4B30BDA8.1070904@linux.intel.com> (Haicheng Li's message of "Tue, 22 Dec 2009 20:38:00 +0800")
Message-ID: <87skb3chbx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haicheng Li <haicheng.li@linux.intel.com> writes:

> Memory hotplug would online new node in runtime, then reap timer will
> add this new node as a reap node. In such case, for each existing
> kmem_list, we need to ensure that the alien cache entry corresponding
> to this new added node is NULL. Otherwise, it might cause BUG when
> reap_alien() affecting the new added node.
>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>

Acked-by: Andi Kleen <ak@linux.intel.com>
IMHO a 2.6.33 and even stable candidate

-Andi


> ---
>  mm/slab.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 7dfa481..a9486a0 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -966,18 +966,17 @@ static void *alternate_node_alloc(struct kmem_cache *, gfp_t);
>  static struct array_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
>  {
>  	struct array_cache **ac_ptr;
> -	int memsize = sizeof(void *) * nr_node_ids;
> +	int memsize = sizeof(void *) * MAX_NUMNODES;
>  	int i;
>
>  	if (limit > 1)
>  		limit = 12;
>  	ac_ptr = kmalloc_node(memsize, gfp, node);
>  	if (ac_ptr) {
> +		memset(ac_ptr, 0, memsize);
>  		for_each_node(i) {
> -			if (i == node || !node_online(i)) {
> -				ac_ptr[i] = NULL;
> +			if (i == node || !node_online(i))
>  				continue;
> -			}
>  			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
>  			if (!ac_ptr[i]) {
>  				for (i--; i >= 0; i--)
> -- 
> 1.6.0.rc1

-- 
ak@linux.intel.com -- Speaking for myself only.
