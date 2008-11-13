Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYKMW15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYKMW15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYKMW1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:27:48 -0500
Received: from smtp-out.google.com ([216.239.45.13]:17869 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYKMW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:27:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=B8u0P+JAUgv/2atIEVs4R9PR+NPoaougw5sviIio7jskRG2TZSQAdHK1O2uq1cisk
	Sy4LlSPBmYyMRPbkWSXIw==
MIME-Version: 1.0
In-Reply-To: <20081113191546.GL14817@gandalf.sssup.it>
References: <1225990327.7803.4776.camel@twins>
	 <e98e18940811061507t3e19183byf2b8b291458ba81b@mail.gmail.com>
	 <20081107141943.GC21884@redhat.com>
	 <e98e18940811071336n58a073d8w2cbaeddd5657d1e9@mail.gmail.com>
	 <20081110141143.GC26956@redhat.com>
	 <e98e18940811111155q4bd73480pebe088fa1adbe2e4@mail.gmail.com>
	 <20081111223024.GA31527@redhat.com>
	 <e98e18940811121320w5f321302n13b526887cbb4012@mail.gmail.com>
	 <20081113180821.GF7542@redhat.com>
	 <20081113191546.GL14817@gandalf.sssup.it>
Date: Thu, 13 Nov 2008 14:27:41 -0800
Message-ID: <e98e18940811131427i5eea3543jc7e934632f15bcf4@mail.gmail.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Nauman Rafique <nauman@google.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, "dpshah@google.com" <dpshah@google.com>,
       Mike Waychison <mikew@google.com>, rohitseth@google.com,
       paolo.valente@unimore.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 11:15 AM, Fabio Checconi <fchecconi@gmail.com> wrote:
>> From: Vivek Goyal <vgoyal@redhat.com>
>> Date: Thu, Nov 13, 2008 01:08:21PM -0500
>>
>> On Wed, Nov 12, 2008 at 01:20:13PM -0800, Nauman Rafique wrote:
> ...
>> > I was thinking of a more cfq-like solution for proportional division
>> > at the elevator level (i.e. not a token based solution). There are two
>> > options for proportional bandwidth division at elevator level: 1)
>> > change the size of the time slice in proportion to the weights or 2)
>> > allocate equal time slice each time but allocate more slices to cgroup
>> > with more weight. For (2), we can actually keep track of time taken to
>> > serve requests and allocate time slices in such a way that the actual
>> > disk time is proportional to the weight. We can adopt a fair-queuing
>> > (http://lkml.org/lkml/2008/4/1/234) like approach for this if we want
>> > to go that way.
>>
>> Hi Nauman,
>>
>> I think doing proportional weight division at elevator level will be
>> little difficult, because if we go for a full hierarchical solution then
>> we will be doing proportional weight division among tasks as well as
>> groups.
>>
>> For example, consider this. Assume at root level there are three tasks
>> A, B, C and two cgroups D and E. Now for proportional weight division we
>> should consider A, B, C, D and E at same level and then try to divide
>> the BW (Thanks to peterz for clarifying this).
>>
>> Other approach could be that consider A, B, C in root cgroup and then
>> consider root, D and E competing groups and try to divide the BW. But
>> this is not how cpu controller operates and this approach I think was
>> initially implemented for group scheduling in cpu controller and later
>> changed.
>>
>> How the proportional weight division is done among tasks is a property
>> of IO scheduler. cfq decides to use time slices according to priority
>> and bfq decides to use tokens. So probably we can't move this to common
>> elevator layer.
>>
>
> cfq and bfq are pretty similar in the concepts they adopt, and the pure
> time-based approach of cfq can be extended to arbitrary hierarchies.
>
> Even in bfq, when dealing with groups that generate only seeky traffic
> we don't try to be fair in the service domain, as it would decrease too
> much the aggregate throughput, but we fall back to a time-based approach.
>
> [ This is a design choice, but it does not depend on the algorithms,
>  and of course can be changed... ]
>
> The two approaches can be mixed/unified, for example, using wf2q+ to
> schedule the slices, in the time domain, of cfq; the main remaining
> difference would be the ability of bfq to provide service-domain
> guarantees.

Before going into the design of elevator level scheduler, we should
have some consensus on abandoning the two level approach. Infact, it
would be useful if we had Ryo and Satoshi jump into this discussion
and express their opinion.

Having said that, I think I agree with Fabio on some mix/unification
of BFQ and CFQ patches, specially using wf2q+ to schedule time slices
would be a small patch into existing 2 level cfqs. That approach might
also reduce the resistance to have this in the tree, as CFQ is already
the default scheduler.

>
>
>> I think Satoshi's cfq controller patches also do not seem to be considering
>> A, B, C, D and E to be at same level, instead it treats cgroup "/" , D and E
>> at same level and tries to do proportional BW division among these.
>> Satoshi, please correct me, if that's not the case.
>>
>> Above example, raises another question and that is what to do wih IO
>> schedulers which do not differentiate between tasks. For example, noop. It
>> simply has got one single linked list and does not have the notion of
>> io context and does not differentiate between IO coming from different
>> tasks. In that case probably we have no choice but to group A, B, C's bio
>> in root cgroup and do proportional weight division among "root", D and E
>> groups. I have not looked at deadline and AS yet.
>>
>
> When you talk about grouping tasks into the root cgroup and then
> scheduling inside the groups using an existing scheduler, do you mean
> doing something like creating a ``little as'' or ``little noop'' queue
> per each group, somehow like what happens with classless leaf qdiscs in
> network scheduling, and then select first the leaf group to be scheduled,
> and then using the per-leaf scheduler to select the request from the leaf?
>
> A good thing about this approach would be that idling would still make
> sense and the upper infrastructure would be the same for all the schedulers
> (except for cfq and bfq, that in my opinion better fit the cpu scheduler's
> hierarchical approach, with hierarchies confined into scheduling classes).
>
>
>> So at this point of time I think that probably porting BFQ's hierarchical
>> scheduling implementation to other IO schedulers might make sense. Thoughts?
>>
>
> IMO for cfq, given the similarities, this can be done without conceptual
> problems.  How to do that for schedulers like as, noop or deadline, and
> if this is the best solution, is an interesting problem :)

It might be a little too early to start patching things into other
schedulers. First, because we still don't have a common ground on the
exact approach for proportional bandwidth division. Second, if
somebody is using vanilla no-op, deadline or as, do they really care
about proportional division? If they did, they would probably be using
cfq already. So we can have something going for cfq first, and then we
can move to other schedulers.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
