Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab0BYBj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:39:58 -0500
Received: from mout.perfora.net ([74.208.4.194]:55844 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758679Ab0BYBj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:39:56 -0500
MIME-Version: 1.0
From: vb@vsbe.com
Date: Wed, 24 Feb 2010 17:39:33 -0800
Message-ID: <f608b67d1002241739o2668b93cuc9eea669f70a407d@mail.gmail.com>
Subject: "irq 42: nobody cared" and I/O errors on serial ports
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-Provags-ID: V01U2FsdGVkX1/fFJb/qVJb4GUe1YtupQ91KSn6BN+5yYHnyWG
 kwHE1uwAmtsFpSmc0sbItwGeLG+SWymd+cT4VQP+Cet2LFrUXp
 q4FDW5bClwhiPZSIJyohw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I saw this issue mentioned in the past
(http://lkml.indiana.edu/hypermail/linux/kernel/0612.3/0756.html) but
there has been no resolution. I also started experiencing this problem
recently, it happens on a dual uart powerpc CPU when one of the ports
is used by getty and its input is held in active state all the time,
(apparently generating continuous UART breaks).

It looks like getty gets tired of the junk it sees on the channel and
shuts the port down. Soon after that I see this message reporting a
dangling IRQ.

I investigated a bit, what happens is that the second port (which was
shut down on getty restart) asserts the IRQ, but the ISR
(8250.c:serial8250_interrupt()) does not look at the second port's
state, as the port is now unlinked from the list of active ports. The
ISR reports the interrupt not handled.

Now, why does the port assert the IRQ? This is because of the
following code in serial_core.c:uart_close():

	uart_shutdown(state);
	uart_flush_buffer(tty);

        tty_ldisc_flush(tty);

uart_shutdown() disables ports interrupts and takes it out of the
list, uart_flush_buffer() returns right away on a port which is down,
uart_ldisc_flush()  however doesn't mind. It goes like this:

[ee0b1c70] [c01848bc] serial8250_start_tx+0x2c/0x268
[ee0b1ca0] [c017a8e4] uart_send_xchar+0xb4/0xd4
[ee0b1cd0] [c017ec04] uart_unthrottle+0x80/0x144
[ee0b1d10] [c01754d0] tty_unthrottle+0x64/0x80
[ee0b1d20] [c0173ca4] reset_buffer_flags+0xb4/0xe8
[ee0b1d40] [c0173cf0] n_tty_flush_buffer+0x18/0x88
[ee0b1d60] [c01777d8] tty_ldisc_flush+0x3c/0x60
[ee0b1d70] [c017d850] uart_close+0x1ec/0x2d0
[ee0b1da0] [c01712dc] tty_release_dev+0x168/0x4f4
[ee0b1e40] [c0171688] tty_release+0x20/0x3c
[ee0b1e60] [c009c020] __fput+0x70/0x168
[ee0b1e80] [c0098884] filp_close+0x60/0x94
[ee0b1ea0] [c003d488] put_files_struct+0xf4/0x110
[ee0b1ec0] [c003f1a0] do_exit+0x560/0x5e8
[ee0b1f10] [c003f270] do_group_exit+0x48/0xac
[ee0b1f30] [c003f2e8] sys_exit_group+0x14/0x28
[ee0b1f40] [c000f9a0] ret_from_syscall+0x0/0x3c


where 8250.c:serial8250_start_tx() reenables transmit interrupt of the
channel which was excluded from interrupt processing.

what would be a proper fix here - should
serial_core.c:uart_unthrottle() be modified not to attempt sending a
character on the disabled tty?

cheers,
vadim
