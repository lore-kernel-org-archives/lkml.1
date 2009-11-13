Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZKMAOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZKMAOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 19:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZKMAOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 19:14:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbZKMAOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 19:14:06 -0500
Subject: Re: RT wakeup woes in Linux 2.6.31.6 on Mac Mini
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Greg Steuck <greg@nest.cx>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <a27c0c970911121552w63f63baew93d06336b39816a5@mail.gmail.com>
References: <a27c0c970911121552w63f63baew93d06336b39816a5@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 12 Nov 2009 19:14:08 -0500
Message-Id: <1258071249.22249.72.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you tried the -rt kernel?

http://rt.wiki.kernel.org/index.php/Main_Page

On Thu, 2009-11-12 at 15:52 -0800, Greg Steuck wrote:
> Hello kernel gurus,
> 
> I would appreciate some ideas about reducing wakeup latency for our
> real time application. The write up below identifies 3 seemingly
> different cases of our task not getting to run long after it is woken
> up.
> 
> We have a real-timish requirement for feeding a hardware device on
> time. To achieve this goal we run a userspace program with SCHED_FIFO
> at priority 99. We also set CPU affinity with sys_sched_setaffinity
> inside our driver program (rxtest) to get a dedicated core (#1). We
> change the affinity of all user processes (i.e. non-kernel threads) on
> the system to stay on the other core (#0). Then we ran a bunch of
> experiments with wakeup ftrace tracer enabled. Here is the script we
> ran:
> 
> sudo mount -t debugfs nodev /sys/kernel/debug
> cd /sys/kernel/debug/tracing
> 
> while : ; do
>   sudo sh -c '
>       echo wakeup > current_tracer

I think you want "wakeup_rt", since that ignores SCHED_OTHER tasks.
SCHED_OTHER may wake up poorly, and hide the results of your RT task.

>       echo 0 > tracing_max_latency
>       echo 2 > tracing_cpumask
>       echo 1 > tracing_enabled
>       chrt -f 99 ~/rxtest -logtostderr 2>&1
>       echo 0 > tracing_enabled
>       cat trace > ~/trace.$$'
> done | tee ~/tracing-wakeup-latency
> 
> There was some decent disk activity to keep the machine busy while the
> script was running (rsync copying kernel source directory). We ran the
> experiment some 15000 times and observed the average wakeup latency of
> about 276 microseconds. There are however a few outliers that would be
> nice to understand.

If you are not running the -rt kernel, vanilla Linux will give lots of
outliers.

> 
>  Latency (us)	Trace log file
>  612	trace.1029
>  900	trace.13653
>  922	trace.6039
> 
> The attachments at http://sites.google.com/a/nest.cx/public/rtwakeup
> have machine configuration and full traces. Belows are excerpts from
> the trace files:
> 
> % egrep '[+!]' trace.*
> trace.1029:  <idle>-0       1d.s.    0us :      0:140:R   + [001]
> 1030:  0:S rxtest
> trace.1029:  <idle>-0       1.Nh.   80us+: mii_rw <-nv_update_linkspeed
> trace.1029:  <idle>-0       1.Nh.   85us+: delay_tsc <-__delay
> trace.1029:  <idle>-0       1.Nh.   97us+: delay_tsc <-__delay
> trace.1029:  <idle>-0       1.Nh.  109us+: delay_tsc <-__delay
> trace.1029:  <idle>-0       1.Nh.  120us+: delay_tsc <-__delay

Looks like NEED_RESCHED is set, but interrupts are disabled. This is
typical for vanilla linux. I really suggest trying out the latest -rt
patch.

You can get it here:

http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31.6-rt19.bz2

You can also use my version of ketchup.

~$ wget http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
~$ mv ketchup-0.9.8-rt3 ketchup
~$ chmod +x ketchup
~$ mkdir tmp
~$ cd tmp
tmp$ ../ketchup -r -G -f 2.6.31.6-rt19
tmp$ cd .
linux-2.6.31.6-rt19$ 

-- Steve

> ...
> trace.13653:kblockd/-65      1d.s.    0us :     65:115:R   + [001]
> 13654:  0:S rxtest
> trace.13653:kblockd/-65      1dN..  130us+: kmem_cache_alloc
> <-mempool_alloc_slab
> trace.13653:kblockd/-65      1dN..  132us+: blk_rq_map_sg <-scsi_init_sgtable
> trace.13653:kblockd/-65      1dN..  200us+: blk_rq_map_sg <-scsi_init_sgtable
> trace.13653:kblockd/-65      1dN..  264us+: ata_tf_to_fis <-ahci_qc_prep
> trace.13653:kblockd/-65      1dN..  289us+: blk_rq_map_sg <-scsi_init_sgtable
> trace.13653:kblockd/-65      1dN..  349us+: ata_tf_to_fis <-ahci_qc_prep
> ...
> trace.6039: pdflush-5162    1d.s.    0us :   5162:120:R   + [001]
> 6040:  0:S rxtest
> trace.6039: pdflush-5162    1dN..   61us+: idle_cpu <-irq_exit
> trace.6039: pdflush-5162    1dN..  130us!: idle_cpu <-irq_exit
> trace.6039: pdflush-5162    1dN..  273us!: idle_cpu <-irq_exit
> 
> Thanks
> Greg

