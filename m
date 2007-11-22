Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbXKVMxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbXKVMxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 07:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXKVMxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 07:53:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:43157 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbXKVMxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 07:53:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LdANEUv7TnpwFiwoOLdMZ2FbceqbDzlfC5u32Ps4nAFJgkgDs0T7SVurUMAmQqykDZxmPlmddIpnvOp/p/MPri5sbbwM5R8/Xf5wAa/0etSodFTdAruvQcJJWWDfh4rn42dRqpHp8bNJom2w/bpU4h7q+6CR91wxCtOIqNPizCU=
Message-ID: <b647ffbd0711220453i15e786ubbb02c3431869048@mail.gmail.com>
Date: Thu, 22 Nov 2007 13:53:02 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Micah Dowty" <micah@vmware.com>
Subject: Re: High priority tasks break SMP balancer?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Cyrus Massoumi" <cyrusm@gmx.net>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Mike Galbraith" <efault@gmx.de>,
       "Paul Menage" <menage@google.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20071122074652.GA6502@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071116221404.GC31527@vmware.com>
	 <20071117010352.GA13666@vmware.com>
	 <b647ffbd0711171110q9f695e1qb42ba73dc23b626d@mail.gmail.com>
	 <20071119185116.GA28173@vmware.com>
	 <b647ffbd0711191422q6be59c44gfbc72f0fc3167768@mail.gmail.com>
	 <20071119230516.GC4736@vmware.com> <20071120055755.GE20436@elte.hu>
	 <20071120180643.GD4736@vmware.com>
	 <b647ffbd0711201347tedf7ac0sc6476118353feab3@mail.gmail.com>
	 <20071122074652.GA6502@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/2007, Micah Dowty <micah@vmware.com> wrote:
> On Tue, Nov 20, 2007 at 10:47:52PM +0100, Dmitry Adamushko wrote:
> > btw., what's your system? If I recall right, SD_BALANCE_NEWIDLE is on
> > by default for all configs, except for NUMA nodes.
>
> It's a dual AMD64 Opteron.
>
> So, I recompiled my 2.6.23.1 kernel without NUMA support, and with
> your patch for scheduling domain flags in /proc. It looks like with
> NUMA disabled, my test case no longer shows the CPU imbalance
> problem. Cool.
>
> With NUMA disabled (and my test running smoothly), the flags show that
> SD_BALANCE_NEWIDLE is set:
>
> root@micah-64:~# cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags
> 55
>
> Next I turned it off:
>
> root@micah-64:~# echo 53 > /proc/sys/kernel/sched_domain/cpu0/domain0/flags
> root@micah-64:~# echo 53 > /proc/sys/kernel/sched_domain/cpu1/domain0/flags
>
> Oddly enough, I still don't observe the CPU imbalance problem.

Look for the 'load_idx' variable in find_busiest_group() and how it's used.

include/linux/topology.h (+ some architectures defines additional
node-definition-structures, but that's primarily for NUMA)

There you can find : 'busy_idx', 'idle_idx' and 'newidle_idx' (amongst
others that affect load-balancing).

Those parameters specify the _source_ of load for determining the
busiest group for !CPU_IDLE, CPU_IDLE and CPU_NEWLY_IDLE cases
respectively.

when 'load_idx == 0' (say, when CPU_NEWLY_IDLE and 'newidle_idx == 0'
or when CPU_IDLE and 'idle_idx == 0') the cpu_load[] table is _not_
taken into account by {source,target}_load(), and the raw load on the
rq is considered instead. In case of CPU_NEWLY_IDLE the raw load is
always 0 (no tasks on the queue).

so for NUMA, newidle_idx = 0 and it also seems to be a generic option
for other variants on 2.6.23.1. Hence, it doesn't matter how big are
cpu_load[], they are just not taken into account.

>
> Now I reboot into a kernel which has NUMA re-enabled but which is
> otherwise identical. I verify that now I can reproduce the CPU
> imbalance again.

for NUMA, 'idle_idx != 0' (i.e. cpu_load[] is taken into account) for
the CPU_IDLE case
and
'newidle_idx == 0' (just because, SD_BALANCE_NEWIDLE is normally not
used on NUMA) for CPU_NEWLY_IDLE.

>
> root@micah-64:~# cat /proc/sys/kernel/sched_domain/cpu0/domain0/flags
> 1101
>
> Now I set cpu[10]/domain0/flags to 1099, and the imbalance immediately
> disappears. I can reliably cause the imbalance again by setting it
> back to 1101, and remove the imbalance by setting them to 1099.

I guess, you meant it to be the other way aroumd -- 1101 when it's switched on.

>
> Do these results make sense? I'm not sure I understand how
> SD_BALANCE_NEWIDLE could be the whole story, since my /proc/schedstat
> graphs do show that we continuously try to balance on idle, but we
> can't successfully do so because the idle CPU has a much higher load
> than the non-idle CPU.

(1) CPU_IDLE and idle_idx != 0 --> cpu_load[] is considered

(2) CPU_NEWIDLE and newidle_idx == 0 --> raw load is considered (which
is 0 in this case).


>  - Is this intended/expected behaviour for a machine without
>    NEWIDLE set? I'm not familiar with the rationale for disabling
>    this flag on NUMA systems.

As you may see, there are varios node's configs in
include/linux/topology.h that affects load-balancing. Migrations
between NUMA nodes can be more expensive than e.g. between cpus on
'normal' SMP, multi-core, etc. So it should be about being more
conservative when doing load-balancing on some setups.

e.g. in your particular case, what happens is smth like this:

SD_BALANCE_NEWIDLE + newidle_idx == 0

cpu #0: 2 nice(0) cpu-hogs
cpu #1: nice(-15) blocks...
cpu #1: load_balance_newidle() is triggered  (*)
cpu #1: newidle_idx == 0 so the busiest group is on cpu #0
cpu #1: nice(0) (which is != current) is pulled over to cpu #1
cpu #1: nice(0) is running untill it's preempted by nice(-15)
cpu #1: nice(-15) is running
...
in the mean time, rebalance_domain event can be triggered on
cpu #0: and due to the huge load on cpu #1, nice (0) is pulled over
(back) to the cpu #0
...
this situation may repeat again and again --> nice(0) tasks are being
pulled back and forth.

Other variants:

- the normal rebalance_domain event can be triggered at (*) and,
provided idle_idx == 0, cpu_load[] is not considered again and one of
the nice(0) can be migrated (a CPU_IDLE case).

the difference is that CPU_NEWLY_IDLE is triggered immediately after a
CPU becomes idle, while it may take some time for a normal rebalance
event (with CPU_IDLE in this case) to be triggered.

- moreover, I observed cpu_load[] from /proc/sched_debug while running
your test application and I did see from time to time cases when
cpu_load[] is low (both cpus are comparable, load-wise) on the cpu
where nice(-15) is normally running (I even used cpu_affinity to get
it bound to it)... the time for which nice(-15) is _not_ running can
be enough to degrade some of the slots of cpu_load[] back to 0...
should the rebalance_domain be triggered at this particular moment and
depending on sd->busy_idx, one of the nice(0) tasks can be migrated.

Note, different versions of kernels may have (and have) different
variants of tunings for domains, plus there can be some differences in
generic behavior of the load balancer.

>  - Is there a good way to detect, without any kernel debug flags
>    set, whether the current machine has any scheduling domains
>    that are missing the SD_BALANCE_NEWIDLE bit?

e.g. by reading its config and kernel version. But as a generic way
(sort of API for user-space), I guess, no.

> I'm looking for
>    a good way to work around the problem I'm seeing with VMware's
>    code. Right now the best I can do is disable all thread priority
>    elevation when running on an SMP machine with Linux 2.6.20 or
>    later.

why are your application depends on the load-balancer's decisions?
Maybe it's just smth wrong with its logic instead? :-/


>
> Thank you again for all your help.
> --Micah
>

-- 
Best regards,
Dmitry Adamushko
