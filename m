Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZCCM6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZCCM6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 07:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZCCM6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 07:58:44 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:41303 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZCCM6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 07:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=npyC0qebWoXAJHOeIXE+3UGIl7CJ/Z56knjHjR/9ZG8J/ZC+W7TGDFV3CA7/VoKG8t
         vD3MLUSP0b5eNVUdiPD5q738vKkLg2Pl126lOesBu7G1ZToRCXPsLZEy1AWdnvXk56Wv
         f4DU8SY7c8J2lRXTpEPyUTcSTHCczT3r1hsLA=
MIME-Version: 1.0
In-Reply-To: <1234271177.23438.24.camel@twins>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
Date: Tue, 3 Mar 2009 12:58:40 +0000
Message-ID: <b6a2d2e20903030458o1c83a0f9ra52994e7a7f3be6c@mail.gmail.com>
Subject: Re: cgroup, RT reservation per core(s)?
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 1:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-02-09 at 20:04 +0000, Rolando Martins wrote:
>
>> I should have elaborated this more:
>>
>>                      root
>>                   ----|----
>>                   |          |
>> (0.5 mem) 0         1 (100% rt, 0.5 mem)
>>                          ---------
>>                          |    |    |
>>                          2   3   4  (33% rt for each group, 33% mem
>> per group(0.165))
>> Rol
>
>
> Right, i think this can be done.
>
> You would indeed need cpusets and sched-cgroups.
>
> Split the machine in 2 using cpusets.
>
>   ___R___
>  /       \
>  A         B
>
> Where R is the root cpuset, and A and B are the siblings.
> Assign A one half the cpus, and B the other half.
> Disable load-balancing on R.
>
> Then using sched cgroups create the hierarchy
>
>  ____1____
>  /    |    \
> 2     3     4
>
> Where 1 can be the root group if you like.
>
> Assign 1 a utilization limit of 100%, and 2,3 and 4 a utilization limit
> of 33% each.
>
> Then place the tasks that get 100% cputime on your 2 cpus in cpuset A
> and sched group 1.
>
> Place your other tasks in B,{2-4} respectively.
>
> The reason this works is that bandwidth distribution is sched domain
> wide, and by disabling load-balancing on R, you split the schedule
> domain.
>
> I've never actually tried anything like this, let me know if it
> works ;-)
>

Just to confirm, cpuset.sched_load_balance doesn't work with RT, right?
You cannot have tasks for sub-domain 2 to utilize bandwidth of
sub-domain 3, right?

                               __1__
                              /        \
                             2         3
                       (50% rt)  (50% rt )

For my application domain;) it would be interesting to have
rt_runtime_ns as a min. of allocated rt and not a max.
Ex. If an application of domain 2 needs to go up to 100% and domain 3
is idle, then it would be cool to let it utilize the full bandwidth.
(we also could have a hard upper limit in each sub-domain, like
hard_up=0.8, i.e. even if we could get 100%, we will only utilize
80%).

Does this make sense?
