Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYHQDLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYHQDLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 23:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYHQDLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 23:11:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54058 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYHQDLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 23:11:43 -0400
Message-ID: <48A79690.1090600@cn.fujitsu.com>
Date: Sun, 17 Aug 2008 11:10:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "IKEDA, Munehiro" <m-ikeda@ds.jp.nec.com>
CC: linux-kernel@vger.kernel.org, menage@google.com,
       Linux Containers <containers@lists.linux-foundation.org>,
       balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] cgroup: memory.force_empty can make system slowdown
References: <48A63AD1.3010907@ds.jp.nec.com> <48A77BBB.7050305@cn.fujitsu.com>
In-Reply-To: <48A77BBB.7050305@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> IKEDA, Munehiro wrote:
>> Cgroup's memory controller has a control file "memory.force_empty"
>> to reset usage account charged to a cgroup.  The account shouldn't
>> be reset if one or more processes are attached to the cgroup (at
>> least for memory controller, IMHO).  So mem_cgroup_force_empty()
>> is implemented to return -EBUSY and do nothing if so.
>> However, cgroup on hierarchy root faultily might be a exception.
>> Even if processes are attached to root cgroup (which is a "default"
>> cgroup for processes), forcing-empty can run by writing something to
>> memory.force_empty and it'll never end.
>>
> 
> I found this bug last week, and I've made patches to fix it, but then
> I was on vacation. I'll send the patches out soon.
> 
>> Following patch prevents this issue.
>>
>> This patch is for cgroup infrastructure code.  The issue can be
>> measured by modifying memory controller code also, namely to change
>> mem_cgroup_force_empty() to see CSS_ROOT bit of css->flags.
>> I believe cgroup->count approach like the patch below is rather
>> generic and reasonable, how does that sound?
>>
> 
> It's ok for the top_group's count to be 0 due to the top_cgroup hack.
> With this patch, the top cgroup's count will be always >0, even if it
> has no tasks in it, so writing to top_cgroup's force_empty will always
> return -EBUSY.
> 

I thought cgrp->css_sets will be empty when there are no tasks in the top cgroup,
but I was wrong, because init_css_set's refcount will always >0,
so cgroup_task_count() won't return 0 for the top cgroup:

# mount -t cgroup -o debug xxx /mnt
# mkdir /mnt/sub
# for pid in `cat /mnt/tasks`; do echo $pid > /mnt/sub/tasks; done
# cat /mnt/tasks
# cat /mnt/debug.taskcount
3


