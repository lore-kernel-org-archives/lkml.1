Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbYJWSQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbYJWSQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758082AbYJWSP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:15:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073AbYJWSPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:15:55 -0400
To: =?us-ascii?Q?=3D=3FISO-8859-1=3FQ=3FFr=3DE9d=3DE9ric=5FWeisbecker=3F?=
	 =?us-ascii?Q?=3D?= <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Steven Rostedt" <rostedt@goodmis.org>, systemtap@sources.redhat.com
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock tracer
References: <48F10B0B.406@gmail.com>
	<c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 23 Oct 2008 14:15:25 -0400
In-Reply-To: <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com> (fweisbec@gmail.com's message of "Tue, 21 Oct 2008 14:28:52 +0200")
Message-ID: <y0mmygv18le.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Introduce the Big Kernel Lock tracer.
>> This new tracer lets one to observe the latencies caused
>> by the lock_kernel() function.
>> It captures the time when the task request the spinlock,
>> the time when the spinlock is hold and the time it is released.
>> This way we can measure the latency for a task that wait for this
>> spinlock and the latency caused by the time this lock is hold.

For comparison, this is how this sort of analysis may be done with
systemtap, just for fun collecting locking latency on a
per-locker/unlocker (stack traceback) basis.  We don't have the stack
traceback extended right into userspace yet, but will before too long.


% cat bkl.stp
probe kernel.function("lock_kernel") {
        locker=backtrace()
        locktime=gettimeofday_us()
}

probe kernel.function("lock_kernel").return {
        unlocktime=gettimeofday_us()
        delay = unlocktime-locktime
        lockhistory[locker,unlocker] <<< delay
}

probe kernel.function("unlock_kernel") {
        unlocker=backtrace()
}

global locker, unlocker, locktime, lockhistory

probe end,timer.s(30) { // interrupt any time; automatic ending in 30s
        foreach ([l,u] in lockhistory+) { // in increasing order of @count()

                println("locker:") print_stack (l)
                println("unlocker:") print_stack (u)

                println(@hist_log (lockhistory[l,u]))

                if (@max (lockhistory[l,u]) > 100)
                   println("--- holy cow, that can take a long time ---")
        }
        exit()
}



% sudo stap bkl.stp
[...]
locker:
 0xffffffff812bdcec : lock_kernel+0x1/0x37 [kernel]
 0xffffffff812bf12b : kretprobe_trampoline_holder+0x4/0x50 [kernel]
 0xffffffff811b067b : write_chan+0x273/0x338 [kernel]
 0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
 0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
 0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
 0x00000ffffffff810
unlocker:
 0xffffffff812bdca9 : unlock_kernel+0x1/0x31 [kernel]
 0xffffffff811b064e : write_chan+0x246/0x338 [kernel]
 0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
 0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
 0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
 0xffffffff810b6f89 : vfs_write+0xae/0x157 [kernel]
 0x00000fffffffff7f
value |-------------------------------------------------- count
    0 |                                                     3
    1 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    570
    2 |@@@@@@@@@@@@@                                      159
    4 |                                                     9
    8 |@                                                   16
   16 |                                                     3
   32 |@@                                                  35
   64 |                                                     5
  128 |                                                     0
  256 |                                                     0

locker:
 0xffffffff812bdcec : lock_kernel+0x1/0x37 [kernel]
 0xffffffff812bf12b : kretprobe_trampoline_holder+0x4/0x50 [kernel]
 0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
 0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
 0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
 0xffffffff810b6f89 : vfs_write+0xae/0x157 [kernel]
 0x00000fffffffff7f
unlocker:
 0xffffffff812bdca9 : unlock_kernel+0x1/0x31 [kernel]
 0xffffffff811b064e : write_chan+0x246/0x338 [kernel]
 0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
 0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
 0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
 0xffffffff810b6f89 : vfs_write+0xae/0x157 [kernel]
 0x00000fffffffff7f
value |-------------------------------------------------- count
    0 |                                                     0
    1 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      454
    2 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  497
    4 |@@                                                  21
    8 |@                                                   15
   16 |                                                     1
   32 |@@@                                                 33
   64 |                                                     2
  128 |                                                     0
  256 |                                                     0



NB: Observed lock times in the 1-2 us range indicate no contention, as
that's on the order of magnitude of the (un)lock_kernel kprobe
overheads.


- FChE
