Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbYLMIX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbYLMIX5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 03:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYLMIXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 03:23:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51881 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYLMIXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 03:23:49 -0500
Message-ID: <494370C0.4050005@cn.fujitsu.com>
Date: Sat, 13 Dec 2008 16:22:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bharata B Rao <bharata.rao@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
References: <494234B0.5@cn.fujitsu.com> <344eb09a0812120338h29e1088pac7f9a22e37bf609@mail.gmail.com>
In-Reply-To: <344eb09a0812120338h29e1088pac7f9a22e37bf609@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> On Fri, Dec 12, 2008 at 3:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>  kernel/sched_debug.c |   10 ++++++++--
>>  1 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
>> index 26ed8e3..01abf5b 100644
>> --- a/kernel/sched_debug.c
>> +++ b/kernel/sched_debug.c
>> @@ -127,8 +127,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>>        if (tg)
>>                cgroup = tg->css.cgroup;
>>
>> -       if (cgroup)
>> +       if (cgroup) {
>> +               cgroup_lock();
>>                cgroup_path(cgroup, path, sizeof(path));
>> +               cgroup_unlock();
>> +       }
>>
>>        SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
>>  #else
>> @@ -181,8 +184,11 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
>>        if (tg)
>>                cgroup = tg->css.cgroup;
>>
>> -       if (cgroup)
>> +       if (cgroup) {
>> +               cgroup_lock();
>>                cgroup_path(cgroup, path, sizeof(path));
>> +               cgroup_unlock();
>> +       }
>>
>>        SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
>>  #else
> 
> The comment in cgroup_path() routine says that it needs to be called
> with cgroup_mutex held. With the above fix, print_task() in
> sched_debug.c remains the last caller of cgroup_path() which calls it
> without holding cgroup_mutex. Does this also need a fix ?
> 

You mean:

print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
{
	...
		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
	...
}

Hmm...Normally we have to take task_lock() or rcu_read_lock() to retrieve
the cgroup from the task, and as long as we hold either lock, we don't need
to take cgroup_lock().

I noticed neither task_lock() nor rcu is held before calling cgroup_path,
so I wrote a test program to see if I can trigger a but here, but it didn't
happen. I'll dig more.
