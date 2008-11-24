Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYKXUqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYKXUqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYKXUpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:45:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:58683 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKXUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:45:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=HktuQGhL1JeeC02vzqV3a+N52+hhQiW4W5gk4IZS5dmXDQox7kpyq4OScSpJb4cDs
	eUJimSwAzXiK57glqckuw==
MIME-Version: 1.0
In-Reply-To: <49277AF7.3090000@cn.fujitsu.com>
References: <4926761E.8030002@cn.fujitsu.com>
	 <6599ad830811211007s43f0c683s9d56e0aed3af938@mail.gmail.com>
	 <49277AF7.3090000@cn.fujitsu.com>
Date: Mon, 24 Nov 2008 12:45:49 -0800
Message-ID: <6599ad830811241245v3b16853dw4c3abd0e36d40ea6@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix incorrect using rcu_dereference() in 
	cgroup_subsys_state()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 7:22 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> No, if you use cgroup_lock() you can do this for any task.
>> cgroup_lock() is the cgroups equivalent of the BKL, and definitely
>> prevents all task movement between groups.
>
> cgroup_exit() will defeat you.

Ah, good point. You should mention that in your description of the
locking rules. But it would be nice if we could get rid of that
restriction.

Paul

>
>>>  static inline struct cgroup_subsys_state *task_subsys_state(
>>>        struct task_struct *task, int subsys_id)
>>>  {
>>> -       return rcu_dereference(task->cgroups->subsys[subsys_id]);
>>> +       /*
>>> +        * ->subsys[subsys_id] are read-only data, so we do not need
>>> +        * rcu_dereference() for it.
>>> +        */
>>> +       return rcu_dereference(task->cgroups)->subsys[subsys_id];
>>>  }
>>
>> Change looks OK but I think we can lose the additional comment.
>>
>> Paul
>>
>>
>>
>
> I just remembered I had deferred Li Zefan's patch.
> (I'm also RCU developer, I had been writing CGROUP VS RCU then,
> I thought these patches should be sent together, So I deferred his patch)
>
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Mon, 25 Aug 2008 11:05:28 +0800
> Subject: [PATCH] cgroup: fix wrong rcu_dereference()
>
> It is tsk->cgroups which is protected by RCU.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/cgroup.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index c98dd7c..d911dc7 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -355,7 +355,7 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
>  static inline struct cgroup_subsys_state *task_subsys_state(
>        struct task_struct *task, int subsys_id)
>  {
> -       return rcu_dereference(task->cgroups->subsys[subsys_id]);
> +       return rcu_dereference(task->cgroups)->subsys[subsys_id];
>  }
>
>  static inline struct cgroup* task_cgroup(struct task_struct *task,
>
>
