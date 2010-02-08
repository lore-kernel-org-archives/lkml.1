Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab0BHFid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 00:38:33 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41087 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0BHFib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 00:38:31 -0500
Date: Mon, 8 Feb 2010 06:38:30 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100208053830.GA7128@rhlx01.hs-esslingen.de>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100207191949.GA23665@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 07, 2010 at 08:19:49PM +0100, Andreas Mohr wrote:
> Umm, CONFIG_FTRACE_NMI_ENTER, anyone?
> That sounds like the most invasive candidate at least.

Nope, that wasn't it.
(I removed both CONFIG_DYNAMIC_FTRACE - which implicitly removes
CONFIG_FTRACE_NMI_ENTER - and CONFIG_FTRACE_SYSCALLS)

Next theory:

On this -rc7 upgrade, I had another NMI watchdog trigger on bootup:

BUG: NMI Watchdog detected LOCKUP on CPU0, ip c1045170, registers:
Modules linked in:

Pid: 266, comm: kwatchdog Not tainted 2.6.33-rc7 #1 Inspiron 8000
/Inspiron 8000
EIP: 0060:[<c1045170>] EFLAGS: 00000082 CPU: 0
EIP is at timekeeping_forward_now+0x116/0x139
EAX: 00000000 EBX: efd7f032 ECX: fb5d3b74 EDX: 45643ff3
ESI: 8e7480ca EDI: ffffffff EBP: df8cdf3c ESP: df8cdf18
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kwatchdog (pid: 266, ti=df8cd000 task=df9bc1c0 task.ti=df8cd000)
Stack:
 005ba19f 00000000 00000000 0000231e 2ab321bc 0000231e c13b6010 c13b6010
<0> c13b6014 df8cdf4c c10451a4 c1392128 c13b6010 df8cdf58 c1045d16
c13b6010
<0> df8cdf70 c1046dc6 c130ee48 c130eeac c139212c c139212c df8cdf84
c1046e36
Call Trace:
 [<c10451a4>] ? change_clocksource+0x11/0x3e
 [<c1045d16>] ? timekeeping_notify+0x24/0x31
 [<c1046dc6>] ? clocksource_select+0x9e/0xa7
 [<c1046e36>] ? __clocksource_change_rating+0x67/0x6c
 [<c1046f1c>] ? clocksource_watchdog_kthread+0xe1/0x104
 [<c1046e3b>] ? clocksource_watchdog_kthread+0x0/0x104
 [<c103e50c>] ? kthread+0x63/0x68
 [<c103e4a9>] ? kthread+0x0/0x68
 [<c1002cba>] ? kernel_thread_helper+0x6/0x10
Code: ea f6 c1 20 0f 45 c2 0f 45 d7 89 c1 89 f7 8b 45 e4 89 d3 c1 ff 1f
01 f1 11 fb 31 d2 eb 0a 81 c1 00 36 65 c4 83 d
3 ff 42 83 fb 00 <77> f1 81 f9 ff c9 9a 3b 77 e9 89 45 e4 8d 04 02 a3 0c
21 46 c1
---[ end trace a7919e7f17c0a725 ]---


And then a cat current_clocksource managed to hang again.
(NOTE that the - now complete! - SysRq-T list does NOT show any backtraces
of kwatchdog any more, only many other processes)
Could it be that the (rather disruptive) NMI watchdog confuses the current state at
change_clocksource and causes that stuff to get left with
clocksource_mutex remaining taken?

Then my userspace cat current_clocksource hits the leftover mutex and
has nowhere to go...

And, could it perhaps be that the NMI watchdog gets confused by
simple timekeeping inconsistencies _during_ clocksource change?
(in that case we'd simply need to make sure NMI watchdog remains
satisfied with current conditions during clocksource rochade)


And the lockdep thingy is suboptimal: a developer colleague told me that
"INFO: lockdep is turned off." simply gets done after the first backtrace
in order to avoid subsequent spews.
But at that point in time some people (such as him) _would_ have liked to trace
some further issues.

So at least it should be enhanced to "INFO: lockdep is turned off (or defused!)."
or some such to clearly indicate that something is rotten,
and one should think of perhaps increasing one-time use to up to 3 times or so.

Thanks,

Andreas Mohr
