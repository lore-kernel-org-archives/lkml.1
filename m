Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYJ0Pvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYJ0Pvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYJ0Pvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:51:46 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:31334 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYJ0Pvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f2eBBtdPccD4E3KyXcjGpIxuHJqXfTlSRHJDhVeqrH/xBk0ax4JvHtuqB7tsiCUyAr
         JonI499dChVR0UOMZsLmcm+lROrORQhACGhuXwwXyE7M77u9L5HCLGCTXFR0F/PyFvrr
         gLhXTW2ZomtYTGaM+few2LlleJ1XKPlzwGCL0=
Message-ID: <c62985530810270851l11fc6f66pb4db9f1f44467c26@mail.gmail.com>
Date: Mon, 27 Oct 2008 16:51:42 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] [RESEND v2] tracing/ftrace: Introduce the big kernel lock tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081027154301.GM5704@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FF928F.1010300@gmail.com> <48FF93D1.4090008@gmail.com>
	 <20081027154301.GM5704@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/27 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
>> index 01a3c22..45828b2 100644
>> --- a/lib/kernel_lock.c
>> +++ b/lib/kernel_lock.c
>> @@ -9,6 +9,7 @@
>>  #include <linux/module.h>
>>  #include <linux/kallsyms.h>
>>  #include <linux/semaphore.h>
>> +#include <trace/bkl.h>
>>
>>  /*
>>   * The 'big kernel lock'
>> @@ -107,6 +108,37 @@ static inline void __unlock_kernel(void)
>>       preempt_enable();
>>  }
>>
>> +#ifdef CONFIG_BKL_TRACER
>> +static void lock_kernel_trace(void)
>> +{
>> +     int cpu;
>> +     struct bkl_trace_acquire trace;
>> +
>> +     preempt_disable();
>> +     cpu = raw_smp_processor_id();
>> +     preempt_enable();
>> +
>> +     trace.acquire_req_time = cpu_clock(cpu);
>> +     __lock_kernel();
>> +     trace.acquire_time = cpu_clock(cpu);
>> +     trace_bkl_acquire(&trace);
>> +}
>> +
>> +static void unlock_kernel_trace(void)
>> +{
>> +     struct bkl_trace_release trace;
>> +     trace.release_time = cpu_clock(raw_smp_processor_id());
>> +     trace_bkl_release(&trace);
>> +     __unlock_kernel();
>> +}
>> +
>> +#else
>> +
>> +#define lock_kernel_trace() __lock_kernel()
>> +#define unlock_kernel_trace() __unlock_kernel()
>> +
>> +#endif
>
> hm, this looks a bit ugly.
>
> are you aware of the tip/kill-the-BKL branch? It's an old-ish but
> otherwise sane branch that needs some refreshing (hence it's not part
> of tip/master).
>
> Once we have that "kill the BKL by turning it into a mutex" feature
> alive, and have fixed the places that rely on odd properties of the
> BKL, the BKL becomes just an ordinary mutex and we could trace its
> latencies via the existing lockdep/lockstat callbacks.
>
> and we could trace all the other mutexes as well.


No problem, we can forget about it. My goal was to produce some
statistics to locate the points that
most often hold the bkl. That would help to define some priorities on
which bkl holding is to remove first.

But if that would be better to rather invest the time on the
kill-the-bkl tree (which I thought was dead), so I would be pleased to
help.
