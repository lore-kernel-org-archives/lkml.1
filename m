Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbZJaQTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbZJaQTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 12:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbZJaQTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 12:19:22 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51782 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbZJaQTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 12:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L4RPX8sE2W4mdGuZbqrdvRhjwBLq+JEbHWIJQ9ywl+kmTofMLgCJjdmEnLJtZbubw5
         KXZ8gUBPI3YbmHf5Fz92wjwNaVJggZsnjEh9CdKhkOwJ9mYUcpbJvfUmTEb2zWxKdKKu
         8NMqUx89UM2GW4o6zL48VYF7ROrbpIeN4qROE=
MIME-Version: 1.0
In-Reply-To: <20091029081917.GC26970@elte.hu>
References: <20091028155827.GA8604@in.ibm.com> <20091029081917.GC26970@elte.hu>
Date: Sat, 31 Oct 2009 17:19:24 +0100
Message-ID: <c62985530910310919u6ee28ad8qcaa3046b86ecaaee@mail.gmail.com>
Subject: Re: [RFC Patch 0/4] Enhance perf-events to profile memory accesses 
	using hw-breakpoints - ver II
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/29 Ingo Molnar <mingo@elte.hu>:
>
> * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
>
>> Hi All,
>>       Please find version II of the patchset that enables perf-events to
>> place hw-breakpoints over kernel symbols (along with requisite enhancements to
>> the hw-breakpoint layer).
>>
>> Changelog version II
>> ---------------------
>> Version I: http://lkml.org/lkml/2009/10/26/461
>>
>> - Fixed parsing issues that disallowed other perf events to be invoked
>> - Fixed user-space breakpoint usage which was broken due to patch 2/4
>> - Introduced an instance of perf_sample_data for use by do_perf_sw_event()
>>
>> An edited log of 'perf stat' and 'perf record' output is shown below for your
>> reference.
>>
>> Kindly let me know your suggestions/feedback about the same.
>>
>> Thanks,
>> K.Prasad
>>
>> Screen logs
>> ------------
>> # perf stat -v -i -e breakpoint-readwrite:pid_max -e breakpoint-write:jiffies make kernel/futex.o
>>   CHK     include/linux/version.h
>>   CHK     include/linux/utsrelease.h
>>   SYMLINK include/asm -> include/asm-x86
>>   CALL    scripts/checksyscalls.sh
>>   CC      kernel/futex.o
>> breakpoint-readwrite: 68 298512531 298512531
>> breakpoint-write: 235 298512531 298512531
>>
>>  Performance counter stats for 'make kernel/futex.o':
>>
>>              68  breakpoint-readwrite     #      0.000 M/sec
>>             235  breakpoint-write         #      0.000 M/sec
>>
>>    14.571235288  seconds time elapsed
>>
>> #
>> #
>> # perf record -v -i -e breakpoint-readwrite:jiffies top
>>
>> [Ran 'top' for about 10 seconds]
>
> btw., you probably want to add the -a/--all option as well when you test
> via top, to do system-wide profiling. With this command you profile top
> itself (and its child tasks).
>
>>
>> # perf report -i perf.data
>> # Samples: 2022950155
>> #
>> # Overhead  Command  Shared Object  Symbol
>> # ........  .......  .............  ......
>> #
>>     99.99%      top  [kernel]       [k] scheduler_tick
>>      0.01%     perf  [kernel]       [k] scheduler_tick
>>      0.00%      top  [kernel]       [k] set_track
>>      0.00%      top  [kernel]       [k] run_timer_softirq
>>      0.00%     perf  [kernel]       [k] set_track
>>      0.00%      top  [kernel]       [k] __call_rcu
>>      0.00%      top  [kernel]       [k] calc_global_load
>>      0.00%      top  [kernel]       [k] do_timer
>>      0.00%      top  [kernel]       [k] __rcu_process_callbacks
>> #
>> # (For a higher level overview, try: perf report --sort comm,dso)
>> #
>
> That output looks pretty awesome! This way we can map out how frequently
> global variables are used in the kernel - in stock distro kernels too.
> Previously we could only measure it indirectly (by looking at
> high-overhead functions and assembly level annotations), or by running
> very costly instrumentation like Valgrind.
>
> I like it how you extended --event with the breakpoint-readwrite:jiffies
> method as well.
>
> A few additional shortcuts/aliases would be nice, such as:
>
>   perf record -v -i -e readwrite:jiffies top
>
> as breakpoint-readwrite is pretty log users arent really interested in
> the mechanism (hardware-breakpoints), they are more interested that it's
> memory read-write profiling done at a given address.
>
> Maybe even 'rw' would be a useful alias as well. There are alias tables
> for events which you can use for this. You can define them via:
>
>  { CHBP(WRITE),               "memory-write",     "write",     "w"  },
>  { CHBP(RW),                  "memory-readwrite", "readwrite", "rw" },
>
> Anyway, this looks very good already - Frederic, if you like these
> patches too feel free to send it to me in your next hw-breakpoints pull
> request.


I can't add these patches to my tree as this is a patchset that implements
another direction.
Prasad's patchset is an evolution of the current state of
tip:/tracing/hw-breakpoint
that keeps the hardware breakpoints standalone wrt perf events:

perf   ftrace   ptrace   kgdb
 |        /           /           /
pmu  /           /          /
 |     /           /           /
 |   /           /           /

 ----------------------------
     Hw breakpoints api

Whereas my patchset does:

perf   ftrace  ptrace  kgdb
  |           |        |       |
  |           |        |       |
  |        --------------------
  |       hw breakpoint api
  |                |
  |----------------
  |
  |
Lower level perf / pmu

Well this ascii art should be a bit more complicated actually.
But anyway. Prasad's patchset is another branch of evolution of
tracing/hw-breakpoints.
I've expressed my opinion about that in a mail yesterday. I basically
think it limits the perf events
possibilities and rewrites the context binding / register allocation
that perf already handles.

That said I won't mind if the general opinion is in favour of that
direction and I can zap
my patches and send a pull request with Prasad's patches instead.
