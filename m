Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbYCGQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbYCGQlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYCGQlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:41:07 -0500
Received: from sacred.ru ([62.205.161.221]:46823 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYCGQlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:41:05 -0500
Message-ID: <47D16F9B.6050008@openvz.org>
Date: Fri, 07 Mar 2008 19:38:51 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com, serue@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
References: <47CED717.60406@openvz.org> <47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com>
In-Reply-To: <20080307155921.GB28439@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 07 Mar 2008 19:38:49 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Mar 07, 2008 at 12:52:40PM +0300, Pavel Emelyanov wrote:
>> Andrew Morton wrote:
>>> On Fri, 07 Mar 2008 12:22:01 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
>>>
>>>>> This doesn't include sufficient headers to be compileable.
>>>>>
>>>>> I'm sure there are lots of headers like this.  But we regularly need
>>>>> to fix them.
>>>>>
>>>> Not sure, whether this is still relevant after Greg's comments, but that's
>>>> the -fix patch for this one. (It will cause a conflict with the 9th patch.)
>>> Well.  Where do we stand with this?  afaict the state of play is:
>>>
>>> Greg: do it in udev
>>> Pavel: but people want to run old distros in containers
>> Actually no.
>>
>> Greg: Use LSM for this
> 
> Yes, that is my recommendation.
> 
>> Pavel: My approach just makes maps per-group, while LSM will
>>        bring a new level of filtering/lookup on device open path
> 
> Huh?  You are still doing that same "filtering/lookup" by modifying the
> maps code.  The result should be exactly the same.

No - this lookup was there before to get struct kobject from the dev_t, 
I just make it look up in another map.

> Why do you not want to use the LSM interface?  That is exactly what it
> is there for, don't go creating new hooks into the kernel for the exact
> same functionality.

_No_new_hooks_ - just the map is get from task, not from a static variable.

I have basically three objections against LSM.

1. LSM is not stackable, so loading this tiny module with devices
   access rights will block other security modules;

2. Turning CONFIG_SECURITY on immediately causes all the other hooks
   to get called. This affects performance on critical paths, like
   process creation/destruction, network flow and so on. This impact
   is small, but noticeable;

3. With LSM turned on we'll have to "virtualize" it, i.e. make its
   work safe in a container. I don't presume to judge how much work
   will have to be done in this area, so the result patch would be
   even larger and maybe will duplicate functionality, which is currently
   in cgroups. OTOH, cgroups already provide the ways to correctly 
   delegate proper rights to containers.

> Opening a dev node is not on any "fast path" that you need to be
> concerned about a few extra calls within the kernel.
> 
> And, I think in the end your patch would be much smaller and easier to
> understand and review and maintain overall.

Hardly - the largest part of my patch is cgroup manipulations. The part
that makes the char and block layers switch to new map ac check the 
permissions is 10-20 lines of new code.

But with LSM I will still need this API.

>>> Realistically, when is the mainline kernel likely to have sufficient
>>> container functionality which is sufficiently well-tested for people to
>>> actually be able to do that?  And how much longer will it take for that
>>> kernel.org functionality to propagate out into non-bleeding-edge distros?
>> The fact is that we have users of OpenVZ and even Virtuozzo, that still use 
>> redhat-9 as in containers. So even if this is ready in 5 years, there will 
>> always be someone who sets the outdated (by that time) fedora-core-8 and find
>> out, that his udev refuses to work.
> 
> That's fine, use the LSM interface, no need to change userspace at all.
> 
> Although I think your requirement of using new kernels on very old
> distros is going to cause you more problems than you realize in the
> end...
> 
> thanks,
> 
> greg k-h
> 

