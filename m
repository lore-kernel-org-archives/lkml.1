Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbZLRABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbZLRABR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZLRABO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:01:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbZLRABN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:01:13 -0500
Message-ID: <4B2AC59D.2010004@ds.jp.nec.com>
Date: Thu, 17 Dec 2009 18:58:21 -0500
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, Alan.Brunelle@hp.com
Subject: Re: [RFC] CFQ group scheduling structure organization
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com> <4e5e476b0912170341h7ba632akddb921c996a36f73@mail.gmail.com>
In-Reply-To: <4e5e476b0912170341h7ba632akddb921c996a36f73@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Corrado Zoccolo wrote, on 12/17/2009 06:41 AM:
> Hi,
> On Wed, Dec 16, 2009 at 11:52 PM, Vivek Goyal<vgoyal@redhat.com>  wrote:
>> Hi All,
>>
>> With some basic group scheduling support in CFQ, there are few questions
>> regarding how group structure should look like in CFQ.
>>
>> Currently, grouping looks as follows. A, and B are two cgroups created by
>> user.
>>
>> [snip]
>>
>> Proposal 4:
>> ==========
>> Treat task and group at same level. Currently groups are at top level and
>> at second level are tasks. View the whole hierarchy as follows.
>>
>>
>>                         service-tree
>>                         /   |  \  \
>>                        T1   T2  G1 G2
>>
>> Here T1 and T2 are two tasks in root group and G1 and G2 are two cgroups
>> created under root.
>>
>> In this kind of scheme, any RT task in root group will still be system
>> wide RT even if we create groups G1 and G2.
>>
>> So what are the issues?
>>
>> - I talked to few folks and everybody found this scheme not so intutive.
>>   Their argument was that once I create a cgroup, say A,  under root, then
>>   bandwidth should be divided between "root" and "A" proportionate to
>>   the weight.
>>
>>   It is not very intutive that group is competing with all the tasks
>>   running in root group. And disk share of newly created group will change
>>   if more tasks fork in root group. So it is highly dynamic and not
>>   static hence un-intutive.

I agree it might be dynamic but I don't think it's un-intuitive.
I think it's reasonable that disk share of a group is
influenced by the number of tasks running in root group,
because the root group is shared by the tasks and groups from
the viewpoint of cgroup I/F, and they really share disk bandwidth.


>>   To emulate the behavior of previous proposals, root shall have to create
>>   a new group and move all root tasks there. But admin shall have to still
>>   keep RT tasks in root group so that they still remain system-wide.
>>
>>                         service-tree
>>                         /   |    \  \
>>                        T1  root  G1 G2
>>                             |
>>                             T2
>>
>>   Now admin has specifically created a group "root" along side G1 and G2
>>   and moved T2 under root. T1 is still left in top level group as it might
>>   be an RT task and we want it to remain RT task systemwide.
>>
>>   So to some people this scheme is un-intutive and requires more work in
>>   user space to achive desired behavior. I am kind of 50:50 between two
>>   kind of arrangements.
>>
> This is the one I prefer: it is the most natural one if you see that
> groups are scheduling entities like any other task.
> I think it becomes intuitive with an analogy with a qemu (e.g. kvm)
> virtual machine model. If you think a group like a virtual machine, it
> is clear that for the normal system, the whole virtual machine is a
> single scheduling entity, and that it has to compete with other
> virtual machines (as other single entities) and every process in the
> real system (those are inherently more important, since without the
> real system, the VMs cannot simply exist).
> Having a designated root group, instead, resembles the xen VM model,
> where you have a separated domain for each VM and for the real system.
>
> I think the implementation of this approach can make the code simpler
> and modular (CFQ could be abstracted to deal with scheduling entities,
> and each scheduling entity could be defined in a separate file).
> Within each group, you will now have the choice of how to schedule its
> queues. This means that you could possibly have different I/O
> schedulers within each group, and even have sub-groups within groups.

Corrado exactly says my preference.

I understand current implementation, like proposal 1, was
employed to make code simple and I believe it succeeded.
However, rather I feel it's un-intuitive because it's
inconsistent with cgroup I/F.  Behavior which is inconsistent
with the I/F can lead to misconfiguration of sys-admins.
This might be problematic, IMHO.



Thanks,
Muuhh

-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

