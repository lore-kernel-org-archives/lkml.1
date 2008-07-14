Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYGNWis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYGNWis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYGNWii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:38:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:30378 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbYGNWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IDWmzWE8PhGmEPO0XxHU12ghh/63RKKDnkax8rrUXewZwEUuRpxukf2wyk6A+0Nq78
         nTx8D2owx3RPfpSo2zF4ln3rMOV9qW0gZ0feuw2of4Jt2KDsAbHXxSKDTesUMVXHKxRm
         lNPb/ouZLV32cfwT7wdPAQ4ELvOuc5cy86aXg=
Message-ID: <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
Date: Tue, 15 Jul 2008 00:38:36 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008, Linus Torvalds wrote:
> [ ... ]
>
> Btw - the way to avoid this whole problem might be to make CPU migration
> use a *different* CPU map than "online".
>
> This patch almost certainly doesn't work, but let me explain:
>
>  - "cpu_online_map" is the CPU's that can be currently be running
>
>   It is enabled/disabled by low-level architecture code when the CPU
>   actually gets disabled.
>
>  - Add a new "cpu_active_map", which is the CPU's that are currently fully
>   set up, and can not just be running tasks, but can be _migrated_ to!
>
>  - We can always just clear the "cpu_active_map" entry when we start a CPU
>   down event - that guarantees that while tasks may be running on it,
>   there won't be any _new_ tasks migrated to it.

(please correct me if I misinterpreted your point)

cpu_clear(cpu, cpu_active_map); _alone_ does not guarantee that after
its completion, no new tasks can appear on (be migrated to) 'cpu'.

cpu_clear() may race against migration operations which are already in
progress on other CPUs : executing right after a check for
!cpu_active(cpu) and before doing actual migration [*]

Am I missing something?

[  If no, then what I dare to say below is that: (a) with only
cpu_clear(cpu, cpu_active_map) in cpu_down(), "cpu_active_map" is
perhaps not much better than (alternatively) using existing
"cpu_online_map" to check if a task can be migrated to 'cpu' _and_ (b)
there are also a few (rough) speculations on how to fix [*] ]

New tasks may appear on (soon-to-be-dead) 'cpu' at any point until
_cpu_down() calls

__stop_machine_run() -> [ next is called by 'kstopmachine' ] do_stop()
-> stop_machine()

stop_machine() starts a RT high-prio thread on each online cpu and
waits until these threads get scheduled in (take control of cpus).
That guarantees a re-schedule on each CPU has taken place.
In turn, it means none of the CPUs are in the middle of task-migration
operation [**] and further task-migration operations can not race
against cpu_down() -> cpu_clear() (in a sense, stop_machine() is a
synchronization point).

[**] migration operations are done with rq->lock being held.

OTOH, cpu_clear(cpu, cpu_online_map) takes place right after
stop_machine() : do_stop() -> take_cpu_down() (via smdata->fn()) ->
__cpu_disable().

Let's imagine we update all places in the scheduler where
task-migration may take place with a check for either
(a) !cpu_active(cpu) _or_ (b) cpu_offline(cpu) :

then for both cases new tasks may apear on 'cpu' for which cpu_down()
is in progress and for both cases - until __stop_machine_run() -> ...
-> stop_machine() gets called.

Hm?

In any case, the scheduler does not depend on sched-domains to do
migration and migration to offline cpus is not possible (although,
it's possible to soon-to-be-offline cpus), but OTOH we depend on
internals of __stop_machine_run() [ it acts as a sync. point ].

To solve both, we might introduce a special synchronization point
right after cpu_clear(cpu, cpu_active_map) gets called in cpu_down().

[ simplest (probably stupid) approaches ]

(a)

per-cpu rw_lock, readers' part is taken by task-migration code,
writer's part is in cpu_down():

rw_write_lock(per_cpu(migration_lock, cpu)); cpu_clear(cpu,
cpu_active_map); rw_write_unlock(...);

(b)

add rq->migration counter (per-cpu)

inc(rq->migration);
if (cpu_active(dst_cpu))
        do_migration(dst_cpu);
dec(rq->migration);

cpu_active_sync(cpu)
{
for_each_online_cpu:
   while (rq->migration) { cpu_relax(); }
}

(c)

per-cpu "migration_counter" so per_cpu(migration_counter, dst_cpu)
gets +1 while a migration operation _to_ this cpu is in progress and
then

cpu_active_sync(to_be_offline_cpu)
{
   while (per_cpu(migration_counter, to_be_offline_cpu) != 0) { cpu_relax(); }
}


-- 
Best regards,
Dmitry Adamushko
