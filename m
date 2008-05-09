Return-Path: <linux-kernel-owner+w=401wt.eu-S1762420AbYEIDAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762420AbYEIDAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 23:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbYEIDAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 23:00:41 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48385 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbYEIDAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 23:00:39 -0400
Date: Thu, 8 May 2008 22:59:56 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Hugh Dickins <hugh@veritas.com>
Cc: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Possible regression?  2.6.26-rc1: T61s failure after
	suspend/resume
Message-ID: <20080509025956.GC8871@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Hugh Dickins <hugh@veritas.com>, Glauber Costa <gcosta@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <E1JuCBA-0002NZ-4E@closure.thunk.org> <Pine.LNX.4.64.0805082148060.3994@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805082148060.3994@blonde.site>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 10:48:57PM +0100, Hugh Dickins wrote:
> It's such a good signature, but I've failed to make progress with it.
> Ted, please try doing the same (and check your logs for existing
> segfault messages): let's see if you get the same number ;)
> though I've no idea what it'd tell us.

I cant say see any such segfaults.  The only ones in my logs are
these, and they seem to be correlated to right after a system boot:

May  5 09:35:02 closure kernel: [ 2249.245926] hald-addon-keyb[8631]: segfault at fffffffd ip b7e827bc sp bffcf1a8 error 4 in libc-2.6.1.so[b7e15000+144000]
May  5 09:35:02 closure kernel: [ 2249.252562] hald-addon-keyb[8630]: segfault at fffffffd ip b7dcf7bc sp bf81b9d8 error 4 in libc-2.6.1.so[b7d62000+144000]

I did find this, but it was from an attempt to do a bisect (see
below).  In this case the system lasted half-way through the boot
sequence (although not before the X server started) before it crashed.
I'm beginning to think that "git bisecting" in the middle of the merge
window just doesn't work well because some people aren't adequately
checking to make sure the their patch series are "git bisectable" in
terms of being bootable between arbitrary patches in their series.  So
what I plan to do when I have a spare 10-15 hours is to fetch the git
id's from patch-2.6.25-git*.id, which should hopefully represent
somewhat more likely-to-bootable git bisection points, and try to do a
git bisect using those points to see if the resulting kernels are a
bit more likely to last long enough so I can test for this particular
regression.

       	       	    	      	- Ted

P.S.  The "-numa" is due to a mistake that crept in via one of the
patch trees (and which set -LOCALVERSION in the top-level Makefile; it
got reverted later.)


[    2.097917] 
[    2.097919] =================================
[    2.098059] [ INFO: inconsistent lock state ]
[    2.098136] 2.6.25-numa-04462-g10c993a #23
[    2.098209] ---------------------------------
[    2.098284] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[    2.098359] swapper/0 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    2.098434]  (&rq->rq_lock_key){++..}, at: [sched_clock_idle_wakeup_event+67/116] sched_clock_idle_wakeup_event+0x43/0x74
[    2.098753] {in-hardirq-W} state was registered at:
[    2.098833]   [__lock_acquire+1023/2834] __lock_acquire+0x3ff/0xb12
[    2.099082]   [lock_acquire+106/144] lock_acquire+0x6a/0x90
[    2.099329]   [_spin_lock+28/73] _spin_lock+0x1c/0x49
[    2.099590]   [scheduler_tick+67/443] scheduler_tick+0x43/0x1bb
[    2.099836]   [update_process_times+61/73] update_process_times+0x3d/0x49
[    2.100083]   [tick_periodic+102/114] tick_periodic+0x66/0x72
[    2.100327]   [tick_handle_periodic+25/106] tick_handle_periodic+0x19/0x6a
[    2.100574]   [timer_interrupt+72/115] timer_interrupt+0x48/0x73
[    2.100822]   [handle_IRQ_event+26/79] handle_IRQ_event+0x1a/0x4f
[    2.101064]   [handle_level_irq+127/202] handle_level_irq+0x7f/0xca
[    2.101316]   [do_IRQ+169/210] do_IRQ+0xa9/0xd2
[    2.101563]   [<ffffffff>] 0xffffffff
[    2.101806] irq event stamp: 1772935
[    2.101883] hardirqs last  enabled at (1772935): [native_sched_clock+231/255] native_sched_clock+0xe7/0xff
[    2.102091] hardirqs last disabled at (1772934): [native_sched_clock+109/255] native_sched_clock+0x6d/0xff
[    2.102298] softirqs last  enabled at (1772496): [__do_softirq+249/255] __do_softirq+0xf9/0xff
[    2.102501] softirqs last disabled at (1772491): [do_softirq+113/206] do_softirq+0x71/0xce
[    2.102708] 
[    2.102709] other info that might help us debug this:
[    2.102850] no locks held by swapper/0.
[    2.102923] 
[    2.102924] stack backtrace:
[    2.103067] Pid: 0, comm: swapper Not tainted 2.6.25-numa-04462-g10c993a #23
[    2.103145]  [print_usage_bug+263/276] print_usage_bug+0x107/0x114
[    2.103278]  [mark_lock+491/924] mark_lock+0x1eb/0x39c
[    2.103417]  [__lock_acquire+1140/2834] __lock_acquire+0x474/0xb12
[    2.103547]  [restore_nocheck+18/21] ? restore_nocheck+0x12/0x15
[    2.103740]  [native_sched_clock+231/255] ? native_sched_clock+0xe7/0xff
[    2.103929]  [lock_acquire+106/144] lock_acquire+0x6a/0x90
[    2.104065]  [sched_clock_idle_wakeup_event+67/116] ? sched_clock_idle_wakeup_event+0x43/0x74
[    2.104255]  [_spin_lock+28/73] _spin_lock+0x1c/0x49
[    2.104392]  [sched_clock_idle_wakeup_event+67/116] ? sched_clock_idle_wakeup_event+0x43/0x74
[    2.104582]  [sched_clock_idle_wakeup_event+67/116] sched_clock_idle_wakeup_event+0x43/0x74
[    2.104715]  [<f886c3b3>] acpi_idle_enter_simple+0x19a/0x21b [processor]
[    2.104858]  [<f886bfa5>] acpi_idle_enter_bm+0xbe/0x332 [processor]
[    2.104999]  [cpuidle_idle_call+99/143] cpuidle_idle_call+0x63/0x8f
[    2.105135]  [cpuidle_idle_call+0/143] ? cpuidle_idle_call+0x0/0x8f
[    2.105330]  [cpu_idle+182/214] cpu_idle+0xb6/0xd6
[    2.105463]  [rest_init+73/75] rest_init+0x49/0x4b
[    2.105596]  =======================
