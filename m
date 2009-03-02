Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbZCBUMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbZCBUMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbZCBULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:11:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbZCBULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:11:54 -0500
Date: Mon, 2 Mar 2009 12:11:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jan sonnek <ha2nny@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Catalin Marinas <catalin.marinas@arm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Regression - locking (all from 2.6.28)
Message-Id: <20090302121127.e46dc4be.akpm@linux-foundation.org>
In-Reply-To: <49AC334A.9030800@gmail.com>
References: <49AC334A.9030800@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Mar 2009 20:28:10 +0100
jan sonnek <ha2nny@gmail.com> wrote:

> Later I have reported regression, now I have better debug info in the 
> attachements.
> 
> Later reporter - still actual for (2.6.29-rc6-mm1):
>  From 2.6.28 and other 2.6.29-rc3-mm1 I have problem with starting
> system with GDM (gdm-2.24.0-12). Without login screen system stop and
> generate error (all kernel soon then 2.6.27 are ok).
> 
> It is bug: http://bugzilla.kernel.org/show_bug.cgi?id=12619
> 

The linux-kernel mailing list probably won't accept a 662 kbyte email.
Please trim these reports down to some sane size.


> Mar  1 00:07:03 localhost kernel: [   86.440261] =========================================================
> Mar  1 00:07:03 localhost kernel: [   86.440266] [ INFO: possible irq lock inversion dependency detected ]
> Mar  1 00:07:03 localhost kernel: [   86.440271] 2.6.29-rc6-mm1-hanny #17
> Mar  1 00:07:03 localhost kernel: [   86.440273] ---------------------------------------------------------

I stared at this for a while, but my brain broke trying to work out
what lockdep is trying to tell us.

> Mar  1 00:07:03 localhost kernel: [   86.440277] Xorg/2733 just changed the state of lock:
> Mar  1 00:07:03 localhost kernel: [   86.440280]  (fasync_lock){.-....}, at: [<c01952bb>] kill_fasync+0x20/0x3a
> Mar  1 00:07:03 localhost kernel: [   86.440292] but this lock took another, HARDIRQ-READ-irq-unsafe lock in the past:
> Mar  1 00:07:03 localhost kernel: [   86.440296]  (&f->f_lock){+.+...}

This message needs help.  A lock cannot "take" another lock.  And why
is f_lock described as "HARDIRQ-READ-irq-unsafe"?  It's a spinlock and
the "READ" part is not relevant.

> Mar  1 00:07:03 localhost kernel: [   86.440299] 
> Mar  1 00:07:03 localhost kernel: [   86.440300] and interrupts could create inverse lock ordering between them.
> Mar  1 00:07:03 localhost kernel: [   86.440302] 
> Mar  1 00:07:03 localhost kernel: [   86.440305] 
> Mar  1 00:07:03 localhost kernel: [   86.440305] other info that might help us debug this:
> Mar  1 00:07:03 localhost kernel: [   86.440309] 3 locks held by Xorg/2733:
> Mar  1 00:07:03 localhost kernel: [   86.440312]  #0:  (&dev->event_lock){-.-...}, at: [<c02d5e8c>] input_event+0x35/0x69
> Mar  1 00:07:03 localhost kernel: [   86.440322]  #1:  (rcu_read_lock){.+.+..}, at: [<c02d4af3>] __rcu_read_lock+0x0/0x30
> Mar  1 00:07:03 localhost kernel: [   86.440331]  #2:  (rcu_read_lock){.+.+..}, at: [<c02d872a>] evdev_event+0x0/0xe2
> Mar  1 00:07:03 localhost kernel: [   86.440340] 
> Mar  1 00:07:03 localhost kernel: [   86.440341] the first lock's dependencies:
> Mar  1 00:07:03 localhost kernel: [   86.440344] -> (fasync_lock){.-....} ops: 190 {
> Mar  1 00:07:03 localhost kernel: [   86.440351]    IN-HARDIRQ-R at:
> Mar  1 00:07:03 localhost kernel: [   86.440355]                                        [<c01471a2>] __lock_acquire+0x204/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440362]                                        [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440368]                                        [<c0398bc2>] _read_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440375]                                        [<c01952bb>] kill_fasync+0x20/0x3a
> Mar  1 00:07:03 localhost kernel: [   86.440381]                                        [<c02d84a7>] evdev_pass_event+0x60/0x66
> Mar  1 00:07:03 localhost kernel: [   86.440387]                                        [<c02d879d>] evdev_event+0x73/0xe2
> Mar  1 00:07:03 localhost kernel: [   86.440393]                                        [<c02d4bb9>] input_pass_event+0x5c/0x7f
> Mar  1 00:07:03 localhost kernel: [   86.440399]                                        [<c02d5dd6>] input_handle_event+0x366/0x36f
> Mar  1 00:07:03 localhost kernel: [   86.440405]                                        [<c02d5eab>] input_event+0x54/0x69
> Mar  1 00:07:03 localhost kernel: [   86.440410]                                        [<c02f1e03>] hidinput_hid_event+0x24c/0x279
> Mar  1 00:07:03 localhost kernel: [   86.440418]                                        [<c02ef1ed>] hid_process_event+0x8d/0xbc
> Mar  1 00:07:03 localhost kernel: [   86.440424]                                        [<c02ef558>] hid_report_raw_event+0x33c/0x348
> Mar  1 00:07:03 localhost kernel: [   86.440431]                                        [<c02ef60f>] hid_input_report+0xab/0xbc
> Mar  1 00:07:03 localhost kernel: [   86.440437]                                        [<c02f576c>] hid_irq_in+0x86/0x182
> Mar  1 00:07:03 localhost kernel: [   86.440443]                                        [<c02af7fa>] usb_hcd_giveback_urb+0x68/0x9c
> Mar  1 00:07:03 localhost kernel: [   86.440451]                                        [<c02cec0f>] uhci_giveback_urb+0xf6/0x1f1
> Mar  1 00:07:03 localhost kernel: [   86.440458]                                        [<c02cf404>] uhci_scan_schedule+0x5f8/0x85f
> Mar  1 00:07:03 localhost kernel: [   86.440464]                                        [<c02d10e7>] uhci_irq+0x12b/0x13f
> Mar  1 00:07:03 localhost kernel: [   86.440470]                                        [<c02af3cc>] usb_hcd_irq+0x32/0x81
> Mar  1 00:07:03 localhost kernel: [   86.440475]                                        [<c0156b6b>] handle_IRQ_event+0x1f/0x4b
> Mar  1 00:07:03 localhost kernel: [   86.440483]                                        [<c0157d09>] handle_fasteoi_irq+0x77/0xb0
> Mar  1 00:07:03 localhost kernel: [   86.440489]                                        [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440494]    INITIAL USE at:
> Mar  1 00:07:03 localhost kernel: [   86.440498]                                       [<c01472e2>] __lock_acquire+0x344/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440504]                                       [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440510]                                       [<c039895d>] _write_lock_irq+0x33/0x63
> Mar  1 00:07:03 localhost kernel: [   86.440515]                                       [<c0194ef6>] fasync_helper+0x44/0xe4
> Mar  1 00:07:03 localhost kernel: [   86.440521]                                       [<c0247242>] tty_fasync+0x50/0xea
> Mar  1 00:07:03 localhost kernel: [   86.440528]                                       [<c0249322>] tty_release_dev+0x57/0x409
> Mar  1 00:07:03 localhost kernel: [   86.440534]                                       [<c02496eb>] tty_release+0x17/0x21
> Mar  1 00:07:03 localhost kernel: [   86.440539]                                       [<c018c369>] __fput+0xcf/0x158
> Mar  1 00:07:03 localhost kernel: [   86.440546]                                       [<c018c410>] fput+0x1e/0x20
> Mar  1 00:07:03 localhost kernel: [   86.440551]                                       [<c0189b12>] filp_close+0x56/0x60
> Mar  1 00:07:03 localhost kernel: [   86.440557]                                       [<c0189b8b>] sys_close+0x6f/0xa9
> Mar  1 00:07:03 localhost kernel: [   86.440562]                                       [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440569]                                       [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440574]  }
> Mar  1 00:07:03 localhost kernel: [   86.440576]  ... key      at: [<c04fea24>] fasync_lock+0x10/0x24
> Mar  1 00:07:03 localhost kernel: [   86.440583]  -> (&f->f_lock){+.+...} ops: 493 {
> Mar  1 00:07:03 localhost kernel: [   86.440590]     HARDIRQ-ON-W at:
> Mar  1 00:07:03 localhost kernel: [   86.440594]                                          [<c0147260>] __lock_acquire+0x2c2/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440600]                                          [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440606]                                          [<c039869c>] _spin_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440612]                                          [<c019561e>] do_fcntl+0x222/0x2bc
> Mar  1 00:07:03 localhost kernel: [   86.440617]                                          [<c0195712>] sys_fcntl64+0x5a/0x6e
> Mar  1 00:07:03 localhost kernel: [   86.440623]                                          [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440629]                                          [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440633]     SOFTIRQ-ON-W at:
> Mar  1 00:07:03 localhost kernel: [   86.440637]                                          [<c0147283>] __lock_acquire+0x2e5/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440643]                                          [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440649]                                          [<c039869c>] _spin_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440654]                                          [<c019561e>] do_fcntl+0x222/0x2bc
> Mar  1 00:07:03 localhost kernel: [   86.440660]                                          [<c0195712>] sys_fcntl64+0x5a/0x6e
> Mar  1 00:07:03 localhost kernel: [   86.440666]                                          [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440672]                                          [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440676]     INITIAL USE at:
> Mar  1 00:07:03 localhost kernel: [   86.440680]                                         [<c01472e2>] __lock_acquire+0x344/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440686]                                         [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440691]                                         [<c039869c>] _spin_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440697]                                         [<c0194f66>] fasync_helper+0xb4/0xe4
> Mar  1 00:07:03 localhost kernel: [   86.440703]                                         [<c0247242>] tty_fasync+0x50/0xea
> Mar  1 00:07:03 localhost kernel: [   86.440708]                                         [<c0249322>] tty_release_dev+0x57/0x409
> Mar  1 00:07:03 localhost kernel: [   86.440714]                                         [<c02496eb>] tty_release+0x17/0x21
> Mar  1 00:07:03 localhost kernel: [   86.440720]                                         [<c018c369>] __fput+0xcf/0x158
> Mar  1 00:07:03 localhost kernel: [   86.440725]                                         [<c018c410>] fput+0x1e/0x20
> Mar  1 00:07:03 localhost kernel: [   86.440731]                                         [<c0189b12>] filp_close+0x56/0x60
> Mar  1 00:07:03 localhost kernel: [   86.440736]                                         [<c0189b8b>] sys_close+0x6f/0xa9
> Mar  1 00:07:03 localhost kernel: [   86.440741]                                         [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440747]                                         [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440752]   }
> Mar  1 00:07:03 localhost kernel: [   86.440754]   ... key      at: [<c0b839d0>] __key.20190+0x0/0x8
> Mar  1 00:07:03 localhost kernel: [   86.440760]  ... acquired at:
> Mar  1 00:07:03 localhost kernel: [   86.440763]    [<c0147965>] __lock_acquire+0x9c7/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440768]    [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440773]    [<c039869c>] _spin_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440778]    [<c0194f66>] fasync_helper+0xb4/0xe4
> Mar  1 00:07:03 localhost kernel: [   86.440783]    [<c0247242>] tty_fasync+0x50/0xea
> Mar  1 00:07:03 localhost kernel: [   86.440788]    [<c0249322>] tty_release_dev+0x57/0x409
> Mar  1 00:07:03 localhost kernel: [   86.440793]    [<c02496eb>] tty_release+0x17/0x21
> Mar  1 00:07:03 localhost kernel: [   86.440798]    [<c018c369>] __fput+0xcf/0x158
> Mar  1 00:07:03 localhost kernel: [   86.440803]    [<c018c410>] fput+0x1e/0x20
> Mar  1 00:07:03 localhost kernel: [   86.440807]    [<c0189b12>] filp_close+0x56/0x60
> Mar  1 00:07:03 localhost kernel: [   86.440812]    [<c0189b8b>] sys_close+0x6f/0xa9
> Mar  1 00:07:03 localhost kernel: [   86.440817]    [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440822]    [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440826] 
> Mar  1 00:07:03 localhost kernel: [   86.440828] 
> Mar  1 00:07:03 localhost kernel: [   86.440829] the second lock's dependencies:
> Mar  1 00:07:03 localhost kernel: [   86.440832] -> (&f->f_lock){+.+...} ops: 493 {
> Mar  1 00:07:03 localhost kernel: [   86.440839]    HARDIRQ-ON-W at:
> Mar  1 00:07:03 localhost kernel: [   86.440842]                                        [<c0147260>] __lock_acquire+0x2c2/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440848]                                        [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440854]                                        [<c039869c>] _spin_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440859]                                        [<c019561e>] do_fcntl+0x222/0x2bc
> Mar  1 00:07:03 localhost kernel: [   86.440865]                                        [<c0195712>] sys_fcntl64+0x5a/0x6e
> Mar  1 00:07:03 localhost kernel: [   86.440871]                                        [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440876]                                        [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440881]    SOFTIRQ-ON-W at:
> Mar  1 00:07:03 localhost kernel: [   86.440884]                                        [<c0147283>] __lock_acquire+0x2e5/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440890]                                        [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440896]                                        [<c039869c>] _spin_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440901]                                        [<c019561e>] do_fcntl+0x222/0x2bc
> Mar  1 00:07:03 localhost kernel: [   86.440907]                                        [<c0195712>] sys_fcntl64+0x5a/0x6e
> Mar  1 00:07:03 localhost kernel: [   86.440913]                                        [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440918]                                        [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440923]    INITIAL USE at:
> Mar  1 00:07:03 localhost kernel: [   86.440926]                                       [<c01472e2>] __lock_acquire+0x344/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.440932]                                       [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.440938]                                       [<c039869c>] _spin_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.440943]                                       [<c0194f66>] fasync_helper+0xb4/0xe4
> Mar  1 00:07:03 localhost kernel: [   86.440949]                                       [<c0247242>] tty_fasync+0x50/0xea
> Mar  1 00:07:03 localhost kernel: [   86.440955]                                       [<c0249322>] tty_release_dev+0x57/0x409
> Mar  1 00:07:03 localhost kernel: [   86.440960]                                       [<c02496eb>] tty_release+0x17/0x21
> Mar  1 00:07:03 localhost kernel: [   86.440966]                                       [<c018c369>] __fput+0xcf/0x158
> Mar  1 00:07:03 localhost kernel: [   86.440971]                                       [<c018c410>] fput+0x1e/0x20
> Mar  1 00:07:03 localhost kernel: [   86.440977]                                       [<c0189b12>] filp_close+0x56/0x60
> Mar  1 00:07:03 localhost kernel: [   86.440982]                                       [<c0189b8b>] sys_close+0x6f/0xa9
> Mar  1 00:07:03 localhost kernel: [   86.440988]                                       [<c0102f47>] sysenter_do_call+0x12/0x35
> Mar  1 00:07:03 localhost kernel: [   86.440993]                                       [<ffffffff>] 0xffffffff
> Mar  1 00:07:03 localhost kernel: [   86.440998]  }
> Mar  1 00:07:03 localhost kernel: [   86.441000]  ... key      at: [<c0b839d0>] __key.20190+0x0/0x8
> Mar  1 00:07:03 localhost kernel: [   86.441005] 
> Mar  1 00:07:03 localhost kernel: [   86.441006] stack backtrace:
> Mar  1 00:07:03 localhost kernel: [   86.441010] Pid: 2733, comm: Xorg Not tainted 2.6.29-rc6-mm1-hanny #17
> Mar  1 00:07:03 localhost kernel: [   86.441013] Call Trace:
> Mar  1 00:07:03 localhost kernel: [   86.441018]  [<c0396150>] ? printk+0x14/0x1c
> Mar  1 00:07:03 localhost kernel: [   86.441023]  [<c0146a58>] print_irq_inversion_bug+0xea/0xf7
> Mar  1 00:07:03 localhost kernel: [   86.441029]  [<c0146a9b>] check_usage_forwards+0x36/0x3f
> Mar  1 00:07:03 localhost kernel: [   86.441034]  [<c0146425>] mark_lock+0x129/0x20b
> Mar  1 00:07:03 localhost kernel: [   86.441038]  [<c0146a65>] ? check_usage_forwards+0x0/0x3f
> Mar  1 00:07:03 localhost kernel: [   86.441043]  [<c01471a2>] __lock_acquire+0x204/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.441048]  [<c02d8467>] ? evdev_pass_event+0x20/0x66
> Mar  1 00:07:03 localhost kernel: [   86.441054]  [<c0147b45>] lock_acquire+0x5d/0x7a
> Mar  1 00:07:03 localhost kernel: [   86.441059]  [<c01952bb>] ? kill_fasync+0x20/0x3a
> Mar  1 00:07:03 localhost kernel: [   86.441063]  [<c0398bc2>] _read_lock+0x2d/0x5d
> Mar  1 00:07:03 localhost kernel: [   86.441068]  [<c01952bb>] ? kill_fasync+0x20/0x3a
> Mar  1 00:07:03 localhost kernel: [   86.441073]  [<c01952bb>] kill_fasync+0x20/0x3a
> Mar  1 00:07:03 localhost kernel: [   86.441078]  [<c02d84a7>] evdev_pass_event+0x60/0x66
> Mar  1 00:07:03 localhost kernel: [   86.441083]  [<c02d879d>] evdev_event+0x73/0xe2
> Mar  1 00:07:03 localhost kernel: [   86.441087]  [<c02d4bb9>] input_pass_event+0x5c/0x7f
> Mar  1 00:07:03 localhost kernel: [   86.441092]  [<c02d5dd6>] input_handle_event+0x366/0x36f
> Mar  1 00:07:03 localhost kernel: [   86.441098]  [<c0246eac>] ? add_timer_randomness+0xee/0x108
> Mar  1 00:07:03 localhost kernel: [   86.441103]  [<c02d5eab>] input_event+0x54/0x69
> Mar  1 00:07:03 localhost kernel: [   86.441108]  [<c02f1e03>] hidinput_hid_event+0x24c/0x279
> Mar  1 00:07:03 localhost kernel: [   86.441114]  [<c02ef1ed>] hid_process_event+0x8d/0xbc
> Mar  1 00:07:03 localhost kernel: [   86.441119]  [<c02ef558>] hid_report_raw_event+0x33c/0x348
> Mar  1 00:07:03 localhost kernel: [   86.441125]  [<c02ef60f>] hid_input_report+0xab/0xbc
> Mar  1 00:07:03 localhost kernel: [   86.441130]  [<c02f576c>] hid_irq_in+0x86/0x182
> Mar  1 00:07:03 localhost kernel: [   86.441135]  [<c02af7fa>] usb_hcd_giveback_urb+0x68/0x9c
> Mar  1 00:07:03 localhost kernel: [   86.441140]  [<c02cec0f>] uhci_giveback_urb+0xf6/0x1f1
> Mar  1 00:07:03 localhost kernel: [   86.441145]  [<c0147ad9>] ? __lock_acquire+0xb3b/0xb4a
> Mar  1 00:07:03 localhost kernel: [   86.441151]  [<c02cf404>] uhci_scan_schedule+0x5f8/0x85f
> Mar  1 00:07:03 localhost kernel: [   86.441156]  [<c014548a>] ? put_lock_stats+0xd/0x21
> Mar  1 00:07:03 localhost kernel: [   86.441161]  [<c02d10e7>] uhci_irq+0x12b/0x13f
> Mar  1 00:07:03 localhost kernel: [   86.441166]  [<c02af3cc>] usb_hcd_irq+0x32/0x81
> Mar  1 00:07:03 localhost kernel: [   86.441172]  [<c0156b6b>] handle_IRQ_event+0x1f/0x4b
> Mar  1 00:07:03 localhost kernel: [   86.441176]  [<c0157d09>] handle_fasteoi_irq+0x77/0xb0
> Mar  1 00:07:03 localhost kernel: [   86.441181]  [<c0157c92>] ? handle_fasteoi_irq+0x0/0xb0
> Mar  1 00:07:03 localhost kernel: [   86.441184]  <IRQ>  [<c0398faa>] ? __irqentry_text_start+0x4a/0x8c
> 

And bazillions of these:

> Mar  1 00:06:51 localhost kernel: [   74.007988] unreferenced object 0xf6c4da80 (size 52):
> Mar  1 00:06:51 localhost kernel: [   74.007991]   comm "swapper", pid 1, jiffies 4294893427
> Mar  1 00:06:51 localhost kernel: [   74.007994]   backtrace:
> Mar  1 00:06:51 localhost kernel: [   74.007997]     [<c018978c>] kmemleak_alloc+0x17e/0x28e
> Mar  1 00:06:51 localhost kernel: [   74.008002]     [<c0186b86>] kmem_cache_alloc+0xdc/0xe7
> Mar  1 00:06:51 localhost kernel: [   74.008006]     [<c01a53bd>] alloc_buffer_head+0x16/0x71
> Mar  1 00:06:51 localhost kernel: [   74.008011]     [<c01a5b91>] alloc_page_buffers+0x23/0xad
> Mar  1 00:06:51 localhost kernel: [   74.008015]     [<c01a5fd4>] __getblk+0x192/0x26b
> Mar  1 00:06:51 localhost kernel: [   74.008020]     [<c01d91f4>] jread+0x105/0x1de
> Mar  1 00:06:51 localhost kernel: [   74.008026]     [<c01d932b>] do_one_pass+0x5e/0x38c
> Mar  1 00:06:51 localhost kernel: [   74.008031]     [<c01d96f8>] journal_recover+0x41/0x9d
> Mar  1 00:06:51 localhost kernel: [   74.008037]     [<c01db8d4>] journal_load+0x47/0x7b
> Mar  1 00:06:51 localhost kernel: [   74.008042]     [<c01d43d1>] ext3_fill_super+0xe9d/0x144c
> Mar  1 00:06:51 localhost kernel: [   74.008047]     [<c018d721>] get_sb_bdev+0xfa/0x140
> Mar  1 00:06:51 localhost kernel: [   74.008052]     [<c01d2070>] ext3_get_sb+0x18/0x1a
> Mar  1 00:06:51 localhost kernel: [   74.008057]     [<c018c71f>] vfs_kern_mount+0x41/0x7c
> Mar  1 00:06:51 localhost kernel: [   74.008062]     [<c018c7a8>] do_kern_mount+0x37/0xbe
> Mar  1 00:06:51 localhost kernel: [   74.008067]     [<c019f0bf>] do_mount+0x5f7/0x630
> Mar  1 00:06:51 localhost kernel: [   74.008070]     [<c019f167>] sys_mount+0x6f/0xac
> Mar  1 00:06:51 localhost kernel: [   74.008075] unreferenced object 0xf6c4dab8 (size 52):
> Mar  1 00:06:51 localhost kernel: [   74.008078]   comm "swapper", pid 1, jiffies 4294893427
> Mar  1 00:06:51 localhost kernel: [   74.008081]   backtrace:
> Mar  1 00:06:51 localhost kernel: [   74.008085]     [<c018978c>] kmemleak_alloc+0x17e/0x28e
> Mar  1 00:06:51 localhost kernel: [   74.008091]     [<c0186b86>] kmem_cache_alloc+0xdc/0xe7
> Mar  1 00:06:51 localhost kernel: [   74.008097]     [<c01a53bd>] alloc_buffer_head+0x16/0x71
> Mar  1 00:06:51 localhost kernel: [   74.008103]     [<c01a5b91>] alloc_page_buffers+0x23/0xad
> Mar  1 00:06:51 localhost kernel: [   74.008109]     [<c01a5fd4>] __getblk+0x192/0x26b
> Mar  1 00:06:51 localhost kernel: [   74.008114]     [<c01d91f4>] jread+0x105/0x1de
> Mar  1 00:06:51 localhost kernel: [   74.008118]     [<c01d932b>] do_one_pass+0x5e/0x38c
> Mar  1 00:06:51 localhost kernel: [   74.008122]     [<c01d96f8>] journal_recover+0x41/0x9d
> Mar  1 00:06:51 localhost kernel: [   74.008127]     [<c01db8d4>] journal_load+0x47/0x7b
> Mar  1 00:06:51 localhost kernel: [   74.008132]     [<c01d43d1>] ext3_fill_super+0xe9d/0x144c
> Mar  1 00:06:51 localhost kernel: [   74.008136]     [<c018d721>] get_sb_bdev+0xfa/0x140
> Mar  1 00:06:51 localhost kernel: [   74.008141]     [<c01d2070>] ext3_get_sb+0x18/0x1a
> Mar  1 00:06:51 localhost kernel: [   74.008145]     [<c018c71f>] vfs_kern_mount+0x41/0x7c
> Mar  1 00:06:51 localhost kernel: [   74.008149]     [<c018c7a8>] do_kern_mount+0x37/0xbe
> Mar  1 00:06:51 localhost kernel: [   74.008154]     [<c019f0bf>] do_mount+0x5f7/0x630
> Mar  1 00:06:51 localhost kernel: [   74.008159]     [<c019f167>] sys_mount+0x6f/0xac
> Mar  1 00:06:51 localhost kernel: [   74.008165] unreferenced object 0xf6c4daf0 (size 52):
> Mar  1 00:06:51 localhost kernel: [   74.008170]   comm "swapper", pid 1, jiffies 4294893427
> Mar  1 00:06:51 localhost kernel: [   74.008175]   backtrace:
> Mar  1 00:06:51 localhost kernel: [   74.008179]     [<c018978c>] kmemleak_alloc+0x17e/0x28e
> Mar  1 00:06:51 localhost kernel: [   74.008185]     [<c0186b86>] kmem_cache_alloc+0xdc/0xe7
> Mar  1 00:06:51 localhost kernel: [   74.008190]     [<c01a53bd>] alloc_buffer_head+0x16/0x71
> Mar  1 00:06:51 localhost kernel: [   74.008196]     [<c01a5b91>] alloc_page_buffers+0x23/0xad
> Mar  1 00:06:51 localhost kernel: [   74.008200]     [<c01a5fd4>] __getblk+0x192/0x26b
> Mar  1 00:06:51 localhost kernel: [   74.008205]     [<c01d91f4>] jread+0x105/0x1de
> Mar  1 00:06:51 localhost kernel: [   74.008209]     [<c01d932b>] do_one_pass+0x5e/0x38c
> Mar  1 00:06:51 localhost kernel: [   74.008213]     [<c01d96f8>] journal_recover+0x41/0x9d
> Mar  1 00:06:51 localhost kernel: [   74.008218]     [<c01db8d4>] journal_load+0x47/0x7b
> Mar  1 00:06:51 localhost kernel: [   74.008221]     [<c01d43d1>] ext3_fill_super+0xe9d/0x144c
> Mar  1 00:06:51 localhost kernel: [   74.008225]     [<c018d721>] get_sb_bdev+0xfa/0x140
> Mar  1 00:06:51 localhost kernel: [   74.008231]     [<c01d2070>] ext3_get_sb+0x18/0x1a
> Mar  1 00:06:51 localhost kernel: [   74.008235]     [<c018c71f>] vfs_kern_mount+0x41/0x7c
> Mar  1 00:06:51 localhost kernel: [   74.008241]     [<c018c7a8>] do_kern_mount+0x37/0xbe
> Mar  1 00:06:51 localhost kernel: [   74.008247]     [<c019f0bf>] do_mount+0x5f7/0x630
> Mar  1 00:06:51 localhost kernel: [   74.008253]     [<c019f167>] sys_mount+0x6f/0xac

I suspect kmemleak has gone nuts here.

kmemleak has no MAINTAINERS entry, btw.
