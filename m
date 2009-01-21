Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbZAUPTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbZAUPTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZAUPTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:19:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZAUPTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:19:43 -0500
Date: Wed, 21 Jan 2009 16:18:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090121151820.GA23813@elte.hu>
References: <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au> <20090120125652.GA1457@elte.hu> <20090120130714.GA11048@elte.hu> <alpine.DEB.1.10.0901200957220.2681@gandalf.stny.rr.com> <49760E2D.2060109@redhat.com> <1232547932.4895.119.camel@kulgan.wumi.org.au> <49773275.3020203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49773275.3020203@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Kevin Shanahan wrote:
>> On Tue, 2009-01-20 at 19:47 +0200, Avi Kivity wrote:
>>   
>>> Steven Rostedt wrote:
>>>     
>>>> Note, the wakeup latency only tests realtime threads, since other threads
>>>> can have other issues for wakeup. I could change the wakeup tracer as
>>>> wakeup_rt, and make a new "wakeup" that tests all threads, but it may
>>>> be difficult to get something accurate.
>>>>       
>>> Kevin, can you retest with kvm at realtime priority?
>>>     
>>
>> Running vanilla Linux 2.6.28, kvm-82. First a control test to check that
>> the problem is still there when running at normal priority:
>>
>> --- hermes-old.wumi.org.au ping statistics ---
>> 900 packets transmitted, 900 received, 0% packet loss, time 899283ms
>> rtt min/avg/max/mdev = 0.119/269.773/13739.426/1230.836 ms, pipe 14
>>
>> Yeah, sure is.
>>
>> Okay, so now I set the realtime attributes of the processes for the VM
>> instance being pinged:
>>
>> flexo:~# ps ax | grep 6284
>>  6284 ?        Sl     6:11 /usr/local/kvm/bin/qemu-system-x86_64 -smp 2
>> -m 2048 -hda kvm-17-1.img -hdb kvm-17-tmp.img -net
>> nic,vlan=0,macaddr=52:54:00:12:34:67,model=rtl8139 -net
>> tap,vlan=0,ifname=tap17,script=no -vnc 127.0.0.1:17 -usbdevice tablet
>> -daemonize
>> flexo:~# pstree -p 6284
>> qemu-system-x86(6284)─┬─{qemu-system-x86}(6285)
>>                       ├─{qemu-system-x86}(6286)
>>                       └─{qemu-system-x86}(6540)
>>
>> (info cpus on the QEMU console shows 6285 and 6286 being the VCPU
>> processes. Not sure what the third child is for, maybe vnc?.)
>>
>> flexo:~# chrt -r -p 3 6284
>> flexo:~# chrt -r -p 3 6285
>> flexo:~# chrt -r -p 3 6286
>> flexo:~# chrt -p 6284
>> pid 6284's current scheduling policy: SCHED_RR
>> pid 6284's current scheduling priority: 3
>> flexo:~# chrt -p 6285
>> pid 6285's current scheduling policy: SCHED_RR
>> pid 6285's current scheduling priority: 3
>> flexo:~# chrt -p 6286
>> pid 6286's current scheduling policy: SCHED_RR
>> pid 6286's current scheduling priority: 3
>>
>> And the result of the ping test now:
>>
>> --- hermes-old.wumi.org.au ping statistics ---
>> 900 packets transmitted, 900 received, 0% packet loss, time 899326ms
>> rtt min/avg/max/mdev = 0.093/0.157/3.611/0.117 ms
>>
>> So, a _huge_ difference. But what does it mean?
>
> It means, a scheduling problem.  Can you run the latency tracer (which 
> only works with realtime priority), so we can tell if it is (a) kvm 
> failing to wake up the vcpu properly or (b) the scheduler delaying the 
> vcpu from running.

Could we please get an ftrace capture of the incident?

Firstly, it makes sense to simplify the tracing environment as much as 
possible: for example single-CPU traces are much easier to interpret.

Can you reproduce it with just one CPU online? I.e. if you offline all the 
other cores via:

  echo 0 > /sys/devices/system/cpu/cpu1/online

  [etc.]

and keep CPU#0 only, do the latencies still occur?

If they do still occur, then please do the traces that way.

[ If they do not occur then switch back on all CPUs - we'll sort out the
  traces ;-) ]

Then please build a function tracer kernel, by enabling:

  CONFIG_FUNCTION_TRACER=y
  CONFIG_FUNCTION_GRAPH_TRACER=y
  CONFIG_DYNAMIC_FTRACE=y

Once you boot into such a kernel, you can switch on function tracing via:

  cd /debug/tracing/

  echo 0 > tracing_enabled
  echo function_graph > current_tracer
  echo funcgraph-proc > trace_options 

It does not run yet, first find a suitable set of functions to trace. For 
example this will be a pretty good starting point for scheduler+KVM 
problems:

  echo ''         > set_ftrace_filter  # clear filter functions
  echo '*sched*' >> set_ftrace_filter 
  echo '*wake*'  >> set_ftrace_filter
  echo '*kvm*'   >> set_ftrace_filter
  echo 1 > tracing_enabled             # let the tracer go

You can see your current selection of functions to trace via 'cat 
set_ftrace_filter', and you can see all functions via 'cat 
available_filter_functions'.

You can also trace all functions via:

  echo '*' > set_ftrace_filter

Tracer output can be captured from the 'trace' file. It should look like 
this:

 15)   cc1-28106    |   0.263 us    |    page_evictable();
 15)   cc1-28106    |               |    lru_cache_add_lru() {
 15)   cc1-28106    |   0.252 us    |      __lru_cache_add();
 15)   cc1-28106    |   0.738 us    |    }
 15)   cc1-28106    | + 74.026 us   |  }
 15)   cc1-28106    |               |  up_read() {
 15)   cc1-28106    |   0.257 us    |    _spin_lock_irqsave();
 15)   cc1-28106    |   0.253 us    |    _spin_unlock_irqrestore();
 15)   cc1-28106    |   1.329 us    |  }

To capture a continuous stream of all trace data you can do:

  cat trace_pipe > /tmp/trace.txt

(this will also drain the trace ringbuffers.)

Note that this can be quite expensive if there are a lot of functions that 
are traced - so it makes sense to trim down the set of traced functions to 
only the interesting ones. Which are the interesting ones can be 
determined from looking at the traces. You should see your KVM threads 
getting active every second as the ping happens.

If you get lost events you can increase the trace buffer size via the 
buffer_size_kb control - the default is around 1.4 MB.

Let me know if any of these steps is causing problems or if interpreting 
the traces is difficult.

	Ingo
