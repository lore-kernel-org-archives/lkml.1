Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZD3AI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZD3AI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZD3AIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:08:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44154 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZD3AIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:08:18 -0400
Date: Thu, 30 Apr 2009 09:06:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] memcg: fix mem_cgroup_update_mapped_file_stat
 oops
Message-Id: <20090430090646.a1443096.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0904292209550.30874@blonde.anvils>
References: <Pine.LNX.4.64.0904292209550.30874@blonde.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 22:13:33 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> CONFIG_SPARSEMEM=y CONFIG_CGROUP_MEM_RES_CTLR=y cgroup_disable=memory
> bootup is oopsing in mem_cgroup_update_mapped_file_stat().  !SPARSEMEM
> is fine because its lookup_page_cgroup() contains an explicit check for
> NULL node_page_cgroup, but the SPARSEMEM version was missing a check for
> NULL section->page_cgroup.
> 
Ouch, it's curious this bug alive now.. thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I think this patch itself is sane but.. Balbir, could you see "caller" ?
It seems strange.

> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Should go in as a fix to
> memcg-add-file-based-rss-accounting.patch
> but it's curious that's the first thing to suffer from this divergence.
> 
> Perhaps this is the wrong fix, and there should be an explicit
> mem_cgroup_disable() check somewhere else; but it would then seem
> dangerous that SPARSEMEM and !SPARSEMEM diverge in this way,
> and there are lots of lookup_page_cgroup NULL tests around.
> 
>  mm/page_cgroup.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- 2.6.30-rc3-mm1/mm/page_cgroup.c	2009-04-29 21:01:06.000000000 +0100
> +++ mmotm/mm/page_cgroup.c	2009-04-29 21:12:04.000000000 +0100
> @@ -99,6 +99,8 @@ struct page_cgroup *lookup_page_cgroup(s
>  	unsigned long pfn = page_to_pfn(page);
>  	struct mem_section *section = __pfn_to_section(pfn);
>  
> +	if (!section->page_cgroup)
> +		return NULL;
>  	return section->page_cgroup + pfn;
>  }
>  
> 

