Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYIKSVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYIKSVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYIKSVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:21:32 -0400
Received: from main.gmane.org ([80.91.229.2]:44920 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYIKSVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:21:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: Re: 2.6.26.4 hard-unsafe lock order detected (drm-related?)
Date: Thu, 11 Sep 2008 19:21:24 +0100
Message-ID: <gabnj1$nh4$1@ger.gmane.org>
References: <ga8tos$kbv$1@ger.gmane.org> <1221070510.4415.207.camel@twins.programming.kicks-ass.net> <gaavrs$of3$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 84-203-83-149.mysmart.ie
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 12:36 in <gaavrs$of3$1@ger.gmane.org>, Marcus
Furlong wrote:

> On Wednesday 10 September 2008 19:15 in
> <1221070510.4415.207.camel@twins.programming.kicks-ass.net>, Peter Zijlstra
> wrote:
> 
>> On Wed, 2008-09-10 at 17:48 +0100, Marcus Furlong wrote:
>>> Hi,
>>> 
>>> Just found this in dmesg, if any more info is needed let me know.
>> 
>> Dave, have you ever seen this one before?
>> 
>> Marcus, can you reproduce? - if so, could you try .27-rc6 to see if it
>> is still valid?
> 
> Can't reproduce so far.

Actually just found another one on 2.6.26.4. Not sure what I was doing at the
time though. Tried 27-rc6 for a few hours last night and it didn't recoccur.
I'll see if I can pinpoint what causes it.

[16869.930402] ======================================================
[16869.930413] [ INFO: hard-safe -> hard-unsafe lock order detected ]
[16869.930418] 2.6.26.4 #1
[16869.930422] ------------------------------------------------------
[16869.930427] swapper/0 [HC0[0]:SC1[2]:HE0:SE0] is trying to acquire:
[16869.930432]  (&dev->lock.spinlock){-+..}, at: [<f9072ecc>]
drm_lock_take+0x1c/0xc0 [drm]
[16869.930460]
[16869.930461] and this task is already holding:
[16869.930464]  (&dev->tasklet_lock){++..}, at: [<f907254e>]
drm_locked_tasklet_func+0x1e/0x90 [drm]
[16869.930485] which would create a new lock dependency:
[16869.930490]  (&dev->tasklet_lock){++..} -> (&dev->lock.spinlock){-+..}
[16869.930510]
[16869.930511] but this new dependency connects a hard-irq-safe lock:
[16869.930517]  (&dev->tasklet_lock){++..}
[16869.930524] ... which became hard-irq-safe at:
[16869.930529]   [<c016495d>] __lock_acquire+0x82d/0xfb0
[16869.930544]   [<c0165141>] lock_acquire+0x61/0x80
[16869.930556]   [<c0496de3>] _spin_lock_irqsave+0x43/0x60
[16869.930571]   [<f907260d>] drm_locked_tasklet+0x4d/0xa0 [drm]
[16869.930592]   [<f9048bf3>] i915_driver_irq_handler+0x1c3/0x1f0 [i915]
[16869.930611]   [<c016f048>] handle_IRQ_event+0x28/0x60
[16869.930624]   [<c01704f8>] handle_fasteoi_irq+0x78/0xf0
[16869.930636]   [<c011d719>] do_IRQ+0x79/0xc0
[16869.930649]   [<ffffffff>] 0xffffffff
[16869.930661]
[16869.930662] to a hard-irq-unsafe lock:
[16869.930668]  (&dev->lock.spinlock){-+..}
[16869.930674] ... which became hard-irq-unsafe at:
[16869.930679] ...  [<c0164736>] __lock_acquire+0x606/0xfb0
[16869.930696]   [<c0165141>] lock_acquire+0x61/0x80
[16869.930708]   [<c0496e8b>] _spin_lock_bh+0x3b/0x50
[16869.930724]   [<f907319e>] drm_lock+0x8e/0x310 [drm]
[16869.930747]   [<f90713e9>] drm_ioctl+0x1b9/0x2f0 [drm]
[16869.930773]   [<c01a30eb>] vfs_ioctl+0x6b/0x80
[16869.930785]   [<c01a3157>] do_vfs_ioctl+0x57/0x2b0
[16869.930798]   [<c01a33e9>] sys_ioctl+0x39/0x60
[16869.930809]   [<c011a505>] sysenter_past_esp+0x6a/0xb1
[16869.930821]   [<ffffffff>] 0xffffffff
[16869.930837]
[16869.930838] other info that might help us debug this:
[16869.930839]
[16869.930842] 1 lock held by swapper/0:
[16869.930844]  #0:  (&dev->tasklet_lock){++..}, at: [<f907254e>]
drm_locked_tasklet_func+0x1e/0x90 [drm]
[16869.930858]
[16869.930859] the hard-irq-safe lock's dependencies:
[16869.930862] -> (&dev->tasklet_lock){++..} ops: 0 {
[16869.930870]    initial-use  at:
[16869.930873]                                        [<c016424d>]
__lock_acquire+0x11d/0xfb0
[16869.930932]                                        [<c0165141>]
lock_acquire+0x61/0x80
[16869.930987]                                        [<c0496de3>]
_spin_lock_irqsave+0x43/0x60
[16869.930987]                                        [<f9073007>]
drm_unlock+0x27/0xc0 [drm]
[16869.930987]                                        [<f90713e9>]
drm_ioctl+0x1b9/0x2f0 [drm]
[16869.930987]                                        [<c01a30eb>]
vfs_ioctl+0x6b/0x80
[16869.930987]                                        [<c01a3157>]
do_vfs_ioctl+0x57/0x2b0
[16869.930987]                                        [<c01a33e9>]
sys_ioctl+0x39/0x60
[16869.930987]                                        [<c011a505>]
sysenter_past_esp+0x6a/0xb1
[16869.930987]                                        [<ffffffff>] 0xffffffff
[16869.930987]    in-hardirq-W at:
[16869.930987]                                        [<c016495d>]
__lock_acquire+0x82d/0xfb0
[16869.930987]                                        [<c0165141>]
lock_acquire+0x61/0x80
[16869.930987]                                        [<c0496de3>]
_spin_lock_irqsave+0x43/0x60
[16869.930987]                                        [<f907260d>]
drm_locked_tasklet+0x4d/0xa0 [drm]
[16869.930987]                                        [<f9048bf3>]
i915_driver_irq_handler+0x1c3/0x1f0 [i915]
[16869.930987]                                        [<c016f048>]
handle_IRQ_event+0x28/0x60
[16869.930987]                                        [<c01704f8>]
handle_fasteoi_irq+0x78/0xf0
[16869.930987]                                        [<c011d719>]
do_IRQ+0x79/0xc0
[16869.930987]                                        [<ffffffff>] 0xffffffff
[16869.930987]    in-softirq-W at:
[16869.930987]                                        [<c01645ef>]
__lock_acquire+0x4bf/0xfb0
[16869.930987]                                        [<c0165141>]
lock_acquire+0x61/0x80
[16869.930987]                                        [<c0496de3>]
_spin_lock_irqsave+0x43/0x60
[16869.930987]                                        [<f907254e>]
drm_locked_tasklet_func+0x1e/0x90 [drm]
[16869.930987]                                        [<c01476eb>]
tasklet_hi_action+0x5b/0xd0
[16869.930987]                                        [<c01474e4>]
__do_softirq+0x74/0xe0
[16869.930987]                                        [<c011d665>]
do_softirq+0x95/0xd0
[16869.930987]                                        [<ffffffff>] 0xffffffff
[16869.930987]  }
[16869.930987]  ... key      at: [<f907e444>] __key.23164+0x0/0xffff90cb [drm]
[16869.930987]
[16869.930987] the hard-irq-unsafe lock's dependencies:
[16869.930987] -> (&dev->lock.spinlock){-+..} ops: 0 {
[16869.930987]    initial-use  at:
[16869.930987]                                        [<c016424d>]
__lock_acquire+0x11d/0xfb0
[16869.930987]                                        [<c0165141>]
lock_acquire+0x61/0x80
[16869.930987]                                        [<c0496e8b>]
_spin_lock_bh+0x3b/0x50
[16869.930987]                                        [<f907319e>]
drm_lock+0x8e/0x310 [drm]
[16869.930987]                                        [<f90713e9>]
drm_ioctl+0x1b9/0x2f0 [drm]
[16869.930987]                                        [<c01a30eb>]
vfs_ioctl+0x6b/0x80
[16869.930987]                                        [<c01a3157>]
do_vfs_ioctl+0x57/0x2b0
[16869.930987]                                        [<c01a33e9>]
sys_ioctl+0x39/0x60
[16869.930987]                                        [<c011a505>]
sysenter_past_esp+0x6a/0xb1
[16869.930987]                                        [<ffffffff>] 0xffffffff
[16869.930987]    in-softirq-W at:
[16869.930987]                                        [<c01645ef>]
__lock_acquire+0x4bf/0xfb0
[16869.930987]                                        [<c0165141>]
lock_acquire+0x61/0x80
[16869.930987]                                        [<c0496e8b>]
_spin_lock_bh+0x3b/0x50
[16869.930987]                                        [<f9072ecc>]
drm_lock_take+0x1c/0xc0 [drm]
[16869.930987]                                        [<f907256a>]
drm_locked_tasklet_func+0x3a/0x90 [drm]
[16869.930987]                                        [<c01476eb>]
tasklet_hi_action+0x5b/0xd0
[16869.930987]                                        [<c01474e4>]
__do_softirq+0x74/0xe0
[16869.930987]                                        [<c011d665>]
do_softirq+0x95/0xd0
[16869.930987]                                        [<ffffffff>] 0xffffffff
[16869.930987]    hardirq-on-W at:
[16869.930987]                                        [<c0164736>]
__lock_acquire+0x606/0xfb0
[16869.930987]                                        [<c0165141>]
lock_acquire+0x61/0x80
[16869.930987]                                        [<c0496e8b>]
_spin_lock_bh+0x3b/0x50
[16869.930987]                                        [<f907319e>]
drm_lock+0x8e/0x310 [drm]
[16869.930987]                                        [<f90713e9>]
drm_ioctl+0x1b9/0x2f0 [drm]
[16869.930987]                                        [<c01a30eb>]
vfs_ioctl+0x6b/0x80
[16869.930987]                                        [<c01a3157>]
do_vfs_ioctl+0x57/0x2b0
[16869.930987]                                        [<c01a33e9>]
sys_ioctl+0x39/0x60
[16869.930987]                                        [<c011a505>]
sysenter_past_esp+0x6a/0xb1
[16869.930987]                                        [<ffffffff>] 0xffffffff
[16869.930987]  }
[16869.930987]  ... key      at: [<f907e43c>] __key.23165+0x0/0xffff90d3 [drm]
[16869.930987]
[16869.930987] stack backtrace:
[16869.930987] Pid: 0, comm: swapper Not tainted 2.6.26.4 #1
[16869.930987]  [<c0164072>] check_usage+0x252/0x260
[16869.930987]  [<c0164c18>] __lock_acquire+0xae8/0xfb0
[16869.930987]  [<c0135534>] ? hrtick_start_fair+0x114/0x170
[16869.930987]  [<c0165141>] lock_acquire+0x61/0x80
[16869.930987]  [<f9072ecc>] ? drm_lock_take+0x1c/0xc0 [drm]
[16869.930987]  [<c0496e8b>] _spin_lock_bh+0x3b/0x50
[16869.930987]  [<f9072ecc>] ? drm_lock_take+0x1c/0xc0 [drm]
[16869.930987]  [<f9072ecc>] drm_lock_take+0x1c/0xc0 [drm]
[16869.930987]  [<f907256a>] drm_locked_tasklet_func+0x3a/0x90 [drm]
[16869.930987]  [<c01476eb>] tasklet_hi_action+0x5b/0xd0
[16869.930987]  [<c01474e4>] __do_softirq+0x74/0xe0
[16869.930987]  [<c011d665>] do_softirq+0x95/0xd0
[16869.930987]  [<c0170480>] ? handle_fasteoi_irq+0x0/0xf0
[16869.930987]  [<c0147386>] irq_exit+0x86/0xa0
[16869.930987]  [<c011d720>] do_IRQ+0x80/0xc0
[16869.930987]  [<c011af82>] common_interrupt+0x2e/0x34
[16869.930987]  [<c01600d8>] ? tick_setup_oneshot+0x28/0x40
[16869.930987]  [<c030fa9f>] ? acpi_idle_enter_bm+0x297/0x306
[16869.930987]  [<c03cfd0b>] cpuidle_idle_call+0x6b/0xc0
[16869.930987]  [<c03cfca0>] ? cpuidle_idle_call+0x0/0xc0
[16869.930987]  [<c0118f70>] cpu_idle+0x60/0xf0
[16869.930987]  [<c04806f2>] rest_init+0x62/0x70
[16869.930987]  =======================

