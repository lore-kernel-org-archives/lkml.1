Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZGaK5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZGaK5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZGaK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:57:29 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51191 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZGaK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:57:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xF3YhhwwGjMdKUM4KpqFOsIeuo1u4b53MT3LqxuenjFPcrn54WyOuCUdooHwi3NUfX
         fyae2aElUwT0/7z9z4PfHp8piTpqL+qxpKAKI568ETyyUAtDSKc+yozhkl9+1iM0Olxk
         8jPpRiXQlDK9RNO5bKrv9O+y/aiy8NqG1OGBk=
MIME-Version: 1.0
Date: Fri, 31 Jul 2009 12:57:27 +0200
Message-ID: <c4e36d110907310357s1a143522h6fd1b5fc6f43eff9@mail.gmail.com>
Subject: INFO: possible circular locking dependency detected kacpi_hotplug
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: willy@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've noticed this INFO trace in my message log - happened during
undocking T61 C2D 4GB

Zdenek


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-rc4-00001-gec938c6 #74
-------------------------------------------------------
 /113 is trying to acquire lock:
 (kacpid){+.+.+.}, at: [<ffffffff81062ca0>] flush_workqueue+0x0/0xc0

but task is already holding lock:
 (&dpc->work){+.+.+.}, at: [<ffffffff81061286>] worker_thread+0x196/0x3a0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&dpc->work){+.+.+.}:
       [<ffffffff8107be6c>] __lock_acquire+0xc5c/0x1090
       [<ffffffff8107c338>] lock_acquire+0x98/0x140
       [<ffffffff810612d2>] worker_thread+0x1e2/0x3a0
       [<ffffffff8106687e>] kthread+0x9e/0xb0
       [<ffffffff8100d1da>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (kacpid){+.+.+.}:
       [<ffffffff8107bf3f>] __lock_acquire+0xd2f/0x1090
       [<ffffffff8107c338>] lock_acquire+0x98/0x140
       [<ffffffff81062d02>] flush_workqueue+0x62/0xc0
       [<ffffffff8120bbd0>] acpi_os_wait_events_complete+0x15/0x23
       [<ffffffff8120bc0d>] acpi_os_execute_hp_deferred+0x2f/0x43
       [<ffffffff810612d8>] worker_thread+0x1e8/0x3a0
       [<ffffffff8106687e>] kthread+0x9e/0xb0
       [<ffffffff8100d1da>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by kacpi_hotplug/113:
 #0:  (kacpi_hotplug){+.+...}, at: [<ffffffff81061286>]
worker_thread+0x196/0x3a0
 #1:  (&dpc->work){+.+.+.}, at: [<ffffffff81061286>] worker_thread+0x196/0x3a0

stack backtrace:
Pid: 113, comm: kacpi_hotplug Not tainted 2.6.31-rc4-00001-gec938c6 #74
Call Trace:
 [<ffffffff81079e65>] print_circular_bug_tail+0xa5/0xf0
 [<ffffffff8107bf3f>] __lock_acquire+0xd2f/0x1090
 [<ffffffff8107857f>] ? save_trace+0x3f/0xb0
 [<ffffffff8107c338>] lock_acquire+0x98/0x140
 [<ffffffff81062ca0>] ? flush_workqueue+0x0/0xc0
 [<ffffffff8120bbde>] ? acpi_os_execute_hp_deferred+0x0/0x43
 [<ffffffff81062d02>] flush_workqueue+0x62/0xc0
 [<ffffffff81062ca0>] ? flush_workqueue+0x0/0xc0
 [<ffffffff81061286>] ? worker_thread+0x196/0x3a0
 [<ffffffff8120bbd0>] acpi_os_wait_events_complete+0x15/0x23
 [<ffffffff8120bc0d>] acpi_os_execute_hp_deferred+0x2f/0x43
 [<ffffffff810612d8>] worker_thread+0x1e8/0x3a0
 [<ffffffff81061286>] ? worker_thread+0x196/0x3a0
 [<ffffffff81378c5b>] ? thread_return+0x3e/0x703
 [<ffffffff81066c60>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff810610f0>] ? worker_thread+0x0/0x3a0
 [<ffffffff8106687e>] kthread+0x9e/0xb0
 [<ffffffff8100d1da>] child_rip+0xa/0x20
 [<ffffffff8100cb7c>] ? restore_args+0x0/0x30
 [<ffffffff810667e0>] ? kthread+0x0/0xb0
 [<ffffffff8100d1d0>] ? child_rip+0x0/0x20
ACPI: \_SB_.GDCK - undocking
usb 1-4: USB disconnect, address 4
usb 1-4.3: USB disconnect, address 5
usb 1-4.4: USB disconnect, address 6
e1000e: eth0 NIC Link is Down
