Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZIVACj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZIVACj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZIVACi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:02:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:56263 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbZIVACi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:02:38 -0400
Message-ID: <4AB813F3.8060102@kernel.org>
Date: Tue, 22 Sep 2009 09:01:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] powerpc: Allocate per-cpu areas for node IDs for
 SLQB to use as per-node areas
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <1253549426-917-2-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1253549426-917-2-git-send-email-mel@csn.ul.ie>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 00:01:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mel Gorman wrote:
> diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> index 1f68160..a5f52d4 100644
> --- a/arch/powerpc/kernel/setup_64.c
> +++ b/arch/powerpc/kernel/setup_64.c
> @@ -588,6 +588,26 @@ void __init setup_per_cpu_areas(void)
>  		paca[i].data_offset = ptr - __per_cpu_start;
>  		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
>  	}
> +#ifdef CONFIG_SLQB
> +	/* 
> +	 * SLQB abuses DEFINE_PER_CPU to setup a per-node area. This trick
> +	 * assumes that ever node ID will have a CPU of that ID to match.
> +	 * On systems with memoryless nodes, this may not hold true. Hence,
> +	 * we take a second pass initialising a "per-cpu" area for node-ids
> +	 * that SLQB can use
> +	 */
> +	for_each_node_state(i, N_NORMAL_MEMORY) {
> +
> +		/* Skip node IDs that a valid CPU id exists for */
> +		if (paca[i].data_offset)
> +			continue;
> +
> +		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
> +
> +		paca[i].data_offset = ptr - __per_cpu_start;
> +		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
> +	}
> +#endif /* CONFIG_SLQB */
>  }
>  #endif

Eh... I don't know.  This seems too hacky to me.  Why not just
allocate pointer array of MAX_NUMNODES and allocate per-node memory
there?  This will be slightly more expensive but I doubt it will be
noticeable.  The only extra overhead is the cachline footprint for the
extra array.

Thanks.

-- 
tejun
