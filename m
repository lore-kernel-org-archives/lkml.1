Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZCBRxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZCBRxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 12:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZCBRwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 12:52:53 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53826 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZCBRww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 12:52:52 -0500
Date: Mon, 2 Mar 2009 23:22:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Memory controller soft limit patches (v3)
Message-ID: <20090302175235.GN11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain> <20090302092404.1439d2a6.kamezawa.hiroyu@jp.fujitsu.com> <20090302044043.GC11421@balbir.in.ibm.com> <20090302143250.f47758f9.kamezawa.hiroyu@jp.fujitsu.com> <20090302060519.GG11421@balbir.in.ibm.com> <20090302151830.3770e528.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090302151830.3770e528.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-02 15:18:30]:

> On Mon, 2 Mar 2009 11:35:19 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > > Then, not-sorted RB-tree can be there.
> > > 
> > > BTW,
> > >    time_after(jiffies, 0)
> > > is buggy (see definition). If you want make this true always,
> > >    time_after(jiffies, jiffies +1)
> > >
> > 
> > HZ/4 is 250/4 jiffies in the worst case (62). We have
> > time_after(jiffies, next_update_interval) and next_update_interval is
> > set to last_tree_update + 62. Not sure if I got what you are pointing
> > to.
> > 
> +	unsigned long next_update = 0;
> +	unsigned long flags;
> +
> +	if (!css_tryget(&mem->css))
> +		return;
> +	prev_usage_in_excess = mem->usage_in_excess;
> +	new_usage_in_excess = res_counter_soft_limit_excess(&mem->res);
> +
> +	if (time_check)
> +		next_update = mem->last_tree_update +
> +				MEM_CGROUP_TREE_UPDATE_INTERVAL;
> +	if (new_usage_in_excess && time_after(jiffies, next_update)) {
> +		if (prev_usage_in_excess)
> +			mem_cgroup_remove_exceeded(mem);
> +		mem_cgroup_insert_exceeded(mem);
> +		updated_tree = true;
> +	} else if (prev_usage_in_excess && !new_usage_in_excess) {
> +		mem_cgroup_remove_exceeded(mem);
> +		updated_tree = true;
> +	}
> 
> My point is what happens if time_check==false.
> time_afrter(jiffies, 0) is buggy.
>

I see your point now, but the idea behind doing so is that
time_after(jiffies, 0) will always return false, which forces the
prev_usage_in_excess and !new_usage_in_excess check to execute. We set
the value to false only from __mem_cgroup_free().

Are you suggesting that calling time_after(jiffies, 0) is buggy?
The comment

  Do this with "<0" and ">=0" to only test the sign of the result. A
 
I think refers to the comparison check and not to the parameters. I
hope I am reading this right.
-- 
	Balbir
