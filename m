Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYGKXx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYGKXx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYGKXxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:53:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:37669 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYGKXxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jv27JEV/6/L0lCFkwnbw3DpQMUywlBhZRpWuB+Qw6p7LebufMPapEv4bZ9DrgFYAMp
         VZgAKKva3N2oNfuC0RcvGhv0u9MlOYxC1ViIKvwKYCnUyjmvu78O92XfnXsOxF4k//i/
         SNzJlzdQvYmsgScUV6VNN68G2ECBYf12pdvm8=
Message-ID: <b647ffbd0807111653g85aecaeqcfbdb4dec153b3d4@mail.gmail.com>
Date: Sat, 12 Jul 2008 01:53:19 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Paul Menage" <menage@google.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4877EA9A.1070700@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>
	 <6599ad830807111236t2bc9aa02ned59dcc58f14b1bf@mail.gmail.com>
	 <19f34abd0807111243s549b0facvbd0a650358463231@mail.gmail.com>
	 <b647ffbd0807111603m45b65f73q90399891fb8795f1@mail.gmail.com>
	 <4877EA9A.1070700@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/12 Max Krasnyansky <maxk@qualcomm.com>:
> Dmitry Adamushko wrote:
>>
>> Does the patch below help?
>>
>> (non-white-space-damaged version is attached)
>>
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index 9fceb97..ae61dc9 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -1912,11 +1912,21 @@ static void common_cpu_mem_hotplug_unplug(void)
>>  static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
>>                                unsigned long phase, void *unused_cpu)
>>  {
>> -       if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
>> +       swicth (phase) {
>> +       case CPU_UP_CANCELED:
>> +       case CPU_UP_CANCELED_FROZEN:
>> +       case CPU_DOWN_FAILED:
>> +       case CPU_DOWN_FAILED_FROZEN:
>> +       case CPU_ONLINE:
>> +       case CPU_ONLINE_FROZEN:
>> +       case CPU_DEAD:
>> +       case CPU_DEAD_FROZEN:
>> +               common_cpu_mem_hotplug_unplug();
>> +               break;
>> +       default:
>>                return NOTIFY_DONE;
>
> I was always wondering why we're running that logic for every hotplug event.
> For example, do we care for UP_CANCELED* and DOWN_FAILED* ? Presumably
> nothing should've changed, no ?

I guess, it's to revert the effect of CPU_{DOWN | UP}_PREPARE.

e.g. CPU_DOWN_PREPARE detaches/destroys sched-domains... so if a
cpu-down op. fails, we restore them to their inital state.


> btw I'm just going by the name of the event. So UP_CANCELED to me sounds
> like CPU never got to the ONLINE stage and cpuset should not really care.

Yes, if it has not done anything for UP_PREPARE (and no one else on
behave of it).


>
> Max
>

-- 
Best regards,
Dmitry Adamushko
