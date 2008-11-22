Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYKVC0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYKVC0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYKVC0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:26:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51355 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYKVC0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:26:14 -0500
Message-ID: <49276D25.5020001@cn.fujitsu.com>
Date: Sat, 22 Nov 2008 10:23:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 1/2] cgroups: enhance task_cgroup()
References: <4926762A.7000602@cn.fujitsu.com> <6599ad830811211058q3fe12e5coa62436e777b60f1a@mail.gmail.com>
In-Reply-To: <6599ad830811211058q3fe12e5coa62436e777b60f1a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> task_cgroup() calls cgroup_subsys_state().
> 
> No, it calls task_subsys_state()
> 
>> and we must use rcu_read_lock() to protect cgroup_subsys_state().
>> so we must use rcu_read_lock() to protect task_cgroup().
>>
>> but it'll not so friendly to caller: the callers of task_cgroup() have
>> held cgroup_lock(). it means that struct cgroup will not be freed.
>>
>> So this patch add rcu_read_lock() in task_cgroup() to enhance task_cgroup().
>> And we do NOT NEED FIX task_cgroup()'s callers, and cgroup_lock()
>> can protect task_cgroup().
> 
> Is there a reason to add an implicit rcu_read_lock() in task_cgroup()
> and not directly in task_subsys_state() ?

Yes.

The caller have held the cgroup_lock() when it calls task_cgroup().
After we add an implicit rcu_read_lock() in task_cgroup(),
we don't need rcu_read_lock()/task_lock() for using task_cgroup().

For cgroup_exit() will change tsk->cgroups, if we don't
add an implicit rcu_read_lock() in task_cgroup(), we have to fix 7
places which using task_cgroup().


task_subsys_state() is different, it is used in fast path,
If we add an implicit rcu_read_lock() in task_subsys_state(),
we still need rcu_read_lock()/task_lock() for using it,
so it's redundant rcu_read_lock(), and slower the fast path a little.


Lai.

> 
> Paul
> 


