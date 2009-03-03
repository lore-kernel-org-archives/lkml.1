Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbZCCCuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbZCCCuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZCCCtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:49:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:45606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbZCCCty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:49:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,293,1233561600"; 
   d="scan'208";a="116047678"
Date: Tue, 3 Mar 2009 10:49:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: lockdep: possible fasync_lock/f_lock irq lock inversion dependency
Message-ID: <20090303024900.GA24473@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get a lockdep warning on HP 6910p:

[  313.825353]
[  313.825356] =========================================================
[  313.825375] [ INFO: possible irq lock inversion dependency detected ]
[  313.825385] 2.6.29-rc5-next-20090220 #62
[  313.825393] ---------------------------------------------------------
[  313.825401] swapper/0 just changed the state of lock:
[  313.825409]  (fasync_lock){.-....}, at: [<ffffffff810ec9ae>] kill_fasync+0x2e/0x60
[  313.825443] but this lock took another, HARDIRQ-READ-irq-unsafe lock in the past:
[  313.825451]  (&f->f_lock){+.+...}
[  313.825464]
[  313.825465] and interrupts could create inverse lock ordering between them.
[  313.825468]
[  313.825484]
[  313.825486] other info that might help us debug this:
[  313.825497] 4 locks held by swapper/0:
[  313.825504]  #0:  (&serio->lock){-.-...}, at: [<ffffffff8134afa1>] serio_interrupt+0x31/0xa0
[  313.825539]  #1:  (&dev->event_lock){-.-...}, at: [<ffffffff8134fffc>] input_event+0x5c/0xa0
[  313.825570]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff8134e570>] input_pass_event+0x0/0xf0
[  313.825600]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff813538d0>] evdev_event+0x0/0x120
[  313.825630]
[  313.825632] the first lock's dependencies:
[  313.825642] -> (fasync_lock){.-....} ops: 0 {
[  313.825671]    IN-HARDIRQ-R at:
[  313.825684]                                        [<ffffffffffffffff>] 0xffffffffffffffff
[  313.825705]    INITIAL USE at:
[  313.825717]                                       [<ffffffff8106f7f0>] __lock_acquire+0x1a0/0x1ad0
[  313.825735]                                       [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.825752]                                       [<ffffffff81472d2d>] _write_lock_irq+0x3d/0x80
[  313.825769]                                       [<ffffffff810ec414>] fasync_helper+0x34/0x180
[  313.825786]                                       [<ffffffff81268435>] tty_fasync+0x85/0x160
[  313.825802]                                       [<ffffffff8126b316>] tty_release_dev+0x86/0x580
[  313.825819]                                       [<ffffffff8126b829>] tty_release+0x19/0x30
[  313.825834]                                       [<ffffffff810dfef5>] __fput+0xd5/0x230
[  313.825851]                                       [<ffffffff810e006d>] fput+0x1d/0x30
[  313.825866]                                       [<ffffffff810dc6cb>] filp_close+0x5b/0x90
[  313.825882]                                       [<ffffffff810dc7b9>] sys_close+0xb9/0x120
[  313.825897]                                       [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.825916]                                       [<ffffffffffffffff>] 0xffffffffffffffff
[  313.825931]  }
[  313.825939]  ... key      at: [<ffffffff81671cf8>] fasync_lock+0x18/0x40
[  313.825958]  -> (&f->f_lock){+.+...} ops: 0 {
[  313.825987]     HARDIRQ-ON-W at:
[  313.826009]                                          [<ffffffff81070175>] __lock_acquire+0xb25/0x1ad0
[  313.826026]                                          [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.826043]                                          [<ffffffff81472a01>] _spin_lock+0x31/0x70
[  313.826058]                                          [<ffffffff810ecf1f>] sys_fcntl+0x31f/0x470
[  313.826074]                                          [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.826091]                                          [<ffffffffffffffff>] 0xffffffffffffffff
[  313.826107]     SOFTIRQ-ON-W at:
[  313.826118]                                          [<ffffffff810701a0>] __lock_acquire+0xb50/0x1ad0
[  313.826136]                                          [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.826151]                                          [<ffffffff81472a01>] _spin_lock+0x31/0x70
[  313.826168]                                          [<ffffffff810ecf1f>] sys_fcntl+0x31f/0x470
[  313.826183]                                          [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.826200]                                          [<ffffffffffffffff>] 0xffffffffffffffff
[  313.826215]     INITIAL USE at:
[  313.826227]                                         [<ffffffff8106f7f0>] __lock_acquire+0x1a0/0x1ad0
[  313.826243]                                         [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.826259]                                         [<ffffffff81472a01>] _spin_lock+0x31/0x70
[  313.826274]                                         [<ffffffff810ec466>] fasync_helper+0x86/0x180
[  313.826291]                                         [<ffffffff81268435>] tty_fasync+0x85/0x160
[  313.826306]                                         [<ffffffff8126b316>] tty_release_dev+0x86/0x580
[  313.826323]                                         [<ffffffff8126b829>] tty_release+0x19/0x30
[  313.826338]                                         [<ffffffff810dfef5>] __fput+0xd5/0x230
[  313.826355]                                         [<ffffffff810e006d>] fput+0x1d/0x30
[  313.826370]                                         [<ffffffff810dc6cb>] filp_close+0x5b/0x90
[  313.826386]                                         [<ffffffff810dc7b9>] sys_close+0xb9/0x120
[  313.826401]                                         [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.826419]                                         [<ffffffffffffffff>] 0xffffffffffffffff
[  313.826434]   }
[  313.826441]   ... key      at: [<ffffffff82127568>] __key.22001+0x0/0x8
[  313.826459]  ... acquired at:
[  313.826465]    [<ffffffff810708ec>] __lock_acquire+0x129c/0x1ad0
[  313.826482]    [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.826496]    [<ffffffff81472a01>] _spin_lock+0x31/0x70
[  313.826511]    [<ffffffff810ec466>] fasync_helper+0x86/0x180
[  313.826525]    [<ffffffff81268435>] tty_fasync+0x85/0x160
[  313.826539]    [<ffffffff8126b316>] tty_release_dev+0x86/0x580
[  313.826554]    [<ffffffff8126b829>] tty_release+0x19/0x30
[  313.826569]    [<ffffffff810dfef5>] __fput+0xd5/0x230
[  313.826583]    [<ffffffff810e006d>] fput+0x1d/0x30
[  313.826597]    [<ffffffff810dc6cb>] filp_close+0x5b/0x90
[  313.826611]    [<ffffffff810dc7b9>] sys_close+0xb9/0x120
[  313.826625]    [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.826641]    [<ffffffffffffffff>] 0xffffffffffffffff
[  313.826655]
[  313.826661]
[  313.826663] the second lock's dependencies:
[  313.826673] -> (&f->f_lock){+.+...} ops: 0 {
[  313.826700]    HARDIRQ-ON-W at:
[  313.826711]                                        [<ffffffff81070175>] __lock_acquire+0xb25/0x1ad0
[  313.826728]                                        [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.826743]                                        [<ffffffff81472a01>] _spin_lock+0x31/0x70
[  313.826759]                                        [<ffffffff810ecf1f>] sys_fcntl+0x31f/0x470
[  313.826774]                                        [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.826792]                                        [<ffffffffffffffff>] 0xffffffffffffffff
[  313.826806]    SOFTIRQ-ON-W at:
[  313.826819]                                        [<ffffffff810701a0>] __lock_acquire+0xb50/0x1ad0
[  313.826834]                                        [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.826851]                                        [<ffffffff81472a01>] _spin_lock+0x31/0x70
[  313.826866]                                        [<ffffffff810ecf1f>] sys_fcntl+0x31f/0x470
[  313.826881]                                        [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.826898]                                        [<ffffffffffffffff>] 0xffffffffffffffff
[  313.826914]    INITIAL USE at:
[  313.826925]                                       [<ffffffff8106f7f0>] __lock_acquire+0x1a0/0x1ad0
[  313.826951]                                       [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.826966]                                       [<ffffffff81472a01>] _spin_lock+0x31/0x70
[  313.826982]                                       [<ffffffff810ec466>] fasync_helper+0x86/0x180
[  313.826997]                                       [<ffffffff81268435>] tty_fasync+0x85/0x160
[  313.827013]                                       [<ffffffff8126b316>] tty_release_dev+0x86/0x580
[  313.827028]                                       [<ffffffff8126b829>] tty_release+0x19/0x30
[  313.827045]                                       [<ffffffff810dfef5>] __fput+0xd5/0x230
[  313.827060]                                       [<ffffffff810e006d>] fput+0x1d/0x30
[  313.827076]                                       [<ffffffff810dc6cb>] filp_close+0x5b/0x90
[  313.827090]                                       [<ffffffff810dc7b9>] sys_close+0xb9/0x120
[  313.827106]                                       [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b
[  313.827123]                                       [<ffffffffffffffff>] 0xffffffffffffffff
[  313.827138]  }
[  313.827146]  ... key      at: [<ffffffff82127568>] __key.22001+0x0/0x8
[  313.827163]
[  313.827164] stack backtrace:
[  313.827176] Pid: 0, comm: swapper Not tainted 2.6.29-rc5-next-20090220 #62
[  313.827184] Call Trace:
[  313.827315]  <IRQ>  [<ffffffff8106eae1>] print_irq_inversion_bug+0x161/0x1d0
[  313.827340]  [<ffffffff8106ebcd>] check_usage_forwards+0x7d/0xc0
[  313.827352]  [<ffffffff8106de62>] mark_lock+0x212/0x6e0
[  313.827364]  [<ffffffff8106eb50>] ? check_usage_forwards+0x0/0xc0
[  313.827375]  [<ffffffff8107030f>] __lock_acquire+0xcbf/0x1ad0
[  313.827388]  [<ffffffff81071184>] lock_acquire+0x64/0x90
[  313.827399]  [<ffffffff810ec9ae>] ? kill_fasync+0x2e/0x60
[  313.827410]  [<ffffffff81473004>] _read_lock+0x34/0x70
[  313.827421]  [<ffffffff810ec9ae>] ? kill_fasync+0x2e/0x60
[  313.827432]  [<ffffffff810ec9ae>] kill_fasync+0x2e/0x60
[  313.827444]  [<ffffffff81353566>] evdev_pass_event+0x86/0xa0
[  313.827455]  [<ffffffff8135394a>] evdev_event+0x7a/0x120
[  313.827466]  [<ffffffff813538d0>] ? evdev_event+0x0/0x120
[  313.827477]  [<ffffffff8134e5da>] input_pass_event+0x6a/0xf0
[  313.827488]  [<ffffffff8134e570>] ? input_pass_event+0x0/0xf0
[  313.827499]  [<ffffffff8134fad2>] input_handle_event+0x92/0x460
[  313.827510]  [<ffffffff81350026>] input_event+0x86/0xa0
[  313.827523]  [<ffffffff81359395>] synaptics_process_byte+0x4d5/0x8c0
[  313.827536]  [<ffffffff813572b2>] psmouse_handle_byte+0x12/0x120
[  313.827548]  [<ffffffff813582fb>] psmouse_interrupt+0xdb/0x2d0
[  313.827560]  [<ffffffff8134afa1>] ? serio_interrupt+0x31/0xa0
[  313.827572]  [<ffffffff8134afbd>] serio_interrupt+0x4d/0xa0
[  313.827582]  [<ffffffff8134c1ce>] i8042_interrupt+0xce/0x280
[  313.827594]  [<ffffffff8108f025>] handle_IRQ_event+0x35/0x70
[  313.827606]  [<ffffffff81090a41>] handle_edge_irq+0xc1/0x160
[  313.827618]  [<ffffffff8100ed9e>] handle_irq+0x4e/0xd0
[  313.827628]  [<ffffffff8100e43a>] do_IRQ+0x6a/0xf0
[  313.827640]  [<ffffffff8100ce93>] ret_from_intr+0x0/0x16
[  313.827648]  <EOI>  [<ffffffff81257694>] ? acpi_idle_enter_c1+0xad/0x103
[  313.827673]  [<ffffffff8125768e>] ? acpi_idle_enter_c1+0xa7/0x103
[  313.827685]  [<ffffffff8136a765>] ? cpuidle_idle_call+0xa5/0x100
[  313.827697]  [<ffffffff8100b616>] ? cpu_idle+0x76/0xd0
[  313.827709]  [<ffffffff8146aafe>] ? start_secondary+0x1b9/0x29b

Thanks,
Fengguang

