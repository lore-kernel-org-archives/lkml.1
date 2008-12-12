Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYLLQhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYLLQhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbYLLQhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:37:10 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56299 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757408AbYLLQhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:37:09 -0500
Message-ID: <49429332.8030105@sgi.com>
Date: Fri, 12 Dec 2008 08:37:06 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: fix cpu_mask_to_apicid_and to include cpu_online_mask
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112806.873424000@polaris-admin.engr.sgi.com> <200812122136.34780.rusty@rustcorp.com.au>
In-Reply-To: <200812122136.34780.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 11 December 2008 21:58:08 Mike Travis wrote:
>> Impact: fix potential problem.
>>
>> In determining the destination apicid, there are usually three cpumasks
>> that are considered: the incoming cpumask arg, cfg->domain and the
>> cpu_online_mask.  Since we are just introducing the cpu_mask_to_apicid_and
>> function, make sure it includes the cpu_online_mask in it's evaluation.
> 
> Yerk.  Can we really "fail" cpu_mask_to_apicid_and with no repercussions?
> And does it make sense to try to fix this there?

Fail?  The only failure is if there is not a cpu that satisfies the conjunction
of the three masks, in which case it returns BAD_APICID.

The old procedure was to:

function(..., cpumask_t mask)
{
	cpumask_t tmp;

	cpus_and(tmp, mask, cfg->domain);
	...
	cpus_and(tmp, tmp, cpu_online_map);
	dest = cpu_mask_to_apicid(tmp);
	...
}

So making cpu_mask_to_apicid_and return:

	dest = cpu_mask_to_apicid(mask1 & mask2 & cpu_online_mask);

maintains this compatibility.

Turns out that there are two functions that did not AND all three masks,
but those two used TARGET_CPUS as one of the arguments.  All the x86
variations except NUMAQ, only return TARGET_CPUS which are online
(and that's probably a mistake in NUMAQ.)  So the above AND'ing is a
NOP in these cases and harmless.

> 
> This is not a new problem with the cpumask patches is it?  I toyed with a
> patch which converts flush_tlb_others, and it actually ensures that those
> cases never hand an offline mask to cpu_mask_to_apicid_and as a side
> effect (others still might).

No, I introduced the problem when I added cpu_mask_to_apicid_and(), and I
wanted to fix it before it was "officially" released.  I've been doing
benchmark testing with random HOTPLUG off and on events, and it's becoming
clear that setting the destination apicid to an off line cpu is definitely
a no-no. ;-)

Thanks,
Mike
