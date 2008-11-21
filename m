Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYKUS6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYKUS6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYKUS6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:58:48 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22433 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYKUS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:58:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=phqZLC5caoZnEO6rmr/QNU8NlhbRdBiDtSSSt+EHQi1fP/5yeTJ9PpYo3YtS7cQZq
	dmcB3ZCh7Z0wH5yoaFm0g==
MIME-Version: 1.0
In-Reply-To: <4926762A.7000602@cn.fujitsu.com>
References: <4926762A.7000602@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 10:58:44 -0800
Message-ID: <6599ad830811211058q3fe12e5coa62436e777b60f1a@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroups: enhance task_cgroup()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> task_cgroup() calls cgroup_subsys_state().

No, it calls task_subsys_state()

> and we must use rcu_read_lock() to protect cgroup_subsys_state().
> so we must use rcu_read_lock() to protect task_cgroup().
>
> but it'll not so friendly to caller: the callers of task_cgroup() have
> held cgroup_lock(). it means that struct cgroup will not be freed.
>
> So this patch add rcu_read_lock() in task_cgroup() to enhance task_cgroup().
> And we do NOT NEED FIX task_cgroup()'s callers, and cgroup_lock()
> can protect task_cgroup().

Is there a reason to add an implicit rcu_read_lock() in task_cgroup()
and not directly in task_subsys_state() ?

Paul

>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 1164963..22901ff 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -359,6 +360,10 @@
>  static inline struct cgroup* task_cgroup(struct task_struct *task,
>                                               int subsys_id)
>  {
> -       return task_subsys_state(task, subsys_id)->cgroup;
> +       struct cgroup *ret;
> +       rcu_read_lock();
> +       ret = task_subsys_state(task, subsys_id)->cgroup;
> +       rcu_read_unlock();
> +       return ret;
>  }
>
>  int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *ss,
>
>
>
