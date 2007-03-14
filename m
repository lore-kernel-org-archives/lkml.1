Return-Path: <linux-kernel-owner+w=401wt.eu-S933889AbXCNIh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889AbXCNIh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 04:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933884AbXCNIh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 04:37:27 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:34814 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933889AbXCNIhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 04:37:25 -0400
Message-ID: <45F7A8D3.3010109@in.ibm.com>
Date: Wed, 14 Mar 2007 13:18:35 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Dave Hansen <hansendc@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 4/7] RSS accounting hooks over the code
References: <45ED7DEC.7010403@sw.ru> <45ED81F2.80402@sw.ru>	<m14porwq1c.fsf@ebiederm.dsl.xmission.com> <45F57E7D.6080604@sw.ru>	<1173718208.11945.54.camel@localhost.localdomain>	<20070312235452.GB11578@MAIL.13thfloor.at>	<m1veh5sbwy.fsf@ebiederm.dsl.xmission.com>	<45F67C2D.7020303@yahoo.com.au> <m1odmxrv2l.fsf@ebiederm.dsl.xmission.com> <45F77149.7040604@yahoo.com.au> <45F7993E.2010200@in.ibm.com> <45F79CF3.1090302@yahoo.com.au>
In-Reply-To: <45F79CF3.1090302@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Balbir Singh wrote:
>> Nick Piggin wrote:
> 
>>> And strangely, this example does not go outside the parameters of
>>> what you asked for AFAIKS. In the worst case of one container getting
>>> _all_ the shared pages, they will still remain inside their maximum
>>> rss limit.
>>>
>>
>> When that does happen and if a container hits it limit, with a LRU
>> per-container, if the container is not actually using those pages,
>> they'll get thrown out of that container and get mapped into the
>> container that is using those pages most frequently.
> 
> Exactly. Statistically, first touch will work OK. It may mean some
> reclaim inefficiencies in corner cases, but things will tend to
> even out.
> 

Exactly!

>>> So they might get penalised a bit on reclaim, but maximum rss limits
>>> will work fine, and you can (almost) guarantee X amount of memory for
>>> a given container, and it will _work_.
>>>
>>> But I also take back my comments about this being the only design I
>>> have seen that gets everything, because the node-per-container idea
>>> is a really good one on the surface. And it could mean even less impact
>>> on the core VM than this patch. That is also a first-touch scheme.
>>>
>>
>> With the proposed node-per-container, we will need to make massive core
>> VM changes to reorganize zones and nodes. We would want to allow
>>
>> 1. For sharing of nodes
>> 2. Resizing nodes
>> 3. May be more
> 
> But a lot of that is happening anyway for other reasons (eg. memory
> plug/unplug). And I don't consider node/zone setup to be part of the
> "core VM" as such... it is _good_ if we can move extra work into setup
> rather than have it in the mm.
> 
> That said, I don't think this patch is terribly intrusive either.
> 

Thanks, thats one of our goals, to keep it simple, understandable and
non-intrusive.

> 
>> With the node-per-container idea, it will hard to control page cache
>> limits, independent of RSS limits or mlock limits.
>>
>> NOTE: page cache == unmapped page cache here.
> 
> I don't know that it would be particularly harder than any other
> first-touch scheme. If one container ends up being charged with too
> much pagecache, eventually they'll reclaim a bit of it and the pages
> will get charged to more frequent users.
> 
> 

Yes, true, but what if a user does not want to control the page
cache usage in a particular container or wants to turn off
RSS control.

>>>> However the messed up accounting that doesn't handle sharing between
>>>> groups of processes properly really bugs me.  Especially when we have
>>>> the infrastructure to do it right.
>>>>
>>>> Does that make more sense?
>>>
>>>
>>> I think it is simplistic.
>>>
>>> Sure you could probably use some of the rmap stuff to account shared
>>> mapped _user_ pages once for each container that touches them. And
>>> this patchset isn't preventing that.
>>>
>>> But how do you account kernel allocations? How do you account unmapped
>>> pagecache?
>>>
>>> What's the big deal so many accounting people have with just RSS? I'm
>>> not a container person, this is an honest question. Because from my
>>> POV if you conveniently ignore everything else... you may as well just
>>> not do any accounting at all.
>>>
>>
>> We decided to implement accounting and control in phases
>>
>> 1. RSS control
>> 2. unmapped page cache control
>> 3. mlock control
>> 4. Kernel accounting and limits
>>
>> This has several advantages
>>
>> 1. The limits can be individually set and controlled.
>> 2. The code is broken down into simpler chunks for review and merging.
> 
> But this patch gives the groundwork to handle 1-4, and it is in a small
> chunk, and one would be able to apply different limits to different types
> of pages with it. Just using rmap to handle 1 does not really seem like a
> viable alternative because it fundamentally isn't going to handle 2 or 4.
> 

For (2), we have the basic setup in the form of a per-container LRU list
and a pointer from struct page to the container that first brought in
the page.

> I'm not saying that you couldn't _later_ add something that uses rmap or
> our current RSS accounting to tweak container-RSS semantics. But isn't it
> sensible to lay the groundwork first? Get a clear path to something that
> is good (not perfect), but *works*?
> 

I agree with your development model suggestion. One of things we are going 
to do in the near future is to build (2) and then add (3) and (4). So far,
we've not encountered any difficulties on building on top of (1).

Vaidy, any comments?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
