Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYIRSXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYIRSXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbYIRSXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:23:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2287 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYIRSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:23:09 -0400
Message-ID: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
Date: Thu, 18 Sep 2008 11:23:07 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm encountering a very odd issue which only seems to crop up while I
sleep at night. In the morning, I go back to my Linux machine and
there's a ridiculously bad latency I immediately notice in Firefox's
redraw which I cannot explain. glxgears shows the typical 5K FPS, so
it seems like graphics are normal, but there's something causing
horrendous redraw times for Firefox. If I exit X11, the problem then
extends to my virtual terminals. If I switch a VT, it takes about a
second to redraw the whole screen top-to-bottom[1]. I can also get the
same issue if I do page-up/page-down in less, or pretty much anything
that causes the screen to redraw.

I'm using 2.6.27-rc6-tip right now, but this problem occurs on
pristine rc5 and rc6 as well. uptime is only 7 hours, and this problem
seems to get progressively worse over time. Strangely enough,
unloading the 'ath9k' driver causes the latency to outright -vanish-
instantaneously (I only discovered this -after- I made the YouTube
video cited below, so the video doesn't demonstrate this tidbit,
unfortunately). I wish I knew what these symptoms are pointing to,
because this makes no sense to me at all. Is there some hardware
interrupt going bonkers? The only thing I can think of is that I've
got 'irqpoll' on the command line. I have it because I had to reload
the ath9k driver at one point, and this was the result (caused ath9k
to become a useless driver until I rebooted, which re-enabled IRQ 17):

[53997.493777] ath9k: driver unloaded
[54001.098532] ath9k: 0.1
[54001.098833] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[54001.099013] ath9k 0000:03:00.0: setting latency timer to 64
[54001.233825] phy1: Selected rate control algorithm 'ath9k_rate_control'
[54001.236980] phy1: Atheros 5416: mem=0xffffc20000060000, irq=17
[54002.136218] irq 17: nobody cared (try booting with the "irqpoll" option)
[54002.136229] Pid: 0, comm: swapper Tainted: P 2.6.27-rc6-00036-ga551b98 #2
[54002.136234]
[54002.136235] Call Trace:
[54002.136241] <IRQ> [<ffffffff80265231>] __report_bad_irq+0x3d/0x81
[54002.136258] [<ffffffff80265477>] note_interrupt+0x202/0x267
[54002.136265] [<ffffffff80265bfc>] handle_fasteoi_irq+0xba/0xe4
[54002.136273] [<ffffffff8020e7ff>] do_IRQ+0x115/0x191
[54002.136279] [<ffffffff8020bc01>] ret_from_intr+0x0/0xa
[54002.136283] <EOI> [<ffffffff802541bb>] ?
tick_nohz_stop_sched_tick+0x2c5/0x2d4
[54002.136296] [<ffffffff8020a69f>] ? cpu_idle+0x2d/0xed
[54002.136304] [<ffffffff8060d741>] ? rest_init+0x75/0x77
[54002.136309]
[54002.136312] handlers:
[54002.136315] [<ffffffffa0209016>] (ath_isr+0x0/0x160 [ath9k])
[54002.136340] Disabling IRQ #17


latencytop did not give me anything useful while the enormous latency
was showing up, except during one case where 'less' was taking forever
and a half to redraw:

Cause                                                Maximum     Percentage
down acquire_console_sem con_flush_chars write_cha1140.9 msec         70.0 %
Scheduler: waiting for cpu                         79.6 msec         21.0 %
do_sys_poll sys_poll system_call_fastpath           4.8 msec          4.1 %
down acquire_console_sem vt_waitactive vt_ioctl tt  0.9 msec          4.8 %
down acquire_console_sem do_con_write con_write wr  0.8 msec          0.1 %

Process less (5550)                        Total: 1145.3 msec
down acquire_console_sem con_flush_chars write_cha1140.9 msec
99.6 %write system_call_fastpath
Scheduler: waiting for cpu                          1.3 msec          0.3 %
down acquire_console_sem do_con_write con_write wr  0.8 msec
0.1 %ite sys_write system_call_fastpath


latencytop only showed the redraw delay once, couldn't pin Firefox or
VT switch latency on anything. 'top' also doesn't show anything taking
a ridiculous amount of CPU. I can't figure out what precisely the
explanation is for ath9k's horrendous slowdown of the system.

This problem isn't easily bisectable either, because the only way I
can reproduce this problem is by leaving Linux running with ath9k
loaded overnight, and then finding it running like a tortoise in the
morning. I also don't know what kernels this -does not- happen on,
because I just recently put Linux on this particular machine, and I've
only used 2.6.27-rc5 through rc6 and above.

- Steven

[1] http://www.youtube.com/watch?v=4GeCx1gZMpA -- took a quick video
of the problem in progress. be prepared to be absolutely horrified.
