Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYKLVUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYKLVUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYKLVUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:20:36 -0500
Received: from smtp-out.google.com ([216.239.33.17]:55103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYKLVUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:20:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=LseQyw+c4iMycEarYRembWdjvRtJ3nDEtcnQYtIM1DX0w+ejup0OGvwliHt8MXWKX
	yGjrsGFZmJbs5qDba/8zw==
MIME-Version: 1.0
In-Reply-To: <20081111223024.GA31527@redhat.com>
References: <20081106160154.GA7461@redhat.com>
	 <20081106163957.GB7461@redhat.com> <1225990327.7803.4776.camel@twins>
	 <20081106170830.GD7461@redhat.com>
	 <e98e18940811061507t3e19183byf2b8b291458ba81b@mail.gmail.com>
	 <20081107141943.GC21884@redhat.com>
	 <e98e18940811071336n58a073d8w2cbaeddd5657d1e9@mail.gmail.com>
	 <20081110141143.GC26956@redhat.com>
	 <e98e18940811111155q4bd73480pebe088fa1adbe2e4@mail.gmail.com>
	 <20081111223024.GA31527@redhat.com>
Date: Wed, 12 Nov 2008 13:20:13 -0800
Message-ID: <e98e18940811121320w5f321302n13b526887cbb4012@mail.gmail.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, "dpshah@google.com" <dpshah@google.com>,
       Mike Waychison <mikew@google.com>, rohitseth@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 2:30 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Nov 11, 2008 at 11:55:53AM -0800, Nauman Rafique wrote:
>> On Mon, Nov 10, 2008 at 6:11 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Fri, Nov 07, 2008 at 01:36:20PM -0800, Nauman Rafique wrote:
>> >> On Fri, Nov 7, 2008 at 6:19 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > On Thu, Nov 06, 2008 at 03:07:57PM -0800, Nauman Rafique wrote:
>> >> >> It seems that approaches with two level scheduling (DM-IOBand or this
>> >> >> patch set on top and another scheduler at elevator) will have the
>> >> >> possibility of undesirable interactions (see "issues" listed at the
>> >> >> end of the second patch). For example, a request submitted as RT might
>> >> >> get delayed at higher layers, even if cfq at elevator level is doing
>> >> >> the right thing.
>> >> >>
>> >> >
>> >> > Yep. Buffering of bios at higher layer can break underlying elevator's
>> >> > assumptions.
>> >> >
>> >> > What if we start keeping track of task priorities and RT tasks in higher
>> >> > level schedulers and dispatch the bios accordingly. Will it break the
>> >> > underlying noop, deadline or AS?
>> >>
>> >> It will probably not. But then we have a cfq-like scheduler at higher
>> >> level and we can agree that the combinations "cfq(higher
>> >> level)-noop(lower level)", "cfq-deadline", "cfq-as" and "cfq-cfq"
>> >> would probably work.  But if we implement one high level cfq-like
>> >> scheduler at a higher level, we would not take care of somebody who
>> >> wants noop-noop or propotional-noop. The point I am trying to make is
>> >> that there is probably no single one-size-fits-all solution for a
>> >> higher level scheduler. And we should limit the arbitrary mixing and
>> >> matching of higher level schedulers and elevator schedulers. That
>> >> being said, the existence of a higher level scheduler is still a point
>> >> of debate I guess, see my comments below.
>> >>
>> >
>> > Ya, implemeting CFQ like thing in higher level scheduler will make things
>> > complex.
>> >
>> >>
>> >> >
>> >> >> Moreover, if the requests in the higher level scheduler are dispatched
>> >> >> as soon as they come, there would be no queuing at the higher layers,
>> >> >> unless the request queue at the lower level fills up and causes a
>> >> >> backlog. And in the absence of queuing, any work-conserving scheduler
>> >> >> would behave as a no-op scheduler.
>> >> >>
>> >> >> These issues motivate to take a second look into two level scheduling.
>> >> >> The main motivations for two level scheduling seem to be:
>> >> >> (1) Support bandwidth division across multiple devices for RAID and LVMs.
>> >> >
>> >> > Nauman, can you give an example where we really need bandwidth division
>> >> > for higher level devices.
>> >> >
>> >> > I am beginning to think that real contention is at leaf level physical
>> >> > devices and not at higher level logical devices hence we should be doing
>> >> > any resource management only at leaf level and not worry about higher
>> >> > level logical devices.
>> >> >
>> >> > If this requirement goes away, then case of two level scheduler weakens
>> >> > and one needs to think about doing changes at leaf level IO schedulers.
>> >>
>> >> I cannot agree with you more on this that there is only contention at
>> >> the leaf level physical devices and bandwidth should be managed only
>> >> there. But having seen earlier posts on this list, i feel some folks
>> >> might not agree with us. For example, if we have RAID-0 striping, we
>> >> might want to schedule requests based on accumulative bandwidth used
>> >> over all devices. Again, I myself don't agree with moving scheduling
>> >> at a higher level just to support that.
>> >>
>> >
>> > Hmm.., I am not very convinced that we need to do resource management
>> > at RAID0 device. The common case of resource management is that a higher
>> > priority task group is not deprived of resources because of lower priority
>> > task group. So if there is no contention between two task groups (At leaf
>> > node), then I might as well let them give them full access to RAID 0
>> > logical device without any control.
>> >
>> > Hope people who have requirement of control at higher level devices can
>> > pitch in now and share their perspective.
>> >
>> >> >
>> >> >> (2) Divide bandwidth between different cgroups without modifying each
>> >> >> of the existing schedulers (and without replicating the code).
>> >> >>
>> >> >> One possible approach to handle (1) is to keep track of bandwidth
>> >> >> utilized by each cgroup in a per cgroup data structure (instead of a
>> >> >> per cgroup per device data structure) and use that information to make
>> >> >> scheduling decisions within the elevator level schedulers. Such  a
>> >> >> patch can be made flag-disabled if co-ordination across different
>> >> >> device schedulers is not required.
>> >> >>
>> >> >
>> >> > Can you give more details about it. I am not sure I understand it. Exactly
>> >> > what information should be stored in each cgroup.
>> >> >
>> >> > I think per cgroup per device data structures are good so that an scheduer
>> >> > will not worry about other devices present in the system and will just try
>> >> > to arbitrate between various cgroup contending for that device. This goes
>> >> > back to same issue of getting rid of requirement (1) from io controller.
>> >>
>> >> I was thinking that we can keep track of disk time used at each
>> >> device, and keep the cumulative number in a per cgroup data structure.
>> >> But that is only if we want to support bandwidth division across
>> >> devices. You and me both agree that we probably do not need to do
>> >> that.
>> >>
>> >> >
>> >> >> And (2) can probably be handled by having one scheduler support
>> >> >> different modes. For example, one possible mode is "propotional
>> >> >> division between crgroups + no-op between threads of a cgroup" or "cfq
>> >> >> between cgroups + cfq between threads of a cgroup". That would also
>> >> >> help avoid combinations which might not work e.g RT request issue
>> >> >> mentioned earlier in this email. And this unified scheduler can re-use
>> >> >> code from all the existing patches.
>> >> >>
>> >> >
>> >> > IIUC, you are suggesting some kind of unification between four IO
>> >> > schedulers so that proportional weight code is not replicated and user can
>> >> > switch mode on the fly based on tunables?
>> >>
>> >> Yes, that seems to be a solution to avoid replication of code. But we
>> >> should also look at any other solutions that avoid replication of
>> >> code, and also avoid scheduling in two different layers.
>> >> In my opinion, scheduling at two different layers is problematic because
>> >> (a) Any buffering done at a higher level will be artificial, unless
>> >> the queues at lower levels are completely full. And if there is no
>> >> buffering at a higher level, any scheduling scheme would be
>> >> ineffective.
>> >> (b) We cannot have an arbitrary mixing and matching of higher and
>> >> lower level schedulers.
>> >>
>> >> (a) would exist in any solution in which requests are queued at
>> >> multiple levels. Can you please comment on this with respect to the
>> >> patch that you have posted?
>> >>
>> >
>> > I am not very sure about the queustion, but in my patch, buffering at
>> > at higher layer is irrespective of the status of underlying queue. We
>> > try our best to fill underlying queue with request, only subject to the
>> > criteria of proportional bandwidth.
>> >
>> > So, if there are two cgroups A and B and we allocate two cgroups 2000
>> > tokens each to begin with. If A has consumed all the tokens soon and B
>> > has not, then we will stop A from dispatching more requests and wait for
>> > B to either issue more IO and consume tokens or get out of contention.
>> > This can leave disk idle for sometime. We can probably do some
>> > optimizations here.
>>
>> What do you think about elevator based solutions like 2 level cfq
>> patches submitted by Satoshi and Vasily earlier?
>
> I have had a very high level look at Satoshi's patch. I will go into
> details soon. I was thinking that this patch solves the problem only
> for CFQ. Can we create a common layer which can be shared by all
> the four IO schedulers.
>
> So this one common layer can take care of all the management w.r.t
> per device per cgroup data structures and track all the groups, their
> limits (either token based or time based scheme), and control the
> dispatch of requests.
>
> This way we can enable IO controller not only for CFQ but for all the
> IO schedulers without duplicating too much of code.
>
> This is what I am playing around with currently. At this point I am
> not sure, how much of common ground I can have between all the IO
> schedulers.

I see your point. But having some common code in different schedulers
is not worse than what we have today (cfq, as, and deadline all have
some common code). Besides, each lower level (elevator level)
scheduler might impose certain requirements on higher level schedulers
(e.g RT requests for cfq that we talked about earlier).

>
>> CFQ can be trivially
>> modified to do proportional division (i.e give time slices in
>> proportion to weight instead of priority).
>> And such a solution would
>> avoid idleness problem like the one you mentioned above.
>
> Can you just elaborate a little on how do you get around idleness problem?
> If you don't create idleness than if two tasks in two cgroups are doing
> sequential IO, they might simply get into lockstep and we will not achieve
> any differentiated service proportionate to their weight.

I was thinking of a more cfq-like solution for proportional division
at the elevator level (i.e. not a token based solution). There are two
options for proportional bandwidth division at elevator level: 1)
change the size of the time slice in proportion to the weights or 2)
allocate equal time slice each time but allocate more slices to cgroup
with more weight. For (2), we can actually keep track of time taken to
serve requests and allocate time slices in such a way that the actual
disk time is proportional to the weight. We can adopt a fair-queuing
(http://lkml.org/lkml/2008/4/1/234) like approach for this if we want
to go that way.

I am not sure if the solutions mentioned above will have the lockstep
problem you mentioned above or not. Since we are allocating time
slices, and would have anticipation built in (just like cfq), we would
have some level of idleness. But this idleness can be predicted based
on a thread behavior. Can we use AS like algorithm for predicting idle
time before starting new epoch in your token based patch?

>
>>  and can also
>> avoid burstiness issues (see smoothing patches -- v1.2.0 and v1.3.0 --
>> of dm-ioband) in token based schemes.
>>
>> Also doing time based token allocation (as you mentioned in TODO list)
>> sounds very interesting. Can we look at the disk time taken by each
>> bio and use that to account for tokens? The problem is that the time
>> taken is not available when the requests are sent to disk, but we can
>> do delayed token charging (i.e deduct tokens after the request is
>> completed?). It seems that such an approach should work. What do you
>> think?
>
> This is a good idea. Charging the cgroup based on time actually consumed
> should be doable. I will look into it. I think in the past somebody
> mentioned that how do you account for the seek time taken because of
> switchover between cgroups? May be average time per cgroup can help here
> a bit.
>
> This is more about refining the dispatch algorightm once we have agreed
> upon other semantics like 2 level scheduler and can we come up with a common
> layer which can be shared by all four IO schedulers. Once common layer is
> possible, we can always change the common layer algorithm from token based
> to time based to achive better accuracy.
>
> Thanks
> Vivek
>
