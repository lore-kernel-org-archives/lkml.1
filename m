Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZHFUdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZHFUdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZHFUdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:33:02 -0400
Received: from claw.goop.org ([74.207.240.146]:50943 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbZHFUdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:33:02 -0400
Message-ID: <4A7B3DFB.9000402@goop.org>
Date: Thu, 06 Aug 2009 13:32:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with percpu values when bringing up second CPU?
References: <4A78BD1A.9050001@goop.org> <200908051101.20471.rusty@rustcorp.com.au>
In-Reply-To: <200908051101.20471.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/09 18:31, Rusty Russell wrote:
> On Wed, 5 Aug 2009 08:28:34 am Jeremy Fitzhardinge wrote:
>   
>> Hi,
>>
>> I just tracked down a bug I was having to a change where I changed one
>> of my Xen event channel variables to a percpu variable, relating to
>> masking an event channel.
>>
>> The symptom was that shortly after bringing up the second CPU, the first
>> CPU's timer events stopped arriving, apparently because they had become
>> masked.
>>
>> The event channels masks are declared as:
>>
>> #define NR_EVENT_CHANNEL_LONGS (NR_EVENT_CHANNELS/BITS_PER_LONG)
>> static DEFINE_PER_CPU(unsigned long,
>>                      cpu_evtchn_mask[NR_EVENT_CHANNEL_LONGS]) =
>>        {[0 ... NR_EVENT_CHANNEL_LONGS-1] = ~0ul };	/* everything masked by default */
>>
>>
>> My theory about what's happening is that when the second CPU comes up,
>> it allocates separate percpu areas for each CPU, but it is somehow
>> failing to accurately copy CPU 0's percpu data over
>>     
>
> If you touch the per-cpu vars before setup_per_cpu_areas(), you will hit the
> master copy.
>
> Is that possible?
>   

Likely, I think.   It depends on whether interrupts can happen before
that point.   But hitting the master copy should be OK.

However, the problem I'm seeing happens when the second CPU starts.  I
was working on the assumption that that's when the transfer from master
to allocated copy happens, but it looks like I'm mistaken.

Maybe I'm barking up the wrong tree, but the problem does bisect to a
simple conversion to percpu...

    J
