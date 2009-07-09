Return-Path: <linux-kernel-owner+w=401wt.eu-S1761562AbZGIObw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761562AbZGIObw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761031AbZGIObr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:31:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:63306 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761049AbZGIObq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=LHq0oR5FX83mV+2Pqb+nLZTZ/Cief3wCE066gqOKHbeFKLahAgblUDxDxY6JVQXRXE
         WY+AgKJJlXj9mV+8j5Ps8vJl8Whp0u9DYSPp7tbzRWeizkx9coHpHuBXnibpN2cUG7Vj
         3D3anuMgyYoUpebaoKlI2QAOMPwmqBL3cIgQk=
Date: Thu, 9 Jul 2009 10:31:41 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, xorg@lists.freedesktop.org
Subject: SIGQUIT from tty layer
Message-ID: <20090709143141.GA17551@ben-laptop>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, xorg@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

Last night I started chipping away at a (presumable xserver) bug[1] that's
been bothering me for some time now. With recent xservers, running
compiz will sporatically cause the xserver to crash, being send SIGQUIT
by some unknown process.  Looking further into the matter with
systemtap, I found that it was keventd sending the signal, specifically
through this path,

send_signal: SIGQUIT was sent to X (pid:2787) by events/1 uid:0
 0xffffffff8106b301 : T.649+0x1/0x2c0 [kernel]
 0xffffffff8106b8f3 : __group_send_sig_info+0x13/0x20 [kernel]
 0xffffffff8106c254 : group_send_sig_info+0x54/0x90 [kernel]
 0xffffffff8106c428 : __kill_pgrp_info+0x48/0x80 [kernel]
 0xffffffff8106c4a0 : kill_pgrp+0x40/0x60 [kernel]
 0xffffffff812eab52 : n_tty_receive_buf+0x482/0x12e0 [kernel]
 0xffffffff812ee373 : flush_to_ldisc+0x103/0x1d0 [kernel]
 0xffffffff81070d0a : worker_thread+0x15a/0x280 [kernel]
 0xffffffff81075cbe : kthread+0x9e/0xb0 [kernel]
 0xffffffff8101312a : child_rip+0xa/0x20 [kernel]
 0xffffffff81075c20 : kthread+0x0/0xb0 [kernel] (inexact)
 0xffffffff81013120 : child_rip+0x0/0x20 [kernel] (inexact)

As you can see, the signal strangely enough seems to be coming from the
tty layer. Looking at n_tty_receive_buf, I see really only one line
which could cause any sort of signal,

drivers/char/n_tty.c:
	if (!tty->icanon && (tty->read_cnt >= tty->minimum_to_wake)) {
		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
		if (waitqueue_active(&tty->read_wait))
			wake_up_interruptible(&tty->read_wait);
	}

However, this is apparently sending SIGIO, not SIGQUIT. I'm not entirely
certain why n_tty_receive_buf is the direct antecedent of kill_pgrp in
the backtrace. Could this be the result of inlining? If so, shouldn't
the DWARF information be enough to get the intermediate callers?

What could cause the tty layer to send a SIGQUIT to a process? Could the
backtrace I acquired through systemtap somehow result in a SIGQUIT
signal? 

Unfortunately, my knowledge of the tty layer is extremely limited, so
any and all advice you could provide would be greatly appreciated.

Thanks,

- Ben

[1] https://bugs.freedesktop.org/show_bug.cgi?id=22679
