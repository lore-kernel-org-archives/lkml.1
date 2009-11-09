Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbZKIRdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbZKIRdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZKIRdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:33:52 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZKIRdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:33:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oNRxG8v1+KTJV5t7leDg0kUpsBxWZFgaKWjrAOsw9r+Pt0YHvMnRa7WuWU1jVp8W+
	BOdcG3r8pIPvBNOQsrlRQ==
MIME-Version: 1.0
In-Reply-To: <20091106222257.GB2969@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	 <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
	 <20091106222257.GB2969@redhat.com>
Date: Mon, 9 Nov 2009 09:33:47 -0800
Message-ID: <e98e18940911090933l33544686j64358573bb659592@mail.gmail.com>
Subject: Re: [RFC] Workload type Vs Groups (Was: Re: [PATCH 02/20] blkio: 
	Change CFQ to use CFS like queue time stamps)
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 2:22 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 04, 2009 at 10:18:15PM +0100, Corrado Zoccolo wrote:
>> Hi Vivek,
>> On Wed, Nov 4, 2009 at 12:43 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > o Previously CFQ had one service tree where queues of all theree prio classes
>> >  were being queued. One side affect of this time stamping approach is that
>> >  now single tree approach might not work and we need to keep separate service
>> >  trees for three prio classes.
>> >
>> Single service tree is no longer true in cfq for-2.6.33.
>> Now we have a matrix of service trees, with first dimension being the
>> priority class, and second dimension being the workload type
>> (synchronous idle, synchronous no-idle, async).
>> You can have a look at the series: http://lkml.org/lkml/2009/10/26/482 .
>> It may have other interesting influences on your work, as the idle
>> introduced at the end of the synchronous no-idle tree, that provides
>> fairness also for seeky or high-think-time queues.
>>
>
> Hi All,
>
> I am now rebasing my patches to for-2.6.33 branch. There are significant
> number of changes in that branch, especially changes from corrado bring
> in an interesting question.
>
> Currently corrado has introduced the functinality of kind of grouping the
> cfq queues based on workload type and gives the time slots to these sub
> groups (sync-idle, sync-noidle, async).
>
> I was thinking of placing groups on top of this model, so that we select
> the group first and then select the type of workload and then finally
> the queue to run.
>
> Corrodo came up with an interesting suggestion (in a private mail), that
> what if we implement workload type at top and divide the share among
> groups with-in workoad type.
>
> So one would first select the workload to run and then select group
> with-in workload and then cfq queue with-in group.
>
> The advantage of this approach are.
>
> - for sync-noidle group, we will not idle per group. We will idle only
>  only at root level. (Well if we don't idle on the group once it becomes
>  empty, we will not see fairness for group. So it will be fairness vs
>  throughput call).
>
> - It allows us to limit system wide share of workload type. So for
>  example, one can kind of fix system wide share of async queues.
>  Generally it might not be very prudent to allocate a group 50% of
>  disk share and then that group decides to just do async IO and sync
>  IO in rest of the groups suffer.
>
> Disadvantage
>
> - The definition of fairness becomes bit murkier. Now fairness will be
>  achieved for a group with-in the workload type. So if a group is doing
>  IO of type sync-idle as well as sync-noidle and other group is doing
>  IO of type only sync-noidle, then first group will get overall more
>  disk time even if both the groups have same weight.
>
> Looking for some feedback about which appraoch makes more sense before I
> write patches.

On the first look, the first option did make some sense. But isn't the
whole point of adding cgroups is to support fairness, or isolation? If
we are adding cgroups support in a way that does not support
isolation, there is not much point to the whole effort.

The first approach seems to be directed towards keeping good overall
throughput. Fairness and isolation might always come with a
possibility of the loss in overall throughput. The assumption is that
once someone is using cgroup, the overall system efficiency is a
concern which is secondary to the performance we are supporting for
each cgroup.

Also, the second approach is cleaner design. For each cgroup, we will
need one data structure, instead of having 3, one for each workload
type. And all the new functionality should still live under a config
option; so if someone does not want cgroups, they are just turn them
off and we will be back to just one set of threads for each workload
type.

>
> Thanks
> Vivek
>
