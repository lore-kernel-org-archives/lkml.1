Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbYKYQxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbYKYQxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYKYQww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:52:52 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43624 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752292AbYKYQwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:52:51 -0500
Message-ID: <492C2D61.2050406@sgi.com>
Date: Tue, 25 Nov 2008 08:52:49 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Fix locking error caused by e76bd8d9850c2296a7e8e24c9dce9b5e6b55fe2f
References: <200811250238.53883.rusty@rustcorp.com.au> <200811250957.52031.rusty@rustcorp.com.au> <200811250958.41573.rusty@rustcorp.com.au> <200811250959.20652.rusty@rustcorp.com.au>
In-Reply-To: <200811250959.20652.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> We can't call cpuset_cpus_allowed_locked() with the rq lock held.
> However, the rq lock merely protects us from (1) cpu_online_mask changing
> and (2) someone else changing p->cpus_allowed.
> 
> The first can't happen because we're being called from a cpu hotplug
> notifier.  The second doesn't really matter: we are forcing the task off
> a CPU it was affine to, so we're not doing very well anyway.
> 
> So we remove the rq lock from this path, and all is good.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Tested-by: Mike Travis <travis@sgi.com>

 112# ./offline-test
possible cpus: 0-3, last cpu: 3
=== 0 > /sys/devices/system/cpu/cpu1/online
=== 0 > /sys/devices/system/cpu/cpu2/online
=== 0 > /sys/devices/system/cpu/cpu3/online
online cpus: 0, last cpu: 0
=== 1 > /sys/devices/system/cpu/cpu1/online
=== 1 > /sys/devices/system/cpu/cpu2/online
=== 1 > /sys/devices/system/cpu/cpu3/online

[ 1142.012421] numa_remove_cpu cpu 1 node 0: mask now 0
[ 1142.013646] CPU 1 is now offline
[ 1143.050422] numa_remove_cpu cpu 2 node 1: mask now 3
[ 1143.051661] CPU 2 is now offline
[ 1144.089438] numa_remove_cpu cpu 3 node 1: mask now
[ 1144.090661] CPU 3 is now offline
[ 1144.115065] SMP alternatives: switching to UP code


[ 1145.234266] SMP alternatives: switching to SMP code
[ 1145.370548] Booting processor 1 APIC 0x1 ip 0x6000
[ 1142.038605] Initializing CPU#1
[ 1142.038605] Calibrating delay using timer specific routine.. 4000.04 BogoMIPS (lpj=2000023)
[ 1142.038605] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[ 1142.038605] CPU: L2 Cache: 1024K (64 bytes/line)
[ 1142.038605] CPU 1/0x1 -> Node 0
[ 1142.038605] CPU: Physical Processor ID: 0
[ 1142.038605] CPU: Processor Core ID: 1
[ 1142.038605] numa_add_cpu cpu 1 node 0: mask now 0-1
[ 1142.038605] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[ 1145.455476] CPU1: <7>Switched to high resolution mode on CPU 1
[ 1145.610706] Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
[ 1146.637468] Booting processor 2 APIC 0x2 ip 0x6000
[ 1143.076576] Initializing CPU#2
[ 1143.076576] Calibrating delay using timer specific routine.. 4000.09 BogoMIPS (lpj=2000049)
[ 1143.076576] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[ 1143.076576] CPU: L2 Cache: 1024K (64 bytes/line)
[ 1143.076576] CPU 2/0x2 -> Node 1
[ 1143.076576] CPU: Physical Processor ID: 1
[ 1143.076576] CPU: Processor Core ID: 0
[ 1143.076576] numa_add_cpu cpu 2 node 1: mask now 2
[ 1143.076576] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[ 1146.722688] CPU2: <7>Switched to high resolution mode on CPU 2
[ 1146.877389] Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
[ 1147.903780] Booting processor 3 APIC 0x3 ip 0x6000
[ 1144.223262] Initializing CPU#3
[ 1144.223262] Calibrating delay using timer specific routine.. 4000.07 BogoMIPS (lpj=2000035)
[ 1144.223262] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[ 1144.223262] CPU: L2 Cache: 1024K (64 bytes/line)
[ 1144.223262] CPU 3/0x3 -> Node 1
[ 1144.223262] CPU: Physical Processor ID: 1
[ 1144.223262] CPU: Processor Core ID: 1
[ 1144.223262] numa_add_cpu cpu 3 node 1: mask now 2-3
[ 1144.223262] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[ 1147.988822] CPU3: <7>Switched to high resolution mode on CPU 3
[ 1148.144178] Dual-Core AMD Opteron(tm) Processor 2212 stepping 02


>  113# cat offline-test
#!/bin/bash

get_cpus()
{
        local which=$1; shift
        local list=$(cat /sys/devices/system/cpu/$which)
        local last=${list#0-}

        echo "$which cpus: $list, last cpu: $last" >/dev/stderr
        echo $last
}

set_cpu()
{
        local i state
        for ((i = 1; i <= $2; i++ ))
        do
                state=$(cat /sys/devices/system/cpu/cpu$i/online)
                [ $state != $1 ] && {
                        echo === "$1 > /sys/devices/system/cpu/cpu$i/online"
                        echo $1 > /sys/devices/system/cpu/cpu$i/online
                        sleep 1
                }
        done
}

typeset last=$(get_cpus possible)

set_cpu 0 $last

typeset ignore=$(get_cpus online)

set_cpu 1 $last

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1aa840a..7acf95f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6126,7 +6126,6 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int 
> dest_cpu)
>   */
>  static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
>  {
> -	unsigned long flags;
>  	struct rq *rq;
>  	int dest_cpu;
>  	/* FIXME: Use cpumask_of_node here. */
> @@ -6146,10 +6145,8 @@ again:
>  
>  	/* No more Mr. Nice Guy. */
>  	if (dest_cpu >= nr_cpu_ids) {
> -		rq = task_rq_lock(p, &flags);
>  		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
>  		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
> -		task_rq_unlock(rq, &flags);
>  
>  		/*
>  		 * Don't tell them about moving exiting tasks or

