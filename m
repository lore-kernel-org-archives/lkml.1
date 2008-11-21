Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYKUSIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYKUSIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYKUSHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:07:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:12446 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYKUSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:07:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=rRPYgqqBTc4OZE+CGqoa18HcSS1bfbT0nzGFtsUj17CeBwijRG3yMuQ5p4q79h1Wg
	UaptAPiM5b0FbpIf497Dg==
MIME-Version: 1.0
In-Reply-To: <4926761E.8030002@cn.fujitsu.com>
References: <4926761E.8030002@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 10:07:48 -0800
Message-ID: <6599ad830811211007s43f0c683s9d56e0aed3af938@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix incorrect using rcu_dereference() in 
	cgroup_subsys_state()
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
> It's task->cgroups protected by RCU. and struct css_set.subsys[subsys_id]
> is readonly(after init). so we don't need rcu_dereference() for
> struct css_set.subsys[subsys_id].
>
> the ways using cgroup_subsys_state() safely:
>
> #1:
> rcu_read_lock() / task_lock();
> c = cgroup_subsys_state(tsk, id);
> use c;
> rcu_read_unlock() / task_unlock();

You need to qualify that with the fact that if you're just using RCU,
the subsys state may no longer be the state for the task that you're
interested in, since we don't guarantee that the task won't move
directly after you read the state pointer.

>
>
> #2: use cgroup_lock() for _current_ task.
> cgroup_lock();
> c = cgroup_subsys_state(current, id);
> use c;
> cgroup_unlock();

No, if you use cgroup_lock() you can do this for any task.
cgroup_lock() is the cgroups equivalent of the BKL, and definitely
prevents all task movement between groups.
>  static inline struct cgroup_subsys_state *task_subsys_state(
>        struct task_struct *task, int subsys_id)
>  {
> -       return rcu_dereference(task->cgroups->subsys[subsys_id]);
> +       /*
> +        * ->subsys[subsys_id] are read-only data, so we do not need
> +        * rcu_dereference() for it.
> +        */
> +       return rcu_dereference(task->cgroups)->subsys[subsys_id];
>  }

Change looks OK but I think we can lose the additional comment.

Paul
