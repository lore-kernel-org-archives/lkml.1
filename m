Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYKDGP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYKDGP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYKDGPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:15:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62435 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYKDGPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:15:00 -0500
Message-ID: <490FE7B5.8020400@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 14:12:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 3/5] Container Freezer: Implement freezer cgroup subsystem
References: <20080811235323.872291138@us.ibm.com>	 <20080811235325.121356317@us.ibm.com> <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>
In-Reply-To: <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Aug 11, 2008 at 3:53 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
>> +}
>> +
>> +static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
>> +{
>> +       struct freezer *freezer;
>> +
>> +       task_lock(task);
>> +       freezer = task_freezer(task);
>> +       task_unlock(task);
>> +
>> +       BUG_ON(freezer->state == STATE_FROZEN);
>> +       spin_lock_irq(&freezer->lock);
>> +       /* Locking avoids race with FREEZING -> RUNNING transitions. */
>> +       if (freezer->state == STATE_FREEZING)
>> +               freeze_task(task, true);
>> +       spin_unlock_irq(&freezer->lock);
>> +}
> 
> Sorry for such a delayed response to this patch, but I just noticed
> (in mainline now)
> the change to move the task_lock() to only encompass the
> task_freezer() call.
> 
> That results in absolutely zero protection from the task_lock() - as
> soon as you drop it, then in theory the current task could move cgroup
> and the old freezer structure be freed.
> 
> Having said that, I think that in this case any locking my be
> unnecessary since task isn't on the tasklist yet, so can't be selected
> to move cgroups. (Although this does make me wonder whether
> cpuset.c:move_member_tasks_to_cpuset() can fail silently if it races
> with a fork).
> 
> On top of that, for a system that configures in the cgroup freezer
> system but doesn't ever use it, every task is in the same freezer
> cgroup (the root cgroup) and task_freezer(task)->lock becomes a global
> spinlock. I think this would certainly show up on some benchmarks
> although I don't know how bad it would be in a practical sense. But it
> might be worth considering making using of the cgroup bind() callback
> to track whether or not the freezer subsystem is in use, and
> short-circuiting this in freezer_fork() without any locking if you're
> not active.
> 

I think another reasonable and easier way is to disable writing freezer.state
of top cgroup, so we can skip checks in freezer_fork() for tasks in top cgroup.

