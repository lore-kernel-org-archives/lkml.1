Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYJ1WtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYJ1WtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYJ1Wsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:48:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYJ1Wsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:48:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:in-reply-to:mime-version:
	content-type:content-transfer-encoding:content-disposition:references;
	b=pSpFBB/c2BgfqaOv6S6WmKSdm6LGVba1mm3bJTqaAQGx0/FBLNBPDnwus+reZ5dFP
	MzNCMV6hg+wkakERlmmlA==
Message-ID: <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com>
Date: Tue, 28 Oct 2008 15:48:44 -0700
From: "Naveen Gupta" <ngupta@google.com>
To: "Naveen Gupta" <ngupta@google.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, akpm@linux-foundation.org,
       s-uchida@ap.jp.nec.com
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
In-Reply-To: <20081028214443.GX4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027190131.070061000@elf.corp.google.com>
	 <20081027190139.838646000@elf.corp.google.com>
	 <20081028002024.GM4985@disturbed>
	 <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com>
	 <20081028214443.GX4985@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/28 Dave Chinner <david@fromorbit.com>:
> On Tue, Oct 28, 2008 at 10:14:20AM -0700, Naveen Gupta wrote:
>> 2008/10/27 Dave Chinner <david@fromorbit.com>:
>> > On Mon, Oct 27, 2008 at 12:01:32PM -0700, ngupta@google.com wrote:
>> >>
>> >> Modifications to the Anticipatory I/O scheduler to add multiple priority
>> >> levels. It makes use of anticipation and batching in current
>> >> anticipatory scheduler to implement priorities.
> .....
>> >> In this patch I have added a new class IOPRIO_CLASS_LATENCY to differentiate
>> >> notion of absolute priority over existing uses of various time-slice based
>> >> priority classes in cfq. Though internally within anticipatory scheduler all
>> >> of them map to best-effort levels. Hence, one can also use various best-effort
>> >> priority levels.
>> >
>> > Please don't introduce yet another incompatible behaviour between
>> > I/O schedulers. It's bad enough from an optimisation point of view
>> > that BIO_RW_SYNC and BIO_RW_META mean different things to different
>> > schedulers, let alone that only CFQ currently understands
>> > priorities. If you are going to introduce priorities into AS, then
>> > please, please, please make it use the same interface as CFQ.
>> >
>> > Why? Both the extN and XFS devs have been considering bumping the
>> > priority of journal writes using the existing CFQ-based I/O priority
>> > mechanism - the last thing I want to see is a different scheduler
>> > requiring a different priority configuration to acheive the same
>> > optimisation. There is no way we can support this sort of
>> > optimisation in the filesystem code if the interface changes when
>> > the I/O scheduler changes. So please use the existing IOPRIO classes
>> > to map the priorities for the AS scheduler.
>> >
>>
>> The anticipatory scheduler chooses it's next i/o to be of highest
>> available priority level.
>
> That sounds exactly like what the current RT class is supposed to
> be used for - defining the absolute priority of dispatch. How
> is this latency class different to the current RT class semantics
> that are defined for CFQ?
>

I/O from RT class in CFQ can still see a bubble with this new latency
class. An easy way to check this would be to submit ios at multiple
levels both in CFQ and AS and check max latency of the highest levels.
I will let Jens or Satoshi comment on exact algorithm for RT class.


>> So, in some sense it kind of implements
>> absolute priority and is best used for jobs which are latency
>> sensitive.  Since the priorities can be and are mapped internally in
>> anticipatory scheduler, BEST_EFFORT class is mapped one-one with the
>> LATENCY class.
>
> So you map the BE class to something with the same semantics as the
> RT class? What mapping do you do when an application uses the RT
> class?
>

Yes I could have used RT class but it was used in CFQ to implement
it's time-sliced based highest priority class. If an application uses
RT class, AS maps all levels of RT class to BE class level 0 (i.e. to
the highest priority available)

>> A filesystem can use best-effort class using similar
>> interface as for cfq.
>
> The folk using the RT priority classes greatly objected to using
> the RT class for journal I/O precisely because it would then
> preempt their application's RT I/O and introduce unpredictable
> latencies.
>
> Journal I/O will typically use the highest priority BE class so that
> it is promoted above BE I/O but does not preempt RT I/O.  With your
> mapping of BE classes to this new "absolute priority latency" class,
> this configuration will give journal I/O the highest priority in the
> scheduler. This will cause preemption of your latency sensitive I/O
> and so those latencies you are trying to avoid won't go away....
>

I see your problem, we could make the LATENCY class different from and
above BE class (instead of one-one mapping). Then you could use BE
class level 0 all you want. Or you could select BE level 1 and we can
keep the classes as they are.


> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
