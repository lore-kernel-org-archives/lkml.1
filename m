Return-Path: <linux-kernel-owner+w=401wt.eu-S1762324AbYEHLOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324AbYEHLOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 07:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYEHLOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 07:14:04 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60673 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754134AbYEHLOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 07:14:01 -0400
Subject: Re: CONFIG_PRINTK_TIME broken on git HEAD ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4822DD4E.3010000@googlemail.com>
References: <48222C7C.2050807@googlemail.com>
	 <20080507154155.2b472bb1.akpm@linux-foundation.org>
	 <482233CD.70502@googlemail.com>  <4822DD4E.3010000@googlemail.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:13:58 +0200
Message-Id: <1210245238.13978.199.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-08 at 13:00 +0200, Gabriel C wrote:

> >>From my log 2.6.26-rc1-00065-g5717922 was fine.
> > 
>  
> > May  6 00:13:14 thor kernel: [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
> > May  6 00:13:14 thor kernel: [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> > May  6 00:13:14 thor kernel: [    0.000000] PERCPU: Allocating 41732 bytes of per cpu data
> > May  6 00:13:14 thor kernel: [    0.000000] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
> > May  6 00:13:14 thor kernel: [    0.000000] Preemptible RCU implementation.
> > May  6 00:13:14 thor kernel: [    0.000000] Extended CMOS year: 2000
> > May  6 00:13:14 thor kernel: [    0.000000] TSC calibrated against PM_TIMER
> > May  6 00:13:14 thor kernel: [    0.000014] time.c: Detected 2499.952 MHz processor.
> > May  6 00:13:14 thor kernel: [    0.000032] console [tty0] enabled
> > May  6 00:13:14 thor kernel: [    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> > May  6 00:13:14 thor kernel: [    0.000999] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> > May  6 00:13:14 thor kernel: [    0.000999] Checking aperture...
> > 
> > ...
> > 
> >>> dmesg shows here :
> >>>
> >>> ...
> >>>
> >>>
> >>> [    0.000000] Allocating PCI resources starting at d0000000 (gap: cf600000:2f800000)
> >>> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> >>> [    0.000000] PERCPU: Allocating 42756 bytes of per cpu data
> >>> [    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
> >>> [4294014.506571] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010753
> >>> [4294014.506571] Kernel command line: root=/dev/sdb1 ro debug vga=0x317
> >>> [4294014.506571] Initializing CPU#0
> >>> [4294014.506571] Preemptible RCU implementation.
> >>> [4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes) 


> I've bisected it.

> cat ./.git/refs/bisect/bad
> 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
> 
>  git show 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
>  commit 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd
>  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
>  Date:   Sat May 3 18:29:28 2008 +0200
>  
>      sched: add optional support for CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
>  
>      this replaces the rq->clock stuff (and possibly cpu_clock()).
>  
>       - architectures that have an 'imperfect' hardware clock can set
>         CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
>  
>       - the 'jiffie' window might be superfulous when we update tick_gtod
>         before the __update_sched_clock() call in sched_clock_tick()
>  
>       - cpu_clock() might be implemented as:
>  
>           sched_clock_cpu(smp_processor_id())
>  
>         if the accuracy proves good enough - how far can TSC drift in a
>         single jiffie when considering the filtering and idle hooks?
>  
>      [ mingo@elte.hu: various fixes and cleanups ]
>  
>      Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>      Signed-off-by: Ingo Molnar <mingo@elte.hu>
>                                                                                                                                                              

Ok, so the issue is that the clock doesn't start at 0, but at:
4294014.506571 ?

I guess that's a side-effect of using ktime to base the clock off.
Thomas, do we have a clock that is uptime based?


