Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYLBJG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYLBJG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYLBJGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:06:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56684 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbYLBJGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:06:18 -0500
Date: Tue, 2 Dec 2008 18:05:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 11/11] memcg: show reclaim_stat
Message-Id: <20081202180525.2023892c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201211905.1CEB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081201211905.1CEB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Dec 2008 21:19:49 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> added following four field to memory.stat file.
> 
>   - recent_rotated_anon
>   - recent_rotated_file
>   - recent_scanned_anon
>   - recent_scanned_file
> 
> it is useful for memcg reclaim debugging.
> 
I'll put this under CONFIG_DEBUG_VM.

Thanks,
-Kame

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> Index: b/mm/memcontrol.c
> ===================================================================
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1799,6 +1799,31 @@ static int mem_control_stat_show(struct 
>  
>  	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
>  
> +	{
> +		int nid, zid;
> +		struct mem_cgroup_per_zone *mz;
> +		unsigned long recent_rotated[2] = {0, 0};
> +		unsigned long recent_scanned[2] = {0, 0};
> +
> +		for_each_online_node(nid)
> +			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
> +				mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
> +
> +				recent_rotated[0] +=
> +					mz->reclaim_stat.recent_rotated[0];
> +				recent_rotated[1] +=
> +					mz->reclaim_stat.recent_rotated[1];
> +				recent_scanned[0] +=
> +					mz->reclaim_stat.recent_scanned[0];
> +				recent_scanned[1] +=
> +					mz->reclaim_stat.recent_scanned[1];
> +			}
> +		cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
> +		cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
> +		cb->fill(cb, "recent_scanned_anon", recent_scanned[0]);
> +		cb->fill(cb, "recent_scanned_file", recent_scanned[1]);
> +	}
> +
>  	return 0;
>  }
>  
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

