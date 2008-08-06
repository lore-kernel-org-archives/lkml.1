Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbYHFMRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbYHFMRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYHFMR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:17:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:44586 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753717AbYHFMRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:17:25 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18pHVkc81UpJRtKJWSVWJZgiKmT+rHKwYzHpK+ov4
	vQKtx6zaC5QM2o
Date: Wed, 6 Aug 2008 14:16:50 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com
Subject: Oops when accessing /proc/lockdep_chains
Message-ID: <20080806121650.GA3119@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26 (x86_64)
X-Uptime: 14:12:30 up 1 day, 22:55,  1 user,  load average: 0.25, 0.38, 0.50
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

with current -git (aka -rc2) i sometime get the following oops
when doing a cat /proc/lockdep_chains
The other /proc/lockdep* files dont cause any errors

I dont get it after a fresh reboot :| But was able to reproduce it when
running my testscripts, I'll try to narrow it down.

[  584.458673] BUG: unable to handle kernel paging request at d1a27580
[  584.459010] IP: [<c049403e>] strnlen+0xe/0x20
[  584.459340] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  584.459596] Modules linked in: [last unloaded: rcutorture]
[  584.459923] 
[  584.460038] Pid: 9047, comm: cat Not tainted (2.6.27-rc2 #26)
[  584.460245] EIP: 0060:[<c049403e>] EFLAGS: 00010297 CPU: 0
[  584.460394] EIP is at strnlen+0xe/0x20
[  584.460532] EAX: d1a27580 EBX: c86efca8 ECX: d1a27580 EDX: fffffffe
[  584.460682] ESI: 00000000 EDI: c86f0000 EBP: c87fdce8 ESP: c87fdce8
[  584.460890]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  584.461035] Process cat (pid: 9047, ti=c87fd000 task=c87d2420 task.ti=c87fd000)
[  584.461193] Stack: c87fdd04 c0493036 c010317c d1a27580 c86efca8 00000000 c87fde5c c87fde34 
[  584.462138]        c0493457 ffffffff ffffffff 00000000 ffffffff ffffffff 00000000 00000358 
[  584.463021]        c86efca8 ffffffff c86f0000 ffffffff ffffffff ffffffff 0000000f c0a3b725 
[  584.463964] Call Trace:
[  584.464173]  [<c0493036>] ? string+0x26/0xa0
[  584.464510]  [<c010317c>] ? restore_nocheck_notrace+0x0/0xe
[  584.464859]  [<c0493457>] ? vsnprintf+0x3a7/0x6a0
[  584.465141]  [<c04940ac>] ? trace_hardirqs_on_thunk+0xc/0x10
[  584.465219]  [<c01059de>] ? do_softirq+0x3e/0xb0
[  584.465219]  [<c010317c>] ? restore_nocheck_notrace+0x0/0xe
[  584.465219]  [<c04934c4>] ? vsnprintf+0x414/0x6a0
[  584.465219]  [<c0149837>] ? __lock_acquire+0x257/0xe50
[  584.465219]  [<c01b46c2>] ? seq_printf+0x32/0x60
[  584.465219]  [<c014aa81>] ? print_name+0x31/0xb0
[  584.465219]  [<c0149260>] ? mark_held_locks+0x40/0x80
[  584.465219]  [<c01494ab>] ? trace_hardirqs_on+0xb/0x10
[  584.465219]  [<c0149409>] ? trace_hardirqs_on_caller+0xc9/0x160
[  584.465219]  [<c0830f64>] ? __mutex_lock_common+0x1e4/0x2e0
[  584.465219]  [<c01b4c1a>] ? seq_read+0x2a/0x2a0
[  584.465219]  [<c01b46c2>] ? seq_printf+0x32/0x60
[  584.465219]  [<c014ab6f>] ? lc_show+0x6f/0xc0
[  584.465219]  [<c01b4d5f>] ? seq_read+0x16f/0x2a0
[  584.465219]  [<c01b4bf0>] ? seq_read+0x0/0x2a0
[  584.465219]  [<c01d58f2>] ? proc_reg_read+0x62/0x90
[  584.465219]  [<c0199269>] ? vfs_read+0x99/0x160
[  584.465219]  [<c01d5890>] ? proc_reg_read+0x0/0x90
[  584.465219]  [<c0199842>] ? sys_read+0x42/0x70
[  584.465219]  [<c0103059>] ? sysenter_do_call+0x12/0x31
[  584.465219]  =======================
[  584.465219] Code: 57 0f 1f 44 00 00 85 c9 89 c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f 5d c3 90 8d 74 26 00 55 89 e5 0f 1f 44 00 00 89 c1 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 55 89 e5 
[  584.465219] EIP: [<c049403e>] strnlen+0xe/0x20 SS:ESP 0068:c87fdce8
[  584.465219] ---[ end trace 560310b80b6f2ef3 ]---

[  657.508210] BUG: unable to handle kernel paging request at d1a27580
[  657.508546] IP: [<c049403e>] strnlen+0xe/0x20
[  657.508827] *pde = 0ef53067 *pte = 00000000 
[  657.509067] Oops: 0000 [#2] DEBUG_PAGEALLOC
[  657.509364] Modules linked in: [last unloaded: rcutorture]
[  657.509382] 
[  657.509382] Pid: 14555, comm: cat Tainted: G      D   (2.6.27-rc2 #26)
[  657.509382] EIP: 0060:[<c049403e>] EFLAGS: 00010297 CPU: 0
[  657.509382] EIP is at strnlen+0xe/0x20
[  657.509382] EAX: d1a27580 EBX: c86ef36c ECX: d1a27580 EDX: fffffffe
[  657.509382] ESI: 00000000 EDI: c86f0000 EBP: c867fce8 ESP: c867fce8
[  657.509382]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  657.509382] Process cat (pid: 14555, ti=c867f000 task=c86a4420 task.ti=c867f000)
[  657.509382] Stack: c867fd04 c0493036 00000000 d1a27580 c86ef36c 00000000 c867fe5c c867fe34 
[  657.509382]        c0493457 ffffffff ffffffff 00000000 00000000 c867fd44 00000046 00000c94 
[  657.509382]        c86ef36c ffffffff c86f0000 ffffffff ffffffff ffffffff 0000000f c0a3b725 
[  657.509382] Call Trace:
[  657.509382]  [<c0493036>] ? string+0x26/0xa0
[  657.509382]  [<c0493457>] ? vsnprintf+0x3a7/0x6a0
[  657.509382]  [<c012417b>] ? try_to_wake_up+0x6b/0xf0
[  657.509382]  [<c04934c4>] ? vsnprintf+0x414/0x6a0
[  657.509382]  [<c0514aed>] ? n_tty_receive_buf+0x63d/0x1230
[  657.509382]  [<c01189ff>] ? __change_page_attr_set_clr+0xcf/0x4e0
[  657.509382]  [<c0164ef0>] ? handle_level_irq+0x0/0xd0
[  657.509382]  [<c0146d84>] ? trace_hardirqs_off_caller+0x14/0xa0
[  657.509382]  [<c01b46c2>] ? seq_printf+0x32/0x60
[  657.509382]  [<c014aa81>] ? print_name+0x31/0xb0
[  657.509382]  [<c0146d84>] ? trace_hardirqs_off_caller+0x14/0xa0
[  657.509382]  [<c0149355>] ? trace_hardirqs_on_caller+0x15/0x160
[  657.509382]  [<c0830f64>] ? __mutex_lock_common+0x1e4/0x2e0
[  657.509382]  [<c01b4c1a>] ? seq_read+0x2a/0x2a0
[  657.509382]  [<c01b46c2>] ? seq_printf+0x32/0x60
[  657.509382]  [<c014ab6f>] ? lc_show+0x6f/0xc0
[  657.509382]  [<c01b4d5f>] ? seq_read+0x16f/0x2a0
[  657.509382]  [<c01b4bf0>] ? seq_read+0x0/0x2a0
[  657.509382]  [<c01d58f2>] ? proc_reg_read+0x62/0x90
[  657.509382]  [<c0199269>] ? vfs_read+0x99/0x160
[  657.509382]  [<c01d5890>] ? proc_reg_read+0x0/0x90
[  657.509382]  [<c0199842>] ? sys_read+0x42/0x70
[  657.509382]  [<c0103059>] ? sysenter_do_call+0x12/0x31
[  657.509382]  [<c0124abf>] ? __cleanup_sighand+0x1f/0x30
[  657.509382]  =======================
[  657.509382] Code: 57 0f 1f 44 00 00 85 c9 89 c7 89 d0 74 05 f2 ae 75 01 4f 89 f8 5f 5d c3 90 8d 74 26 00 55 89 e5 0f 1f 44 00 00 89 c1 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 55 89 e5 
[  657.509382] EIP: [<c049403e>] strnlen+0xe/0x20 SS:ESP 0068:c867fce8
[  657.510433] ---[ end trace 560310b80b6f2ef3 ]---



Greetings, Eric
