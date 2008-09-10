Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYIJQsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYIJQsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYIJQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:48:41 -0400
Received: from main.gmane.org ([80.91.229.2]:44621 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYIJQsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:48:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: 2.6.26.4 hard-unsafe lock order detected (drm-related?)
Date: Wed, 10 Sep 2008 17:48:32 +0100
Message-ID: <ga8tos$kbv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 84-203-83-149.mysmart.ie
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just found this in dmesg, if any more info is needed let me know.

Marcus.

[18255.940781] ======================================================
[18255.940789] [ INFO: hard-safe -> hard-unsafe lock order detected ]
[18255.940792] 2.6.26.4 #1
[18255.940794] ------------------------------------------------------
[18255.940797] swapper/0 [HC0[0]:SC1[2]:HE0:SE0] is trying to acquire:
[18255.940800]  (&dev->lock.spinlock){-+..}, at: [<f9072ecc>]
drm_lock_take+0x1c/0xc0 [drm]
[18255.940815]
[18255.940816] and this task is already holding:
[18255.940818]  (&dev->tasklet_lock){++..}, at: [<f907254e>]
drm_locked_tasklet_func+0x1e/0x90 [drm]
[18255.940831] which would create a new lock dependency:
[18255.940833]  (&dev->tasklet_lock){++..} -> (&dev->lock.spinlock){-+..}
[18255.940840]
[18255.940841] but this new dependency connects a hard-irq-safe lock:
[18255.940843]  (&dev->tasklet_lock){++..}
[18255.940846] ... which became hard-irq-safe at:
[18255.940848]   [<c016495d>] __lock_acquire+0x82d/0xfb0
[18255.940856]   [<c0165141>] lock_acquire+0x61/0x80
[18255.940862]   [<c0496de3>] _spin_lock_irqsave+0x43/0x60
[18255.940869]   [<f907260d>] drm_locked_tasklet+0x4d/0xa0 [drm]
[18255.940880]   [<f9048bf3>] i915_driver_irq_handler+0x1c3/0x1f0 [i915]
[18255.940888]   [<c016f048>] handle_IRQ_event+0x28/0x60
[18255.940892]   [<c01704f8>] handle_fasteoi_irq+0x78/0xf0
[18255.940892]   [<c011d719>] do_IRQ+0x79/0xc0
[18255.940892]   [<ffffffff>] 0xffffffff
[18255.940892]
[18255.940892] to a hard-irq-unsafe lock:
[18255.940892]  (&dev->lock.spinlock){-+..}
[18255.940892] ... which became hard-irq-unsafe at:
[18255.940892] ...  [<c0164736>] __lock_acquire+0x606/0xfb0
[18255.940892]   [<c0165141>] lock_acquire+0x61/0x80
[18255.940892]   [<c0496e8b>] _spin_lock_bh+0x3b/0x50
[18255.940892]   [<f907319e>] drm_lock+0x8e/0x310 [drm]
[18255.940892]   [<f90713e9>] drm_ioctl+0x1b9/0x2f0 [drm]
[18255.940892]   [<c01a30eb>] vfs_ioctl+0x6b/0x80
[18255.940892]   [<c01a3157>] do_vfs_ioctl+0x57/0x2b0
[18255.940892]   [<c01a33e9>] sys_ioctl+0x39/0x60
[18255.940892]   [<c011a505>] sysenter_past_esp+0x6a/0xb1
[18255.940892]   [<ffffffff>] 0xffffffff
[18255.940892]
[18255.940892] other info that might help us debug this:
[18255.940892]
[18255.940892] 1 lock held by swapper/0:
[18255.940892]  #0:  (&dev->tasklet_lock){++..}, at: [<f907254e>]
drm_locked_tasklet_func+0x1e/0x90 [drm]
[18255.940892]
[18255.940892] the hard-irq-safe lock's dependencies:
[18255.940892] -> (&dev->tasklet_lock){++..} ops: 0 {
[18255.940892]    initial-use  at:
[18255.940892]                                        [<c016424d>]
__lock_acquire+0x11d/0xfb0
[18255.940892]                                        [<c0165141>]
lock_acquire+0x61/0x80
[18255.940892]                                        [<c0496de3>]
_spin_lock_irqsave+0x43/0x60
[18255.940892]                                        [<f907260d>]
drm_locked_tasklet+0x4d/0xa0 [drm]
[18255.940892]                                        [<f9048bf3>]
i915_driver_irq_handler+0x1c3/0x1f0 [i915]
[18255.940892]                                        [<c016f048>]
handle_IRQ_event+0x28/0x60
[18255.940892]                                        [<c01704f8>]
handle_fasteoi_irq+0x78/0xf0
[18255.940892]                                        [<c011d719>]
do_IRQ+0x79/0xc0
[18255.940892]                                        [<ffffffff>] 0xffffffff
[18255.940892]    in-hardirq-W at:
[18255.940892]                                        [<c016495d>]
__lock_acquire+0x82d/0xfb0
[18255.940892]                                        [<c0165141>]
lock_acquire+0x61/0x80
[18255.940892]                                        [<c0496de3>]
_spin_lock_irqsave+0x43/0x60
[18255.940892]                                        [<f907260d>]
drm_locked_tasklet+0x4d/0xa0 [drm]
[18255.940892]                                        [<f9048bf3>]
i915_driver_irq_handler+0x1c3/0x1f0 [i915]
[18255.940892]                                        [<c016f048>]
handle_IRQ_event+0x28/0x60
[18255.940892]                                        [<c01704f8>]
handle_fasteoi_irq+0x78/0xf0
[18255.940892]                                        [<c011d719>]
do_IRQ+0x79/0xc0
[18255.940892]                                        [<ffffffff>] 0xffffffff
[18255.940892]    in-softirq-W at:
[18255.940892]                                        [<c01645ef>]
__lock_acquire+0x4bf/0xfb0
[18255.940892]                                        [<c0165141>]
lock_acquire+0x61/0x80
[18255.940892]                                        [<c0496de3>]
_spin_lock_irqsave+0x43/0x60
[18255.940892]                                        [<f907254e>]
drm_locked_tasklet_func+0x1e/0x90 [drm]
[18255.940892]                                        [<c01476eb>]
tasklet_hi_action+0x5b/0xd0
[18255.940892]                                        [<c01474e4>]
__do_softirq+0x74/0xe0
[18255.940892]                                        [<c011d665>]
do_softirq+0x95/0xd0
[18255.940892]                                        [<ffffffff>] 0xffffffff
[18255.940892]  }
[18255.940892]  ... key      at: [<f907e444>] __key.23164+0x0/0xffff90cb [drm]
[18255.940892]
[18255.940892] the hard-irq-unsafe lock's dependencies:
[18255.940892] -> (&dev->lock.spinlock){-+..} ops: 0 {
[18255.940892]    initial-use  at:
[18255.940892]                                        [<c016424d>]
__lock_acquire+0x11d/0xfb0
[18255.940892]                                        [<c0165141>]
lock_acquire+0x61/0x80
[18255.940892]                                        [<c0496e8b>]
_spin_lock_bh+0x3b/0x50
[18255.940892]                                        [<f907319e>]
drm_lock+0x8e/0x310 [drm]
[18255.940892]                                        [<f90713e9>]
drm_ioctl+0x1b9/0x2f0 [drm]
[18255.940892]                                        [<c01a30eb>]
vfs_ioctl+0x6b/0x80
[18255.940892]                                        [<c01a3157>]
do_vfs_ioctl+0x57/0x2b0
[18255.940892]                                        [<c01a33e9>]
sys_ioctl+0x39/0x60
[18255.940892]                                        [<c011a505>]
sysenter_past_esp+0x6a/0xb1
[18255.940892]                                        [<ffffffff>] 0xffffffff
[18255.940892]    in-softirq-W at:
[18255.940892]                                        [<c01645ef>]
__lock_acquire+0x4bf/0xfb0
[18255.940892]                                        [<c0165141>]
lock_acquire+0x61/0x80
[18255.940892]                                        [<c0496e8b>]
_spin_lock_bh+0x3b/0x50
[18255.940892]                                        [<f9072ecc>]
drm_lock_take+0x1c/0xc0 [drm]
[18255.940892]                                        [<f907256a>]
drm_locked_tasklet_func+0x3a/0x90 [drm]
[18255.940892]                                        [<c01476eb>]
tasklet_hi_action+0x5b/0xd0
[18255.940892]                                        [<c01474e4>]
__do_softirq+0x74/0xe0
[18255.940892]                                        [<c011d665>]
do_softirq+0x95/0xd0
[18255.940892]                                        [<ffffffff>] 0xffffffff
[18255.940892]    hardirq-on-W at:
[18255.940892]                                        [<c0164736>]
__lock_acquire+0x606/0xfb0
[18255.940892]                                        [<c0165141>]
lock_acquire+0x61/0x80
[18255.940892]                                        [<c0496e8b>]
_spin_lock_bh+0x3b/0x50
[18255.940892]                                        [<f907319e>]
drm_lock+0x8e/0x310 [drm]
[18255.940892]                                        [<f90713e9>]
drm_ioctl+0x1b9/0x2f0 [drm]
[18255.940892]                                        [<c01a30eb>]
vfs_ioctl+0x6b/0x80
[18255.940892]                                        [<c01a3157>]
do_vfs_ioctl+0x57/0x2b0
[18255.940892]                                        [<c01a33e9>]
sys_ioctl+0x39/0x60
[18255.940892]                                        [<c011a505>]
sysenter_past_esp+0x6a/0xb1
[18255.940892]                                        [<ffffffff>] 0xffffffff
[18255.940892]  }
[18255.940892]  ... key      at: [<f907e43c>] __key.23165+0x0/0xffff90d3 [drm]
[18255.940892]
[18255.940892] stack backtrace:
[18255.940892] Pid: 0, comm: swapper Not tainted 2.6.26.4 #1
[18255.940892]  [<c0164072>] check_usage+0x252/0x260
[18255.940892]  [<c0164c18>] __lock_acquire+0xae8/0xfb0
[18255.940892]  [<c0165141>] lock_acquire+0x61/0x80
[18255.940892]  [<f9072ecc>] ? drm_lock_take+0x1c/0xc0 [drm]
[18255.940892]  [<c0496e8b>] _spin_lock_bh+0x3b/0x50
[18255.940892]  [<f9072ecc>] ? drm_lock_take+0x1c/0xc0 [drm]
[18255.940892]  [<f9072ecc>] drm_lock_take+0x1c/0xc0 [drm]
[18255.940892]  [<f907256a>] drm_locked_tasklet_func+0x3a/0x90 [drm]
[18255.940892]  [<c01476eb>] tasklet_hi_action+0x5b/0xd0
[18255.940892]  [<c01474e4>] __do_softirq+0x74/0xe0
[18255.940892]  [<c011d665>] do_softirq+0x95/0xd0
[18255.940892]  [<c0170480>] ? handle_fasteoi_irq+0x0/0xf0
[18255.940892]  [<c0147386>] irq_exit+0x86/0xa0
[18255.940892]  [<c011d720>] do_IRQ+0x80/0xc0
[18255.940892]  [<c011af82>] common_interrupt+0x2e/0x34
[18255.940892]  [<c01600d8>] ? tick_setup_oneshot+0x28/0x40
[18255.940892]  [<c030fa9f>] ? acpi_idle_enter_bm+0x297/0x306
[18255.940892]  [<c03cfd0b>] cpuidle_idle_call+0x6b/0xc0
[18255.940892]  [<c03cfca0>] ? cpuidle_idle_call+0x0/0xc0
[18255.940892]  [<c0118f70>] cpu_idle+0x60/0xf0
[18255.940892]  [<c04806f2>] rest_init+0x62/0x70
[18255.940892]  =======================


