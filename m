Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0CLJpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:45:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:57808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0CLJpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:45:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=B1ksjnlccwfr4mhBqbUHF1VPUMgW41u2udBPxNt/CAbzAd2icjnRCfzmH2oz61CeM
	CHzAMP7Gb5qaiJzYe4Spg==
Date: Fri, 12 Mar 2010 01:45:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm 2/2] cpuset: alloc nodemask_t at heap not stack
 - fix
In-Reply-To: <4B99E634.2070608@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003120145210.22682@chino.kir.corp.google.com>
References: <4B99E634.2070608@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010, Miao Xie wrote:

> fix memory leak
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Against the following patch in mmotm-2010-03-11-13-13:
> cpuset-alloc-nodemask_t-at-heap-not-stack.patch
> ---
>  kernel/cpuset.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index f36e577..8e27d00 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1401,7 +1401,7 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
>  
>  	if (from == NULL || to == NULL)
> -		return;
> +		goto alloc_fail;
>  
>  	if (cs == &top_cpuset) {
>  		cpumask_copy(cpus_attach, cpu_possible_mask);
> @@ -1432,8 +1432,12 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  		mmput(mm);
>  	}
>  
> -	NODEMASK_FREE(from);
> -	NODEMASK_FREE(to);
> +alloc_fail:
> +	if (from)
> +		NODEMASK_FREE(from);
> +
> +	if (to)
> +		NODEMASK_FREE(to);

kfree() can take NULL pointers.
