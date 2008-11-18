Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYKRWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYKRWdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKRWdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:33:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:32602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYKRWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:33:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=x4cS8GKrIWaNUBb26K+jiR0jXmJcPClP5O/iEYK06kBHL84wSXex2B/H9yVSZjeX9
	FltRpg0fv/7XRig0a4aUA==
MIME-Version: 1.0
In-Reply-To: <20081118120508.GD15268@gandalf.sssup.it>
References: <20081113.180558.519459540419535699.ryov@valinux.co.jp>
	 <af41c7c40811131041t1b8491b6la5574ebe75f89000@mail.gmail.com>
	 <20081113214642.GG7542@redhat.com>
	 <af41c7c40811131457w472e4a86tb5344cc1d3d366fb@mail.gmail.com>
	 <20081114160525.GE24624@redhat.com>
	 <e98e18940811141444u5947b806v27fac453ed1e8a5@mail.gmail.com>
	 <20081117142309.GA15564@redhat.com> <4922224A.5030502@cn.fujitsu.com>
	 <e98e18940811172101na345b6bh5c73f9e657aac5a7@mail.gmail.com>
	 <20081118120508.GD15268@gandalf.sssup.it>
Date: Tue, 18 Nov 2008 14:33:19 -0800
Message-ID: <e98e18940811181433o4bb5a147i1e0b9c1baf495ae2@mail.gmail.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Nauman Rafique <nauman@google.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
       Divyesh Shah <dpshah@google.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       paolo.valente@unimore.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 4:05 AM, Fabio Checconi <fchecconi@gmail.com> wrote:
> Hi,
>
>> From: Nauman Rafique <nauman@google.com>
>> Date: Mon, Nov 17, 2008 09:01:48PM -0800
>>
>> If we start with bfq patches, this is how plan would look like:
>>
>> 1 Start with BFQ take 2.
>> 2 Do the following to support proportional division:
>>  a) Expose the per device weight interface to user, instead of calculating
>>  from priority.
>>  b) Add support for disk time budgets, besides sector budget that is currently
>>  available (configurable option). (Fabio: Do you think we can just emulate
>> that using the existing code?). Another approach would be to give time slices
>> just like CFQ (discussing?)
>
>  it should be possible without altering the code.  The slices can be
> assigned in the time domain using big values for max_budget.  The logic
> is: each process is assigned a budget (in the range [max_budget/2, max_budget],
> choosen from the feedback mechanism, driven in __bfq_bfqq_recalc_budget()),
> and if it does not complete it in timeout_sync milliseconds, it is
> charged a fixed amount of sectors of service.
>
> Using big values for max_budget (where big means greater than two
> times the number of sectors the hard drive can transfer in timeout_sync
> milliseconds) makes the budgets always to time out, so the disk time
> is scheduled in slices of timeout_sync.
>
> However this is just a temporary workaround to do some basic testing.
>
> Modifying the scheduler to support time slices instead of sector
> budgets would indeed simplify the code; I think that the drawback
> would be being too unfair in the service domain.  Of course we
> have to consider how much is important to be fair in the service
> domain, and how much added complexity/new code can we accept for it.
>
> [ Better service domain fairness is one of the main reasons why
>  we started working on bfq, so, talking for me and Paolo it _is_
>  important :) ]
>
> I have to think a little bit on how it would be possible to support
> an option for time-only budgets, coexisting with the current behavior,
> but I think it can be done.

I think "time only budget" vs "sector budget" is dependent on the
definition of fairness: do you want to be fair in the time that is
given to each cgroup or fair in total number of sectors transferred.
And the appropriate definition of fairness depends on how/where the IO
scheduler is used. Do you think the work-around that you mentioned
would have a significant performance difference compared to direct
built-in support?

>
>
>> 4 Do the following to support the goals of 2 level schedulers:
>>  a) Limit the request descriptors allocated to each cgroup by adding
>>  functionality to elv_may_queue()
>>  b) Add support for putting an absolute limit on IO consumed by a
>>  cgroup. Such support is provided by Andrea
>>  Righi's patches too.
>>  c) Add support (configurable option) to keep track of total disk
>> time/sectors/count
>>  consumed at each device, and factor that into scheduling decision
>>  (more discussion needed here)
>> 6 Incorporate an IO tracking approach which re-uses memory resource
>> controller code but is not dependent on it (may be biocgroup patches from
>> dm-ioband can be used here directly)
>> 7 Start an offline email thread to keep track of progress on the above
>> goals.
>>
>> BFQ's support for hierarchy of cgroups means that its close to where
>> we want to get. Any comments on what approach looks better?
>>
>
> The main problems with this approach (as with the cfq-based ones) in
> my opinion are:
>  - the request descriptor allocation problem Divyesh talked about,
>  - the impossibility of respecting different weights, resulting from
>    the interlock problem with synchronous requests Vivek talked about
>    [ in cfq/bfq this can happen when idling is disabled, e.g., for
>      SSDs, or when using NCQ ],
>
> but I think that correctly addressing your points 4.a) and 4.b) should
> solve them.
>
