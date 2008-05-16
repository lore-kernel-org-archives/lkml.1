Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbYEPPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbYEPPT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYEPPTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:19:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:38149 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYEPPTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:19:45 -0400
Message-Id: <5DA48DE4-1DEF-438D-AA65-0F4DA73AA33A@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: tty_driver, wait_until_sent, and types
Date: Fri, 16 May 2008 10:19:30 -0500
Cc: lkml List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the following reported back on both a ppc64 and x86_64  
box, running 2.6.25:

schedule_timeout: wrong timeout value ffffffffffffffff
Call Trace:
[c0000000558ef3f0] [c000000000010b7c] .show_stack+0x70/0x19c  
(unreliable)
[c0000000558ef4a0] [c00000000045137c] .schedule_timeout+0x5c/0xe8
[c0000000558ef590] [d0000000005793f0] .espx_wait_until_sent 
+0x154/0x240 [espx]
[c0000000558ef670] [c0000000002caa30] .tty_wait_until_sent+0x17c/0x1ac
[c0000000558ef750] [c0000000002cadc0] .set_termios+0x360/0x3c0
[c0000000558ef830] [c0000000002cb33c] .tty_mode_ioctl+0x51c/0x8a8
[c0000000558ef910] [c0000000002c6f34] .tty_ioctl+0x1228/0x12b0
[c0000000558efaf0] [c000000000134928] .vfs_ioctl+0xb4/0xec
[c0000000558efb80] [c000000000134df8] .do_vfs_ioctl+0x498/0x4c4
[c0000000558efc30] [c000000000134e94] .sys_ioctl+0x70/0xb4
[c0000000558efce0] [c000000000167594] .do_ioctl32_pointer+0x14/0x2c
[c0000000558efd50] [c00000000016c788] .compat_sys_ioctl+0x3ec/0x470
[c0000000558efe30] [c000000000008748] syscall_exit+0x0/0x40

It seems like the issue has to do with types:

in drivers/char/tty_ioctl.c:

void tty_wait_until_sent(struct tty_struct *tty, long timeout)
	tty->ops->wait_until_sent(tty, timeout);

however, from include/linux/tty_driver.h we see:

void (*wait_until_sent)(struct tty_struct *tty, int timeout);

should timeout be a long instead of an int?

- k
