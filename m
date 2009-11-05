Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZKERsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZKERsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZKERsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:48:04 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:57502 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbZKERsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:48:03 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.32-rc5-mmotm1101 - unkillable processes stuck in futex.
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257443268_2581P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Nov 2009 12:47:48 -0500
Message-ID: <5906.1257443268@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4AF30FC5.0025,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257443268_2581P
Content-Type: text/plain; charset=us-ascii

(Hmm.. I seem to be on a roll on this -mmotm, breaking all sorts of stuff.. :)

Am cc'ing Thomas and Darren because their names were attached to commits in
the origin.patch that touched futex.c

It looks like pulseaudio clients with multiple threads manage to hose up
the futex code to the point they're not kill -9'able.  Semi-replicatable,
as I've hit it twice by accident. No recipe for triggering it yet.

Did it once to gyachi (a Yahoo Messenger client) and  twice to pidgin (an
everything-else IM client). 'top' would report 100%CPU usage, all of it kernel
mode, and it was confirmed by the CPU going to top Ghz and warming up some 6-7
degrees (so we were spinning on something rather than a wait/deadlock). In both
cases, I tried to kill -9 the process, the process didn't go away.

Here's the 'alt-sysrq-t' for both cases.  I started a second pidgin the second
time around, that one wedged real fast (on the first thread it created) and
didn't get kill -9'ed (if that makes a diff in the stack trace...)

gyachi wedged up - main thread kept going, subthread hung.

[44347.339018] gyachi        ? ffff88000260e010  3856  3183   2393 0x00000080
[44347.339018]  ffff88006c3cfeb8 0000000000000046 ffff88006c3cfe80 ffff88006c3cfe7c
[44347.339018]  ffff88006c3cfe28 0000000000000000 0000000000000155 ffff88006c0dabc0
[44347.339018]  ffff88006c3ce000 000000000000e010 ffff88006c0dabc0 00000001029f3766
[44347.339018] Call Trace:
[44347.339018]  [<ffffffff8103ed89>] do_exit+0x8f7/0x906
[44347.339018]  [<ffffffff814bb838>] ? preempt_schedule+0x5e/0x67
[44347.339018]  [<ffffffff8103ee27>] do_group_exit+0x8f/0xb8
[44347.339018]  [<ffffffff8103ee62>] sys_exit_group+0x12/0x16
[44347.339018]  [<ffffffff8100246b>] system_call_fastpath+0x16/0x1b
[44347.339018] gyachi        R  running task     5344  3187   2393 0x00000084
[44347.339018]  ffff88006c2c6b40 0000000000000002 ffff88007967f988 ffffffff81066193
[44347.339018]  ffff88007967f998 ffffffff81066193 ffffffff823ceab0 0000000000000000
[44347.339018]  000000007967fab8 ffffffff814bd184 0000000000000000 ffff88007f8b0000
[44347.339018] Call Trace:
[44347.339018]  [<ffffffff81066193>] ? trace_hardirqs_on_caller+0x16/0x13c
[44347.339018]  [<ffffffff81066193>] ? trace_hardirqs_on_caller+0x16/0x13c
[44347.339018]  [<ffffffff814bd184>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[44347.339018]  [<ffffffff814be2c0>] ? restore_args+0x0/0x30
[44347.339018]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
[44347.339018]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
[44347.339018]  [<ffffffff811caa4c>] ? _raw_spin_lock+0xe9/0x1ab
[44347.339018]  [<ffffffff81030429>] ? get_parent_ip+0x11/0x41
[44347.339018]  [<ffffffff814c0df1>] ? sub_preempt_count+0x35/0x48
[44347.339018]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
[44347.339018]  [<ffffffff810692d2>] ? queue_unlock+0x1d/0x21
[44347.339018]  [<ffffffff8106939f>] ? futex_wait_setup+0xc9/0xeb
[44347.339018]  [<ffffffff8106ae9d>] ? futex_wait_requeue_pi+0x190/0x3d4
[44347.339018]  [<ffffffff814bdae1>] ? _spin_unlock_irq+0x62/0x6f
[44347.339018]  [<ffffffff814bda7a>] ? _spin_unlock_irqrestore+0x7b/0x80
[44347.339018]  [<ffffffff8102843e>] ? need_resched+0x3a/0x40
[44347.339018]  [<ffffffff814bb838>] ? preempt_schedule+0x5e/0x67
[44347.339018]  [<ffffffff814bd9fa>] ? _spin_unlock+0x65/0x6a
[44347.339018]  [<ffffffff81069afc>] ? futex_wake+0x108/0x11a
[44347.339018]  [<ffffffff8106c11f>] ? do_futex+0x95d/0x9cb
[44347.339018]  [<ffffffff8106c2d9>] ? sys_futex+0x14c/0x164
[44347.339018]  [<ffffffff810e2328>] ? path_put+0x1d/0x22
[44347.339018]  [<ffffffff8100246b>] ? system_call_fastpath+0x16/0x1b

After the reboot, it bit again, pidgin this time.  Since the main thread
is the one that wedged, it locked up hard.

[ 1730.490005] pidgin        R  running task     4112  4195   2312 0x00000084
[ 1730.490005]  ffff880068889a08 ffffffff81066193 ffff880068889b54 0000000000000000
[ 1730.490005]  ffff880068889ae8 ffff880068aa8c80 0000000000000002 0000000000000000
[ 1730.490005]  ffffffff81069189 0000000000000000 ffff880068889ab8 0000000000000246
[ 1730.490005] Call Trace:
[ 1730.490005]  [<ffffffff81066193>] ? trace_hardirqs_on_caller+0x16/0x13c
[ 1730.490005]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
[ 1730.490005]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
[ 1730.490005]  [<ffffffff814be2c0>] ? restore_args+0x0/0x30
[ 1730.490005]  [<ffffffff811caa4c>] ? _raw_spin_lock+0xe9/0x1ab
[ 1730.490005]  [<ffffffff814bd506>] ? _spin_lock+0x36/0x45
[ 1730.490005]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
[ 1730.490005]  [<ffffffff814bd9bb>] ? _spin_unlock+0x26/0x6a
[ 1730.490005]  [<ffffffff810691bf>] ? get_futex_value_locked+0x2b/0x49
[ 1730.490005]  [<ffffffff810692c9>] ? queue_unlock+0x14/0x21
[ 1730.490005]  [<ffffffff8106939f>] ? futex_wait_setup+0xc9/0xeb
[ 1730.490005]  [<ffffffff81097e34>] ? ftrace_likely_update+0xc/0x14
[ 1730.490005]  [<ffffffff8106ae9d>] ? futex_wait_requeue_pi+0x190/0x3d4
[ 1730.490005]  [<ffffffff814bdae1>] ? _spin_unlock_irq+0x62/0x6f
[ 1730.490005]  [<ffffffff814bda7a>] ? _spin_unlock_irqrestore+0x7b/0x80
[ 1730.490005]  [<ffffffff8102843e>] ? need_resched+0x3a/0x40
[ 1730.490005]  [<ffffffff814bb838>] ? preempt_schedule+0x5e/0x67
[ 1730.490005]  [<ffffffff814bd9fa>] ? _spin_unlock+0x65/0x6a
[ 1730.490005]  [<ffffffff81069afc>] ? futex_wake+0x108/0x11a
[ 1730.490005]  [<ffffffff8106c11f>] ? do_futex+0x95d/0x9cb
[ 1730.490005]  [<ffffffff8106c2d9>] ? sys_futex+0x14c/0x164
[ 1730.490005]  [<ffffffff810e2328>] ? path_put+0x1d/0x22
[ 1730.490005]  [<ffffffff8100246b>] ? system_call_fastpath+0x16/0x1b

(This is me starting another one because the first one wedged. It wedged too, but
I don't remember kill -9'ing this one...)

[ 1730.490005] pidgin        R  running task     5672  4220   2312 0x00000084
[ 1730.490005]  ffff880057ce7a18 0000000000000046 ffff8800026133c0 ffff88005410a380
[ 1730.490005]  ffff880057ce7978 ffff8800026133c0 ffff880057ce7998 ffff880057f3c4c0
[ 1730.490005]  ffff880057ce6000 000000000000e010 ffff880057f3c4c8 ffffffff81030d7e
[ 1730.490005] Call Trace:
[ 1730.490005]  [<ffffffff81030d7e>] ? finish_task_switch+0x95/0xb8
[ 1730.490005]  [<ffffffff814bd184>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1730.490005]  [<ffffffff814bb7bd>] preempt_schedule_irq+0x56/0x73
[ 1730.490005]  [<ffffffff81069189>] ? queue_lock+0x50/0x5b
[ 1730.490005]  [<ffffffff814be3d6>] retint_kernel+0x26/0x30
[ 1730.490005]  [<ffffffff81069128>] ? get_futex_key+0x24e/0x25f
[ 1730.490005]  [<ffffffff81068fa7>] ? get_futex_key+0xcd/0x25f
[ 1730.490005]  [<ffffffff814bd9f1>] ? _spin_unlock+0x5c/0x6a
[ 1730.490005]  [<ffffffff81069319>] futex_wait_setup+0x43/0xeb
[ 1730.490005]  [<ffffffff81068fa7>] ? get_futex_key+0xcd/0x25f
[ 1730.490005]  [<ffffffff8106ae9d>] futex_wait_requeue_pi+0x190/0x3d4
[ 1730.490005]  [<ffffffff814bdae1>] ? _spin_unlock_irq+0x62/0x6f
[ 1730.490005]  [<ffffffff814bda7a>] ? _spin_unlock_irqrestore+0x7b/0x80
[ 1730.490005]  [<ffffffff8102843e>] ? need_resched+0x3a/0x40
[ 1730.490005]  [<ffffffff814bb838>] ? preempt_schedule+0x5e/0x67
[ 1730.490005]  [<ffffffff814bd9fa>] ? _spin_unlock+0x65/0x6a
[ 1730.490005]  [<ffffffff81069afc>] ? futex_wake+0x108/0x11a
[ 1730.490005]  [<ffffffff8106c11f>] do_futex+0x95d/0x9cb
[ 1730.490005]  [<ffffffff811c2bd6>] ? __up_read+0x1a/0x7f
[ 1730.490005]  [<ffffffff811c2bd6>] ? __up_read+0x1a/0x7f
[ 1730.490005]  [<ffffffff811caa4c>] ? _raw_spin_lock+0xe9/0x1ab
[ 1730.490005]  [<ffffffff814c0df1>] ? sub_preempt_count+0x35/0x48
[ 1730.490005]  [<ffffffff814bda71>] ? _spin_unlock_irqrestore+0x72/0x80
[ 1730.490005]  [<ffffffff811c2c32>] ? __up_read+0x76/0x7f
[ 1730.490005]  [<ffffffff8106c2d9>] sys_futex+0x14c/0x164
[ 1730.490005]  [<ffffffff810e2328>] ? path_put+0x1d/0x22
[ 1730.490005]  [<ffffffff8100246b>] system_call_fastpath+0x16/0x1b

And the rest of the thread from the first one I started. They're all
packed up and ready to leave Dodge on the first stagecoach, but the one
thread is still stuck in the saloon and unable to find its way out...

[ 1730.490005] pidgin        ? ffff88007f872040  5568  4214   4195 0x00000080
[ 1730.490005]  ffff880054033eb8 0000000000000046 ffffffff8103ec0b ffff88007e968400
[ 1730.490005]  0000000000000011 0000000000040001 000003c700001076 ffff880057c4b280
[ 1730.490005]  ffff880054032000 000000000000e010 ffff880057c4b280 0000000000000000
[ 1730.490005] Call Trace:
[ 1730.490005]  [<ffffffff8103ec0b>] ? do_exit+0x779/0x906
[ 1730.490005]  [<ffffffff814c0df1>] ? sub_preempt_count+0x35/0x48
[ 1730.490005]  [<ffffffff8103ed89>] do_exit+0x8f7/0x906
[ 1730.490005]  [<ffffffff814bd1fa>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 1730.490005]  [<ffffffff8103ee27>] do_group_exit+0x8f/0xb8
[ 1730.490005]  [<ffffffff8103ee62>] sys_exit_group+0x12/0x16
[ 1730.490005]  [<ffffffff8100246b>] system_call_fastpath+0x16/0x1b
[ 1730.490005] pidgin        ? ffff88007f872040  5568  4215   4195 0x00000080
[ 1730.490005]  ffff880054059eb8 0000000000000046 ffffffff8103ec0b ffff88007e968400
[ 1730.490005]  0000000000000011 0000000000040001 000003c700001077 ffff8800689d0f00
[ 1730.490005]  ffff880054058000 000000000000e010 ffff8800689d0f00 0000000000000000
[ 1730.490005] Call Trace:
[ 1730.490005]  [<ffffffff8103ec0b>] ? do_exit+0x779/0x906
[ 1730.490005]  [<ffffffff814c0df1>] ? sub_preempt_count+0x35/0x48
[ 1730.490005]  [<ffffffff8103ed89>] do_exit+0x8f7/0x906
[ 1730.490005]  [<ffffffff814bd1fa>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 1730.490005]  [<ffffffff8103ee27>] do_group_exit+0x8f/0xb8
[ 1730.490005]  [<ffffffff8103ee62>] sys_exit_group+0x12/0x16
[ 1730.490005]  [<ffffffff8100246b>] system_call_fastpath+0x16/0x1b
[ 1730.490005] pidgin        ? ffff88007f872040  5568  4216   4195 0x00000080
[ 1730.490005]  ffff8800542e7eb8 0000000000000046 ffffffff8103ec0b ffff88007e968400
[ 1730.490005]  0000000000000011 0000000000040001 000003c700001078 ffff88006887ad40
[ 1730.490005]  ffff8800542e6000 000000000000e010 ffff88006887ad40 0000000000000000
[ 1730.490005] Call Trace:
[ 1730.490005]  [<ffffffff8103ec0b>] ? do_exit+0x779/0x906
[ 1730.490005]  [<ffffffff814c0df1>] ? sub_preempt_count+0x35/0x48
[ 1730.490005]  [<ffffffff8103ed89>] do_exit+0x8f7/0x906
[ 1730.490005]  [<ffffffff814bd1fa>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 1730.490005]  [<ffffffff8103ee27>] do_group_exit+0x8f/0xb8
[ 1730.490005]  [<ffffffff8103ee62>] sys_exit_group+0x12/0x16
[ 1730.490005]  [<ffffffff8100246b>] system_call_fastpath+0x16/0x1b
[ 1730.490005] pidgin        ? ffff88007f872040  5440  4217   4195 0x00000080
[ 1730.490005]  ffff880053c7deb8 0000000000000046 ffffffff8103ec0b ffff88007e968400
[ 1730.490005]  0000000000000011 0000000000040001 000003c700001079 ffff880053c7a440
[ 1730.490005]  ffff880053c7c000 000000000000e010 ffff880053c7a440 0000000000000000
[ 1730.490005] Call Trace:
[ 1730.490005]  [<ffffffff8103ec0b>] ? do_exit+0x779/0x906
[ 1730.490005]  [<ffffffff814c0df1>] ? sub_preempt_count+0x35/0x48
[ 1730.490005]  [<ffffffff8103ed89>] do_exit+0x8f7/0x906
[ 1730.490005]  [<ffffffff814bd1fa>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 1730.490005]  [<ffffffff8103ee27>] do_group_exit+0x8f/0xb8
[ 1730.490005]  [<ffffffff8103ee62>] sys_exit_group+0x12/0x16
[ 1730.490005]  [<ffffffff8100246b>] system_call_fastpath+0x16/0x1b





--==_Exmh_1257443268_2581P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8w/EcC3lWbTT17ARAtkTAKCn0gpk7o2jE8wXgHOr0EsG06fZAwCfQ71/
Bf280MS/TPMCrO1XP4nzhFU=
=l9qt
-----END PGP SIGNATURE-----

--==_Exmh_1257443268_2581P--

