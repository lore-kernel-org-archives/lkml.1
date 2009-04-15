Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZDODfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZDODfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZDODfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:35:37 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:36456 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZDODfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:35:36 -0400
Date: Wed, 15 Apr 2009 09:04:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Mel Gorman <mel@linux.vnet.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: meminfo Committed_AS underflows
Message-ID: <20090415033455.GS7082@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1239737619.32604.118.camel@nimitz> <20090415105033.AC29.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090415105033.AC29.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-04-15 11:04:59]:

>  	committed = atomic_long_read(&vm_committed_space);
> +	if (committed < 0)
> +		committed = 0;

Isn't this like pushing the problem under the rug?

>  	allowed = ((totalram_pages - hugetlb_total_pages())
>  		* sysctl_overcommit_ratio / 100) + total_swap_pages;
> 
> Index: b/mm/swap.c
> ===================================================================
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -519,7 +519,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
>   * We tolerate a little inaccuracy to avoid ping-ponging the counter between
>   * CPUs
>   */
> -#define ACCT_THRESHOLD	max(16, NR_CPUS * 2)
> +#define ACCT_THRESHOLD	max_t(long, 16, num_online_cpus() * 2)
>

Hmm.. this is a one time expansion, free of CPU hotplug.

Should we use nr_cpu_ids or num_possible_cpus()?
 

-- 
	Balbir
