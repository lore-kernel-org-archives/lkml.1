Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab0BXIDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:03:44 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52422 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0BXIDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:03:43 -0500
Message-ID: <4B84DD5D.5080001@dcl.info.waseda.ac.jp>
Date: Wed, 24 Feb 2010 17:03:41 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf sched broken on tip, bisected
References: <20100222190042.GB15854@ghostprotocols.net> <20100222190952.GD15854@ghostprotocols.net>
In-Reply-To: <20100222190952.GD15854@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/10 04:09, Arnaldo Carvalho de Melo wrote:
> While testing a patch series I'm working on I noticed that 'perf sched record ;
> perf sched latency' is broken on tip, bisected it down to this cset, investigating...
>

I couldn't reproduce your problem on tip/master ( 
ae37d2288d22938bd48b552f83d3e01c41fd42f9 ),
could you give me a pointer to your testing patch series?

> [acme@mica linux-2.6-tip]$ git bisect good
> 86d8d29634de4464d568e7c335c0da6cba64e8ab is first bad commit
> commit 86d8d29634de4464d568e7c335c0da6cba64e8ab
> Author: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
> Date:   Sat Jan 30 20:43:23 2010 +0900
>
>      perf tools: Add __data_loc support
>
>      This patch is required to test the next patch for perf lock.
>
>      At 064739bc4b3d7f424b2f25547e6611bcf0132415 ,
>      support for the modifier "__data_loc" of format is added.
>
>      But, when I wanted to parse format of lock_acquired (or some
>      event else), raw_field_ptr() did not returned correct pointer.
>
>      So I modified raw_field_ptr() like this patch. Then
>      raw_field_ptr() works well.
>
>      Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
>      Acked-by: Frederic Weisbecker<fweisbec@gmail.com>
>      Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>      Cc: Paul Mackerras<paulus@samba.org>
>      Cc: Tom Zanussi<tzanussi@gmail.com>
>      Cc: Steven Rostedt<srostedt@redhat.com>
>      LKML-Reference:<1264851813-8413-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
>      [ v3: fixed minor stylistic detail ]
>      Signed-off-by: Ingo Molnar<mingo@elte.hu>
>
> :040000 040000 8650752c9d8295e3c0ae3999b237fb86eb269e5d eb3ecfba6bfbcc80ecde51e10307fefc4d43864e M	tools
> [acme@mica linux-2.6-tip]$
>
> (gdb) run sched latency
> Starting program: /root/bin/perf sched latency
> [Thread debugging using libthread_db enabled]
> [Detaching after fork from child process 30314. (Try `set detach-on-fork off'.)]
> [New Thread 139670509008608 (LWP 30311)]
>
> Program received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 139670509008608 (LWP 30311)]
> 0x000000000040df1b in process_sched_switch_event (data=0x7f079312f9fc, session=0xcaf780, event=0xcaff50, this_cpu=3, timestamp=3964393249899, thread=0xd21ea0) at builtin-sched.c:1489
> 1489		FILL_ARRAY(switch_event, prev_comm, event, data);
> (gdb) bt
> #0  0x000000000040df1b in process_sched_switch_event (data=0x7f079312f9fc, session=0xcaf780, event=0xcaff50, this_cpu=3, timestamp=3964393249899, thread=0xd21ea0) at builtin-sched.c:1489
> #1  0x000000000040e508 in process_raw_event (raw_event=0x7f079312f9d0, session=0xcaf780, data=0x7f079312f9fc, cpu=3, timestamp=3964393249899, thread=0xd21ea0) at builtin-sched.c:1594
> #2  0x000000000040e7ec in process_sample_event (event=0x7f079312f9d0, session=0xcaf780) at builtin-sched.c:1639
> #3  0x000000000043be6f in perf_session__process_event (self=0xcaf780, event=0x7f079312f9d0, ops=0x6878e0, offset=0, head=117200) at util/session.c:298
> #4  0x000000000043c5f0 in perf_session__process_events (self=0xcaf780, ops=0x6878e0) at util/session.c:464
> #5  0x000000000040e8e0 in read_events () at builtin-sched.c:1667
> #6  0x000000000040edb7 in __cmd_lat () at builtin-sched.c:1708
> #7  0x000000000040f355 in cmd_sched (argc=1, argv=0x7fff2a064640, prefix=0x0) at builtin-sched.c:1911
> #8  0x0000000000404fdd in run_builtin (p=0x682cd0, argc=2, argv=0x7fff2a064640) at perf.c:264
> #9  0x00000000004051b3 in handle_internal_command (argc=2, argv=0x7fff2a064640) at perf.c:329
> #10 0x00000000004052f2 in run_argv (argcp=0x7fff2a064534, argv=0x7fff2a064528) at perf.c:373
> #11 0x00000000004054ce in main (argc=2, argv=0x7fff2a064640) at perf.c:457
> (gdb)
>

