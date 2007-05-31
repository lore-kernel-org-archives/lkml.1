Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbXEaO2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbXEaO2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXEaO2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:28:31 -0400
Received: from mx2.compro.net ([216.54.166.4]:47231 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbXEaO23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:28:29 -0400
X-IronPort-AV: E=Sophos;i="4.14,599,1170651600"; 
   d="txt'?scan'208";a="401001"
Message-ID: <465EDB97.5070908@compro.net>
Date: Thu, 31 May 2007 10:28:39 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: floppy.c soft lockup
References: <465C6359.1020106@compro.net> <20070530224650.04b33117.akpm@linux-foundation.org>
In-Reply-To: <20070530224650.04b33117.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------080906060209080602090106"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080906060209080602090106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Tue, 29 May 2007 13:31:05 -0400 Mark Hounschell <markh@compro.net> wrote:
> 
>> Changes in floppy.c from 2.6.17 and 2.6.18 have broken an application I have. I have tracked 
>> it down to a single line of code. When the following patch is applied to the version in 2.6.18
>> my application works.
>>
>> --- linux-2.6.18/drivers/block/floppy.c 2006-09-19 23:42:06.000000000 -0400
>> +++ linux-2.6.18-crt/drivers/block/floppy.c     2007-05-29 09:12:20.000000000 -0400
>> @@ -893,7 +893,6 @@
>>                 set_current_state(TASK_RUNNING);
>>                 remove_wait_queue(&fdc_wait, &wait);
>>
>> -               flush_scheduled_work();
>>         }
>>         command_status = FD_COMMAND_NONE;
>>
>> I don't claim to understand the changes from 2.6.17 to 2.6.18 except for the devfs removal.
>> All I can say is this one line of code kills the application. I have tried to write a short pgm
>> that shows my problem but everything else I write seems to work. The application only runs
>> on SMP machines and uses process and irq affinities with real-time scheduling. When I turn
>> off process and irq affinities the application runs. 
>>
>> I have tried kernels up through 2.6.21.1 with the same results. All kernels from 2.6.18 up
>> require that I remove this one line of code or my application does not work?
> 
> Interesting.  I'd expect that the calling process is spinning, with realtime
> policy and is expecting some other process to do something (ie: run a workqueue).
> 
> If you keep the process and irq affinities, and disable the realtime policy
> does that also prevent the problem?
> 

Yes it does.

> It would be interesting it you could capture a few task traces while it is stuck:
> echo 1 > /proc/sys/kernel/sysrq then do ALT-SYSRQ-P a bunch of times and ALT-SYSRQ-T,
> see if you can work out where the CPU is stuck.
> 

I've attached the syslog output as a result of doing the above. I can't really make any kind of
determination from it myself as I don't really knowing what I'm looking at.

> ALso, 2.6.22-rc3 might have accidentally fixed this.
> 

No. Same thing there.  The traces attached are using 2.6.22-rc3.

Basically the main RT-process (which is a CPU bound process on processor-2) signals a
thread to do some I/O. That RT-thread (running on the other processor) does a simple 

ioctl(Q->DevSpec1, FDSETPRM, &medprm)

and there is no return from the call. That thread is hung.


Thanks 
Mark



--------------080906060209080602090106
Content-Type: text/plain;
 name="sysrq.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysrq.txt"

May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S E6513DD8     0 12647  12288 (NOTLB)
May 31 10:13:11 harley kernel:        e6513dec 00200082 00000002 e6513dd8 e6513dd4 00000000 00000000 00000000 
May 31 10:13:11 harley kernel:        00000001 e8c0c030 dbde5030 edfda2ef 00000298 00000ef0 e8c0c150 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 e6513e14 c012fc27 00200202 e6513eac e6513e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S CA655DD8     0 12648  12288 (NOTLB)
May 31 10:13:11 harley kernel:        ca655dec 00200082 00000002 ca655dd8 ca655dd4 00000000 00000000 b6c97248 
May 31 10:13:11 harley kernel:        00000001 dbde5030 dbde5a90 edfdb21a 00000298 00000f2b dbde5150 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 ca655e14 c012fc27 00200202 ca655eac ca655e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S DED1BDD8     0 12649  12288 (NOTLB)
May 31 10:13:11 harley kernel:        ded1bdec 00200082 00000002 ded1bdd8 ded1bdd4 00000000 00000060 00200206 
May 31 10:13:11 harley kernel:        00000001 dbde5a90 d629aa90 edfdbf8c 00000298 00000d72 dbde5bb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 ded1be14 c012fc27 00200202 ded1beac ded1be20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S DC153DD8     0 12650  12288 (NOTLB)
May 31 10:13:11 harley kernel:        dc153dec 00200082 00000002 dc153dd8 dc153dd4 00000000 00000060 00200206 
May 31 10:13:11 harley kernel:        00000001 d629aa90 d629a030 edfdce5a 00000298 00000ece d629abb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 dc153e14 c012fc27 00200202 dc153eac dc153e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S C8E1DDD8     0 12651  12288 (NOTLB)
May 31 10:13:11 harley kernel:        c8e1ddec 00200082 00000002 c8e1ddd8 c8e1ddd4 00000000 c199f480 dfe47d34 
May 31 10:13:11 harley kernel:        00000001 d629a030 f3bcba90 edfddd76 00000298 00000f1c d629a150 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 c8e1de14 c012fc27 00200202 c8e1deac c8e1de20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S C3F61DD8     0 12652  12288 (NOTLB)
May 31 10:13:11 harley kernel:        c3f61dec 00200082 00000002 c3f61dd8 c3f61dd4 00000000 00000060 00200206 
May 31 10:13:11 harley kernel:        00000001 f3bcba90 f75b8030 edfdebdd 00000298 00000e67 f3bcbbb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 c3f61e14 c012fc27 00200202 c3f61eac c3f61e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S C4025DD8     0 12653  12288 (NOTLB)
May 31 10:13:11 harley kernel:        c4025dec 00200082 00000002 c4025dd8 c4025dd4 00000000 f75b8030 0ddeea02 
May 31 10:13:11 harley kernel:        00000001 f75b8030 f75b8a90 edfdf9d6 00000298 00000df9 f75b8150 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 c4025e14 c012fc27 00200202 c4025eac c4025e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S F4F5DDD8     0 12654  12288 (NOTLB)
May 31 10:13:11 harley kernel:        f4f5ddec 00200082 00000002 f4f5ddd8 f4f5ddd4 00000000 f75b8a90 0df68c4e 
May 31 10:13:11 harley kernel:        00000001 f75b8a90 c4846a90 edfe094e 00000298 00000f78 f75b8bb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 f4f5de14 c012fc27 00200202 f4f5deac f4f5de20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S F1AD1DD8     0 12655  12288 (NOTLB)
May 31 10:13:11 harley kernel:        f1ad1dec 00200082 00000002 f1ad1dd8 f1ad1dd4 00000000 c4846a90 0e11dd88 
May 31 10:13:11 harley kernel:        00000001 c4846a90 dc68aa90 edfe16d9 00000298 00000d8b c4846bb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 f1ad1e14 c012fc27 00200202 f1ad1eac f1ad1e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S F0A07DD8     0 12656  12288 (NOTLB)
May 31 10:13:11 harley kernel:        f0a07dec 00200082 00000002 f0a07dd8 f0a07dd4 00000000 dc68aa90 0e2c331d 
May 31 10:13:11 harley kernel:        00000001 dc68aa90 dc68a560 edfe254f 00000298 00000e76 dc68abb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 f0a07e14 c012fc27 00200202 f0a07eac f0a07e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S F0293DD8     0 12657  12288 (NOTLB)
May 31 10:13:11 harley kernel:        f0293dec 00200082 00000002 f0293dd8 f0293dd4 00000000 00000060 00200287 
May 31 10:13:11 harley kernel:        00000001 dc68a560 f0f04a90 edfe32a3 00000298 00000d54 dc68a680 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 f0293e14 c012fc27 00200202 f0293eac f0293e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S E5C0FDD8     0 12658  12288 (NOTLB)
May 31 10:13:11 harley kernel:        e5c0fdec 00200082 00000002 e5c0fdd8 e5c0fdd4 00000000 f0f04a90 0e5de043 
May 31 10:13:11 harley kernel:        00000001 f0f04a90 dabeb030 edfe3fbd 00000298 00000d1a f0f04bb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 e5c0fe14 c012fc27 00200202 e5c0feac e5c0fe20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S F2FC3DD8     0 12659  12288 (NOTLB)
May 31 10:13:11 harley kernel:        f2fc3dec 00200082 00000002 f2fc3dd8 f2fc3dd4 00000000 dabeb030 0e76131e 
May 31 10:13:11 harley kernel:        00000001 dabeb030 dabeb560 edfe4d8c 00000298 00000dcf dabeb150 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 f2fc3e14 c012fc27 00200202 f2fc3eac f2fc3e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S E353BDD8     0 12660  12288 (NOTLB)
May 31 10:13:11 harley kernel:        e353bdec 00200082 00000002 e353bdd8 e353bdd4 00000000 dabeb560 0e8d67f3 
May 31 10:13:11 harley kernel:        00000001 dabeb560 c19f3560 edfe5a65 00000298 00000cd9 dabeb680 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 e353be14 c012fc27 00200202 e353beac e353be20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c014ee95>] find_extend_vma+0x12/0x49
May 31 10:13:11 harley kernel:  [<c012fcb6>] get_futex_key+0x6e/0x126
May 31 10:13:11 harley kernel:  [<c0130a00>] futex_wake+0xa9/0xb3
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S E5063DD8     0 12661  12288 (NOTLB)
May 31 10:13:11 harley kernel:        e5063dec 00200082 00000002 e5063dd8 e5063dd4 00000000 00000000 00000000 
May 31 10:13:11 harley kernel:        00000001 e77e8560 c032e360 0eac2c38 00000297 00002691 e77e8680 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 00097b02 ffffffff 00000000 00000000 e5063e20 c199f4b4 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c0130522>] futex_wait+0x1db/0x3bd
May 31 10:13:11 harley kernel:  [<c02a97ae>] __sched_text_start+0x73e/0x7f0
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0130a79>] do_futex+0x6f/0xf4a
May 31 10:13:11 harley kernel:  [<c02a998c>] preempt_schedule+0x3d/0x59
May 31 10:13:11 harley kernel:  [<c0115235>] migrate_task+0x46/0x74
May 31 10:13:11 harley kernel:  [<c0115fd6>] set_cpus_allowed+0x70/0x8e
May 31 10:13:11 harley kernel:  [<c0131a1c>] sys_futex+0xc8/0xda
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  [<c02a0000>] clone_policy+0x42/0xe5
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vrsx          S E6E5DB50     0 12662  12288 (NOTLB)
May 31 10:13:11 harley kernel:        e6e5db64 00200082 00000002 e6e5db50 e6e5db4c 00000000 00000000 00000000 
May 31 10:13:11 harley kernel:        00000001 e77e8a90 c032e360 fba335be 00000312 00003057 e77e8bb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 c199f480 000b83bb fffffffd 00000000 00000000 e6e5db74 000b8401 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c02aa015>] schedule_timeout+0x70/0x8d
May 31 10:13:11 harley kernel:  [<c01211af>] process_timeout+0x0/0x5
May 31 10:13:11 harley kernel:  [<c0167e1b>] do_select+0x393/0x3e0
May 31 10:13:11 harley kernel:  [<c01683a8>] __pollwait+0x0/0xac
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0113ba9>] __activate_task+0x1c/0x29
May 31 10:13:11 harley kernel:  [<c0115b1e>] try_to_wake_up+0x399/0x3a3
May 31 10:13:11 harley kernel:  [<c01299c1>] autoremove_wake_function+0x15/0x35
May 31 10:13:11 harley kernel:  [<c011377e>] __wake_up_common+0x32/0x55
May 31 10:13:11 harley kernel:  [<c0113cca>] __wake_up+0x32/0x43
May 31 10:13:11 harley kernel:  [<c0126ce0>] insert_work+0x61/0x65
May 31 10:13:11 harley kernel:  [<c02a97ae>] __sched_text_start+0x73e/0x7f0
May 31 10:13:11 harley kernel:  [<c02a97d5>] __sched_text_start+0x765/0x7f0
May 31 10:13:11 harley kernel:  [<c0115b1e>] try_to_wake_up+0x399/0x3a3
May 31 10:13:11 harley kernel:  [<c012bddd>] lock_hrtimer_base+0x15/0x2f
May 31 10:13:11 harley kernel:  [<c016cefb>] iput+0x39/0x62
May 31 10:13:11 harley kernel:  [<c012fc27>] unqueue_me+0x7c/0x84
May 31 10:13:11 harley kernel:  [<c013067c>] futex_wait+0x335/0x3bd
May 31 10:13:11 harley kernel:  [<c0113ba9>] __activate_task+0x1c/0x29
May 31 10:13:11 harley kernel:  [<c0115b1e>] try_to_wake_up+0x399/0x3a3
May 31 10:13:11 harley kernel:  [<c0168105>] core_sys_select+0x29d/0x2ba
May 31 10:13:11 harley kernel:  [<c011377e>] __wake_up_common+0x32/0x55
May 31 10:13:11 harley kernel:  [<c0113cca>] __wake_up+0x32/0x43
May 31 10:13:11 harley kernel:  [<c012f678>] wake_futex+0x3b/0x45
May 31 10:13:11 harley kernel:  [<c01318eb>] do_futex+0xee1/0xf4a
May 31 10:13:11 harley kernel:  [<c02a9817>] __sched_text_start+0x7a7/0x7f0
May 31 10:13:11 harley kernel:  [<c0113b01>] set_load_weight+0x4a/0x8e
May 31 10:13:11 harley kernel:  [<c01684f8>] sys_select+0xa4/0x187
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  =======================
May 31 10:13:11 harley kernel: vi            S DB833B50     0 12663  12276 (NOTLB)
May 31 10:13:11 harley kernel:        db833b64 00200082 00000002 db833b50 db833b4c 00000000 00000000 f706b2e0 
May 31 10:13:11 harley kernel:        00000006 e8c0ca90 c032e360 895791b6 000002ad 00005cff e8c0cbb0 c180aa80 
May 31 10:13:11 harley kernel:        00000000 dfce7c40 0009d902 fffffffd 00000000 00000000 7fffffff d2aa0140 
May 31 10:13:11 harley kernel: Call Trace:
May 31 10:13:11 harley kernel:  [<c02a9fb8>] schedule_timeout+0x13/0x8d
May 31 10:13:11 harley kernel:  [<c020942b>] tty_poll+0x56/0x63
May 31 10:13:11 harley kernel:  [<c0167e1b>] do_select+0x393/0x3e0
May 31 10:13:11 harley kernel:  [<c01683a8>] __pollwait+0x0/0xac
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<c0115b28>] default_wake_function+0x0/0xc
May 31 10:13:11 harley kernel:  [<f8901d87>] do_get_write_access+0x58d/0x5ba [jbd]
May 31 10:13:11 harley kernel:  [<f8917ab0>] __ext3_get_inode_loc+0x10f/0x2dd [ext3]
May 31 10:13:11 harley kernel:  [<f8923196>] __ext3_journal_dirty_metadata+0x16/0x3a [ext3]
May 31 10:13:11 harley kernel:  [<f8901dd5>] journal_get_write_access+0x21/0x26 [jbd]
May 31 10:13:11 harley kernel:  [<f891793b>] ext3_mark_iloc_dirty+0x27f/0x2e5 [ext3]
May 31 10:13:11 harley kernel:  [<f8917d0c>] ext3_mark_inode_dirty+0x20/0x27 [ext3]
May 31 10:13:11 harley kernel:  [<c0113cca>] __wake_up+0x32/0x43
May 31 10:13:11 harley kernel:  [<f89017ee>] journal_stop+0x294/0x2a0 [jbd]
May 31 10:13:11 harley kernel:  [<f891ef33>] __ext3_journal_stop+0x19/0x34 [ext3]
May 31 10:13:11 harley kernel:  [<f8919c14>] ext3_ordered_commit_write+0xba/0xd8 [ext3]
May 31 10:13:11 harley kernel:  [<c01477df>] __pagevec_lru_add+0x91/0x9c
May 31 10:13:11 harley kernel:  [<c0113d42>] task_rq_lock+0x31/0x58
May 31 10:13:11 harley kernel:  [<c0115b1e>] try_to_wake_up+0x399/0x3a3
May 31 10:13:11 harley kernel:  [<c02a97ae>] __sched_text_start+0x73e/0x7f0
May 31 10:13:11 harley kernel:  [<c02a97d5>] __sched_text_start+0x765/0x7f0
May 31 10:13:11 harley kernel:  [<c011377e>] __wake_up_common+0x32/0x55
May 31 10:13:11 harley kernel:  [<c0113cca>] __wake_up+0x32/0x43
May 31 10:13:11 harley kernel:  [<c0168105>] core_sys_select+0x29d/0x2ba
May 31 10:13:11 harley kernel:  [<c0113ba9>] __activate_task+0x1c/0x29
May 31 10:13:11 harley kernel:  [<c0115b1e>] try_to_wake_up+0x399/0x3a3
May 31 10:13:11 harley kernel:  [<c011377e>] __wake_up_common+0x32/0x55
May 31 10:13:11 harley kernel:  [<c0113cca>] __wake_up+0x32/0x43
May 31 10:13:11 harley kernel:  [<c02085ac>] tty_wakeup+0x4c/0x50
May 31 10:13:11 harley kernel:  [<c0113cca>] __wake_up+0x32/0x43
May 31 10:13:11 harley kernel:  [<c0208509>] tty_ldisc_deref+0x55/0x64
May 31 10:13:11 harley kernel:  [<c016852a>] sys_select+0xd6/0x187
May 31 10:13:11 harley kernel:  [<c0103d3e>] sysenter_past_esp+0x5f/0x85
May 31 10:13:11 harley kernel:  [<c02a0000>] clone_policy+0x42/0xe5
May 31 10:13:11 harley kernel:  =======================

--------------080906060209080602090106--
