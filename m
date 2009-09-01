Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZIASCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZIASCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 14:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZIASCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 14:02:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbZIASC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 14:02:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=r0wLBnSZxYyXYXv5L5yJgziDuhX5XloUvsIdJKumlA9k7opKlmhhM1qAynvb9iliL
	lYKksvWfvKHq7opb/Jj2w==
MIME-Version: 1.0
In-Reply-To: <20090901141142.GA13709@redhat.com>
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
	 <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
	 <20090901.160004.226800357.ryov@valinux.co.jp>
	 <20090901141142.GA13709@redhat.com>
Date: Tue, 1 Sep 2009 11:02:22 -0700
Message-ID: <e98e18940909011102p7af308d5n9733b12d0a693b77@mail.gmail.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to 
	track async bios.
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, riel@redhat.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 1, 2009 at 7:11 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Tue, Sep 01, 2009 at 04:00:04PM +0900, Ryo Tsuruta wrote:
>> Hi,
>>
>> > > Hi Rik,
>> > >
>> > > Thanks for reviewing the patches. I wanted to have better understanding of
>> > > where all does it help to associate a bio to the group of process who
>> > > created/owned the page. Hence few thoughts.
>> > >
>> > > When a bio is submitted to IO scheduler, it needs to determine the group
>> > > bio belongs to and group which should be charged to. There seem to be two
>> > > methods.
>> > >
>> > > - Attribute the bio to cgroup submitting process belongs to.
>> > > - For async requests, track the original owner hence cgroup of the page
>> > > áand charge that group for the bio.
>> > >
>> > > One can think of pros/cons of both the approaches.
>> > >
>> > > - The primary use case of tracking async context seems be that if a
>> > > áprocess T1 in group G1 mmaps a big file and then another process T2 in
>> > > ágroup G2, asks for memory and triggers reclaim and generates writes of
>> > > áthe file pages mapped by T1, then these writes should not be charged to
>> > > áT2, hence blkio_cgroup pages.
>> > >
>> > > áBut the flip side of this might be that group G2 is a low weight group
>> > > áand probably too busy also right now, which will delay the write out
>> > > áand possibly T2 will wait longer for memory to be allocated.
>>
>> In order to avoid this wait, dm-ioband issues IO which has a page with
>> PG_Reclaim as early as possible.
>>
>
> So in above case IO is still charged to G2 but you keep a track if page is
> PG_Reclaim then releae the this bio before other bios queued up in the
> group?
>
>> > > - At one point of time Andrew mentioned that buffered writes are generally a
>> > > ábig problem and one needs to map these to owner's group. Though I am not
>> > > ávery sure what specific problem he was referring to. Can we attribute
>> > > ábuffered writes to pdflush threads and move all pdflush threads in a
>> > > ácgroup to limit system wide write out activity?
>>
>> I think that buffered writes also should be controlled per cgroup as
>> well as synchronous writes.
>>
>
> But it is hard to achieve fairness for buffered writes becase we don't
> create complete parallel IO paths and not necessarily higher weight
> process dispatches more buffered writes to IO scheduler. (Due to page
> cache buffered write logic).
>
> So in some cases we might see buffered write fairness and in other cases
> not. For example, run two dd processes in two groups doing buffered writes
> and it is hard to achieve fairness between these.

If something is broken, we don't necessarily have to break it further.
Instead, we should be thinking about why its hard to achieve fairness
with buffered write back. Is there a way to change the writeback path
to send down a constant stream of IO, instead of sending down bursts?

>
> That's why the idea that if we can't ensure Buffered write vs Buffered
> write fairness in all the cases, then does it make sense to attribute
> buffered writes to pdflush and put pdflush threads into a separate group
> to limit system wide write out activity.
>
>> > > - Somebody also gave an example where there is a memory hogging process and
>> > > ápossibly pushes out some processes to swap. It does not sound fair to
>> > > ácharge those proccess for that swap writeout. These processes never
>> > > árequested swap IO.
>>
>> I think that swap writeouts should be charged to the memory hogging
>> process, because the process consumes more resources and it should get
>> a penalty.
>>
>
> A process requesting memory gets IO penalty? IMHO, swapping is a kernel
> mechanism and kernel's way of providing extended RAM. If we want to solve
> the issue of memory hogging by a process then right way to solve is to use
> memory controller and not by charging the process for IO activity.
> Instead, proabably a more suitable way is to charge swap activity to root
> group (where by default all the kernel related activity goes).
>
>> > > - If there are multiple buffered writers in the system, then those writers
>> > > ácan also be forced to writeout some pages to disk before they are
>> > > áallowed to dirty more pages. As per the page cache design, any writer
>> > > ácan pick any inode and start writing out pages. So it can happen a
>> > > áweight group task is writting out pages dirtied by a lower weight group
>> > > átask. If, async bio is mapped to owner's group, it might happen that
>> > > áhigher weight group task might be made to sleep on lower weight group
>> > > átask because request descriptors are all consumed up.
>>
>> As mentioned above, in dm-ioband, the bio is charged to the page owner
>> and issued immediately.
>
> But you are doing it only for selected pages and not for all buffered
> writes?
>
>>
>> > > It looks like there does not seem to be a clean way which covers all the
>> > > cases without issues. I am just trying to think, what is a simple way
>> > > which covers most of the cases. Can we just stick to using submitting task
>> > > context to determine a bio's group (as cfq does). Which can result in
>> > > following.
>> > >
>> > > - Less code and reduced complexity.
>> > >
>> > > - Buffered writes will be charged to pdflush and its group. If one wish to
>> > > álimit buffered write activity for pdflush, one can move all the pdflush
>> > > áthreads into a group and assign desired weight. Writes submitted in
>> > > áprocess context will continue to be charged to that process irrespective
>> > > áof the fact who dirtied that page.
>> >
>> > What if we wanted to control buffered write activity per group? If a
>> > group keeps dirtying pages, we wouldn't want it to dominate the disk
>> > IO capacity at the expense of other cgroups (by dominating the writes
>> > sent down by pdflush).
>>
>> Yes, I think that is true.
>>
>
> But anyway we are not able to gurantee this isolation in all the cases.
> Again I go back to example of two dd threads doing buffered writes in two
> groups.
>
> I don't mind keeping it. Just wanted to make sure that we agree and
> understand that keeping it does not mean that we get buffered write vs
> buffered write isolation/fairness in all the cases.
>
>> > > - swap activity will be charged to kswapd and its group. If swap writes
>> > > áare coming from process context, it gets charged to process and its
>> > > ágroup.
>> > >
>> > > - If one is worried about the case of one process being charged for write
>> > > áout of file mapped by another process during reclaim, then we can
>> > > áprobably make use of memory controller and mount memory controller and
>> > > áio controller together on same hierarchy. I am told that with memory
>> > > ácontroller, group's memory will be reclaimed by the process requesting
>> > > ámore memory. If that's the case, then IO will automatically be charged
>> > > áto right group if we use submitting task context.
>> > >
>> > > I just wanted to bring this point forward for more discussions to know
>> > > what is the right thing to do? Use bio tracking or not.
>>
>> Thanks for bringing it forward.
>>
>
> Thanks
> Vivek
>
