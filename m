Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZGOPKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZGOPKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZGOPKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:10:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46305 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753611AbZGOPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:10:43 -0400
Date: Wed, 15 Jul 2009 16:11:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tty related hangs with 2.6.31-rc3
Message-ID: <20090715161142.55083da7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090715132956.GA10004@skywalker>
References: <20090715132956.GA10004@skywalker>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 18:59:56 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Hi,
> 
> I am finding tty related hangs with 2.6.31-rc3. This didn't happen 
> before. This happen when i close the emacs session. The /proc/<pid>/stack
> content is below      

Thanks - nice clear trace. Looks like a bug in the n_tty locking changes
from a few releases back that the pty changes are triggering.

Basically process_echoes calls tty_put_char which if it thinks a device
queue was full and now has a bit of space will call tty_wakeup which can
call process_echoes and thus deadlock. With a physical serial device we
will even sometimes call tty_wakeup() from the serial transmit path
which is an irq path (which makes this doubly wrong as it then takes
mutexes)

Emacs presumably uses fasync which is the trigger for this. You need the
right timing combined with the new pty behaviour combined with FASYNC to
trigger it.


> [<c0362c5b>] process_echoes+0x2b/0x2e0
[which tries to take the lock we already hold (end A)]
> [<c03638cb>] n_tty_write_wakeup+0xb/0x40
[which processes our ldisc wakeup (end A)]
> [<c0360a88>] tty_wakeup+0x58/0x70
[which wakes up our tty (end A)]
> [<c0368347>] pty_write+0x67/0x70
[our write method is for tty/pty pairs end A output, queued to end B]
> [<c035f1cb>] tty_put_char+0x2b/0x40
[calls tty_put_char to write the echoed byte to end A output]
> [<c036291f>] do_output_char+0xef/0x200
[the fake typed character is echoed back towards end B]
> [<c0362d4e>] process_echoes+0x11e/0x2e0
[tries to process echo characters on end A]
> [<c0364292>] n_tty_receive_char+0x102/0x710
[ receives a byte that we've faked typing to end A input]
> [<c0364ac0>] n_tty_receive_buf+0x220/0x410
[ioctl method calls the ld->ops->receive_buf for n_tty (unsafely but that
bug is old]
> [<c036059c>] tiocsti+0x8c/0xa0
> [<c0361aca>] tty_ioctl+0x25a/0x310
> [<c01e52c8>] vfs_ioctl+0x28/0x80
> [<c01e54f4>] do_vfs_ioctl+0x64/0x1c0
> [<c01e56a3>] sys_ioctl+0x53/0x70
> [<c0102e3c>] sysenter_do_call+0x12/0x28
> [<ffffffff>] 0xffffffff

Do you have the lock validator enabled and if so did it have anything
useful to report ?

Please try the following. I suspect this is the real fix:

n_tty: Fix echo race

From: Alan Cox <alan@linux.intel.com>

If a tty in N_TTY mode with echo enabled manages to get itself into a state
where
	- echo characters are pending
	- FASYNC is enabled
	- tty_write_wakeup is called from either
		- a device write path (pty)
		- an IRQ (serial)

then it either deadlocks or explodes taking a mutex in the IRQ path.

On the serial side it is almost impossible to reproduce because you have to
go from a full serial port to a near empty one with echo characters
pending. The pty case happens to have become possible to trigger using
emacs and ptys, the pty changes having created a scenario which shows up
this bug.

The code path is

	n_tty:process_echoes() (takes mutex)
	tty_io:tty_put_char()
	pty:pty_write  (or serial paths)
	tty_wakeup     (from pty_write or serial IRQ)
	n_tty_write_wakeup()
	process_echoes()
	*KABOOM*

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/n_tty.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)


diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 94a5d50..ff47907 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1331,9 +1331,6 @@ handle_newline:
 
 static void n_tty_write_wakeup(struct tty_struct *tty)
 {
-	/* Write out any echoed characters that are still pending */
-	process_echoes(tty);
-
 	if (tty->fasync && test_and_clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
 }

