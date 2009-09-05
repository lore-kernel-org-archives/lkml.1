Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZIEVJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZIEVJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZIEVJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:09:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:33323 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZIEVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:09:45 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de, torvalds@linux-foundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] usb console: 2.6.31 regression fixes
Date: Sat,  5 Sep 2009 16:08:36 -0500
Message-Id: <1252184918-9577-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 05 Sep 2009 21:09:05.0586 (UTC) FILETIME=[19FDD920:01CA2E6D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two regressions in the 2.6.31 for the usb serial console. 

1) A critical crash from user space

* Boot with the kernel argument console=ttyUSB0,9600
* Run: stty -a < /dev/ttyUSB0 
* Immediately you get an oops warning, which later leads to a hard
  kernel crash

WARNING: at drivers/usb/serial/usb-serial.c:414 serial_write_room+0x75/0x80()
Hardware name: 
Modules linked in:
Pid: 6, comm: events/0 Not tainted 2.6.31-rc8-00038-g37d0892-dirty #737
Call Trace:
 [<c0416fd5>] ? serial_write_room+0x75/0x80
 [<c022acbc>] warn_slowpath_common+0x7c/0xa0
 [<c0416fd5>] ? serial_write_room+0x75/0x80
 [<c022acf5>] warn_slowpath_null+0x15/0x20
 [<c0416fd5>] serial_write_room+0x75/0x80
 [<c02245fb>] ? default_wake_function+0xb/0x10
 [<c021e7a8>] ? __wake_up_common+0x48/0x70
 [<c038fcd8>] tty_write_room+0x18/0x20
 [<c038d572>] process_echoes+0x42/0x2c0
 [<c038d29b>] ? echo_char_raw+0x3b/0x70
 [<c038f3a1>] n_tty_receive_buf+0x1141/0x1250
 [<c022056f>] ? hrtick_update+0x3f/0x50
 [<c02277c1>] ? dequeue_task_fair+0xa1/0xb0
 [<c02017d4>] ? __switch_to+0x24/0x1b0
 [<c050ec50>] ? _spin_unlock_irq+0x10/0x30
 [<c0223479>] ? finish_task_switch+0x99/0xc0
 [<c050cae2>] ? schedule+0x242/0x7c0
 [<c050e86c>] ? _spin_lock_irqsave+0x1c/0x40
 [<c050ec21>] ? _spin_unlock_irqrestore+0x11/0x30
 [<c0390eab>] ? tty_ldisc_try+0x3b/0x50
 [<c0391c90>] flush_to_ldisc+0xe0/0x1a0
 [<c038e260>] ? n_tty_receive_buf+0x0/0x1250
 [<c023aa3f>] worker_thread+0x10f/0x1f0
 [<c0391bb0>] ? flush_to_ldisc+0x0/0x1a0
 [<c023db60>] ? autoremove_wake_function+0x0/0x50
 [<c023a930>] ? worker_thread+0x0/0x1f0
 [<c023da5a>] kthread+0x7a/0x90
 [<c023d9e0>] ? kthread+0x0/0x90
 [<c020385f>] kernel_thread_helper+0x7/0x38
---[ end trace 5552e7699618b972 ]---


2) Original console baud is not passed to first post boot open of the
   tty -> hw.

This fix is not critical, and should be reviewed to see if there is
any other preferred way the usb maintainer would prefer to see this
operate.

The first open of the usb serial HW has the termios initialized to
9600 baud, and this will override what ever was setup via the original
console initialization.  The solution is to save the console baud rate
and re-use it later on the first open.


---

The following changes since commit 37d0892c5a94e208cf863e3b7bac014edee4346d:
  Ian Kent (1):
        autofs4 - fix missed case when changing to use struct path

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (2):
      usb console: fix kernel crash on stty -a < /dev/ttyUSB0
      usb console: pass initial console baud on to first tty open

 drivers/usb/serial/console.c    |    1 +
 drivers/usb/serial/usb-serial.c |   19 ++++++++++++-------
 include/linux/usb/serial.h      |    1 +
 3 files changed, 14 insertions(+), 7 deletions(-)
