Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYGUJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYGUJ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYGUJ2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:28:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57388 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbYGUJ2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:28:20 -0400
Message-ID: <48845651.4010904@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 17:26:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ranjit Manomohan <ranjitm@google.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
References: <Pine.LNX.4.64.0807181425270.18212@ranjit.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0807181425270.18212@ranjit.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ranjit Manomohan wrote:
> This patch adds a traffic control cgroup subsystem that is used
> to tag all packets originating from tasks in this cgroup with a
> specific identifier (tc_classid).
> 
> Signed-off-by: Ranjit Manomohan <ranjitm@google.com>
> 
> ---
> 
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index e287745..4b12372 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -48,3 +48,9 @@ SUBSYS(devices)
>  #endif
> 
>  /* */
> +
> +#ifdef CONFIG_CGROUP_TC
> +SUBSYS(tc)
> +#endif
> +

seems tc is not a good name... I won't know it stands for traffic-control if I
didn't know beforehand.

> +int cgroup_tc_classid(struct task_struct *tsk)
> +{
> +    rcu_read_lock();
> +    return container_of(task_subsys_state(tsk, tc_subsys_id),
> +                     struct tc_cgroup, css)->classid;
> +    rcu_read_unlock();

How do you unlock after return ;)

> +}
> +
> +static struct cgroup_subsys_state *tc_create(struct cgroup_subsys *ss,
> +                        struct cgroup *cgroup)
> +{
> +    struct tc_cgroup *tc_cgroup;
> +
> +    tc_cgroup = kzalloc(sizeof(*tc_cgroup), GFP_KERNEL);
> +

The 'if (!tc_cgroup)' below should be here.

> +    /* Copy parent's class id if present */
> +    if (cgroup->parent)
> +        tc_cgroup->classid = cgroup_to_tc(cgroup->parent)->classid;
> +
> +    if (!tc_cgroup)
> +        return ERR_PTR(-ENOMEM);
> +    return &tc_cgroup->css;
> +}
