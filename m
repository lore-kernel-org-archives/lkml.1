Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbXIIQbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbXIIQbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 12:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756852AbXIIQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 12:31:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:49394 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756811AbXIIQbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 12:31:38 -0400
X-Authenticated: #217404
X-Provags-ID: V01U2FsdGVkX18Fuq1k5xYF4p9s92W9Qy4wbkQqJHWuyTYrVBh9e4
	yXR5rcMYuK568K
Subject: tsc timer related problems/questions
From: Dennis Lubert <plasmahh@gmx.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 09 Sep 2007 18:31:45 +0200
Message-Id: <1189355506.6255.60.camel@speedy.projectiwear.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

we are encountering a few behaviours regarding the ways to get accurate
timer values under Linux that we would call bugs, and where we are
currently stuck in further diagnosing and/or fixing.

Background: We are developing for SMP servers with up to 8 CPUs (mostly
AMD64) and for various reasons would like to have time measurements with
a resolution of maybe a few microseconds.


- Using Kernel 2.6.20.7 and surroundings per default the TSC Timer is
used. We are very happy with that (accuracy ~400nanoseconds) but after a
while the system goes wild with the following message for each CPU:

[105771.523771] BUG: soft lockup detected on CPU#1!
[105771.527869]
[105771.527871] Call Trace:
[105771.536079]  <IRQ>  [<ffffffff802619cc>] _spin_lock+0x9/0xb
[105771.540294]  [<ffffffff802a6f9d>] softlockup_tick+0xd2/0xe7
[105771.544359]  [<ffffffff8024bcbb>] run_local_timers+0x13/0x15
[105771.548541]  [<ffffffff80289fc1>] update_process_times+0x4c/0x79
[105771.552737]  [<ffffffff80270327>] smp_local_timer_interrupt
+0x34/0x54
[105771.556934]  [<ffffffff80270834>] smp_apic_timer_interrupt+0x51/0x68
[105771.561022]  [<ffffffff80268121>] default_idle+0x0/0x42
[105771.565199]  [<ffffffff8025cce6>] apic_timer_interrupt+0x66/0x70
[105771.569386]  <EOI>  [<ffffffff8026814e>] default_idle+0x2d/0x42
[105771.573597]  [<ffffffff80247929>] enter_idle+0x22/0x24
[105771.577665]  [<ffffffff80247a92>] cpu_idle+0x5a/0x79
[105771.581838]  [<ffffffff806bc5f7>] start_secondary+0x474/0x483

Question: Is this a known bug already or should further investigation
take place?

- Using Kernels from 2.6.21 on (random sampled) we experience that the
TSC isn't used per default anymore (we usually set the nopmtimer option
at boot for a while now). Looking briefly at the 2.6.23-rc5 code shows
that in the function where the check is done whether the tsc is stable
the only code path where a "is stable" result could be returned is one
where the vendor of the CPU is detected as Intel. Instead a much slower
timesource (10ms instead of a few us resolution, same for getting the
time at all) is used which is totally unusable for us (Within 10ms so
much things happen).

Question: Why are only Intel CPUs considered as stable? Could there be
implemented a more sophisticated heuristic, that actually does some
tests for tsc stability?

- Enabling tsc explicitly as a time source via sysfs we had good results
so far, with quit good resolution, and also various tests about
synchronization between the CPUs didn't show any measurable changes in
the deviation over time.
However, once accidentally someone enabled cpufrequency scaling and
scaled down two of four CPUs. From then on the time on the slower CPU
was totally wrong, and all time displaying programs (simple date
program) showed different (hours in difference) results, depending on
which CPU they where run, so results were randomly. Programs doing a
simple usleep() could hang (likely because the time to wakeup was
gathered from another CPU whith time in the future). The system
was essentially unusable and also after setting the CPUs back to the
correct speed, things were still wrong.

Question: Is this a known problem? It looks like there is a huge problem
in synchronizing the way the time is calculated from the TSC and the cpu
frequency scaling, also something else seems to be buggy since also
after setting things back even after a few seconds only, times are off
by hours.

Is there maybe a mechanism (or could it be implemented) that
synchronizes the TSCs on demand? It usually isn't a huge problem if they
are off a few nanoseconds, maybe even a few microseconds. For quite some
programs they could even be off a few hundred microseconds, so a
synchronization every now and then could still be useful.

greets

Dennis


