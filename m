Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYCVPNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYCVPNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 11:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCVPNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 11:13:42 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:49803 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYCVPNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 11:13:41 -0400
Message-ID: <47E5221B.5040900@frugalware.org>
Date: Sat, 22 Mar 2008 16:13:31 +0100
From: Gabriel C <crazy@frugalware.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com> <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org> <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 22 Mar 2008, Gabriel C wrote:
>  > Now some time later CPU1 gets woken by an interrupt/IPI and runs the
>>> timer wheel. At this point the pm_timer which is the reference clock
>>> has already wrapped around, so the watchdog thinks that there is a
>>> huge time difference and marks the TSC unstable.
>>>
>>> Aside of that watchdog issue this also affects the other users of
>>> add_timer_on(): e.g. queue_delayed_work_on().
>>>
>>> Can you please apply the patch below and verify it with Andi's
>>> watchdog patch applied ? 
>>
>> Did that , git head , Andi's + your patch but TSC is still marked unstable.
> 
> Doh, stupid me. We do not reevaluate the timer wheel, when we just
> wake up via the smp_reschedule IPI when the resched flag on the other
> CPU is not set. That's a separate vector which is not going through
> irq_enter() / irq_exit(). 
> 
> Does the patch below solve the problem ?

With this one TSC is fine but now I get a warning on boot :

..

[    0.041037] ------------[ cut here ]------------
[    0.041052] WARNING: at arch/x86/kernel/smp_32.c:562 native_smp_call_function_mask+0x23/0x11e()
[    0.041074] Modules linked in:
[    0.041087] Pid: 1, comm: swapper Not tainted 2.6.25-rc6-00243-g028011e-dirty #12
[    0.041107]  [<c011b51c>] warn_on_slowpath+0x40/0x65
[    0.041128]  [<c012b543>] autoremove_wake_function+0xd/0x2d
[    0.041148]  [<c033f28b>] schedule_timeout+0x13/0x99
[    0.041167]  [<c011690d>] __wake_up+0x29/0x39
[    0.041182]  [<c011690d>] __wake_up+0x29/0x39
[    0.041197]  [<c0128769>] call_usermodehelper_exec+0x97/0xa2
[    0.041214]  [<c010dff4>] native_smp_call_function_mask+0x23/0x11e
[    0.041233]  [<c01d4a66>] kobject_uevent_env+0x346/0x368
[    0.041251]  [<c010e46d>] smp_call_function_single+0x50/0x6f
[    0.041268]  [<c01336d2>] tick_nohz_rescan_timers_on+0x27/0x2b
[    0.041287]  [<c013109f>] clocksource_register+0x162/0x174
[    0.041306]  [<c0436203>] kernel_init+0x126/0x25e
[    0.041322]  [<c011943d>] schedule_tail+0x17/0x44
[    0.041337]  [<c0103c7a>] ret_from_fork+0x6/0x1c
[    0.041353]  [<c04360dd>] kernel_init+0x0/0x25e
[    0.041367]  [<c04360dd>] kernel_init+0x0/0x25e
[    0.041381]  [<c01049ab>] kernel_thread_helper+0x7/0x10
[    0.041397]  =======================
[    0.041417] ---[ end trace ca143223eefdc828 ]---     

..

Full dmesg there ->    http://frugalware.org/~crazy/dmesg/dmesg_tsc  

                                                                                                
>
> Thanks,
> 
> 	tglx
> 

Gabriel
