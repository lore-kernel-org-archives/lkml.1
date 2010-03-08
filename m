Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0CHV1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:27:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:44565 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0CHV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:27:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=l910o3aJXMuGxifRagnkuG/kzCDt7I8e0Xa/p13vkKqRcXFTkj62LsZjxd1sFE3yi
	XcprB7CimMwJ3t7KinrKw==
Date: Mon, 8 Mar 2010 13:27:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/4] cpuset: alloc nodemask_t at heap not stack
In-Reply-To: <4B94CC6D.2070502@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003081324550.14689@chino.kir.corp.google.com>
References: <4B94CC6D.2070502@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Miao Xie wrote:

> Changes from V1 to V2:
> - None
> 

Both this and patch 2/4 are already in -mm, so please rebase this series 
on mmotm-2010-03-04-18-05.

> @@ -1381,39 +1394,46 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  			  struct cgroup *oldcont, struct task_struct *tsk,
>  			  bool threadgroup)
>  {
> -	nodemask_t from, to;
>  	struct mm_struct *mm;
>  	struct cpuset *cs = cgroup_cs(cont);
>  	struct cpuset *oldcs = cgroup_cs(oldcont);
> +	NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
> +	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
> +
> +	if (from == NULL || to == NULL)
> +		return;
>  

You're potentially leaking one of the allocated nodemasks there if the 
other is -ENOMEM.
