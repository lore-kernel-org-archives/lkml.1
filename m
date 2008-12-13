Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbYLMQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbYLMQll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYLMQld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:41:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55828 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYLMQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:41:32 -0500
Date: Sat, 13 Dec 2008 16:41:23 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [BUG] Upon hitting ^c, inotify blocks on mutex_lock
Message-ID: <20081213164123.GB7639@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.8.

Today, having had gthumb running for a while, I hit ^c expecting it to
quit.  The result was a process with zero VSZ and RSS, and it sitting
in run state.  Only possible recovery action seems to be a reboot.

A sysrq-t reveals the following backtrace for gthumb:

gthumb        R running   2052 26500  25452
       ce631030 00200046 00000005 00000058 ce631290 0d179289 000043e8 c0691a7a
       c06f007b f6d299a0 f794c5c8 f6d299a0 e3a9def0 c041b36d c06109d2 c0610eda
       f794c5c8 f6d29980 c048aa70 00000001 40000010 f6d29400 de0ae880 f6d29418
Call Trace:
 [<c041b36d>] __cond_resched+0x22/0x37
 [<c06109d2>] _cond_resched+0x21/0x2a
 [<c0610eda>] mutex_lock+0x1a/0x28
 [<c048aa70>] inotify_destroy+0x13/0xa9
 [<c048af3c>] inotify_release+0x14/0x7c
 [<c04688f2>] __fput+0xab/0x158
 [<c04663c0>] filp_close+0x4d/0x53
 [<c041efca>] put_files_struct+0x5f/0xa7
 [<c04201c1>] do_exit+0x1b8/0x6c8
 [<c0425636>] __dequeue_signal+0xd/0xce
 [<c042072c>] do_group_exit+0x5b/0x83
 [<c0427842>] get_signal_to_deliver+0x2e2/0x322
 [<c0402aa3>] do_notify_resume+0x62/0x691
 [<c05fce6c>] unix_ioctl+0xa6/0xaf
 [<c05a0c2d>] sock_ioctl+0x1ad/0x1d1
 [<c05a0a80>] sock_ioctl+0x0/0x1d1
 [<c0406f9c>] read_tsc+0x6/0x22
 [<c04301df>] getnstimeofday+0x32/0xb1
 [<c04722ea>] sys_poll+0x3b/0x6e
 [<c040384a>] work_notifysig+0x13/0x19



-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
