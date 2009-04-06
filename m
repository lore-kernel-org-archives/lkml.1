Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZDFGuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZDFGuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 02:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZDFGuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 02:50:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbZDFGuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 02:50:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=P2PmhCsUu1szZ0XHnfHJB7p8vKB7ugFf5kMmict4tkCrR3Tz/uRR/ZHlOGMOwvSbX
	gl76Qj82HPDrjwAFAJB7A==
MIME-Version: 1.0
In-Reply-To: <49D8CB17.7040501@gmail.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
	 <20090312001146.74591b9d.akpm@linux-foundation.org>
	 <20090312180126.GI10919@redhat.com> <49D8CB17.7040501@gmail.com>
Date: Sun, 5 Apr 2009 23:50:31 -0700
Message-ID: <e98e18940904052350wc44fdffl480d613c661d5fe6@mail.gmail.com>
Subject: Re: [PATCH 01/10] Documentation
From: Nauman Rafique <nauman@google.com>
To: righi.andrea@gmail.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, menage@google.com,
       peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 5, 2009 at 8:15 AM, Andrea Righi <righi.andrea@gmail.com> wrote:
> On 2009-03-12 19:01, Vivek Goyal wrote:
>> On Thu, Mar 12, 2009 at 12:11:46AM -0700, Andrew Morton wrote:
>>> On Wed, 11 Mar 2009 21:56:46 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
> [snip]
>>> Also..  there are so many IO controller implementations that I've lost
>>> track of who is doing what.  I do have one private report here that
>>> Andreas's controller "is incredibly productive for us and has allowed
>>> us to put twice as many users per server with faster times for all
>>> users".  Which is pretty stunning, although it should be viewed as a
>>> condemnation of the current code, I'm afraid.
>>>
>>
>> I had looked briefly at Andrea's implementation in the past. I will look
>> again. I had thought that this approach did not get much traction.
>
> Hi Vivek, sorry for my late reply. I periodically upload the latest
> versions of io-throttle here if you're still interested:
> http://download.systemimager.org/~arighi/linux/patches/io-throttle/
>
> There's no consistent changes respect to the latest version I posted to
> the LKML, just rebasing to the recent kernels.
>
>>
>> Some quick thoughts about this approach though.
>>
>> - It is not a proportional weight controller. It is more of limiting
>>   bandwidth in absolute numbers for each cgroup on each disk.
>>
>>   So each cgroup will define a rule for each disk in the system mentioning
>>   at what maximum rate that cgroup can issue IO to that disk and throttle
>>   the IO from that cgroup if rate has excedded.
>
> Correct. Add also the proportional weight control has been in the TODO
> list since the early versions, but I never dedicated too much effort to
> implement this feature, I can focus on this and try to write something
> if we all think it is worth to be done.
>
>>
>>   Above requirement can create configuration problems.
>>
>>       - If there are large number of disks in system, per cgroup one shall
>>         have to create rules for each disk. Until and unless admin knows
>>         what applications are in which cgroup and strictly what disk
>>         these applications do IO to and create rules for only those
>>         disks.
>
> I don't think this is a huge problem anyway. IMHO a userspace tool, e.g.
> a script, would be able to efficiently create/modify rules parsing user
> defined rules in some human-readable form (config files, etc.), even in
> presence of hundreds of disk. The same is valid for dm-ioband I think.
>
>>
>>       - I think problem gets compounded if there is a hierarchy of
>>         logical devices. I think in that case one shall have to create
>>         rules for logical devices and not actual physical devices.
>
> With logical devices you mean device-mapper devices (i.e. LVM, software
> RAID, etc.)? or do you mean that we need to introduce the concept of
> "logical device" to easily (quickly) configure IO requirements and then
> map those logical devices to the actual physical devices? In this case I
> think this can be addressed in userspace. Or maybe I'm totally missing
> the point here.
>
>>
>> - Because it is not proportional weight distribution, if some
>>   cgroup is not using its planned BW, other group sharing the
>>   disk can not make use of spare BW.
>>
>
> Right.
>
>> - I think one should know in advance the throughput rate of underlying media
>>   and also know competing applications so that one can statically define
>>   the BW assigned to each cgroup on each disk.
>>
>>   This will be difficult. Effective BW extracted out of a rotational media
>>   is dependent on the seek pattern so one shall have to either try to make
>>   some conservative estimates and try to divide BW (we will not utilize disk
>>   fully) or take some peak numbers and divide BW (cgroup might not get the
>>   maximum rate configured).
>
> Correct. I think the proportional weight approach is the only solution
> to efficiently use the whole BW. OTOH absolute limiting rules offer a
> better control over QoS, because you can totally remove performance
> bursts/peaks that could break QoS requirements for short periods of
> time. So, my "ideal" IO controller should allow to define both rules:
> absolute and proportional limits.

I completely agree with Andrea here. The final solution has to have
both absolute limits and proportions. But instead of adding a token
based approach on top of proportional based system, I have been
thinking about modifying the proportional approach to support absolute
limits. This might not work, but I think this is an interesting idea
to think about.

Here are my thoughts on it so far. We start with the patches that
Vivek has sent, and change the notion of weights to percent. That is,
the user space specifies percents of disk times instead of weights. We
do not put entities in idle tree; whenever an entity is not
backlogged, we still keep them in the active trees, and allocate them
time slices. But since they have not requests in them, no requests
will get dispatched during the time slices allocated to these
entities. Moreover, if the percents of all entities do not add upto
hundred, we introduce a dummy entity at each level to soak up the rest
of "percent". This dummy entity would get time slices just like any
other entity, but will not dispatch any requests. With these
modification, we can limit entities to their allocated percent of disk
time.

We might want a situation in which we want to allow certain entities
to exceed their "percent" of disk time, while others should be
limited. In this case, we can extend the above mentioned approach by
introducing a secondary active tree. All entities which are allowed to
exceed their "percent" can be queued in the secondary tree, besides
the primary tree. Whenever an idle (or dummy) entity gets a time
slice, instead of idling the disk, an entity can be picked from the
secondary tree.

The advantage of an approach like this is that it will be relatively
smaller modification of the proposed proportional approach. Moreover,
entities will be throttled by getting time slices less frequently,
instead of being allowed to send a burst and then getting starved
(like in ticket based approach). The downside is that this approach
sounds unconventional and probably have not been tried in other
domains either. Thoughts? opinions?

I will create patches based on the above idea in a few weeks.

>
> I still have to look closely at your patchset anyway. I will do and give
> a feedback.
>
> -Andrea
>
