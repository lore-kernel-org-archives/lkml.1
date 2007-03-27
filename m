Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXC0TmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXC0TmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXC0TmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:42:21 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:34646 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbXC0TmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:42:20 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Early hang with 2.6.21-rc4-rt1
X-Message-Flag: Warning: May contain useful information
References: <adad52xnccs.fsf@cisco.com> <20070325073146.GB10734@elte.hu>
	<ada4po9mlw5.fsf@cisco.com> <adavegpl0jd.fsf@cisco.com>
	<20070327192400.GB31695@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 27 Mar 2007 12:42:18 -0700
In-Reply-To: <20070327192400.GB31695@elte.hu> (Ingo Molnar's message of "Tue, 27 Mar 2007 21:24:00 +0200")
Message-ID: <ada648mo4md.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Mar 2007 19:42:18.0491 (UTC) FILETIME=[076F74B0:01C770A8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Great, thanks ... I'm not sure which of the 2 patches fixed things,
but I now got the following trace.  I've not really analyzed this, but
it definitely looks like tun_init() is doing something
fishy... ("149776 us maximum-latency"!!)

 - R.


[  272.392694] tun: Universal TUN/TAP device driver, 1.6
[  272.397780] (        modprobe-1857 |#2): new 5088 us maximum-latency critical section.
[  272.397782]  => started at timestamp 176092523: <__spin_lock_irqsave+0x18/0x42>
[  272.397790]  =>   ended at timestamp 176097606: <release_console_sem+0x1ae/0x1fa>
[  272.397795] 
[  272.397796] Call Trace:
[  272.397801]  [<ffffffff80255e74>] check_critical_timing+0x1e6/0x2f7
[  272.397805]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.397810]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.397814]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.397819]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.397824]  [<ffffffff8022c4e3>] vprintk+0x2a4/0x301
[  272.397828]  [<ffffffff80255f76>] check_critical_timing+0x2e8/0x2f7
[  272.397833]  [<ffffffff8022c5ac>] printk+0x6c/0x6e
[  272.397837]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.397841]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.397846]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.397849]  [<ffffffff8042785c>] wait_for_completion+0xbd/0xc6
[  272.397854]  [<ffffffff802262f9>] default_wake_function+0x0/0x19
[  272.397859]  [<ffffffff8042847a>] mutex_unlock+0x9/0x15
[  272.397863]  [<ffffffff80238dec>] blocking_notifier_call_chain+0x10/0x4e
[  272.397868]  [<ffffffff8800a02a>] :tun:tun_init+0x2a/0x6b
[  272.397873]  [<ffffffff8024d597>] sys_init_module+0x15d6/0x1731
[  272.397879]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.397885]  [<ffffffff803d2b89>] register_netdevice+0x0/0x31e
[  272.397891]  [<ffffffff80209e0f>] system_call+0xef/0x15c
[  272.397896] 
[  272.397900]  =>   dump-end timestamp 176097734
[  272.397902] 
[  272.547556] (        modprobe-1857 |#2): new 149776 us maximum-latency critical section.
[  272.547559]  => started at timestamp 176097899: <__spin_lock_irqsave+0x18/0x42>
[  272.547563]  =>   ended at timestamp 176247674: <release_console_sem+0x1ae/0x1fa>
[  272.547566] 
[  272.547567] Call Trace:
[  272.547570]  [<ffffffff80255e74>] check_critical_timing+0x1e6/0x2f7
[  272.547575]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.547579]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.547583]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.547588]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.547593]  [<ffffffff8022c4e3>] vprintk+0x2a4/0x301
[  272.547597]  [<ffffffff80255f76>] check_critical_timing+0x2e8/0x2f7
[  272.547602]  [<ffffffff8022c5ac>] printk+0x6c/0x6e
[  272.547606]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.547610]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.547614]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.547618]  [<ffffffff8042785c>] wait_for_completion+0xbd/0xc6
[  272.547622]  [<ffffffff802262f9>] default_wake_function+0x0/0x19
[  272.547627]  [<ffffffff8042847a>] mutex_unlock+0x9/0x15
[  272.547630]  [<ffffffff80238dec>] blocking_notifier_call_chain+0x10/0x4e
[  272.547635]  [<ffffffff8800a02a>] :tun:tun_init+0x2a/0x6b
[  272.547639]  [<ffffffff8024d597>] sys_init_module+0x15d6/0x1731
[  272.547646]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.547650]  [<ffffffff803d2b89>] register_netdevice+0x0/0x31e
[  272.547656]  [<ffffffff80209e0f>] system_call+0xef/0x15c
[  272.547660] 
[  272.547663]  =>   dump-end timestamp 176247784
[  272.547664] 
[  272.697343] (        modprobe-1857 |#2): new 149919 us maximum-latency critical section.
[  272.697345]  => started at timestamp 176247830: <__spin_lock_irqsave+0x18/0x42>
[  272.697349]  =>   ended at timestamp 176397741: <release_console_sem+0x1ae/0x1fa>
[  272.697353] 
[  272.697354] Call Trace:
[  272.697357]  [<ffffffff80255e74>] check_critical_timing+0x1e6/0x2f7
[  272.697361]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.697366]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.697369]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.697374]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.697379]  [<ffffffff8022c4e3>] vprintk+0x2a4/0x301
[  272.697383]  [<ffffffff80255f76>] check_critical_timing+0x2e8/0x2f7
[  272.697388]  [<ffffffff8022c5ac>] printk+0x6c/0x6e
[  272.697392]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.697396]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.697401]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.697404]  [<ffffffff8042785c>] wait_for_completion+0xbd/0xc6
[  272.697409]  [<ffffffff802262f9>] default_wake_function+0x0/0x19
[  272.697413]  [<ffffffff8042847a>] mutex_unlock+0x9/0x15
[  272.697416]  [<ffffffff80238dec>] blocking_notifier_call_chain+0x10/0x4e
[  272.697421]  [<ffffffff8800a02a>] :tun:tun_init+0x2a/0x6b
[  272.697425]  [<ffffffff8024d597>] sys_init_module+0x15d6/0x1731
[  272.697432]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.697436]  [<ffffffff803d2b89>] register_netdevice+0x0/0x31e
[  272.697442]  [<ffffffff80209e0f>] system_call+0xef/0x15c
[  272.697446] 
[  272.697450]  =>   dump-end timestamp 176397858
[  272.697451] 
[  272.847183] (        modprobe-1857 |#2): new 149953 us maximum-latency critical section.
[  272.847186]  => started at timestamp 176397924: <__spin_lock_irqsave+0x18/0x42>
[  272.847190]  =>   ended at timestamp 176547875: <release_console_sem+0x1ae/0x1fa>
[  272.847193] 
[  272.847194] Call Trace:
[  272.847197]  [<ffffffff80255e74>] check_critical_timing+0x1e6/0x2f7
[  272.847201]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.847206]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.847210]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.847215]  [<ffffffff8022be60>] release_console_sem+0x1ae/0x1fa
[  272.847219]  [<ffffffff8022c4e3>] vprintk+0x2a4/0x301
[  272.847224]  [<ffffffff80255f76>] check_critical_timing+0x2e8/0x2f7
[  272.847229]  [<ffffffff8022c5ac>] printk+0x6c/0x6e
[  272.847232]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.847237]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.847241]  [<ffffffff80429572>] __spin_unlock_irq+0x14/0x17
[  272.847245]  [<ffffffff8042785c>] wait_for_completion+0xbd/0xc6
[  272.847249]  [<ffffffff802262f9>] default_wake_function+0x0/0x19
[  272.847253]  [<ffffffff8042847a>] mutex_unlock+0x9/0x15
[  272.847257]  [<ffffffff80238dec>] blocking_notifier_call_chain+0x10/0x4e
[  272.847262]  [<ffffffff8800a02a>] :tun:tun_init+0x2a/0x6b
[  272.847266]  [<ffffffff8024d597>] sys_init_module+0x15d6/0x1731
[  272.847272]  [<ffffffff80256323>] trace_hardirqs_on+0x9a/0xb9
[  272.847277]  [<ffffffff803d2b89>] register_netdevice+0x0/0x31e
[  272.847282]  [<ffffffff80209e0f>] system_call+0xef/0x15c
[  272.847287] 
[  272.847289]  =>   dump-end timestamp 176547985
[  272.847291] 
[  272.997056] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
