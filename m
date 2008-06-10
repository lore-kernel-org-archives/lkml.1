Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYFJH62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYFJH62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 03:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYFJH6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 03:58:20 -0400
Received: from gw.goop.org ([64.81.55.164]:59165 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYFJH6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 03:58:19 -0400
Message-ID: <484E33F1.5000503@goop.org>
Date: Tue, 10 Jun 2008 08:57:37 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Isaku Yamahata <yamahata@valinux.co.jp>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com,
       Samuel Thibault <samuel.thibault@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [PATCH] xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
References: <20080610073532.GG24381%yamahata@valinux.co.jp> <200806101741.39871.nickpiggin@yahoo.com.au>
In-Reply-To: <200806101741.39871.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 10 June 2008 17:35, Isaku Yamahata wrote:
>   
>> This patch is ported one from 534:77db69c38249 of linux-2.6.18-xen.hg.
>> Use wmb instead of rmb to enforce ordering between
>> evtchn_upcall_pending and evtchn_pending_sel stores
>> in xen_evtchn_do_upcall().
>>     
>
> There are a whole load of places in the kernel that should be using
> smp_ variants of memory barriers. This seemed to me like one of them,
> but I could be wrong.
>   

No, it needs to be an unconditional barrier.  This is synchronizing with 
the hypervisor - even if the kernel is compiled UP, the SMP hypervisor 
may be testing/setting the events pending bits from another (physical) cpu.

> Also, if you do that can you get rid of the ifdef? If it really *really*
> mattered, we could introduce smp_mb before/after xchg... but if you
> use smp_wmb anyway then it definitely does not matter because that is a
> noop on x86.
>   

Yes, I'd like to lose the #ifdef.  Unfortunately I think putting a 
"lock; addl $0,0(%%esp)" style barrier had a measurable negative 
performance impact, but I may be thinking of something else.  I don't 
know how expensive sfence is.

The alternative is to make ia64's xchg a barrier (or to add a barrier 
variant of it).  It seems like a wart to have a cross-architecture 
function like xchg(), but then have different architectures differ in 
important details like barrier-ness.

    J

> Thanks,
> Nick
>
>   
>  Cc: Samuel Thibault <samuel.thibault@eu.citrix.com>
>   
>> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
>> ---
>>  drivers/xen/events.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>> index 73d78dc..332dd63 100644
>> --- a/drivers/xen/events.c
>> +++ b/drivers/xen/events.c
>> @@ -529,7 +529,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>>
>>  #ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86.
>> */ /* Clear master flag /before/ clearing selector flag. */
>> -		rmb();
>> +		wmb();
>>  #endif
>>  		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
>>  		while (pending_words != 0) {
>>     

