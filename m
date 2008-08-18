Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbYHRS5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbYHRS5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761267AbYHRSz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:55:56 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:45836 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757723AbYHRSzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:55:54 -0400
Message-ID: <48A9BDC0.9070800@gawab.com>
Date: Mon, 18 Aug 2008 11:21:52 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Greg KH <gregkh@suse.de>,
       Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: Backport hr-tick fix into .25/.26
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Since the introduction of 2.6.25-rc1 kernel I've been experiencing 
screen blanking during boot up.
I've reported this issue before (http://lkml.org/lkml/2008/3/12/290), 
and Rafael Wysocki opened a bug report 
(http://bugzilla.kernel.org/show_bug.cgi?id=10235).
Since the problem seemed to be related to the x server, I reported it to 
their bug tracker (https://bugs.freedesktop.org/show_bug.cgi?id=15602).

I've tested with 2 computers, both with Intel graphic cards and various 
versions of Ubuntu. Sorry, I couldn't do more testing :(
I know of one other person that ran into what seems to be the same bug. 
(http://lkml.org/lkml/2008/6/10/137 | 
http://bugzilla.kernel.org/show_bug.cgi?id=10892)

Now since 2.6.27-rc1 the bug has been resolved. I did a git bisect and 
found both the commit that introduced the bug and also the one that 
fixed it.
Greg (and stable team), I was wondering if the commit that went into .27 
that fixed the bug could be backported into both the .25 and .26 stable 
kernels?


This commit introduced the bug.

commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Jan 25 21:08:29 2008 +0100

sched: high-res preemption tick

Use HR-timers (when available) to deliver an accurate preemption tick.

The regular scheduler tick that runs at 1/HZ can be too coarse when nice 
level
are used. The fairness system will still keep the cpu utilisation 'fair' by
then delaying the task that got an excessive amount of CPU time but try to
minimize this by delivering preemption points spot-on.

The average frequency of this extra interrupt is sched_latency / nr_latency.
Which need not be higher than 1/HZ, its just that the distribution 
within the
sched_latency period is important.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 ab225228500f7a19d5ad20ca12ca3fc8ff5f5ad1 
f1742e1d225a72aecea9d6961ed989b5943d31d8 M arch
:040000 040000 25d85e4ef7a71b0cc76801a2526ebeb4dce180fe 
ae61510186b4fad708ef0211ac169decba16d4e5 M include
:040000 040000 9247cec7dd506c648ac027c17e5a07145aa41b26 
950832cc1dc4d30923f593ecec883a06b45d62e9 M kernel


And this one fixed it

commit 31656519e132f6612584815f128c83976a9aaaef
Author: Peter Zijlstra <peterz@infradead.org>
Date: Fri Jul 18 18:01:23 2008 +0200

sched, x86: clean up hrtick implementation

random uvesafb failures were reported against Gentoo:

http://bugs.gentoo.org/show_bug.cgi?id=222799

and Mihai Moldovan bisected it back to:

 > 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
 > commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
 > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
 > Date: Fri Jan 25 21:08:29 2008 +0100
 >
 > sched: high-res preemption tick

Linus suspected it to be hrtick + vm86 interaction and observed:

 > Btw, Peter, Ingo: I think that commit is doing bad things. They aren't
 > _incorrect_ per se, but they are definitely bad.
 >
 > Why?
 >
 > Using random _TIF_WORK_MASK flags is really impolite for doing
 > "scheduling" work. There's a reason that arch/x86/kernel/entry_32.S
 > special-cases the _TIF_NEED_RESCHED flag: we don't want to exit out of
 > vm86 mode unnecessarily.
 >
 > See the "work_notifysig_v86" label, and how it does that
 > "save_v86_state()" thing etc etc.

Right, I never liked having to fiddle with those TIF flags. Initially I
needed it because the hrtimer base lock could not nest in the rq lock.
That however is fixed these days.

Currently the only reason left to fiddle with the TIF flags is remote
wakeups. We cannot program a remote cpu's hrtimer. I've been thinking
about using the new and improved IPI function call stuff to implement
hrtimer_start_on().

However that does require that smp_call_function_single(.wait=0) works
from interrupt context - /me looks at the latest series from Jens - Yes
that does seem to be supported, good.

Here's a stab at cleaning this stuff up ...

Mihai reported test success as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Mihai Moldovan <ionic@ionic.de>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 5ae152350652713c58bd1700ba2c776a556b6985 
40d22771987dc5814a1e18aa3cee82ae9e4faea5 M arch
:040000 040000 4dfe3c6abd244d2da57b7801e47f073899124376 
3863e3311a21dc049d5ad98f45c272e4a5269a2b M include
:040000 040000 236b2824be1c7cf3c899a090498e4151543bba31 
9f9779c89b781d8fa8950468deee42f419339bd7 M kernel

Justin Madru
