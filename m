Return-Path: <linux-kernel-owner+w=401wt.eu-S1750839AbXCRNUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839AbXCRNUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 09:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXCRNUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 09:20:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:25402 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXCRNUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 09:20:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,297,1170662400"; 
   d="scan'208"; a="60153289:sNHT23571495"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] Add not_critical_when_idle timer
Date: Sun, 18 Mar 2007 06:20:42 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F51EDFBF@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070318001028.15219305.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Add not_critical_when_idle timer
thread-index: AcdpNOXmbXu0qraJTx6YrF3wqZym4AAKkCeg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Dave Jones" <davej@redhat.com>, <tglx@linutronix.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Mar 2007 13:20:44.0592 (UTC) FILETIME=[3BE3F300:01C76960]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Sunday, March 18, 2007 1:10 AM
>To: Pallipadi, Venkatesh
>Cc: Dave Jones; tglx@linutronix.de; linux-kernel
>Subject: Re: [PATCH 1/2] Add not_critical_when_idle timer
>
>On Fri, 16 Mar 2007 15:07:35 -0700 Venkatesh Pallipadi 
><venkatesh.pallipadi@intel.com> wrote:
>
>A few cosmetic and interface things:
>
>> --- linux-2.6.20.orig/kernel/timer.c	2007-03-16 
>14:13:19.000000000 -0700
>> +++ linux-2.6.20/kernel/timer.c	2007-03-16 
>14:51:15.000000000 -0700
>> @@ -74,7 +74,7 @@
>>  	tvec_t tv3;
>>  	tvec_t tv4;
>>  	tvec_t tv5;
>> -} ____cacheline_aligned_in_smp;
>> +} ____cacheline_aligned;
>
>hm, that's an unrelated bugfix.

This is not totally unrelated, as I want this base structure to be
aligned in UP case as well, as the lower bits in the pointer to base is
overloaded. 

>> ...
>>
>> +extern struct tvec_t_base_s boot_tvec_bases;
>> +/*
>> + * Note that all tvec_bases is 2 byte aligned and lower bit of
>> + * base in timer_list is guaranteed to be zero. Use the LSB for
>> + * the new flag to indicate whether it is OK to skip timer callback
>> + * when CPU is idle.
>> + */
>> +#define TBASE_FLAG_DELAYED_ON_IDLE		(0x1)
>> +
>> +#define TBASE_GET_BASE_PTR(x)				
>		\
>> +	((struct tvec_t_base_s *)((unsigned long)x &		
>	\
>> +	                          (~TBASE_FLAG_DELAYED_ON_IDLE)))
>> +
>> +#define TBASE_GET_DELAYED_ON_IDLE(x)			
>		\
>> +	((unsigned long)x & TBASE_FLAG_DELAYED_ON_IDLE)
>> +
>> +#define TBASE_SET_DELAYED_ON_IDLE(x)			
>		\
>> +	((struct tvec_t_base_s *)((unsigned long)x |		
>	\
>> +	                          TBASE_FLAG_DELAYED_ON_IDLE))
>> +
>> +#define TBASE_CLEAR_DELAYED_ON_IDLE(x)			
>		\
>> +	((struct tvec_t_base_s *)((unsigned long)x &		
>	\
>> +	                          (~TBASE_FLAG_DELAYED_ON_IDLE)))
>> +
>> +#define TBASE_MERGE_DELAYED_ON_IDLE(x,f)			
>	\
>> +	((f) ? TBASE_SET_DELAYED_ON_IDLE(x) : 
>TBASE_CLEAR_DELAYED_ON_IDLE(x))
>
>Can we implement these as lower-case-named inline functions?  
>I don't think
>there's any reason why they have to be macros?

Yes. Will do.

>>  
>> -extern struct tvec_t_base_s boot_tvec_bases;
>>  
>>  #define TIMER_INITIALIZER(_function, _expires, _data) {	
>	\
>>  		.function = (_function),			\
>> @@ -62,7 +88,8 @@
>>  	return timer->entry.next != NULL;
>>  }
>>  
>> -extern void add_timer_on(struct timer_list *timer, int cpu);
>> +extern void add_timer_on(struct timer_list *timer, int cpu,
>> +                         int not_critical_when_idle);
>
>That `not_critical_when_idle' is a real mouthful.  Could we just use
>"deferrable"?  With a nice comment in a strategic spot which 
>explains what
>it's all about?
>

Yes. deferrable sounds better. Will change.

>>  extern int del_timer(struct timer_list * timer);
>>  extern int __mod_timer(struct timer_list *timer, unsigned 
>long expires);
>>  extern int mod_timer(struct timer_list *timer, unsigned 
>long expires);
>> @@ -144,6 +171,16 @@
>>  static inline void add_timer(struct timer_list *timer)
>>  {
>>  	BUG_ON(timer_pending(timer));
>> +	timer->base = TBASE_CLEAR_DELAYED_ON_IDLE(timer->base);
>> +	__mod_timer(timer, timer->expires);
>> +}
>> +
>> +static inline void add_timer_with_hint(struct timer_list *timer,
>> +                                       int not_critical_when_idle)
>> +{
>> +	BUG_ON(timer_pending(timer));
>> +	timer->base = TBASE_MERGE_DELAYED_ON_IDLE(timer->base,
>> +	                                          
>not_critical_when_idle);
>>  	__mod_timer(timer, timer->expires);
>>  }
>
>I'm not sure I really like the idea of modifying a timer's state when
>installing it.  Plus mod_timer() is a superset of add_timer(), 
>and people
>might want to use mod_timer().
>
>I think it would be better to specify the type of the timer when we're
>initialising it, not when we're installing it.
>
>So would it not be nicer to do:
>
>	setup_deferrable_timer(timer, my_handler, my_data);
>	add_timer(timer, whenever);
>or
>	mod_timer(timer, whenever);
>

OK. I will look at having the setup functions this way. I guess this
should be better as we will never want to use a single timer in both
deferrrable and non-deferrable modes. Will refresh the patch with these
changes soon.

Thanks,
Venki
