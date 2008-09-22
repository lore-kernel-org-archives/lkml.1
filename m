Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYIVL6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYIVL6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYIVL6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:58:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYIVL6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:58:05 -0400
Date: Mon, 22 Sep 2008 13:57:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080922115749.GE14301@elte.hu>
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D39312.9000400@yahoo.com>
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


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Ingo Molnar wrote:
>> here's two quick howtos:
>>
>>   http://redhat.com/~mingo/sched-devel.git/readme-tracer.txt
>>   http://redhat.com/~mingo/sched-devel.git/howto-trace-latencies.txt
>
> These two files appear to be identical. Is this intentional?
>
> Anyway after following your instructions a putting together a small  
> script to dice the output, I collated the 10 switches which took the  
> longest:
>
> # Top ten longest switches
> # Rel TS Process   Abs TS
> 0.122161 hald-3423 1867.821170 ***
> 0.039438 <idle>-0  1867.379054
> 0.036318 hald-3423 1867.669009
> 0.031362 <idle>-0  1868.002762
> 0.030000 hald-3423 1867.699009
> 0.028933 <idle>-0  1867.529238
> 0.028539 <idle>-0  1867.228861
> 0.028196 <idle>-0  1867.128731
> 0.027763 <idle>-0  1868.101449
> 0.027513 <idle>-0  1867.028606
>
> # tracer: sched_switch from around longest switch
> #
> #           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> #              | |      |          |         |
>           <idle>-0     [00]  1867.608017:      0:140:R   +     3:115:S
>           <idle>-0     [00]  1867.608038:      0:140:R   +  3423:120:D
>           <idle>-0     [00]  1867.608045:      0:140:R ==>     3:115:R
>      ksoftirqd/0-3     [00]  1867.608048:      3:115:S ==>  3423:120:R
>             hald-3423  [00]  1867.629350:   3423:120:R   +  6096:120:S
>             hald-3423  [00]  1867.632691:   3423:120:R   +  3827:120:S
>             hald-3423  [00]  1867.669009:   3423:120:R   +  3998:120:S
>             hald-3423  [00]  1867.699009:   3423:120:R   +  6097:120:S
>          ***hald-3423  [00]  1867.821170:   3423:120:R ==>  6096:120:R
>        rhythmbox-6096  [00]  1867.821219:   6096:120:S ==>  6097:120:R
>        rhythmbox-6097  [00]  1867.821262:   6097:120:R   +  3826:120:S
>        rhythmbox-6097  [00]  1867.821289:   6097:120:S ==>  3826:120:R
>       pulseaudio-3826  [00]  1867.821332:   3826:120:R   +  6097:120:S
>       pulseaudio-3826  [00]  1867.821374:   3826:120:S ==>  6097:120:R
>        rhythmbox-6097  [00]  1867.821380:   6097:120:S ==>  3998:120:R
>        rhythmbox-3998  [00]  1867.821709:   3998:120:S ==>  3827:120:R
>       pulseaudio-3827  [00]  1867.824041:   3827:120:R   +  3826:120:S
>
>
>>    LatencyTOP version 0.4       (C) 2008 Intel Corporation
>>
>> Cause                                                Maximum     Percentage
>> Scheduler: waiting for cpu                        152.4 msec         13.8 %
>> Userspace lock contention                           5.0 msec         68.0 %
>> Waiting for event (poll)                            5.0 msec         14.3 %
>> Waiting for event (select)                          4.9 msec          3.5 %
>> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.1 %
>> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_re  1.9 msec          0.2 %
>> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.1 %
>> Executing raw SCSI command                          1.1 msec          0.0 %
>> Waiting for TTY to finish sending                   0.4 msec          0.0 %
>>
>>
>> Process rhythmbox (3998)                   Total: 328.3 msec
>> Scheduler: waiting for cpu                        152.4 msec         80.0 %
>> Userspace lock contention                           4.1 msec         15.7 %
>> Waiting for event (poll)                            2.7 msec          4.1 %
>
>
>> you need to enable:
>>
>>   CONFIG_SCHED_TRACER=y
>>   CONFIG_CONTEXT_SWITCH_TRACER=y
>
> I actually have both of these enabled but there's still no wakeup tracer  
> (as mentioned in the git kernel documentation http://tinyurl.com/4f9s4l  
> ). The good news is that your instructions don't need the wakeup tracer.
>
>> it's not particularly well named though. Why doesnt it say  
>> LATENCY_TRACER or something?
>
> I agree it would be nicer if it had a better name.
>
>>> Additionally I think I found a trigger - unplugging the power cable  
>>> from the EeePC and having it run on battery seems to then set off 
>>> this periodic stall every 30 seconds... There's no CPU frequency 
>>> scaling enabled either (Celeron M's seemingly don't have P states and 
>>> support for cpufreq is configured out).
>>
>> sounds like potential SMM triggered latencies.
>
> I have just gone away and read about the SMM ( 
> http://blogs.msdn.com/carmencr/archive/2005/08/31/458609.aspx ). If 
> you're right there is pretty much nothing that can be done about the 
> problem : (

well, since they went away after you enabled CONFIG_PREEMPT=y, they are 
definitely in-kernel latencies, not any external SMM latencies.

I.e. they are inherently fixable. Could you enable:

  CONFIG_DYNAMIC_FTRACE=y
  CONFIG_FTRACE_MCOUNT_RECORD=y

that should make the traces a lot more verbose - every kernel function 
executed in the latency path will be logged. That way we'll be able to 
say which one takes that long.

note, you might have to increase /debug/tracing/trace_entries to get a 
long enough trace to capture the relevant portion of the latency.

	Ingo
