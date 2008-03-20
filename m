Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYCTULI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYCTULI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYCTUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:10:55 -0400
Received: from homer.mvista.com ([63.81.120.158]:20886 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYCTUKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:10:54 -0400
Message-ID: <47E2C4CC.5050401@ct.jp.nec.com>
Date: Thu, 20 Mar 2008 13:10:52 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] rt-slab: fix cpu inconsistency case
References: <47E2A63B.4020003@ct.jp.nec.com> <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0803201519160.21990@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Hi Hiroshi,

Hi Steven,

> 
> Thanks for looking into it. I'll take a deeper look at it later, but
> first I have a few nitpicks with the patch.

thanks for comments.

> 
> On Thu, 20 Mar 2008, Hiroshi Shimamoto wrote:
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  mm/slab.c |   18 +++++++++---------
>>  1 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index 4bf6ca8..7beb378 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -138,8 +138,8 @@
>>   *
>>   * (On PREEMPT_RT, these are NOPs, but we have to drop/get the irq locks.)
>>   */
>> -# define slab_irq_disable_nort()	local_irq_disable()
>> -# define slab_irq_enable_nort()		local_irq_enable()
>> +# define slab_irq_disable_nort(cpu)	slab_irq_disable(cpu)
>> +# define slab_irq_enable_nort(cpu)	slab_irq_enable(cpu)
> 
> This is the !PREEMPT_RT version. It should stay as is (with the
> exception of ignoring the "cpu" variable. [ (void)cpu; ? ]
> 
> #define slab_irq_disable_nort(cpu) \
> 	do { \
> 		(void)cpu;  \
> 		local_irq_disable(); \
> 	} while(0)

I think "cpu" variable should be changed if current cpu is changed.

mm/slab.c:cache_alloc_refill()
	if (unlikely(!ac->avail)) {
		int x;
		x = cache_grow(cachep, flags | GFP_THISNODE, cpu_to_node(*this_cpu), NULL, this_cpu);

		/* cache_grow can reenable interrupts, then ac could change. */
		ac = cpu_cache_get(cachep, *this_cpu);

The comment says, "ac could change", but it never if *this_cpu is same.

In cache_alloc_refill(), cpu_cache_get() should called with the valid cpu id
after cache_grow(). Because on !PREEMPT_RT, the array_cache is protected by
disabling irqs, so array_cache of other cpu shouldn't be accessed.

> 
>>  # define slab_irq_disable_rt(flags)	do { (void)(flags); } while (0)
>>  # define slab_irq_enable_rt(flags)	do { (void)(flags); } while (0)
>>  # define slab_spin_lock_irq(lock, cpu) \
>> @@ -160,8 +160,8 @@ DEFINE_PER_CPU_LOCKED(int, slab_irq_locks) = { 0, };
>>  	do { slab_irq_enable(cpu); (void) (flags); } while (0)
>>  # define slab_irq_disable_rt(cpu)	slab_irq_disable(cpu)
>>  # define slab_irq_enable_rt(cpu)	slab_irq_enable(cpu)
>> -# define slab_irq_disable_nort()	do { } while (0)
>> -# define slab_irq_enable_nort()		do { } while (0)
>> +# define slab_irq_disable_nort(cpu)	do { } while (0)
>> +# define slab_irq_enable_nort(cpu)	do { } while (0)
> 
> And these are the PREEMPT_RT version. So basically, this patch is a nop
> for PREEMPT_RT. I doubt it will solve your bug ;-)

yes, it's nop. I'm sorry, I didn't show .config.
My kernel config is !PREEMPT_RT, it's same as the deadlock report.
I guess it's a problem only !PREEMPT_RT.

thanks,
Hiroshi Shimamoto
