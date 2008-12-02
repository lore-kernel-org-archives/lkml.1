Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYLBWxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYLBWxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLBWxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:53:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYLBWxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:53:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=VdbZc01pOGYq5Zg5wBfYx24nEGo+/8w0qLIcx2DY+3spbAnbOV1QmachsPGvnrfg/
	gU/GiG33OU5kI/e8Kbbnw==
MIME-Version: 1.0
In-Reply-To: <4934AA53.4000308@cn.fujitsu.com>
References: <492FC1BD.4010705@cn.fujitsu.com>
	 <6599ad830812011735i565087dfg7ebad01a1f0400ad@mail.gmail.com>
	 <4934AA53.4000308@cn.fujitsu.com>
Date: Tue, 2 Dec 2008 14:53:37 -0800
Message-ID: <6599ad830812021453m44e948b1p83f6e02aa7e9068@mail.gmail.com>
Subject: Re: [PATCH 2/3] cgroups: add inactive subsystems to 
	rootnode.root_list
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2008 at 7:24 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Paul Menage wrote:
>> On Fri, Nov 28, 2008 at 2:02 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> Though for an inactive hierarchy, we have subsys->root == &rootnode,
>>> but rootnode's root_list is always empty.
>>
>> I think you mean "rootnode's subsys_list is always empty".
>>
>
> Yes, I mean subsys_list not root_list.
>
>>> The above code assumes rootnode.subsys_list links all inactive
>>> hierarchies.
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>> ---
>>>  kernel/cgroup.c |    5 +++--
>>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>>> index 33ba756..4e50e97 100644
>>> --- a/kernel/cgroup.c
>>> +++ b/kernel/cgroup.c
>>> @@ -716,7 +716,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>>>                        BUG_ON(dummytop->subsys[i]->cgroup != dummytop);
>>>                        cgrp->subsys[i] = dummytop->subsys[i];
>>>                        cgrp->subsys[i]->cgroup = cgrp;
>>> -                       list_add(&ss->sibling, &root->subsys_list);
>>> +                       list_move(&ss->sibling, &root->subsys_list);
>>>                        rcu_assign_pointer(ss->root, root);
>>>                        if (ss->bind)
>>>                                ss->bind(ss, cgrp);
>>> @@ -730,7 +730,7 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>>>                        dummytop->subsys[i]->cgroup = dummytop;
>>>                        cgrp->subsys[i] = NULL;
>>>                        rcu_assign_pointer(subsys[i]->root, &rootnode);
>>> -                       list_del(&ss->sibling);
>>> +                       list_move(&ss->sibling, &rootnode.subsys_list);
>>>                } else if (bit & final_bits) {
>>>                        /* Subsystem state should already exist */
>>>                        BUG_ON(!cgrp->subsys[i]);
>>> @@ -2522,6 +2522,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>>>        printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
>>>
>>>        /* Create the top cgroup state for this subsystem */
>>> +       list_add(&ss->sibling, &rootnode.root_list);
>>
>> This is wrong. cgroup_subsys.sibling is a member of the list of
>> subsystems attached to a given root, and rootnode.root_list is a
>> member of the list of hierarchies. Did you actually meant
>> &rootnode.subsys_list?
>>
>
> I thought I corrected all the s/root_list/subsys_list/ in patch v2. :(
>
> If this patch makes sense, I'll fix it, otherwise we'll going to ask Andrew to drop it from -mm.

Looking at the existing code, it's not actually broken - but only by accident.

We aim to add a link for each cgroup, which we do by finding the first
subsystem in each hierarchy and adding a link for its cgroup, and then
adding a link for dummytop if there weren't any subsystems in the
inactive hierarchy.

But since rootnode.subsys_list is always empty, we always skip the
inactive hierarchy in the main loop (if it has any subsystems), and
always add the inactive hierarchy afterwards. So everything works out
OK (all hierarchies do get linked), but it's horribly unreadable.

Having the subsys_list be correct for the inactive hierarchy is
probably a good thing, so this patch should go ahead (once the typos
is fixed).

Paul
