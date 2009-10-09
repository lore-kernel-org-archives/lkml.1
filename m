Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbZJJAAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbZJJAAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932972AbZJJAAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:00:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:32841 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbZJJAAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:00:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.32-rc3-mmotm1009 - lockdep warning during very early boot...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255132725_2897P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Oct 2009 19:58:45 -0400
Message-ID: <15469.1255132725@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.38.202 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4ACFCE36.008E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255132725_2897P
Content-Type: text/plain; charset=us-ascii

Found this in dmesg. It's reproducible, I've hit it on 3 out of 3 boots so far.
Will bisect if nobody fesses up before Monday, but I'm guessing one of these
as they poke at the clocksource code:

commit 66b1a72ceaa7da811db025855f19482f0a38e815
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Sep 10 19:39:52 2009 +0200

    Revert "clocksource: Resolve cpu hotplug dead lock with TSC unstable"

    This reverts commit 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16.

    causes crashes.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

commit 6fcf67b4c2a4ac4beda87acc7b6e78d9e26b2047
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Sep 3 19:50:16 2009 +0200

    Revert "x86: Make tsc=reliable override boot time stability checks"

    This reverts commit d3b8f889a220aed825accc28eb64ce283a0d51ac.


[    0.330445] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.333157] Switching to clocksource hpet
[    0.333157] 
[    0.333157] =======================================================
[    0.333157] [ INFO: possible circular locking dependency detected ]
[    0.333157] 2.6.32-rc3-mmotm1009 #1
[    0.333157] -------------------------------------------------------
[    0.333157] swapper/1 is trying to acquire lock:
[    0.333157]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810443a2>] cpu_maps_update_begin+0x12/0x14
[    0.333157] 
[    0.333157] but task is already holding lock:
[    0.333157]  (setup_lock){+.+.+.}, at: [<ffffffff810803a5>] stop_machine_create+0x12/0x9b
[    0.333172] 
[    0.333173] which lock already depends on the new lock.
[    0.333174] 
[    0.333183] 
[    0.333183] the existing dependency chain (in reverse order) is:
[    0.333192] 
[    0.333192] -> #3 (setup_lock){+.+.+.}:
[    0.333203]        [<ffffffff8106f6f4>] __lock_acquire+0xb35/0xcdd
[    0.333213]        [<ffffffff8106f967>] lock_acquire+0xcb/0xe8
[    0.333222]        [<ffffffff814ba993>] __mutex_lock_common+0x59/0x583
[    0.333234]        [<ffffffff814baf63>] mutex_lock_nested+0x34/0x39
[    0.333243]        [<ffffffff810803a5>] stop_machine_create+0x12/0x9b
[    0.333253]        [<ffffffff81080449>] stop_machine+0x1b/0x4e
[    0.333263]        [<ffffffff810660de>] timekeeping_notify+0x1e/0x25
[    0.333275]        [<ffffffff81067253>] clocksource_select+0xbd/0xc5
[    0.333285]        [<ffffffff818563d1>] clocksource_done_booting+0x28/0x38
[    0.333298]        [<ffffffff8100905f>] do_one_initcall+0x59/0x14e
[    0.333309]        [<ffffffff81843659>] kernel_init+0x14c/0x1a2
[    0.333320]        [<ffffffff8100c35a>] child_rip+0xa/0x20
[    0.333331] 
[    0.333331] -> #2 (clocksource_mutex){+.+.+.}:
[    0.333343]        [<ffffffff8106f6f4>] __lock_acquire+0xb35/0xcdd
[    0.333353]        [<ffffffff8106f967>] lock_acquire+0xcb/0xe8
[    0.333363]        [<ffffffff814ba993>] __mutex_lock_common+0x59/0x583
[    0.333373]        [<ffffffff814baf63>] mutex_lock_nested+0x34/0x39
[    0.333383]        [<ffffffff8106744c>] clocksource_change_rating+0x1b/0x37
[    0.333394]        [<ffffffff810113fd>] mark_tsc_unstable+0x3f/0x4d
[    0.333405]        [<ffffffff814b5bc6>] check_tsc_sync_source+0xc8/0x10d
[    0.333417]        [<ffffffff814b58e1>] native_cpu_up+0xfb/0x13e
[    0.333427]        [<ffffffff814b6d90>] _cpu_up+0xa8/0x14a
[    0.333437]        [<ffffffff814b6e8d>] cpu_up+0x5b/0x68
[    0.333447]        [<ffffffff818435bf>] kernel_init+0xb2/0x1a2
[    0.333457]        [<ffffffff8100c35a>] child_rip+0xa/0x20
[    0.333466] 
[    0.333467] -> #1 (cpu_hotplug.lock){+.+.+.}:
[    0.333478]        [<ffffffff8106f6f4>] __lock_acquire+0xb35/0xcdd
[    0.333489]        [<ffffffff8106f967>] lock_acquire+0xcb/0xe8
[    0.333498]        [<ffffffff814ba993>] __mutex_lock_common+0x59/0x583
[    0.333509]        [<ffffffff814baf63>] mutex_lock_nested+0x34/0x39
[    0.333519]        [<ffffffff810443dd>] cpu_hotplug_begin+0x27/0x68
[    0.333529]        [<ffffffff814b6d40>] _cpu_up+0x58/0x14a
[    0.333538]        [<ffffffff814b6e8d>] cpu_up+0x5b/0x68
[    0.333548]        [<ffffffff818435bf>] kernel_init+0xb2/0x1a2
[    0.333558]        [<ffffffff8100c35a>] child_rip+0xa/0x20
[    0.333567] 
[    0.333568] -> #0 (cpu_add_remove_lock){+.+.+.}:
[    0.333580]        [<ffffffff8106f59e>] __lock_acquire+0x9df/0xcdd
[    0.333590]        [<ffffffff8106f967>] lock_acquire+0xcb/0xe8
[    0.333600]        [<ffffffff814ba993>] __mutex_lock_common+0x59/0x583
[    0.333610]        [<ffffffff814baf63>] mutex_lock_nested+0x34/0x39
[    0.333620]        [<ffffffff810443a2>] cpu_maps_update_begin+0x12/0x14
[    0.333631]        [<ffffffff8105a36a>] __create_workqueue_key+0x146/0x1f4
[    0.333643]        [<ffffffff810803cd>] stop_machine_create+0x3a/0x9b
[    0.333653]        [<ffffffff81080449>] stop_machine+0x1b/0x4e
[    0.333663]        [<ffffffff810660de>] timekeeping_notify+0x1e/0x25
[    0.333673]        [<ffffffff81067253>] clocksource_select+0xbd/0xc5
[    0.333683]        [<ffffffff818563d1>] clocksource_done_booting+0x28/0x38
[    0.333694]        [<ffffffff8100905f>] do_one_initcall+0x59/0x14e
[    0.333705]        [<ffffffff81843659>] kernel_init+0x14c/0x1a2
[    0.333715]        [<ffffffff8100c35a>] child_rip+0xa/0x20
[    0.333724] 
[    0.333725] other info that might help us debug this:
[    0.333727] 
[    0.333737] 2 locks held by swapper/1:
[    0.333743]  #0:  (clocksource_mutex){+.+.+.}, at: [<ffffffff818563cc>] clocksource_done_booting+0x23/0x38
[    0.333761]  #1:  (setup_lock){+.+.+.}, at: [<ffffffff810803a5>] stop_machine_create+0x12/0x9b
[    0.333778] 
[    0.333779] stack backtrace:
[    0.333787] Pid: 1, comm: swapper Not tainted 2.6.32-rc3-mmotm1009 #1
[    0.333795] Call Trace:
[    0.333802]  [<ffffffff8106e79c>] print_circular_bug+0xa8/0xb7
[    0.333812]  [<ffffffff8106f59e>] __lock_acquire+0x9df/0xcdd
[    0.333822]  [<ffffffff814bae20>] ? __mutex_lock_common+0x4e6/0x583
[    0.333832]  [<ffffffff810443a2>] ? cpu_maps_update_begin+0x12/0x14
[    0.333842]  [<ffffffff8106f967>] lock_acquire+0xcb/0xe8
[    0.333851]  [<ffffffff810443a2>] ? cpu_maps_update_begin+0x12/0x14
[    0.333861]  [<ffffffff814ba993>] __mutex_lock_common+0x59/0x583
[    0.333871]  [<ffffffff810443a2>] ? cpu_maps_update_begin+0x12/0x14
[    0.333881]  [<ffffffff814ba74d>] ? mutex_unlock+0x9/0xb
[    0.333891]  [<ffffffff810de209>] ? pcpu_alloc+0x7c6/0x7e0
[    0.333901]  [<ffffffff8106de88>] ? mark_held_locks+0x52/0x70
[    0.333910]  [<ffffffff810443a2>] ? cpu_maps_update_begin+0x12/0x14
[    0.333920]  [<ffffffff8106e0ed>] ? trace_hardirqs_on_caller+0x118/0x13c
[    0.333930]  [<ffffffff814baf63>] mutex_lock_nested+0x34/0x39
[    0.333940]  [<ffffffff810443a2>] cpu_maps_update_begin+0x12/0x14
[    0.333950]  [<ffffffff8105a36a>] __create_workqueue_key+0x146/0x1f4
[    0.333960]  [<ffffffff810659c8>] ? change_clocksource+0x0/0x5b
[    0.333970]  [<ffffffff810803cd>] stop_machine_create+0x3a/0x9b
[    0.333980]  [<ffffffff81080449>] stop_machine+0x1b/0x4e
[    0.333990]  [<ffffffff810660de>] timekeeping_notify+0x1e/0x25
[    0.333999]  [<ffffffff81067253>] clocksource_select+0xbd/0xc5
[    0.333999]  [<ffffffff818563a9>] ? clocksource_done_booting+0x0/0x38
[    0.333999]  [<ffffffff818563d1>] clocksource_done_booting+0x28/0x38
[    0.333999]  [<ffffffff8100905f>] do_one_initcall+0x59/0x14e
[    0.333999]  [<ffffffff81843659>] kernel_init+0x14c/0x1a2
[    0.333999]  [<ffffffff8100c35a>] child_rip+0xa/0x20
[    0.333999]  [<ffffffff8100bcc0>] ? restore_args+0x0/0x30
[    0.333999]  [<ffffffff8184350d>] ? kernel_init+0x0/0x1a2
[    0.333999]  [<ffffffff8100c350>] ? child_rip+0x0/0x20
[    0.336435] Warning: could not register annotated branches stats



--==_Exmh_1255132725_2897P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKz841cC3lWbTT17ARAoOxAJ9d0+rWcdhnx4rQ9Gq9BnVcG2Sz8wCgu9LG
2wOISyb4BlaeSYpQcpiX00Q=
=CY0q
-----END PGP SIGNATURE-----

--==_Exmh_1255132725_2897P--

