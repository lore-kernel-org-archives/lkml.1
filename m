Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbYHHVbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbYHHVbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbYHHVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:31:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:39890 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbYHHVbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wT1x3Z2sbqtKoeDGzyqvss8cJgKy3I+UksUXyM91u88GrEk+1VxuDUmSo2xyvxbbVe
         zTL9UstmAPyzJR35omJMaGNWIYip3IMhekTIJlSwOCOSNt7UQ+1mSZjGhMYh4IIx8V35
         GwFDOkQhaNGP/LM+qiANbZ0qj+aluPyM9PdKY=
Message-ID: <b647ffbd0808081431q27a48113q5beee1bae7c24b0a@mail.gmail.com>
Date: Fri, 8 Aug 2008 23:31:05 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200808082303.41068.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com>
	 <200808082303.41068.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/8 Rafael J. Wysocki <rjw@sisk.pl>:
> [Adding CCs]
>
> On Friday, 8 of August 2008, Langsdorf, Mark wrote:
>> One of my co-workers noticed that the powernow-k8
>> driver no longer restarts when a CPU core is
>> hot-disabled and then hot-enabled on AMD quad-core
>> systems.
>>
>> The following comands work fine on 2.6.26 and fail
>> on 2.6.27-rc1:
>>
>> echo 0 > /sys/devices/system/cpu/cpu3/online
>> echo 1 > /sys/devices/system/cpu/cpu3/online
>> find /sys -name cpufreq
>>
>> For 2.6.26, the find will return a cpufreq
>> directory for each processor.  In 2.6.27-rc1,
>> the cpu3 directory is missing.
>>
>> After digging through the code, the following
>> logic is failing when the core is hot-enabled
>> at runtime.  The code works during the boot
>> sequence.
>>
>>       cpumask_t = current->cpus_allowed;
>>       set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
>>       if (smp_processor_id() != cpu)
>>               return -ENODEV;
>>


if it gets called from any of the cpu-hotplug handlers, it won't work
now (x86-microcode is another victim).

Please give a try to the following patch: http://lkml.org/lkml/2008/7/30/171

does it help?

(the explanation is also available in this thread).

well, provided we may guarantee that load-balancing has been
initialized (it's ok in our case) by the moment CPU_ONLINE gets
called, this approach is not that bad perhaps... (and it looks like
there is plenty of code that relies on set_cpus_allowed_ptr() being
workable in cpu-hotplug-handlers).

Although, I personally don't like that much this particular use-case
of set_cpus_allowed_ptr() (I posted patches for x86-microcode). btw.,
last time I briefly looked at various places, there seemed to be a few
where

old_mask = p->cpus_allowed;
set_cpus_allowed_ptr(p, target_cpu);
// do something
set_cpus_allowed_ptr(p, old_mask);

is used just wrongly. e.g. it may race with sched_setaffinity() and
negate its effect.


>> -Mark Langdsorf
>> Operating System Research Center
>> AMD

-- 
Best regards,
Dmitry Adamushko
