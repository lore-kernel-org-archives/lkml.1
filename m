Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYCKKTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYCKKTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYCKKSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:18:53 -0400
Received: from sacred.ru ([62.205.161.221]:46634 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbYCKKSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:18:52 -0400
Message-ID: <47D657A3.5080801@openvz.org>
Date: Tue, 11 Mar 2008 12:57:55 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com, serue@us.ibm.com,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
References: <47CED717.60406@openvz.org> <47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com>
In-Reply-To: <20080307170104.GA24746@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 11 Mar 2008 12:57:56 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

>> I have basically three objections against LSM.
>>
>> 1. LSM is not stackable, so loading this tiny module with devices
>>    access rights will block other security modules;
> 
> Do you really want to run other LSMs within a containerd kernel?  Is
> that a requirement?  It would seem to run counter to the main goal of
> containers to me.

_I_ do not want to run LSM with containers, but this was a requirement
from some people when we decided which approach to chose - LSM of mine.

Nevertheless, this is not very important, indeed.

>> 2. Turning CONFIG_SECURITY on immediately causes all the other hooks
>>    to get called. This affects performance on critical paths, like
>>    process creation/destruction, network flow and so on. This impact
>>    is small, but noticeable;
> 
> The last time this was brought up, it was not noticable, except for some
> network paths.  And even then, the number was lost in the noise from
> what I saw.  I think with a containered machine, you have bigger things
> to be worried about :)

The namespace-based virtualization implies no performance overhead for 
a container, actually. This is not xen or vmware where performance 
loss is OK.

Besides, I've measured some things - the lat_syscall test for open from 
lmbench test suite and the nptl perf test. Here are the results:

        sec     nosec
open    3.0980s  3.0709s
nptl    2.7746s  2.7710s

So we have 0.88% loss in open and ~0.15% with nptl. I know, this is not that
much, but it is noticeable. Besides, this is only two tests, digging deeper
may reveal more.

Let alone the fact that simply turning the CONFIG_SECURITY to 'y' puts +8Kb 
to the vmlinux...

I think, I finally agree with you and Al Viro, that the kobj mapper is 
not the right place to put the filtering, but taking the above numbers 
into account, can we put the "hooks" into the #else /* CONFIG_SECURITY */
versions of security_inode_permission/security_file_permission/etc?

>> 3. With LSM turned on we'll have to "virtualize" it, i.e. make its
>>    work safe in a container. I don't presume to judge how much work
>>    will have to be done in this area, so the result patch would be
>>    even larger and maybe will duplicate functionality, which is currently
>>    in cgroups. OTOH, cgroups already provide the ways to correctly 
>>    delegate proper rights to containers.
> 
> No, your lsm would be your "virtualize" policy.  I don't think you would
> have to do any additional work here, but could be wrong.  Would like to
> see the code to prove it.
> 
>>> Opening a dev node is not on any "fast path" that you need to be
>>> concerned about a few extra calls within the kernel.
>>>
>>> And, I think in the end your patch would be much smaller and easier to
>>> understand and review and maintain overall.
>> Hardly - the largest part of my patch is cgroup manipulations. The part
>> that makes the char and block layers switch to new map ac check the 
>> permissions is 10-20 lines of new code.
>>
>> But with LSM I will still need this API.
> 
> Yes, but your LSM hooks will be smaller than the code modifications to
> the map logic :)
> 
> Again, I object to this as you are driving a new security policy
> infrastructure into the device node logic where it does not belong as we
> already have this functionality in the LSM interface today.  Please use
> that one instead and don't clutter up the kernel with "one-off" security
> changes like this one.
> 
> Please try the LSM interface and see what happens.  If, after you have
> created a patch, you still have objections, please post it for review
> and I will be glad to revisit my opinion at that time.
> 
> thanks,
> 
> greg k-h
> 

