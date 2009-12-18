Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbZLRQD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbZLRQD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZLRQDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:03:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZLRQDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:03:54 -0500
Date: Fri, 18 Dec 2009 11:01:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, Alan.Brunelle@hp.com
Subject: Re: [RFC] CFQ group scheduling structure organization
Message-ID: <20091218160140.GE3123@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com> <4e5e476b0912170341h7ba632akddb921c996a36f73@mail.gmail.com> <4B2AC59D.2010004@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2AC59D.2010004@ds.jp.nec.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 06:58:21PM -0500, Munehiro Ikeda wrote:
> Hello,
>
> Corrado Zoccolo wrote, on 12/17/2009 06:41 AM:
>> Hi,
>> On Wed, Dec 16, 2009 at 11:52 PM, Vivek Goyal<vgoyal@redhat.com>  wrote:
>>> Hi All,
>>>
>>> With some basic group scheduling support in CFQ, there are few questions
>>> regarding how group structure should look like in CFQ.
>>>
>>> Currently, grouping looks as follows. A, and B are two cgroups created by
>>> user.
>>>
>>> [snip]
>>>
>>> Proposal 4:
>>> ==========
>>> Treat task and group at same level. Currently groups are at top level and
>>> at second level are tasks. View the whole hierarchy as follows.
>>>
>>>
>>>                         service-tree
>>>                         /   |  \  \
>>>                        T1   T2  G1 G2
>>>
>>> Here T1 and T2 are two tasks in root group and G1 and G2 are two cgroups
>>> created under root.
>>>
>>> In this kind of scheme, any RT task in root group will still be system
>>> wide RT even if we create groups G1 and G2.
>>>
>>> So what are the issues?
>>>
>>> - I talked to few folks and everybody found this scheme not so intutive.
>>>   Their argument was that once I create a cgroup, say A,  under root, then
>>>   bandwidth should be divided between "root" and "A" proportionate to
>>>   the weight.
>>>
>>>   It is not very intutive that group is competing with all the tasks
>>>   running in root group. And disk share of newly created group will change
>>>   if more tasks fork in root group. So it is highly dynamic and not
>>>   static hence un-intutive.
>
> I agree it might be dynamic but I don't think it's un-intuitive.
> I think it's reasonable that disk share of a group is
> influenced by the number of tasks running in root group,
> because the root group is shared by the tasks and groups from
> the viewpoint of cgroup I/F, and they really share disk bandwidth.
>

That's true that it becomes more natural to view it that way. That's a
different thing that it might become little more work in user space to
then move root tasks into a sub group otherwise, the effective share of
a newly created group might be really less. All the tasks in a group are
effectively a single task when it comes to top level.

>
>>>   To emulate the behavior of previous proposals, root shall have to create
>>>   a new group and move all root tasks there. But admin shall have to still
>>>   keep RT tasks in root group so that they still remain system-wide.
>>>
>>>                         service-tree
>>>                         /   |    \  \
>>>                        T1  root  G1 G2
>>>                             |
>>>                             T2
>>>
>>>   Now admin has specifically created a group "root" along side G1 and G2
>>>   and moved T2 under root. T1 is still left in top level group as it might
>>>   be an RT task and we want it to remain RT task systemwide.
>>>
>>>   So to some people this scheme is un-intutive and requires more work in
>>>   user space to achive desired behavior. I am kind of 50:50 between two
>>>   kind of arrangements.
>>>
>> This is the one I prefer: it is the most natural one if you see that
>> groups are scheduling entities like any other task.
>> I think it becomes intuitive with an analogy with a qemu (e.g. kvm)
>> virtual machine model. If you think a group like a virtual machine, it
>> is clear that for the normal system, the whole virtual machine is a
>> single scheduling entity, and that it has to compete with other
>> virtual machines (as other single entities) and every process in the
>> real system (those are inherently more important, since without the
>> real system, the VMs cannot simply exist).
>> Having a designated root group, instead, resembles the xen VM model,
>> where you have a separated domain for each VM and for the real system.
>>
>> I think the implementation of this approach can make the code simpler
>> and modular (CFQ could be abstracted to deal with scheduling entities,
>> and each scheduling entity could be defined in a separate file).
>> Within each group, you will now have the choice of how to schedule its
>> queues. This means that you could possibly have different I/O
>> schedulers within each group, and even have sub-groups within groups.
>
> Corrado exactly says my preference.
>
> I understand current implementation, like proposal 1, was
> employed to make code simple and I believe it succeeded.
> However, rather I feel it's un-intuitive because it's
> inconsistent with cgroup I/F.  Behavior which is inconsistent
> with the I/F can lead to misconfiguration of sys-admins.
> This might be problematic, IMHO.

Thanks Muuhh. It helps to get perspective from various folks before I
start implementing it.

Thanks
Vivek
