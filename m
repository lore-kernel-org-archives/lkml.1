Return-Path: <linux-kernel-owner+w=401wt.eu-S933499AbZDBUIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499AbZDBUIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932926AbZDBUIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:08:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38225 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914AbZDBUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:08:18 -0400
Message-ID: <49D51A82.8090908@redhat.com>
Date: Thu, 02 Apr 2009 16:05:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, frankeh@watson.ibm.com, hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com> <20090402175249.3c4a6d59@skybase> <49D50CB7.2050705@redhat.com> <200904030622.30935.nickpiggin@yahoo.com.au>
In-Reply-To: <200904030622.30935.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 03 April 2009 06:06:31 Rik van Riel wrote:
>   
>> Ballooning has a simpler mechanism, but relies on an
>> as-of-yet undiscovered policy.
>>
>> Having experienced a zillion VM corner cases over the
>> last decade and a bit, I think I prefer a complex mechanism
>> over complex (or worse, unknown!) policy any day.
>>     
>
> I disagree with it being so clear cut. Volatile pagecache policy is completely
> out of the control of the Linux VM. Wheras ballooning does have to make some
> tradeoff between guests, but the actual reclaim will be driven by the guests.
> Neither way is perfect, but it's not like the hypervisor reclaim is foolproof
> against making a bad tradeoff between guests.
>   
I guess we could try to figure out a simple and robust policy
for ballooning.  If we can come up with a policy which nobody
can shoot holes in by just discussing it, it may be worth
implementing and benchmarking.

Maybe something based on the host passing memory pressure
on to the guests, and the guests having their own memory
pressure push back to the host.

I'l start by telling you the best auto-ballooning policy idea
I have come up with so far, and the (major?) hole in it.

Basically, the host needs the memory pressure notification,
where the VM will notify the guests when memory is running
low (and something could soon be swapped).  At that point,
each guest which receives the signal will try to free some
memory and return it to the host.

Each guest can have the reverse in its own pageout code.
Once memory pressure grows to a certain point (eg. when
the guest is about to swap something out), it could reclaim
a few pages from the host.

If all the guests behave themselves, this could work.

However, even with just reasonably behaving guests,
differences between the VMs in each guest could lead
to unbalanced reclaiming, penalizing better behaving
guests.

If one guest is behaving badly, it could really impact
the other guests.

Can you think of improvements to this idea?

Can you think of another balloon policy that does
not have nasty corner cases?
