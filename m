Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYKMR1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYKMR1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYKMR0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:26:51 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:12648 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYKMR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CP5qpKpXwHxasI5CPLA2WQigLCnevvaE6B2XSb8KBmAAZR+6m8WDTnBJHWjocTXBWO
         IGxf4mo9TVIq72QHENME/7oVVYt+XoTwL7DyUwFB+CnUaxDMntkeccfRcsbmj8qNsuk3
         Hx9JGXQ9bF+geAqQSmHNjYw6greAdFsaUJnI0=
Message-ID: <c62985530811130926y656f8f4ancd592f26cdbbee6b@mail.gmail.com>
Date: Thu, 13 Nov 2008 18:26:49 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081113125419.GA32574@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu>
	 <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com>
	 <20081113085551.GF25479@elte.hu>
	 <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com>
	 <20081113092340.GJ25479@elte.hu>
	 <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com>
	 <20081113094027.GK25479@elte.hu>
	 <c62985530811130436s160e3983nd7debbb96cc971ae@mail.gmail.com>
	 <20081113125419.GA32574@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Ingo Molnar <mingo@elte.hu>:
> "prev_global_time" also acts as a global serializer: it ensures that
> events are timestamped in a monotonic and ordered way.
>
> i.e. something like this (pseudocode, without the cmpxchg):
>
>  u64 prev_global_time;
>
>  DEFINE_PER_CPU(prev_local_time);
>
>  u64 global_time()
>  {
>        u64 now, delta, now_global;
>
>        prev_global = prev_global_time;
>        now = sched_clock();
>        delta = now - per_cpu(prev_local_time, this_cpu);
>        per_cpu(prev_local_time, this_cpu) = now;
>
>        now_global = prev_global + delta;
>        prev_global = now_global;
>
>        return now_global;
>  }
>
> note how we build "global time" out of "local time".
>
> The cmpxchg would be used to put the above one into a loop, and
> instead of updating the global time in a racy way:
>
>        prev_global = now_global;
>
> We'd update it via the cmpxchg:
>
>        atomic64_t prev_global_time;
>
>        ...
>
>        while (atomic64_cmpxchg(&prev_global_time,
>                                 prev_global, now_global) != prev_global) {
>                [...]
>        }
>
> To make sure the global time goes monotonic. (this way we also avoid a
> spinlock - locks are fragile for instrumentation)

Ok, I understand better.
But consider the following:

 u64 global_time()
 {
       u64 now, delta, now_global;
       prev_global = prev_global_time;

       while (atomic64_cmpxchg(&prev_global_time,
                                 prev_global, now_global) != prev_global) {

           now = sched_clock();
           delta = now - per_cpu(prev_local_time, this_cpu);
           per_cpu(prev_local_time, this_cpu) = now;
           now_global = prev_global + delta;
           prev_global = now_global;
       }
       return now_global;
 }

Sarting with prev_global_time = 0
If we have two cpu and the above function is executed 5 times on the first cpu.
We couldl have per_cpu(prev_local_time) = 50 for example. And so
prev_global_time will be equal to 50.

Just after that, almost at the same time, cpu2 calls global_time()

delta will be equal to 50 (sched_clock() - per_cpu(prev_local_time)
which is 0) and prev_global_time will be 50 + 50 = 100.
This is not consistent.
I don't know where but I'm pretty sure I missed something....
