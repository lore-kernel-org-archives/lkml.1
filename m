Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYJ1Rcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYJ1Rcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYJ1Rcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:32:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:16004 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYJ1Rcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:32:32 -0400
X-Greylist: delayed 1083 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 13:32:31 EDT
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:in-reply-to:mime-version:
	content-type:content-transfer-encoding:content-disposition:references;
	b=CwUWweR8k7mRwTovKncNzTy+e+UU5k/4u355E+GkUNAvmwvi+zLaJurAajKeLHWiy
	LQkxyNe5w0kDR0iGqK9ZA==
Message-ID: <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com>
Date: Tue, 28 Oct 2008 10:14:20 -0700
From: "Naveen Gupta" <ngupta@google.com>
To: ngupta@google.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
In-Reply-To: <20081028002024.GM4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027190131.070061000@elf.corp.google.com>
	 <20081027190139.838646000@elf.corp.google.com>
	 <20081028002024.GM4985@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/27 Dave Chinner <david@fromorbit.com>:
> On Mon, Oct 27, 2008 at 12:01:32PM -0700, ngupta@google.com wrote:
>>
>> Modifications to the Anticipatory I/O scheduler to add multiple priority
>> levels. It makes use of anticipation and batching in current
>> anticipatory scheduler to implement priorities.
>>
>> - Minimizes the latency of highest priority level.
>> - Low priority requests wait for high priority requests.
>> - Higher priority request break any anticipating low priority request.
>> - If single priority level is used the scheduler behaves as an
>>   anticipatory scheduler. So no change for existing users.
>>
>> With this change, it is possible for a latency sensitive job to coexist
>> with background job.
>>
>> Other possible use of this patch is in context of I/O subsystem controller.
>> It can add another dimension to the parameters controlling a particular cgroup.
>> While we can easily divide b/w among existing croups, setting a bound on
>> latency is not a feasible solution. Hence in context of storage devices
>> bandwidth and priority can be two parameters controlling I/O. Though
>> it can be a standalone patch to separate latency sensitive jobs and need
>> not be tied to I/O controller.
>>
>> In this patch I have added a new class IOPRIO_CLASS_LATENCY to differentiate
>> notion of absolute priority over existing uses of various time-slice based
>> priority classes in cfq. Though internally within anticipatory scheduler all
>> of them map to best-effort levels. Hence, one can also use various best-effort
>> priority levels.
>
> Please don't introduce yet another incompatible behaviour between
> I/O schedulers. It's bad enough from an optimisation point of view
> that BIO_RW_SYNC and BIO_RW_META mean different things to different
> schedulers, let alone that only CFQ currently understands
> priorities. If you are going to introduce priorities into AS, then
> please, please, please make it use the same interface as CFQ.
>
> Why? Both the extN and XFS devs have been considering bumping the
> priority of journal writes using the existing CFQ-based I/O priority
> mechanism - the last thing I want to see is a different scheduler
> requiring a different priority configuration to acheive the same
> optimisation. There is no way we can support this sort of
> optimisation in the filesystem code if the interface changes when
> the I/O scheduler changes. So please use the existing IOPRIO classes
> to map the priorities for the AS scheduler.
>

The anticipatory scheduler chooses it's next i/o to be of highest
available priority level. So, in some sense it kind of implements
absolute priority and is best used for jobs which are latency
sensitive.  Since the priorities can be and are mapped internally in
anticipatory scheduler, BEST_EFFORT class is mapped one-one with the
LATENCY class. A filesystem can use best-effort class using similar
interface as for cfq.

-Naveen


> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
