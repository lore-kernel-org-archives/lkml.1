Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYKVDZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYKVDZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYKVDZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:25:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYKVDZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:25:08 -0500
Message-ID: <49277AF7.3090000@cn.fujitsu.com>
Date: Sat, 22 Nov 2008 11:22:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroups: fix incorrect using rcu_dereference() in 	cgroup_subsys_state()
References: <4926761E.8030002@cn.fujitsu.com> <6599ad830811211007s43f0c683s9d56e0aed3af938@mail.gmail.com>
In-Reply-To: <6599ad830811211007s43f0c683s9d56e0aed3af938@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> It's task->cgroups protected by RCU. and struct css_set.subsys[subsys_id]
>> is readonly(after init). so we don't need rcu_dereference() for
>> struct css_set.subsys[subsys_id].
>>
>> the ways using cgroup_subsys_state() safely:
>>
>> #1:
>> rcu_read_lock() / task_lock();
>> c = cgroup_subsys_state(tsk, id);
>> use c;
>> rcu_read_unlock() / task_unlock();
> 
> You need to qualify that with the fact that if you're just using RCU,
> the subsys state may no longer be the state for the task that you're
> interested in, since we don't guarantee that the task won't move
> directly after you read the state pointer.
> 
>>
>> #2: use cgroup_lock() for _current_ task.
>> cgroup_lock();
>> c = cgroup_subsys_state(current, id);
>> use c;
>> cgroup_unlock();
> 
> No, if you use cgroup_lock() you can do this for any task.
> cgroup_lock() is the cgroups equivalent of the BKL, and definitely
> prevents all task movement between groups.

cgroup_exit() will defeat you.

>>  static inline struct cgroup_subsys_state *task_subsys_state(
>>        struct task_struct *task, int subsys_id)
>>  {
>> -       return rcu_dereference(task->cgroups->subsys[subsys_id]);
>> +       /*
>> +        * ->subsys[subsys_id] are read-only data, so we do not need
>> +        * rcu_dereference() for it.
>> +        */
>> +       return rcu_dereference(task->cgroups)->subsys[subsys_id];
>>  }
> 
> Change looks OK but I think we can lose the additional comment.
> 
> Paul
> 
> 
> 

I just remembered I had deferred Li Zefan's patch.
(I'm also RCU developer, I had been writing CGROUP VS RCU then,
I thought these patches should be sent together, So I deferred his patch)

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 25 Aug 2008 11:05:28 +0800
Subject: [PATCH] cgroup: fix wrong rcu_dereference()

It is tsk->cgroups which is protected by RCU.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c98dd7c..d911dc7 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -355,7 +355,7 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
 static inline struct cgroup_subsys_state *task_subsys_state(
 	struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference(task->cgroups->subsys[subsys_id]);
+	return rcu_dereference(task->cgroups)->subsys[subsys_id];
 }
 
 static inline struct cgroup* task_cgroup(struct task_struct *task,

