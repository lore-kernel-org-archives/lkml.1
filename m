Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZKETWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZKETWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZKETWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:22:12 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35396 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758693AbZKETWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:22:11 -0500
Message-ID: <4AF325DE.4000901@us.ibm.com>
Date: Thu, 05 Nov 2009 11:22:06 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32-rc5-mmotm1101 - unkillable processes stuck in futex.
References: <5906.1257443268@turing-police.cc.vt.edu>
In-Reply-To: <5906.1257443268@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

Hi Valdis,

Thanks for reporting. There are a couple things of interest below, but
first: which kernel version exactly?

Specifically, do you have the following patches applied:

43746940a0067656b612490e921ee8e782f12e30 futex: Fix spurious wakeup for requeue_pi r
e814515d47b9e15ebaa08bab0559d189e8ec90eb futex: Detect mismatched requeue targets
41890f2456998c170f416fc29715fadfd57e6626 futex: Handle spurious wake up
370eaf38450c77ec9b5ce6bc74bc575b2e2ce448 futex: Revert "futex: Wake up waiter outsid
a03d103555aa7b3e0c39a9bc9608502d3354392f futex: Fix wakeup race by setting TASK_INTE

> (Hmm.. I seem to be on a roll on this -mmotm, breaking all sorts of stuff.. :)
> 
> Am cc'ing Thomas and Darren because their names were attached to commits in
> the origin.patch that touched futex.c
> 
> It looks like pulseaudio clients with multiple threads manage to hose up
> the futex code to the point they're not kill -9'able.  Semi-replicatable,
> as I've hit it twice by accident. No recipe for triggering it yet.
> 
> Did it once to gyachi (a Yahoo Messenger client) and  twice to pidgin (an
> everything-else IM client). 'top' would report 100%CPU usage, all of it kernel
> mode, and it was confirmed by the CPU going to top Ghz and warming up some 6-7
> degrees (so we were spinning on something rather than a wait/deadlock). In both
> cases, I tried to kill -9 the process, the process didn't go away.
> 
> Here's the 'alt-sysrq-t' for both cases.  I started a second pidgin the second
> time around, that one wedged real fast (on the first thread it created) and
> didn't get kill -9'ed (if that makes a diff in the stack trace...)
> 
> gyachi wedged up - main thread kept going, subthread hung.

> 
> [44347.339018] gyachi        ? ffff88000260e010  3856  3183   2393 0x00000080
> [44347.339018]  ffff88006c3cfeb8 0000000000000046 ffff88006c3cfe80 ffff88006c3cfe7c
> [44347.339018]  ffff88006c3cfe28 0000000000000000 0000000000000155 ffff88006c0dabc0
> [44347.339018]  ffff88006c3ce000 000000000000e010 ffff88006c0dabc0 00000001029f3766
> [44347.339018] Call Trace:
> [44347.339018]  [<ffffffff8103ed89>] do_exit+0x8f7/0x906
> [44347.339018]  [<ffffffff814bb838>] ? preempt_schedule+0x5e/0x67
> [44347.339018]  [<ffffffff8103ee27>] do_group_exit+0x8f/0xb8
> [44347.339018]  [<ffffffff8103ee62>] sys_exit_group+0x12/0x16
> [44347.339018]  [<ffffffff8100246b>] system_call_fastpath+0x16/0x1b
> [44347.339018] gyachi        R  running task     5344  3187   2393 0x00000084
> [44347.339018]  ffff88006c2c6b40 0000000000000002 ffff88007967f988 ffffffff81066193
> [44347.339018]  ffff88007967f998 ffffffff81066193 ffffffff823ceab0 0000000000000000
> [44347.339018]  000000007967fab8 ffffffff814bd184 0000000000000000 ffff88007f8b0000
> [44347.339018] Call Trace:
> [44347.339018]  [<ffffffff81066193>] ? trace_hardirqs_on_caller+0x16/0x13c
> [44347.339018]  [<ffffffff81066193>] ? trace_hardirqs_on_caller+0x16/0x13c
> [44347.339018]  [<ffffffff814bd184>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [44347.339018]  [<ffffffff814be2c0>] ? restore_args+0x0/0x30
> [44347.339018]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
> [44347.339018]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
> [44347.339018]  [<ffffffff811caa4c>] ? _raw_spin_lock+0xe9/0x1ab
> [44347.339018]  [<ffffffff81030429>] ? get_parent_ip+0x11/0x41
> [44347.339018]  [<ffffffff814c0df1>] ? sub_preempt_count+0x35/0x48
> [44347.339018]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
> [44347.339018]  [<ffffffff810692d2>] ? queue_unlock+0x1d/0x21
> [44347.339018]  [<ffffffff8106939f>] ? futex_wait_setup+0xc9/0xeb
> [44347.339018]  [<ffffffff8106ae9d>] ? futex_wait_requeue_pi+0x190/0x3d4

I see this a couple of times in this trace. This indicates the use of the requeue_pi feature. You shouldn't be able to use this without a not-yet-released version of glibc and applications that are using PTHREAD_PRIO_INHERIT pthread_mutexes. Neither of the apps you mentioned seem like good candidates for that. Do you have some other RT workload running?

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
