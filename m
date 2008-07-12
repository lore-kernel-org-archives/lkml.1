Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYGLAoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYGLAoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 20:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYGLAoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 20:44:16 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:45658 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYGLAoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 20:44:15 -0400
Message-ID: <4877FE5C.3000900@skyrush.com>
Date: Fri, 11 Jul 2008 18:44:12 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com>	<87fxqurqpz.fsf@denkblock.local>	<486E83C3.1040509@skyrush.com>	<20080704212335.4ffc8230@lxorguk.ukuu.org.uk>	<486E9366.2090901@skyrush.com> <20080711154748.407ea6c9@lxorguk.ukuu.org.uk>
In-Reply-To: <20080711154748.407ea6c9@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> seems that the following two calls do the same thing in n_tty.c:
>> 		n_tty_flush_buffer(tty);
>> 		tty_driver_flush_buffer(tty);
> 
> Sorry missed this originally - they don't do the same thing. The first
> clears out anything in the ldisc internally the second clears out
> anything in the tty driver itself.

Alan, before I wrote this, I had put a printk() in n_tty_flush_buffer()
and noticed it was called twice when ^C was hit in an xterm.  Then I did
some investigating into this a few days ago, putting a dump_stack() in
n_tty_flush_buffer() so I could see how it is being called.

I realized the calls indeed have different purposes at that point.  I
still wonder, though, why when processing a ^C in an xterm/pty,
n_tty_flush_buffer() does get called again from the driver call.  See
the two traces below from the ldisc and driver flushes:

***********  CTRL-C received
Pid: 4669, comm: xterm Not tainted 2.6.26-rc8-git3 #1
 [<c0283126>] n_tty_flush_buffer+0xd/0x67
 [<c028385c>] n_tty_receive_buf+0x398/0xd87
 [<c031824b>] ? sock_aio_read+0xed/0xfb
 [<c017a824>] ? do_sync_read+0xab/0xe9
 [<c0136257>] ? hrtimer_forward+0xd6/0xec
 [<c0285569>] pty_write+0x2d/0x3b
 [<c0283450>] write_chan+0x21b/0x28f
 [<c011bfa4>] ? default_wake_function+0x0/0xd
 [<c028103f>] tty_write+0x14e/0x1be
 [<c0283235>] ? write_chan+0x0/0x28f
 [<c017a8ec>] ? rw_verify_area+0x8a/0xad
 [<c0280ef1>] ? tty_write+0x0/0x1be
 [<c017ae88>] vfs_write+0x8c/0x133
 [<c017b48c>] sys_write+0x3b/0x60
 [<c0103aa3>] sysenter_past_esp+0x78/0xb1
 =======================
Pid: 4669, comm: xterm Not tainted 2.6.26-rc8-git3 #1
 [<c02857c5>] ? pty_unthrottle+0x15/0x21
 [<c0283126>] n_tty_flush_buffer+0xd/0x67
 [<c0285663>] pty_flush_buffer+0x20/0x67
 [<c038ae61>] ? _spin_unlock_irqrestore+0x1b/0x2f
 [<c0284934>] tty_driver_flush_buffer+0x13/0x15
 [<c0283863>] n_tty_receive_buf+0x39f/0xd87
 [<c031824b>] ? sock_aio_read+0xed/0xfb
 [<c017a824>] ? do_sync_read+0xab/0xe9
 [<c0136257>] ? hrtimer_forward+0xd6/0xec
 [<c0285569>] pty_write+0x2d/0x3b
 [<c0283450>] write_chan+0x21b/0x28f
 [<c011bfa4>] ? default_wake_function+0x0/0xd
 [<c028103f>] tty_write+0x14e/0x1be
 [<c0283235>] ? write_chan+0x0/0x28f
 [<c017a8ec>] ? rw_verify_area+0x8a/0xad
 [<c0280ef1>] ? tty_write+0x0/0x1be
 [<c017ae88>] vfs_write+0x8c/0x133
 [<c017b48c>] sys_write+0x3b/0x60
 [<c0103aa3>] sysenter_past_esp+0x78/0xb1
 =======================

In a Linux virtual console/tty, however, the tty driver flush doesn't
call the ldisc flush again in my tests:

***********  CTRL-C received
Pid: 6, comm: events/0 Not tainted 2.6.26-rc8-git3 #1
 [<c0283126>] n_tty_flush_buffer+0xd/0x67
 [<c028385c>] n_tty_receive_buf+0x398/0xd87
 [<c038ab32>] ? _spin_lock_irqsave+0x27/0x41
 [<c038ab32>] ? _spin_lock_irqsave+0x27/0x41
 [<c038ae61>] ? _spin_unlock_irqrestore+0x1b/0x2f
 [<c027f3ee>] ? tty_ldisc_try+0x2f/0x35
 [<c027f9e2>] flush_to_ldisc+0xde/0x14d
 [<c013129d>] run_workqueue+0x78/0x102
 [<c027f904>] ? flush_to_ldisc+0x0/0x14d
 [<c0131a0b>] ? worker_thread+0x0/0xbf
 [<c0131abf>] worker_thread+0xb4/0xbf
 [<c0133f4d>] ? autoremove_wake_function+0x0/0x33
 [<c0133e77>] kthread+0x3b/0x64
 [<c0133e3c>] ? kthread+0x0/0x64
 [<c0104753>] kernel_thread_helper+0x7/0x10
 =======================


						-Joe
