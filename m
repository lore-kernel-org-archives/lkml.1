Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbZDXORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbZDXORT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZDXORI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:17:08 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36176 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbZDXORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:17:05 -0400
Subject: Re: [PATCH 02/22] Do not sanity check order in the fast path
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090424103405.GC14283@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-3-git-send-email-mel@csn.ul.ie>
	 <1240416791.10627.78.camel@nimitz> <20090422171151.GF15367@csn.ul.ie>
	 <1240421415.10627.93.camel@nimitz> <20090423001311.GA26643@csn.ul.ie>
	 <1240450447.10627.119.camel@nimitz> <20090423095821.GA25102@csn.ul.ie>
	 <1240508211.10627.139.camel@nimitz>  <20090424103405.GC14283@csn.ul.ie>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 07:16:59 -0700
Message-Id: <1240582619.29485.3.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 11:34 +0100, Mel Gorman wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1464aca..1c60141 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1434,7 +1434,6 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
>  	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
> 
>  	classzone_idx = zone_idx(preferred_zone);
> -	VM_BUG_ON(order >= MAX_ORDER);
> 
>  zonelist_scan:
>  	/*
> @@ -1692,6 +1691,15 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	struct task_struct *p = current;
> 
>  	/*
> +	 * In the slowpath, we sanity check order to avoid ever trying to
> +	 * reclaim >= MAX_ORDER areas which will never succeed. Callers may
> +	 * be using allocators in order of preference for an area that is
> +	 * too large. 
> +	 */
> +	if (WARN_ON_ONCE(order >= MAX_ORDER))
> +		return NULL;
> +
> +	/*
>  	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
>  	 * __GFP_NOWARN set) should not cause reclaim since the subsystem
>  	 * (f.e. slab) using GFP_THISNODE may choose to trigger reclaim



Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

