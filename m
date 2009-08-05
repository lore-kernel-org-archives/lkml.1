Return-Path: <linux-kernel-owner+w=401wt.eu-S933163AbZHEBpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbZHEBpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933008AbZHEBpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:45:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:51162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbZHEBpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:45:13 -0400
Message-ID: <4A78E406.8020605@kernel.org>
Date: Wed, 05 Aug 2009 10:44:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with percpu values when bringing up second CPU?
References: <4A78BD1A.9050001@goop.org>
In-Reply-To: <4A78BD1A.9050001@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 01:44:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeremy Fitzhardinge wrote:
> I just tracked down a bug I was having to a change where I changed one
> of my Xen event channel variables to a percpu variable, relating to
> masking an event channel.
> 
> The symptom was that shortly after bringing up the second CPU, the first
> CPU's timer events stopped arriving, apparently because they had become
> masked.

Hmmmm...

> The event channels masks are declared as:
> 
> #define NR_EVENT_CHANNEL_LONGS (NR_EVENT_CHANNELS/BITS_PER_LONG)
> static DEFINE_PER_CPU(unsigned long,
>                      cpu_evtchn_mask[NR_EVENT_CHANNEL_LONGS]) =
>        {[0 ... NR_EVENT_CHANNEL_LONGS-1] = ~0ul };	/* everything masked by default */
> 
> My theory about what's happening is that when the second CPU comes up,
> it allocates separate percpu areas for each CPU, but it is somehow
> failing to accurately copy CPU 0's percpu data over; either it isn't
> copying it all (ie, using the initialized values rather than the current
> values), or failing to copy the values in an interrupt-atomic way.
>
> Does this sound plausible?

Percpu areas aren't setup when the first cpu comes up.  They're
allocated and copied from the master copy during early init when only
the boot cpu is running.

> When I convert this back to an ad-hoc percpu variable (an array indexed
> by cpu number), it goes back to working.  Also, if I boot with maxcpus=1
> it also works with percpu data.

Hmmm... strange.  Can you try to print out the values along the boot
process and see when things go wrong?

> Also, because we don't have large pages under Xen, it always allocates
> percpu as 4k pages:
> 
> PERCPU: Allocated 21 4k pages, static data 82080 bytes

I don't think the choice of first chunk allocator would cause any
difference.

Thanks.

-- 
tejun
