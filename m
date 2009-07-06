Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZGFDIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZGFDIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 23:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZGFDIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 23:08:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:36190 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZGFDIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 23:08:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,353,1243839600"; 
   d="scan'208";a="530354368"
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage
 unusable on non-NUMA machine
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <4A4C74D8.30809@kernel.org>
References: <bug-13690-10286@http.bugzilla.kernel.org/>
	 <20090701183452.8660c8a9.akpm@linux-foundation.org>
	 <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp>
	 <4A4C74D8.30809@kernel.org>
Content-Type: text/plain
Organization: intel.com
Date: Mon, 06 Jul 2009 11:13:24 +0800
Message-Id: <1246850004.18539.87.camel@alexs-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai:

The 31-rc2 kernel still can not use hugepage on non-NUMA machine. And
this patch did not appear on rc2 kernel. Are there some concern about
this? 

BRG
Alex 


On Thu, 2009-07-02 at 16:50 +0800, Yinghai Lu wrote:
> Alex Shi wrote:
> > The new patch works for my stoakley i386 machine. But for x86_64 machine
> > the specjbb2005 still can not run with hugepage. The specjbb2005 use the
> > same java setting as i386 system. After apply your patch, the iomem of
> > x86_64 is:
> 
> please check
> 
> [PATCH] x86: don't clear nodes_states[N_NORMAL_MEMORY] when numa is not compiled in
> 
> Alex found:
> for x86_64 machine the specjbb2005 still can not run with hugepage
> 
> only happens when numa is not compiled in
> 
> the root cause: node_set_state will not set it back for us in that case
> 
> so don't clear that when numa is not select in config
> 
> Reported-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/mm/init_64.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/mm/init_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/init_64.c
> +++ linux-2.6/arch/x86/mm/init_64.c
> @@ -598,8 +598,14 @@ void __init paging_init(void)
>  
>  	sparse_memory_present_with_active_regions(MAX_NUMNODES);
>  	sparse_init();
> -	/* clear the default setting with node 0 */
> +#if MAX_NUMNODES > 1
> +	/*
> +	 * clear the default setting with node 0
> +	 * note: don't clear it, node_set_state will do nothing
> +	 *	 (aka set it back) when numa support is not compiled in
> +	 */
>  	nodes_clear(node_states[N_NORMAL_MEMORY]);
> +#endif
>  	free_area_init_nodes(max_zone_pfns);
>  }
>  

