Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYAQVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYAQVgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYAQVga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:36:30 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:44429 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbYAQVg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:36:29 -0500
X-Auth-Info: wk/Th+5kLw1arBezwSVgG6rKztPQ+7QSFJAwDhsOt2s=
X-Auth-Info: wk/Th+5kLw1arBezwSVgG6rKztPQ+7QSFJAwDhsOt2s=
X-Auth-Info: wk/Th+5kLw1arBezwSVgG6rKztPQ+7QSFJAwDhsOt2s=
X-Auth-Info: wk/Th+5kLw1arBezwSVgG6rKztPQ+7QSFJAwDhsOt2s=
X-Auth-Info: wk/Th+5kLw1arBezwSVgG6rKztPQ+7QSFJAwDhsOt2s=
X-Auth-Info: wk/Th+5kLw1arBezwSVgG6rKztPQ+7QSFJAwDhsOt2s=
Message-ID: <478FCA58.5070101@grandegger.com>
Date: Thu, 17 Jan 2008 22:36:24 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com> <20080117211149.GQ27137@pengutronix.de>
In-Reply-To: <20080117211149.GQ27137@pengutronix.de>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> On Thu, Jan 17, 2008 at 11:13:26AM +0100, Wolfgang Grandegger wrote:
>>   # ./cyclictest -n -p80 -i1000 -b400
>>
>> [...]
>>
>> Well, I'm not sure if this is the correct way to do it. Is there some
>> doc on how to use the latency tracer and interpret the results?
> 
> Could you put in this kind of log information inline next time? It makes
> it easier to review.

OK.

> 
> Let's see ...
> 
>> preemption latency trace v1.1.5 on 2.6.24-rc8-rt1
>> --------------------------------------------------------------------
>>  latency: 39733427 us, #65536/1202801, CPU#0 | (M:rt VP:0, KP:0, SP:1 HP:1)
>>     -----------------
>>     | task: cyclictest-914 (uid:0 nice:0 policy:1 rt_prio:80)
>>     -----------------
> 
> Ok, so cyclictest-914 triggered the tracer. No big surprise at -t 1 :-)
> 
>> cyclicte-914   0D..1   40us+: enqueue_hrtimer+0x50/0x1a0 (   89 5aa9862 c3a6dea8)
> 
> cyclictest-914 goes to sleep for next period. We expect it to wake up
> again at 40 us + 1000 us = 1040 us.
> 
>>       ls-1032  0DNh2  999us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
>>       ls-1032  0DNh2 1001us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 0)
>>       ls-1032  0DNh. 1008us+: clockevents_program_event+0x84/0x1c0 (   89 5ad6bbf 18e8e)
>> cyclicte-914   0D..2 1033us+: __schedule+0x21c/0x444 <ls-1032> (0 180)
>> cyclicte-914   0D..1 1071us+: enqueue_hrtimer+0x50/0x1a0 (   89 5b9daa2 c3a6dea8)
> 
> Looks good, it happened. Next wakeup at about 1071 us + 1000 us = 2071
> us.
> 
>> cyclicte-914   0D..2 2031us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 180)
>> cyclicte-914   0D..1 2072us+: enqueue_hrtimer+0x50/0x1a0 (   89 5c91ce2 c3a6dea8)
> 
> Bingo. Let's get a cup of coffee in the meantime ...
> 
>> cyclicte-914   0D..1 1905066us+: enqueue_hrtimer+0x50/0x1a0 (   91 66210 c3a6dea8)
> 
> Expected arival at 1905066 us + 1000 us = 1906066 us.
> 
>>       ls-1048  0DNh3 1906017us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
>>       ls-1048  0DNh3 1906021us : __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
>>       ls-1048  0DNh3 1906023us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 0)
> 
> It's trying hard to wake up ...
> 
>>       ls-1048  0DNh1 1906028us!: clockevents_program_event+0x84/0x1c0 (   91 391676 367eff)
>>       ls-1048  0DNh2 1906274us+: activate_task+0x60/0xa4 <IRQ-193-681> (150 6)
> 
> Between these it should have happened.
> 
>>       ls-1048  0DNh2 1906285us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
>>       ls-1048  0DNh2 1906293us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
>>       ls-1048  0DNh2 1906295us+: try_to_wake_up+0x194/0x1b4 <IRQ-193-681> (150 0)
>> cyclicte-914   0D..2 1906332us : __schedule+0x21c/0x444 <ls-1048> (0 180)
> 
> What is this IRQ-193-681? Can you post your /proc/interrupts and the

bash-3.00# cat /proc/interrupts
           CPU0
129:        179  MPC52xx Peripherals Edge      mpc52xx_psc_uart
133:          0  MPC52xx Peripherals Edge      mpc52xx-fec_ctrl
135:          0  MPC52xx Peripherals Edge      mpc52xx_ata
192:      14853  MPC52xx SDMA Edge      mpc52xx-fec_rx
193:       9488  MPC52xx SDMA Edge      mpc52xx-fec_tx
BAD:          0


> output of
> 
> 	ps axHo user,pid,%cpu,%mem,nice,rtprio,policy,tty,stat,start_time,bsdtime,args

time,args# ps axHo
user,pid,%cpu,%mem,nice,rtprio,policy,tty,stat,start_time,bsd
USER       PID %CPU %MEM  NI RTPRIO POL TT       STAT START   TIME COMMAND
root         1  1.0  1.0   0      - TS  ?        Ss   00:00   0:00 init
[3]
root         2  0.0  0.0  -5      - TS  ?        S<   00:00   0:00
[kthreadd]
root         3  0.0  0.0   -     99 FF  ?        S<   00:00   0:00
[posix_cpu_t]
root         4  0.0  0.0   -     50 FF  ?        S<   00:00   0:00
[softirq-hig]
root         5  1.4  0.0   -     50 FF  ?        S<   00:00   0:01
[softirq-tim]
root         6  0.7  0.0   -     50 FF  ?        S<   00:00   0:00
[softirq-net]
root         7  2.4  0.0   -     50 FF  ?        S<   00:00   0:02
[softirq-net]
root         8  0.0  0.0   -     50 FF  ?        S<   00:00   0:00
[softirq-blo]
root         9  0.0  0.0   -     50 FF  ?        S<   00:00   0:00
[softirq-tas]
root        10  0.0  0.0   -     50 FF  ?        S<   00:00   0:00
[softirq-sch]
root        11  0.0  0.0   -     50 FF  ?        S<   00:00   0:00
[softirq-hrt]
root        12  0.4  0.0   -     50 FF  ?        S<   00:00   0:00
[softirq-rcu]
root        13  0.0  0.0   -     99 FF  ?        S<   00:00   0:00
[watchdog/0]
root        14  0.0  0.0 -10      - TS  ?        S<   00:00   0:00
[desched/0]
root        15  0.0  0.0   -      1 FF  ?        S<   00:00   0:00
[events/0]
root        16  0.2  0.0  -5      - TS  ?        S<   00:00   0:00 [khelper]
root        68  0.0  0.0  -5      - TS  ?        S<   00:00   0:00
[kblockd/0]
root        75  0.0  0.0  -5      - TS  ?        S<   00:00   0:00 [ata/0]
root        76  0.0  0.0  -5      - TS  ?        S<   00:00   0:00 [ata_aux]
root        93  0.0  0.0   -      1 FF  ?        S<   00:00   0:00
[krcupreempt]
root        94  0.0  0.0   0      - TS  ?        S    00:00   0:00 [pdflush]
root        95  0.0  0.0   0      - TS  ?        S    00:00   0:00 [pdflush]
root        96  0.0  0.0  -5      - TS  ?        S<   00:00   0:00 [kswapd0]
root        97  0.0  0.0  -5      - TS  ?        S<   00:00   0:00 [aio/0]
root       675  0.0  0.0   -     50 FF  ?        S<   00:00   0:00 [IRQ-135]
root       676  0.0  0.0  -5      - TS  ?        S<   00:00   0:00
[scsi_eh_0]
root       678  0.1  0.0  -5      - TS  ?        S<   00:00   0:00
[rpciod/0]
root       679  0.0  0.0   -     50 FF  ?        S<   00:00   0:00 [IRQ-133]
root       680  1.1  0.0   -     50 FF  ?        S<   00:00   0:01 [IRQ-192]
root       681  0.9  0.0   -     50 FF  ?        S<   00:00   0:00 [IRQ-193]
root       682  0.0  0.0   -     50 FF  ?        S<   00:00   0:00 [IRQ-129]
root       848  0.1  1.3   0      - TS  ?        Ss   00:00   0:00
syslogd -m 0
root       850  0.0  0.6   0      - TS  ?        Ss   00:00   0:00 klogd -x
root       884  0.1  1.6   0      - TS  ?        Ss   00:00   0:00
xinetd -staya
root       890  0.2  2.2   0      - TS  ?        Ss   00:00   0:00 login
-- root
root       891  0.3  2.8   0      - TS  ?        Ss   00:00   0:00 -bash
root       913  5.2  1.6   0      - TS  ?        Ss   00:00   0:03
in.telnetd: 1
root       914  0.1  2.2   0      - TS  ?        Ss   00:00   0:00 login
-- root
root       915  1.4  2.8   0      - TS  ttyp0    Ss   00:00   0:00 -bash
root       938  8.4  1.1   0      - TS  ttyp0    Sl+  00:00   0:03
./cyclictest
root       938  5.5  1.1   -     99 FF  ttyp0    Sl+  00:00   0:02
./cyclictest
root       941  0.0  1.7   0      - TS  ?        R+   00:01   0:00 ps
axHo user,
bash-3.00#

Wolfgang.

> Robert

