Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZF0QJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZF0QJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 12:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZF0QJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 12:09:11 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:47598
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578AbZF0QJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 12:09:09 -0400
Cc: linux-kernel@vger.kernel.org
Message-Id: <33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com>
From: Michael Guntsche <mike@it-loops.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090627140643.7140f6a9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: BUG: scheduling while atomic
Date: Sat, 27 Jun 2009 18:07:31 +0200
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com> <20090627140643.7140f6a9@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 27, 2009, at 15:06, Alan Cox wrote:

> You could stuff calls to might_sleep() in pty_unthrottle and
> check_unthrottle and see which ones are triggered if any.

Hello Alan,

I put might_sleep in like this...

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 94a5d50..f1882ae 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -149,6 +149,7 @@ static void put_tty_queue(unsigned char c, struct  
tty_struct *tty)
  static void check_unthrottle(struct tty_struct *tty)
  {
   if (tty->count)
+   might_sleep();
     tty_unthrottle(tty);
  }

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index daebe1b..d4bc166 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -79,7 +79,8 @@ static void pty_unthrottle(struct tty_struct *tty)

   if (!o_tty)
     return;
-
+
+ might_sleep();
   tty_wakeup(o_tty);
   set_bit(TTY_THROTTLED, &tty->flags);
  }

and then put some load in my ADSL line. Apparently I get the same dump

[   87.152961] BUG: scheduling while atomic: pptpgw/392/0x00000400
[   87.158939] Modules linked in: emlog nf_nat_irc nf_conntrack_irc  
nf_nat_rtsp nf_conntrack_rtsp
[   87.167644] NIP: c00258d0 LR: c00258c8 CTR: c001cae8
[   87.172645] REGS: c7a61d20 TRAP: 0901   Tainted: G        W    
(2.6.31-rc1)
[   87.179551] MSR: 00009032 <EE,ME,IR,DR>  CR: 24222482  XER: 20000000
[   87.185992] TASK = c794a400[392] 'pptpgw' THREAD: c7a60000
[   87.191330] GPR00: c01c1010 c7a61dd0 c794a400 00000001 00190834  
00000000 0014ff97 00000019
[   87.199780] GPR08: 0834548b 00000004 00000004 c7a60000 00190834
[   87.206055] NIP [c00258d0] __tasklet_schedule+0x80/0x90
[   87.211313] LR [c00258c8] __tasklet_schedule+0x78/0x90
[   87.216477] Call Trace:
[   87.218949] [c7a61dd0] [c00258c8] __tasklet_schedule+0x78/0x90  
(unreliable)
[   87.225969] [c7a61de0] [c01c1010] ppp_asynctty_wakeup+0x90/0xbc
[   87.231941] [c7a61e00] [c017037c] tty_wakeup+0x70/0xa0
[   87.237123] [c7a61e10] [c0178cc8] pty_unthrottle+0x24/0x50
[   87.242652] [c7a61e20] [c0175334] tty_unthrottle+0x5c/0x78
[   87.248179] [c7a61e30] [c0172e70] check_unthrottle+0x10/0x20
[   87.253882] [c7a61e40] [c0174a08] n_tty_read+0x3f8/0x65c
[   87.259233] [c7a61ec0] [c0171bf8] tty_read+0xa8/0xe4
[   87.264243] [c7a61ef0] [c0084004] vfs_read+0xb4/0x1c0
[   87.269335] [c7a61f10] [c008438c] sys_read+0x4c/0x90
[   87.274352] [c7a61f40] [c00118a8] ret_from_syscall+0x0/0x38
[   87.279965] --- Exception: c01 at 0xff2d510
[   87.279974]     LR = 0x100032e0
[   87.287316] Instruction dump:
[   87.290309] 60000020 90090040 4182001c 7fe00124 80010014 83e1000c  
38210010 7c0803a6
[   87.298145] 4e800020 4bfff6d5 7fe00124 80010014 <83e1000c> 38210010  
7c0803a6 4e800020

after that (120 seconds later) I see..

[  360.294730] INFO: task pptpgw:392 blocked for more than 120 seconds.
[  360.301147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"  
disables this message.
[  360.309018] pptpgw        D 0ff2d510     0   392    390 0x00000000
[  360.315257] Call Trace:
[  360.317721] [c7a61870] [c794a400] 0xc794a400 (unreliable)
[  360.323194] [c7a61930] [c0008b20] __switch_to+0x4c/0x6c
[  360.328465] [c7a61940] [c02c6244] schedule+0x190/0x380
[  360.333646] [c7a61980] [c02c6d7c] __mutex_lock_slowpath+0x80/0xd8
[  360.339796] [c7a619b0] [c0175370] tty_throttle+0x20/0x78
[  360.345151] [c7a619c0] [c01737f0] n_tty_receive_buf+0x344/0xfcc
[  360.351115] [c7a61aa0] [c01789b8] pty_write+0x8c/0xdc
[  360.356210] [c7a61ac0] [c01c1410] ppp_async_push+0x3d4/0x544
[  360.361910] [c7a61b20] [c01c15d4] ppp_async_send+0x54/0x6c
[  360.367438] [c7a61b30] [c01bd948] ppp_push+0x3f4/0x530
[  360.372614] [c7a61b90] [c01be12c] ppp_xmit_process+0x444/0x548
[  360.378488] [c7a61bf0] [c01bf62c] ppp_start_xmit+0x198/0x1d0
[  360.384203] [c7a61c10] [c01f5554] dev_hard_start_xmit+0x1c0/0x350
[  360.390341] [c7a61c40] [c0207010] __qdisc_run+0x1c8/0x250
[  360.395784] [c7a61c70] [c01f78b0] net_tx_action+0xfc/0x11c
[  360.401314] [c7a61c90] [c00256e0] __do_softirq+0xa8/0x120
[  360.406767] [c7a61cd0] [c00064e4] do_softirq+0x58/0x5c
[  360.411943] [c7a61ce0] [c0025530] irq_exit+0x94/0x98
[  360.416952] [c7a61cf0] [c000e768] timer_interrupt+0x12c/0x188
[  360.422750] [c7a61d10] [c0011f40] ret_from_except+0x0/0x14
[  360.428282] --- Exception: 901 at __tasklet_schedule+0x80/0x90
[  360.428293]     LR = __tasklet_schedule+0x78/0x90
[  360.438870] [c7a61de0] [c01c1010] ppp_asynctty_wakeup+0x90/0xbc
[  360.444837] [c7a61e00] [c017037c] tty_wakeup+0x70/0xa0
[  360.450015] [c7a61e10] [c0178cc8] pty_unthrottle+0x24/0x50
[  360.455544] [c7a61e20] [c0175334] tty_unthrottle+0x5c/0x78
[  360.461071] [c7a61e30] [c0172e70] check_unthrottle+0x10/0x20
[  360.466783] [c7a61e40] [c0174a08] n_tty_read+0x3f8/0x65c
[  360.472136] [c7a61ec0] [c0171bf8] tty_read+0xa8/0xe4
[  360.477171] [c7a61ef0] [c0084004] vfs_read+0xb4/0x1c0
[  360.482264] [c7a61f10] [c008438c] sys_read+0x4c/0x90
[  360.487278] [c7a61f40] [c00118a8] ret_from_syscall+0x0/0x38
[  360.492893] --- Exception: c01 at 0xff2d510
[  360.492902]     LR = 0x100032e0

I am not sure if the might_sleep entries are at the correct position  
but it apparently did not make a difference.

Kind regards,
Michael
