Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZEUAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZEUAsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbZEUAsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:48:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63255 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbZEUAsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:48:06 -0400
Message-ID: <4A14A506.2000601@cn.fujitsu.com>
Date: Thu, 21 May 2009 08:49:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, davem@davemloft.net, tgraf@suug.ch,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: [PATCH] cls_cgroup: read classid atomically in classifier
References: <20090520173426.15291.93021.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090520173426.15291.93021.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(better CC netdev)

Paul Menage wrote:
> cls_cgroup: read classid atomically in classifier
> 
> Avoid reading the unsynchronized value cs->classid multiple times,
> since it could change concurrently from non-zero to zero; this would
> result in the classifier returning a positive result with a bogus
> (zero) classid.
> 

This patch looks nice. It also narrows rcu read section.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> 
>  net/sched/cls_cgroup.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
> index 1ab4542..4ece6e0 100644
> --- a/net/sched/cls_cgroup.c
> +++ b/net/sched/cls_cgroup.c
> @@ -98,8 +98,7 @@ static int cls_cgroup_classify(struct sk_buff *skb, struct tcf_proto *tp,
>  			       struct tcf_result *res)
>  {
>  	struct cls_cgroup_head *head = tp->root;
> -	struct cgroup_cls_state *cs;
> -	int ret = 0;
> +        u32 classid;
>  
>  	/*
>  	 * Due to the nature of the classifier it is required to ignore all
> @@ -115,17 +114,18 @@ static int cls_cgroup_classify(struct sk_buff *skb, struct tcf_proto *tp,
>  		return -1;
>  
>  	rcu_read_lock();
> -	cs = task_cls_state(current);
> -	if (cs->classid && tcf_em_tree_match(skb, &head->ematches, NULL)) {
> -		res->classid = cs->classid;
> -		res->class = 0;
> -		ret = tcf_exts_exec(skb, &head->exts, res);
> -	} else
> -		ret = -1;
> -
> +	classid = task_cls_state(current)->classid;
>  	rcu_read_unlock();
>  
> -	return ret;
> +	if (!classid)
> +		return -1;
> +
> +	if (!tcf_em_tree_match(skb, &head->ematches, NULL))
> +		return -1;
> +
> +	res->classid = classid;
> +	res->class = 0;
> +	return tcf_exts_exec(skb, &head->exts, res);
>  }
>  
>  static unsigned long cls_cgroup_get(struct tcf_proto *tp, u32 handle)
> 
> 
> 
