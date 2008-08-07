Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbYHGMek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbYHGMek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbYHGMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:34:16 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46759 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbYHGMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:34:13 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Fix race/oops in tty layer after BKL pushdown
Date: Thu, 7 Aug 2008 14:33:06 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Olaf Schnapper <os@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071433.06885.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

while testing our KVM code for s390 (starting and killall kvm in a loop) I 
can reproduce the following oops:

Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
Oops: 0038 [#1] SMP 
Modules linked in: dm_multipath sunrpc qeth_l3 qeth_l2 dm_mod qeth ccwgroup
CPU: 1 Not tainted 2.6.27-rc1 #54
Process kuli (pid: 4409, task: 00000000b6aa5940, ksp: 00000000b7343e10)
Krnl PSW : 0704e00180000000 00000000002e0b8c (disassociate_ctty+0x1c0/0x288)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000000 6b6b6b6b6b6b6b6b 0000000000000001 00000000000003a6
           00000000002e0a46 00000000004b4160 0000000000000001 00000000bbd79758
           00000000b7343e58 00000000b8854148 00000000bd34dea0 00000000b7343c20
           0000000000000001 00000000004b6d08 00000000002e0a46 00000000b7343c20
Krnl Code: 00000000002e0b7e: eb9fb0a00004	lmg	%r9,%r15,160(%r11)
           00000000002e0b84: 07f4		bcr	15,%r4
           00000000002e0b86: e31090080004	lg	%r1,8(%r9)
          >00000000002e0b8c: d501109cd000	clc	156(2,%r1),0(%r13)
           00000000002e0b92: a784ff5d		brc	8,2e0a4c
           00000000002e0b96: b9040029		lgr	%r2,%r9
           00000000002e0b9a: c0e5fffff9c3	brasl	%r14,2dff20
           00000000002e0ba0: a7f4ff56		brc	15,2e0a4c
Call Trace:
([<00000000002e0a46>] disassociate_ctty+0x7a/0x288)
 [<0000000000141fe6>] do_exit+0x212/0x8d4
 [<0000000000142708>] do_group_exit+0x60/0xcc
 [<0000000000150660>] get_signal_to_deliver+0x270/0x3ac
 [<000000000010bfd6>] do_signal+0x8e/0x8dc
 [<0000000000113772>] sysc_sigpending+0xe/0x22
 [<000001ff0000b134>] 0x1ff0000b134
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<00000000002e0a48>] disassociate_ctty+0x7c/0x288
 <0>Kernel panic - not syncing: Fatal exception: panic_on_oops

It seems that tty was already free in disassocate_ctty when it tries
to dereference tty->driver.

After moving the lock_kernel before the mutex_unlock, I can no longer
reproduce the problem.

Please review and consider to apply:

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: kvm/drivers/char/tty_io.c
===================================================================
--- kvm.orig/drivers/char/tty_io.c
+++ kvm/drivers/char/tty_io.c
@@ -1161,8 +1161,8 @@ void disassociate_ctty(int on_exit)
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
-		mutex_unlock(&tty_mutex);
 		lock_kernel();
+		mutex_unlock(&tty_mutex);
 		/* XXX: here we race, there is nothing protecting tty */
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
