Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZFEFST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZFEFST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZFEFSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:18:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53570 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZFEFSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:18:03 -0400
Message-ID: <4A28AA25.4050206@redhat.com>
Date: Fri, 05 Jun 2009 08:16:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com>
In-Reply-To: <20090605044946.GA11755@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

    

>>> How, it works out fine in my calculation
>>>
>>> 50 + 40 for G2 and G3, make sure that G1 gets 10%, since others are
>>> limited to 90%
>>> 50 + 40 for G1 and G3, make sure that G2 gets 10%, since others are
>>> limited to 90%
>>> 50 + 50 for G1 and G2, make sure that G3 gets 0%, since others are
>>> limited to 100%
>>>   
>>>       
>> It's fine in that it satisfies the guarantees, but it is deeply  
>> suboptimal.  If I ran a cpu hog in the first group, while the other two  
>> were idle, it would be limited to 50% cpu.  On the other hand, if it  
>> consumed all 100% cpu it would still satisfy the guarantees (as the  
>> other groups are idle).
>>
>> The result is that in such a situation, wall clock time would double  
>> even though cpu resources are available.
>>     
>
> But then there is no other way to make a *guarantee*, guarantees come
> at a cost of idling resources, no? Can you show me any other
> combination that will provide the guarantee and without idling the
> system for the specified guarantees?
>   

Suppose in my example cgroup 1 consumed 100% of the cpu resources and 
cgroup 2 and 3 were completely idle.  All of the guarantees are met (if 
cgroup 2 is idle, there's no need to give it the 10% cpu time it is 
guaranteed).

If  your only tool to achieve the guarantees is a limit system, then 
yes, the equation yields the correct results.  But given that it yields 
such inferior results, I think we need to look for a more involved solution.

I think the limits method fits cases where it is difficult to evict a 
resource (say, disk quotas -- if you want to guarantee 10% of space to 
cgroups 1, you must limit all others to 90%).  But for processor usage, 
you can evict a cgroup instantly, so nothing prevents a cgroup from 
consuming all available resources as long as others do not contend for them.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

