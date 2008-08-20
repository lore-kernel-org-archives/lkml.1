Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYHTI1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYHTI1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYHTI0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:26:55 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37243 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYHTI0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:26:52 -0400
Message-ID: <48ABD545.8010209@linux.vnet.ibm.com>
Date: Wed, 20 Aug 2008 13:56:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrea Righi <righi.andrea@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [discuss] memrlimit - potential applications that can use
References: <48AA73B5.7010302@linux.vnet.ibm.com> <1219161525.23641.125.camel@nimitz>  <48AAF8C0.1010806@linux.vnet.ibm.com> <1219167669.23641.156.camel@nimitz>
In-Reply-To: <1219167669.23641.156.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2008-08-19 at 22:15 +0530, Balbir Singh wrote:
>> Dave Hansen wrote:
>>> On Tue, 2008-08-19 at 12:48 +0530, Balbir Singh wrote:
>>>> 1. To provide a soft landing mechanism for applications that exceed their memory
>>>> limit. Currently in the memory resource controller, we swap and on failure OOM.
>>>> 2. To provide a mechanism similar to memory overcommit for control groups.
>>>> Overcommit has finer accounting, we just account for virtual address space usage.
>>>> 3. Vserver will directly be able to port over on top of memrlimit (their address
>>>> space limitation feature)
>>> Balbir,
>>>
>>> This all seems like a little bit too much hand waving to me.  I don't
>> Dave, there is no hand waving, just an honest discussion. Although, you may not
>> see it in the background, we still need overcommit protection and we have it
>> enabled by default for the system. There are applications that can deal with the
>> constraints setup by the administrator and constraints of the environment,
>> please see http://en.wikipedia.org/wiki/Autonomic_computing.
> 
> OK, let's get back to describing the basic problem here.  What is the
> basic problem being solved?  Applications basically want to get a
> failure back from malloc() when the machine is (nearly?) out of memory
> so they can stop consuming?
> 
> Is this the only way to do autonomic computing with memory?  Or, are
> there other or better approaches?
> 

I guess the application needs to know how much of the resources it can consume.

> Surely an autonomic computing app could keep track of its own memory
> footprint.  

Yes, an application does know it's memory footprint, but does it know how it is
supposed to consume resources in the system. Consider a linear algebra package
trying to do a multiplication of 1 million x 1 million rows. Depending on how
much resources it is allowed to consume, it could do so in one shot or if there
was a restriction, it could multiply smaller matrices and then collate results.
The application wants to stretch itself (memory footprint) for performance, but
at the same time does not want to get killed because

1. Other applications came in and caused an OOM
2. It stretched itself too much beyond what the system can support

> 
>>> really see a single concrete user in the "potential applications" here.
>>> I really don't understand why you're pushing this so hard if you don't
>>> have anyone to actually use it.
>>>
>>> I just don't see anyone that *needs* it.  There's a lot of "it would be
>>> nice", but no "needs".
>> If you see the original email, I've sent - I've mentioned that we need
>> overcommit support (either via memrlimit or by porting over the overcommit
>> feature) and the exploiters you are looking for is the same as the ones who need
>> overcommit and RLIMIT_AS support.
>>
>> On the memory overcommit front, please see PostgreSQL Server Administrator's
>> Guide at
>> http://www.network-theory.co.uk/docs/postgresql/vol3/LinuxMemoryOvercommit.html
>>
>> The guide discusses turning off memory overcommit so that the database is never
>> OOM killed, how do we provide these guarantees for a particular control group?
>> We can do it system wide, but ideally we want the control point to be per
>> control group.
> 
> Heh.  That suggestion is, at best, working around a kernel bug.  The DB
> guys are just saying to do that because they're the biggest memory users
> and always seem to get OOM killed first.
> 
> The base problem here is the OOM killer, not an application that truly
> uses memory overcommit restriction in an interesting way.
> 

No it is not a kernel BUG, agreed that the database is using a lot of memory,
but how can it predict what else will run on the system. Why is it bad for a
database for the sake of data integrity to ensure that it does not get OOM
killed and thus make sure memory is never overcommitted. Yes, you need
performance, so the application expands it's footprint, but at the same time,
the stretching should not cause it to be killed. How would you propose to solve
the problem without overcommit control?

>> As far as other users are concerned, I've listed users of the memory limit
>> feature, in the original email I sent out. To try and understand your viewpoint
>> better, could you please tell me if
>>
>> 1. You are opposed to overcommit and RLIMIT_AS as features
>>
>> OR
>>
>> 2. Expanding them to control groups
> 
> I think that too many of the users of (1) probably fall into the
> PostgreSQL category.  They found that turning it on "fixed" their bugs,
> but it really just swept them under the rug.
> 

Please see my comment on this in the paragraph above

> So, before we expand the use of those features to control groups by
> adding a bunch of new code, let's make sure that there will be users for
> it and that those users have no better way of doing it.

I am all ears to better ways of doing it. Are you suggesting that overcommit was
added even though we don't actually need it?

-- 
	Balbir
