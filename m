Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYHZFYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYHZFYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 01:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYHZFYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 01:24:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62232 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYHZFYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 01:24:45 -0400
Message-ID: <48B39319.7070403@cn.fujitsu.com>
Date: Tue, 26 Aug 2008 13:22:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
References: <48B360CE.2010501@cn.fujitsu.com> <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
In-Reply-To: <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Aug 25, 2008 at 6:47 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> In original code, we kmalloc a lot of memory when we open cgroup.tasks.
>> _This memory is allocated by kmalloc_, So this memory is not statistical
>> for this process or this user. This is a critical bug.
> 
> It's true that this does represent a way for an untrusted user to
> consume a big chunk of memory on a machine. It's been around since
> cpusets was introduced. I'm not sure that it's more serious than say,
> a fork bomb or allocating lots of memory via lots of sockets with huge
IMO This is very different. The number of creating processes is statistical,
The number of opening sockets is statistical, The kernel(OOM-killer ...)
or system manager(use ulimit or other tools) can control these behaviors.
But kmalloc a big chunk of memory is not statistical.

The evil is that this big chunk of memory is not statistical.

> network buffers. I don't see how this can cause an oops - slab.c and
> slub.c both appear to just return NULL in that case, from a quick
> inspection.
I failed to try my best to rescue my system in this condition in my testes.
(But this is true: my skill is so few that I can not rescue any system)

oops - I means that the system is very hard to be rescued. The kernel
do not know which process should be killed for no statistical result.
system manager may know which process should be killed(use lsof or other tools)
but he has no memory to do any operation.

oops - My system was not responded after some printk's messages for other
subsystem were output in one of my test. I thought this was oops.

> 
> But improving the current code has been on my todo list for a while.
> My thought on the best way to fix it is to use a proper seq_file -
> that would remove the issues that you have currently with the
> "unconsumed" portion of the output.

But for my poor knowledge we always have to handle "unconsumed portion"
for nonseekable file in all different way. In my binary search based
solving, I have to handle unconsumed part for a pid and bring in
some complicated. This is really a disadvantage as you pointed out.

> 
> Using a seq_file iterator with your single pid array per cgroup might
> work quite nicely - but isn't there still a problem that with a really
> large cgroup we can overflow the kmalloc() limit for a single pid
> array?
> 
> My original thoughts for solving this involved using a prio_heap to
> ensure that every task in the cgroup was seen once:
> 
> 1) similar to cgroup_scan_tasks, fill a prio_heap with the first N (by
> task start time) tasks in the cgroup
> 2) sort these tasks by pid
> 3) report these by seq_file
> 4) once all the pids in the heap have been reported, update the
> minimum task start time to be greater than the last task start time in
> the reported group, and goto 1
> 
> This way we never have to allocate more than a single prio_heap per
> open file; the downside is that we have more overhead when reporting
> on really large cgroups since we have to make multiple scans of the
> cgroup's task list.
> 
It's complicated than necessary and change too much code IMO.
This solving is nonseekable also(for multi-scanning).
And the result of tasks file is not sorted(for multi-scanning).

Steps in my solving.
1) deal with the unconsumed part of the just read pid
2) binary search
3) deal with the unconsumed part of file(unconsumed pids).

step 2 ensure that every task in the cgroup was seen once and
ensure that we do not need scan again, the result of tasks file
is sorted.


Thank you for reviewing and comments.

                      Lai


