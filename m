Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbYICIWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbYICIWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYICIWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:22:21 -0400
Received: from mailer1.option.com ([81.246.70.162]:45041 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbYICIWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:22:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgBAMvlvUgKAAAZ/2dsb2JhbAAItgSBaQ
Message-ID: <48BE3FD9.6070303@option.com>
Date: Wed, 03 Sep 2008 09:42:17 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: /drivers/char/n_tty.c drops characters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2008 08:22:18.0717 (UTC) FILETIME=[2E2880D0:01C90D9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
While I may be taking this out of context but
from a git log on include/linux/tty_ldisc.c Alan Cox says. 

>  Finally many drivers had invalid and unsafe attempts to avoid buffer
>     overflows by directly invoking tty methods extracted out of the innards
>     of work queue structs. These are no longer needed and all go away. That
>     fixes various random hangs with serial ports on overflow.

Maybe my interpretation of this statement is incorrect but
is Alan implying that ttys will no longer drop charaters ? 
if this is what Alan is saying it is simply not true but it can be implemented.

If tty's use the /drivers/char/n_tty.c line discipline.
a quick look at drivers/char/tty_io.c sees that
tty_flip_buffer_push calls directly or indirectly flush_to_ldisc
which in turns copies to disc->ops->receive_buf normally n_tty_receive_buf
which normally is the ntty line discipline ( the default )

The simplest code path to follow in n_tty_receive_buf if tty->real_raw is set is
below
	if (tty->real_raw) {
		spin_lock_irqsave(&tty->read_lock, cpuflags);
		i = min(N_TTY_BUF_SIZE - tty->read_cnt,
			N_TTY_BUF_SIZE - tty->read_head);
		i = min(count, i);
		memcpy(tty->read_buf + tty->read_head, cp, i);
		tty->read_head = (tty->read_head + i) & (N_TTY_BUF_SIZE-1);
		tty->read_cnt += i;
		cp += i;
		count -= i;

		i = min(N_TTY_BUF_SIZE - tty->read_cnt,
			N_TTY_BUF_SIZE - tty->read_head);
		i = min(count, i);
		memcpy(tty->read_buf + tty->read_head, cp, i);
		tty->read_head = (tty->read_head + i) & (N_TTY_BUF_SIZE-1);
		tty->read_cnt += i;
		spin_unlock_irqrestore(&tty->read_lock, cpuflags);
	}

My understanding of this code might be imperfect but this really looks
likes this blindly copies into a ring buffer of N_TTY_BUF_SIZE &
doesn't return any indication an attempt to copy a tty buffer of larger than N_TTY_BUF_SIZE
& overflows the buffer before the task activated by the code at the bottom of n_tty_receive_buf

i.e.
if (waitqueue_active(&tty->read_wait))
			wake_up_interruptible(&tty->read_wait);
which typically wakes up the read_chan function in the same file.

The main things I see wrong with this code is performance
& dropping characters from serial devices, this which might be quite
acceptable for reading keystrokes but is not for high speed modems.

My main complaints are
1) there is no mechanism for informing the tty layer that not all the
characters are copied from the tty layer to the line discipline.

2) The use of a a ring buffer in the line discipline,
we are memcpying at least twice in the kernel before passing the
buffer back to userland.

3) There is no mechanism for tty_io.c of informing the
char driver which is feeding the tty that it can
release flow control & start feeding read buffers
to the device hardware again to restart io. 

Less important points in point 3.
In my attempts I gave up on
I wrapped disc->ops->receive_buf with my own receive_buf
callback but this would break if the line discipline changed.

I also accidently made my code recursive because I was
calling calling tty_flip_buf calling disc->ops_receive buf
again & stealing a lock again as the tty->low_latency
flag was set in the driver, so the developer should be
warned not to use this flag if we put the callback to
start flow control in flush_to_line_disc.

Maybe it might be an idea to have a user settable minimum
characters available in the tty_layer before the callback
gets done.

4) Maybe the tty_io layer should be using a ring buffer
but this is just a silly & probably plain wrong opinion of mine.

I currently don't know this code & all the line disciplines
well enough to fix this code reliably & I think for all the
line discipline be a patch of over 300 lines. I don't think
I have the street cred to get a patch like this into such a critical part
of the mainstream kernel & probably rightly so.


-- 
best regards,
D.J. Barrow
