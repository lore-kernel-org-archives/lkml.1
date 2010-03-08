Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0CHVWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:22:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab0CHVWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:22:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=t733gWy1NXmGoIAdJ1+6RuoUecMWPVU37v0GwAPNse6HMKB0nDGOEyp0Q2c7feLhb
	+oFnECcaFiUp/vlAkQrsQ==
Date: Mon, 8 Mar 2010 13:22:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Lee Schermerhorn <lee.schermerhorn@hp.com>, Nick Piggin <npiggin@suse.de>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH V2 1/4] cpuset: fix the problem that cpuset_mem_spread_node()
 returns an offline node
In-Reply-To: <4B94CB6C.8090601@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003081318460.14689@chino.kir.corp.google.com>
References: <4B94CB6C.8090601@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Miao Xie wrote:

> Changes from V1 to V2:
> - cleanup two unnecessary smp_wmb() at cpuset_migrate_mm()
> 

This patch is already in -mm without this update, so it's probably better 
to make this an incremental series basedo n mmotm-2010-03-04-18-05 or 
later.

> @@ -2090,15 +2086,19 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
>  static int cpuset_track_online_nodes(struct notifier_block *self,
>  				unsigned long action, void *arg)
>  {
> +	nodemask_t oldmems;
> +
>  	cgroup_lock();
>  	switch (action) {
>  	case MEM_ONLINE:
> -	case MEM_OFFLINE:
> +		oldmems = top_cpuset.mems_allowed;
>  		mutex_lock(&callback_mutex);
>  		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>  		mutex_unlock(&callback_mutex);
> -		if (action == MEM_OFFLINE)
> -			scan_for_empty_cpusets(&top_cpuset);
> +		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
> +		break;
> +	case MEM_OFFLINE:
> +		scan_for_empty_cpusets(&top_cpuset);
>  		break;
>  	default:
>  		break;

This looks wrong, why isn't top_cpuset.mems_allowed updated for 
MEM_OFFLINE?  If you're going to update it when a new node comes online 
for (struct memory_notify *)arg->status_change_nid is >= 0, then it should 
be removed from the nodemask when offlined as well.  You'd be calling 
scan_for_empty_cpusets() needlessly in this code since it'll never change 
under your hotplug code.
