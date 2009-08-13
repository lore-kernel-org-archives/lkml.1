Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZHMH3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZHMH3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZHMH3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:29:52 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51859 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZHMH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:29:51 -0400
Date: Thu, 13 Aug 2009 16:26:40 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "menage@google.com" <menage@google.com>, xemul@openvz.org,
       prarit@redhat.com, andi.kleen@intel.com, nishimura@mxp.nes.nec.co.jp,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH][mmotm] Help Root Memory Cgroup Resource Counters Scale
 Better (v5)
Message-Id: <20090813162640.fe2349e9.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090813065504.GG5087@balbir.in.ibm.com>
References: <20090813065504.GG5087@balbir.in.ibm.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1855,9 +1883,14 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
>  		break;
>  	}
>  
> -	res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
> -	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
> -		res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
> +	if (!mem_cgroup_is_root(mem)) {
> +		res_counter_uncharge(&mem->res, PAGE_SIZE, &soft_limit_excess);
> +		if (do_swap_account &&
> +				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
> +			res_counter_uncharge(&mem->memsw, PAGE_SIZE, NULL);
> +	}
> +	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT && mem_cgroup_is_root(mem))
> +		mem_cgroup_swap_statistics(mem, true);
Hmm, if we don't count MEM_CGROUP_STAT_SWAPOUT properly about other groups than the root,
memsw.usage_in_bytes of the root would be incorrect in use_hierarchy==1 case, right?

>  	mem_cgroup_charge_statistics(mem, pc, false);
>  
>  	ClearPageCgroupUsed(pc);

Thanks,
Daisuke Nishimura.
