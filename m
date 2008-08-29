Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYH2GbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYH2GbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYH2GbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:31:15 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:37960 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYH2GbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cHmRUzLFj9VbLDz4JwkPlahsyOz+IlCi+DtJ/jIvZk7m3R4SjYkXp13dfJwBbhkT4j
         cCBXOUP3DY4UeVsyWzlRqJegSj7ChZ8u1S2gMyajm3w1sXJxGKxy5SI+c+zaeFv44woe
         7CgDVPgFdq1BmGC2brxr3ZTU5Hy/zOziHoiBM=
Message-ID: <520f0cf10808282331r3425f4f4jfac2d3a7d53c8821@mail.gmail.com>
Date: Fri, 29 Aug 2008 08:31:12 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Cc: mgross@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, peterz@infradead.org,
       rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
       arjan@infradead.org
In-Reply-To: <20080828173201.8912a1f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080812224926.GA20652@linux.intel.com>
	 <1218736137.10800.234.camel@twins>
	 <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>
	 <20080825163412.GA21910@linux.intel.com>
	 <1219682129.8515.81.camel@twins>
	 <520f0cf10808260148k47368b71he2737ea1a59bbe4d@mail.gmail.com>
	 <20080826161802.GB9862@linux.intel.com>
	 <520f0cf10808261045v9dddcdcnd1a86b224aa3feb0@mail.gmail.com>
	 <20080828194420.GB6802@linux.intel.com>
	 <20080828173201.8912a1f3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 2:32 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 28 Aug 2008 12:44:20 -0700
> mark gross <mgross@linux.intel.com> wrote:
>
>> From: John Kacur <jkacur at gmail dot com>
>
> I tend to deobfuscate email addresses when preparing the changelogs.
>
> Not sure why, really, and I feel a bit guilty about doing it (hey, you
> can forward the resulting spam to me if you like).  One reason I guess
> is to avoid breaking all the emails which my scripts will automatically
> send out as the patch goes through its little lifecycle.  Some of which
> can sometimes be quite important.
>
>> Patch to make PM_QOS and CPU_IDLE play nicer when ran with the
>> RT-Preempt kernel.  CPU_IDLE polls the target_value's of some of the
>> pm_qos parameters from the idle loop causing sleeping locking
>> warnings.  Changing the target_value to an atomic avoids this issue.
>>
>> Signed-off-by: mark gross <mgross@linux.intel.com>
>>
>> Thanks,
>>
>> --mgross
>>
>>
>> Remove the spinlock in pm_qos_requirement by making target_value an atomic type.
>> This is necessary for real-time since pm_qos_requirement is called by idle and
>> cannot be allowed to sleep.
>> Signed-off-by: John Kacur <jkacur at gmail dot com>
>
> As usual when I get two different changelogs, I create a masterpiece
> which is better than either of the originals!
>
>> Index: linux-2.6/kernel/pm_qos_params.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/pm_qos_params.c     2008-08-08 07:52:01.000000000 -0700
>> +++ linux-2.6/kernel/pm_qos_params.c  2008-08-28 12:14:55.000000000 -0700
>> @@ -43,7 +43,7 @@
>>  #include <linux/uaccess.h>
>>
>>  /*
>> - * locking rule: all changes to target_value or requirements or notifiers lists
>> + * locking rule: all changes to requirements or notifiers lists
>>   * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
>>   * held, taken with _irqsave.  One lock to rule them all
>>   */
>> @@ -66,7 +66,7 @@
>>       struct miscdevice pm_qos_power_miscdev;
>>       char *name;
>>       s32 default_value;
>> -     s32 target_value;
>> +     atomic_t target_value;
>>       s32 (*comparitor)(s32, s32);
>>  };
>>
>> @@ -77,7 +77,7 @@
>>       .notifiers = &cpu_dma_lat_notifier,
>>       .name = "cpu_dma_latency",
>>       .default_value = 2000 * USEC_PER_SEC,
>> -     .target_value = 2000 * USEC_PER_SEC,
>> +     .target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
>>       .comparitor = min_compare
>>  };
>>
>> @@ -87,7 +87,7 @@
>>       .notifiers = &network_lat_notifier,
>>       .name = "network_latency",
>>       .default_value = 2000 * USEC_PER_SEC,
>> -     .target_value = 2000 * USEC_PER_SEC,
>> +     .target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
>>       .comparitor = min_compare
>>  };
>>
>> @@ -99,7 +99,7 @@
>>       .notifiers = &network_throughput_notifier,
>>       .name = "network_throughput",
>>       .default_value = 0,
>> -     .target_value = 0,
>> +     .target_value = ATOMIC_INIT(0),
>>       .comparitor = max_compare
>>  };
>>
>> @@ -150,11 +150,11 @@
>>               extreme_value = pm_qos_array[target]->comparitor(
>>                               extreme_value, node->value);
>>       }
>> -     if (pm_qos_array[target]->target_value != extreme_value) {
>> +     if (atomic_read(&pm_qos_array[target]->target_value) != extreme_value) {
>>               call_notifier = 1;
>> -             pm_qos_array[target]->target_value = extreme_value;
>> +             atomic_set(&pm_qos_array[target]->target_value, extreme_value);
>>               pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
>> -                     pm_qos_array[target]->target_value);
>> +                     atomic_read(&pm_qos_array[target]->target_value));
>>       }
>>       spin_unlock_irqrestore(&pm_qos_lock, flags);
>>
>> @@ -193,14 +193,7 @@
>>   */
>>  int pm_qos_requirement(int pm_qos_class)
>>  {
>> -     int ret_val;
>> -     unsigned long flags;
>> -
>> -     spin_lock_irqsave(&pm_qos_lock, flags);
>> -     ret_val = pm_qos_array[pm_qos_class]->target_value;
>> -     spin_unlock_irqrestore(&pm_qos_lock, flags);
>> -
>> -     return ret_val;
>> +     return atomic_read(&pm_qos_array[pm_qos_class]->target_value);
>>  }
>>  EXPORT_SYMBOL_GPL(pm_qos_requirement);
>
> OK, so I've stared and stared.  This patch doesn't do anything.
>
> I'm suspecting that the rt patch might be doing something silly, like
> thinking that it needs to take pm_qos_lock to read a single word from
> memory, or something like that.
>
> But this patch is simply not understandable given the amount of
> information which you guys have provided.
>

Hi Andrew

The purpose of the patch is to remove the spin_lock around the read in
the function pm_qos_requirement - since spinlocks can sleep in -rt and
this function is called from idle. I did propose a patch, that simply
removed the spinlock, since Peter Zilstra and others (yourself) point
out, the lock isn't needed to read a single word from memory. Although
the patch worked fine, Arjan objected to it, because it was not
symmetric. A reader of the code might wonder why it was locked in
other functions but not here. He suggested changing it to an atomic
type might be less confusing. The alternative which I like better
actually is to simply remove the lock in pm_qos_requirement and add a
comment for readers of the code.

John
