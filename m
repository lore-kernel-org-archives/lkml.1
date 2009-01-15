Return-Path: <linux-kernel-owner+w=401wt.eu-S1763480AbZAOVLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763480AbZAOVLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933971AbZAOVD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:03:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:33310 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934793AbZAOVD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:03:26 -0500
X-Authenticated: #6028172
X-Provags-ID: V01U2FsdGVkX1+EBy85dl2Eb2OHuAGYpb9CIteMlC3qUhmlgR12Hj
	R7z1AQU/iH5OlB
Message-ID: <496FA4B6.3000607@gmx.de>
Date: Thu, 15 Jan 2009 22:03:50 +0100
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com>
In-Reply-To: <496F9604.8020101@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis schrieb:
> Hi Dieter and Maciej,

Hi Mike,

> 
> Can you try the attached patches on your system?  It boots on my system fine
> now, but wasn't there a problem with resume as well?  (My test systems are
> remote so suspending/resuming over the network is iffy.)

I just tested it. The kernel does boot up, suspending to ram works
perfectly, hibernating did also work, but I found an inconsistent lock
state in dmesg afterwards. System is still fully functional

May or may not be related, I don't know.

But the original problem is solved by your patches. Thank you!


[   97.475165] =================================
[   97.475165] [ INFO: inconsistent lock state ]
[   97.475165] 2.6.29-rc1-00256-g0f0f4af #147
[   97.475165] ---------------------------------
[   97.475165] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[   97.475165] echo/5817 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   97.475165]  (&cpu_base->lock){++..}, at: [<ffffffff8025b4fd>]
retrigger_next_event+0x7d/0xd0
[   97.475165] {in-hardirq-W} state was registered at:
[   97.475165]   [<ffffffffffffffff>] 0xffffffffffffffff
[   97.475165] irq event stamp: 88679
[   97.475165] hardirqs last  enabled at (88679): [<ffffffff8069be05>]
_spin_unlock_irqrestore+0x55/0x60
[   97.475165] hardirqs last disabled at (88678): [<ffffffff8069bcac>]
_spin_lock_irqsave+0x1c/0x60
[   97.475165] softirqs last  enabled at (88466): [<ffffffff802478c2>]
__do_softirq+0x132/0x190
[   97.475165] softirqs last disabled at (88461): [<ffffffff8020c97c>]
call_softirq+0x1c/0x40
[   97.475165]
[   97.475165] other info that might help us debug this:
[   97.475165] 3 locks held by echo/5817:
[   97.475165]  #0:  (&buffer->mutex){--..}, at: [<ffffffff8030dff3>]
sysfs_write_file+0x43/0x140
[   97.475165]  #1:  (pm_mutex){--..}, at: [<ffffffff802755a5>]
enter_state+0x55/0x190
[   97.475165]  #2:  (dpm_list_mtx){--..}, at: [<ffffffff80499212>]
device_pm_lock+0x12/0x20
[   97.475165]
[   97.475165] stack backtrace:
[   97.475165] Pid: 5817, comm: echo Not tainted
2.6.29-rc1-00256-g0f0f4af #147
[   97.475165] Call Trace:
[   97.475165]  [<ffffffff80266f86>] print_usage_bug+0x1a6/0x200
[   97.475165]  [<ffffffff80268647>] mark_lock+0xab7/0xe90
[   97.475165]  [<ffffffff8026ae8a>] __lock_acquire+0x80a/0xa50
[   97.475165]  [<ffffffff8026b128>] lock_acquire+0x58/0x80
[   97.475165]  [<ffffffff8025b4fd>] ? retrigger_next_event+0x7d/0xd0
[   97.475165]  [<ffffffff8069b8bc>] _spin_lock+0x2c/0x40
[   97.475165]  [<ffffffff8025b4fd>] ? retrigger_next_event+0x7d/0xd0
[   97.475165]  [<ffffffff8025b4fd>] retrigger_next_event+0x7d/0xd0
[   97.475165]  [<ffffffff8025b55b>] hres_timers_resume+0xb/0x10
[   97.475165]  [<ffffffff80260973>] timekeeping_resume+0xc3/0x100
[   97.475165]  [<ffffffff80493730>] __sysdev_resume+0x20/0x60
[   97.475165]  [<ffffffff804937ba>] sysdev_resume+0x4a/0x80
[   97.475165]  [<ffffffff80499db0>] device_power_up+0x10/0x20
[   97.475165]  [<ffffffff802754c8>] suspend_devices_and_enter+0x158/0x170
[   97.475165]  [<ffffffff802756a5>] enter_state+0x155/0x190
[   97.475165]  [<ffffffff8027578e>] state_store+0xae/0xe0
[   97.475165]  [<ffffffff804009e7>] kobj_attr_store+0x17/0x20
[   97.475165]  [<ffffffff8030e07e>] sysfs_write_file+0xce/0x140
[   97.475165]  [<ffffffff802bd4d7>] vfs_write+0xc7/0x170
[   97.475165]  [<ffffffff802bda90>] sys_write+0x50/0x90
[   97.475165]  [<ffffffff8020b81b>] system_call_fastpath+0x16/0x1b



> 
> The patches apply to the latest tip/cpus4096 branch:
> 
> 	http://people.redhat.com/mingo/tip.git/README

Thanks for that link. Could one of you hint me to some documentation
about what tip is? I searched a bit, but didn't find it.

> 
> (They may apply to linux-next as well, I'm not sure.)
> 
> Thanks!
> Mike
> 

cu

Dieter

