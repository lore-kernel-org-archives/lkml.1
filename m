Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYLBDXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYLBDXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 22:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYLBDXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 22:23:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58812 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYLBDXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 22:23:36 -0500
Message-ID: <4934AA53.4000308@cn.fujitsu.com>
Date: Tue, 02 Dec 2008 11:24:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] cgroups: add inactive subsystems to 	rootnode.root_list
References: <492FC1BD.4010705@cn.fujitsu.com> <6599ad830812011735i565087dfg7ebad01a1f0400ad@mail.gmail.com>
In-Reply-To: <6599ad830812011735i565087dfg7ebad01a1f0400ad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Nov 28, 2008 at 2:02 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Though for an inactive hierarchy, we have subsys->root == &rootnode,
>> but rootnode's root_list is always empty.
> 
> I think you mean "rootnode's subsys_list is always empty".
> 

Yes, I mean subsys_list not root_list.

>> The above code assumes rootnode.subsys_list links all inactive
>> hierarchies.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/cgroup.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 33ba756..4e50e97 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -716,7 +716,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>>                        BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
>>                        cgrp->subsys[i] = dummytop->subsys[i];
>>                        cgrp->subsys[i]->cgroup = cgrp;
>> -                       list_add(&ss->sibling, &root->subsys_list);
>> +                       list_move(&ss->sibling, &root->subsys_list);
>>                        rcu_assign_pointer(ss->root, root);
>>                        if (ss->bind)
>>                                ss->bind(ss, cgrp);
>> @@ -730,7 +730,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>>                        dummytop->subsys[i]->cgroup = dummytop;
>>                        cgrp->subsys[i] = NULL;
>>                        rcu_assign_pointer(subsys[i]->root, &rootnode);
>> -                       list_del(&ss->sibling);
>> +                       list_move(&ss->sibling, &rootnode.subsys_list);
>>                } else if (bit & final_bits) {
>>                        /* Subsystem state should already exist */
>>                        BUG_ON(!cgrp->subsys[i]);
>> @@ -2522,6 +2522,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>>        printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
>>
>>        /* Create the top cgroup state for this subsystem */
>> +       list_add(&ss->sibling, &rootnode.root_list);
> 
> This is wrong. cgroup_subsys.sibling is a member of the list of
> subsystems attached to a given root, and rootnode.root_list is a
> member of the list of hierarchies. Did you actually meant
> &rootnode.subsys_list?
> 

I thought I corrected all the s/root_list/subsys_list/ in patch v2. :(

If this patch makes sense, I'll fix it, otherwise we'll going to ask Andrew to drop it from -mm.

