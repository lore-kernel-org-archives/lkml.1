Return-Path: <linux-kernel-owner+w=401wt.eu-S965427AbXDNKZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbXDNKZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 06:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965509AbXDNKZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 06:25:33 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:48638 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXDNKZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 06:25:32 -0400
Date: Sat, 14 Apr 2007 12:25:28 +0200
From: Jan Kasprzak <kas@fi.muni.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MOXA: mxser_new lockup
Message-ID: <20070414102528.GB20376@fi.muni.cz>
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <462079ED.2000605@gmail.com>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 14 Apr 2007 12:25:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
: I went through the locking again just now, but I can't see anything
: wrong. Could you please enable CONFIG_PROVE_LOCKING and CONFIG_DEBUG_LOCKDEP and
: retest?
: 
: And also post stty -a -F /dev/ttyMIXX or a setup passed to
: tcsetattr/ioctl(TCSETA/S) if available. What do you use for communication?

	I use cu(1) from the uucp package. This MOXA card is used as a
serial console for 8 other linux boxes (mgetty is on the other side).

	I have recompiled the kernel with debugging options you have
mentioned, connected to the remote serial console using "cu -l ttyMI0 -s 38400",
logged to the remote system, and ran "find / -print" to generate some
serial traffic. It went for a minute or so, but as soon as I have pressed
enter on my keyboard (generating traffic in an opposite direction),
I've got the recursive locking message (I have tried it twice, two
dumps are attached).

	Looking at the code, maybe the &port->slock in mxser_interrupt()
should be dropped before calling mxser_receive_chars() (and probably
also befor calling other mxser_* functions too). A proof-of-concept
patch attached - I am not able to reproduce the lockup with this patch.
Another approach would be to use in_interrupt() all over the code to
determine whether the lock should be re-aquired or not.

-Yenya

[ now the two "recursive locking" dumps, and the patch itself ]

=============================================
[ INFO: possible recursive locking detected ]
2.6.21-rc6 #8
---------------------------------------------
cu/1793 is trying to acquire lock:
 (&info->slock){++..}, at: [<ffffffff88003afd>] mxser_flush_chars+0x4d/0x83 [mxser_new]

but task is already holding lock:
 (&info->slock){++..}, at: [<ffffffff88003ead>] mxser_interrupt+0xc2/0x237 [mxser_new]

other info that might help us debug this:
2 locks held by cu/1793:
 #0:  (&tty->atomic_write_lock){--..}, at: [<ffffffff802252dd>] tty_write+0x9e/0x211
 #1:  (&info->slock){++..}, at: [<ffffffff88003ead>] mxser_interrupt+0xc2/0x237 [mxser_new]

stack backtrace:

Call Trace:
 <IRQ>  [<ffffffff8028c6e4>] __lock_acquire+0x155/0xbe1
 [<ffffffff88003afd>] :mxser_new:mxser_flush_chars+0x4d/0x83
 [<ffffffff8028d1eb>] lock_acquire+0x7b/0x9f
 [<ffffffff88003afd>] :mxser_new:mxser_flush_chars+0x4d/0x83
 [<ffffffff8025947c>] _spin_lock_irqsave+0x2d/0x3e
 [<ffffffff88003afd>] :mxser_new:mxser_flush_chars+0x4d/0x83
 [<ffffffff80212a9b>] n_tty_receive_buf+0xd26/0xddc
 [<ffffffff8028d0db>] __lock_acquire+0xb4c/0xbe1
 [<ffffffff803377b1>] flush_to_ldisc+0x3d/0x191
 [<ffffffff8033788e>] flush_to_ldisc+0x11a/0x191
 [<ffffffff803378a5>] flush_to_ldisc+0x131/0x191
 [<ffffffff880025aa>] :mxser_new:mxser_receive_chars+0x25f/0x26e
 [<ffffffff88003f83>] :mxser_new:mxser_interrupt+0x198/0x237
 [<ffffffff8020ed84>] handle_IRQ_event+0x1e/0x51
 [<ffffffff8029ccd4>] handle_fasteoi_irq+0x9a/0xd9
 [<ffffffff80260ccd>] do_IRQ+0x6f/0xd6
 [<ffffffff80253aa6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80259406>] _spin_unlock_irqrestore+0x40/0x44
 [<ffffffff802175dc>] write_chan+0x2e0/0x2ff
 [<ffffffff80275d26>] default_wake_function+0x0/0xe
 [<ffffffff802253b6>] tty_write+0x177/0x211
 [<ffffffff802172fc>] write_chan+0x0/0x2ff
 [<ffffffff802142a3>] vfs_write+0xce/0x157
 [<ffffffff80214baa>] sys_write+0x45/0x6e
 [<ffffffff8025355e>] system_call+0x7e/0x83

BUG: spinlock lockup on CPU#1, cu/1793, ffffffff880082a8

Call Trace:
 <IRQ>  [<ffffffff80207632>] _raw_spin_lock+0xcc/0xf3
 [<ffffffff80259484>] _spin_lock_irqsave+0x35/0x3e
 [<ffffffff88003afd>] :mxser_new:mxser_flush_chars+0x4d/0x83
 [<ffffffff80212a9b>] n_tty_receive_buf+0xd26/0xddc
 [<ffffffff8028d0db>] __lock_acquire+0xb4c/0xbe1
 [<ffffffff803377b1>] flush_to_ldisc+0x3d/0x191
 [<ffffffff8033788e>] flush_to_ldisc+0x11a/0x191
 [<ffffffff803378a5>] flush_to_ldisc+0x131/0x191
 [<ffffffff880025aa>] :mxser_new:mxser_receive_chars+0x25f/0x26e
 [<ffffffff88003f83>] :mxser_new:mxser_interrupt+0x198/0x237
 [<ffffffff8020ed84>] handle_IRQ_event+0x1e/0x51
 [<ffffffff8029ccd4>] handle_fasteoi_irq+0x9a/0xd9
 [<ffffffff80260ccd>] do_IRQ+0x6f/0xd6
 [<ffffffff80253aa6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80259406>] _spin_unlock_irqrestore+0x40/0x44
 [<ffffffff802175dc>] write_chan+0x2e0/0x2ff
 [<ffffffff80275d26>] default_wake_function+0x0/0xe
 [<ffffffff802253b6>] tty_write+0x177/0x211
 [<ffffffff802172fc>] write_chan+0x0/0x2ff
 [<ffffffff802142a3>] vfs_write+0xce/0x157
 [<ffffffff80214baa>] sys_write+0x45/0x6e
 [<ffffffff8025355e>] system_call+0x7e/0x83


-----------------------------------------------------------------------
Another one:

=============================================
[ INFO: possible recursive locking detected ]
����ӡ���2.6.21-rc6 #8
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&info->slock){++..}, at: [<ffffffff88003c6d>] mxser_stop+0x1c/0x43 [mxser_new]

but task is already holding lock:
 (&info->slock){++..}, at: [<ffffffff88003ead>] mxser_interrupt+0xc2/0x237 [mxser_new]

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (&info->slock){++..}, at: [<ffffffff88003ead>] mxser_interrupt+0xc2/0x237 [mxser_new]

stack backtrace:

Call Trace:
 <IRQ>  [<ffffffff8028c6e4>] __lock_acquire+0x155/0xbe1
 [<ffffffff88003c6d>] :mxser_new:mxser_stop+0x1c/0x43
 [<ffffffff8028d1eb>] lock_acquire+0x7b/0x9f
 [<ffffffff88003c6d>] :mxser_new:mxser_stop+0x1c/0x43
 [<ffffffff8025947c>] _spin_lock_irqsave+0x2d/0x3e
 [<ffffffff88003c6d>] :mxser_new:mxser_stop+0x1c/0x43
 [<ffffffff8021207a>] n_tty_receive_buf+0x305/0xddc
 [<ffffffff8028d0db>] __lock_acquire+0xb4c/0xbe1
 [<ffffffff803377b1>] flush_to_ldisc+0x3d/0x191
 [<ffffffff8033788e>] flush_to_ldisc+0x11a/0x191
 [<ffffffff803378a5>] flush_to_ldisc+0x131/0x191
 [<ffffffff880025aa>] :mxser_new:mxser_receive_chars+0x25f/0x26e
 [<ffffffff88003f83>] :mxser_new:mxser_interrupt+0x198/0x237
 [<ffffffff8020ed84>] handle_IRQ_event+0x1e/0x51
 [<ffffffff8029ccd4>] handle_fasteoi_irq+0x9a/0xd9
 [<ffffffff80260ccd>] do_IRQ+0x6f/0xd6
 [<ffffffff8025f6ae>] default_idle+0x35/0x51
 [<ffffffff8025f679>] default_idle+0x0/0x51
 [<ffffffff80253aa6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8025f679>] default_idle+0x0/0x51
 [<ffffffff8025f6ae>] default_idle+0x35/0x51
 [<ffffffff8025f6b0>] default_idle+0x37/0x51
 [<ffffffff8025f6ae>] default_idle+0x35/0x51
 [<ffffffff802420fc>] cpu_idle+0x57/0x76


BUG: spinlock lockup on CPU#1, swapper/0, ffffffff880082a8

Call Trace:
 <IRQ>  [<ffffffff80207632>] _raw_spin_lock+0xcc/0xf3
 [<ffffffff80259484>] _spin_lock_irqsave+0x35/0x3e
 [<ffffffff88003c6d>] :mxser_new:mxser_stop+0x1c/0x43
 [<ffffffff8021207a>] n_tty_receive_buf+0x305/0xddc
 [<ffffffff8028d0db>] __lock_acquire+0xb4c/0xbe1
 [<ffffffff803377b1>] flush_to_ldisc+0x3d/0x191
 [<ffffffff8033788e>] flush_to_ldisc+0x11a/0x191
 [<ffffffff803378a5>] flush_to_ldisc+0x131/0x191
 [<ffffffff880025aa>] :mxser_new:mxser_receive_chars+0x25f/0x26e
 [<ffffffff88003f83>] :mxser_new:mxser_interrupt+0x198/0x237
 [<ffffffff8020ed84>] handle_IRQ_event+0x1e/0x51
 [<ffffffff8029ccd4>] handle_fasteoi_irq+0x9a/0xd9
 [<ffffffff80260ccd>] do_IRQ+0x6f/0xd6
 [<ffffffff8025f6ae>] default_idle+0x35/0x51
 [<ffffffff8025f679>] default_idle+0x0/0x51
 [<ffffffff80253aa6>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8025f679>] default_idle+0x0/0x51
 [<ffffffff8025f6ae>] default_idle+0x35/0x51
 [<ffffffff8025f6b0>] default_idle+0x37/0x51
[...]

-----------------------------------------------------------------------

Signed-off-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>

--- linux-2.6.21-rc6/drivers/char/mxser_new.c.orig	2007-04-14 11:50:54.000000000 +0200
+++ linux-2.6.21-rc6/drivers/char/mxser_new.c	2007-04-14 12:14:28.000000000 +0200
@@ -2352,27 +2352,43 @@
 					if (iir == MOXA_MUST_IIR_GDA ||
 					    iir == MOXA_MUST_IIR_RDA ||
 					    iir == MOXA_MUST_IIR_RTO ||
-					    iir == MOXA_MUST_IIR_LSR)
+					    iir == MOXA_MUST_IIR_LSR) {
+						spin_unlock(&port->slock);
 						mxser_receive_chars(port,
 								&status);
+						spin_lock(&port->slock);
+					}
 
 				} else {
 					status &= port->read_status_mask;
-					if (status & UART_LSR_DR)
+					if (status & UART_LSR_DR) {
+						spin_unlock(&port->slock);
 						mxser_receive_chars(port,
 								&status);
+						spin_lock(&port->slock);
+					}
 				}
 				msr = inb(port->ioaddr + UART_MSR);
-				if (msr & UART_MSR_ANY_DELTA)
+				if (msr & UART_MSR_ANY_DELTA) {
+					spin_unlock(&port->slock);
 					mxser_check_modem_status(port, msr);
+					spin_lock(&port->slock);
+				}
 
 				if (port->board->chip_flag) {
 					if (iir == 0x02 && (status &
-								UART_LSR_THRE))
+							UART_LSR_THRE)) {
+						spin_unlock(&port->slock);
+						
 						mxser_transmit_chars(port);
+						spin_lock(&port->slock);
+					}
 				} else {
-					if (status & UART_LSR_THRE)
+					if (status & UART_LSR_THRE) {
+						spin_unlock(&port->slock);
 						mxser_transmit_chars(port);
+						spin_lock(&port->slock);
+					}
 				}
 			} while (int_cnt++ < MXSER_ISR_PASS_LIMIT);
 			spin_unlock(&port->slock);
-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
