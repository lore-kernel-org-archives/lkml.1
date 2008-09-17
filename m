Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYIQPm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYIQPm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYIQPmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:42:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39428 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYIQPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:42:17 -0400
Date: Wed, 17 Sep 2008 11:42:12 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jeff Dike <jdike@addtoit.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: uml: early panic message do not make it to screen
Message-ID: <alpine.LNX.1.10.0809171136330.3313@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I stumbled upon over a strange "Segmentation Fault" with UML that did 
not want to tell me just what was wrong. At first, it only seemed to 
happen when I specified the initrd= parameter, but when I compiled with 
debug info and let gdb loose on it, it became obvious:

11:33 nuqneh:/lo/Coding/uml > gdb linux
GNU gdb 6.8-debian
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu"...
(gdb) r initrd=root.cpio
Starting program: /lo/Coding/uml/linux initrd=root.cpio
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...missing
Checking for tmpfs mount on /dev/shm...OK
Checking PROT_EXEC mmap in /dev/shm/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
[New LWP 27237]

Program received signal SIGTERM, Terminated.
0x00007f506e05c527 in kill () from /lib64/libc.so.6
(gdb) bt
#0  0x00007f506e05c527 in kill () from /lib64/libc.so.6
#1  0x000000006002b8fb in os_dump_core () at arch/um/os-Linux/util.c:92
#2  0x000000006001b9f5 in panic_exit (self=<value optimized out>, 
    unused1=<value optimized out>, unused2=<value optimized out>)
    at arch/um/kernel/um_arch.c:233
#3  0x00000000600504ff in notifier_call_chain (nl=<value optimized out>, 
    val=0, v=0x60323da0, nr_to_call=-1, nr_calls=0x0) at kernel/notifier.c:85
#4  0x0000000060050539 in __atomic_notifier_call_chain (nh=0x0, val=15, 
    v=0x600293b0, nr_to_call=-1, nr_calls=0x61c21c30) at kernel/notifier.c:174
#5  0x0000000060050551 in atomic_notifier_call_chain (nh=0x0, val=15, 
    v=0x600293b0) at kernel/notifier.c:183
#6  0x0000000060036786 in panic (
    fmt=0x60232690 "incorrect cpio method used: use -H newc option")
    at kernel/panic.c:101
#7  0x0000000060004637 in populate_rootfs () at init/initramfs.c:555
#8  0x00000000600173ec in do_one_initcall (fn=0x60004590 <populate_rootfs>)
    at init/main.c:715
#9  0x000000006000152c in kernel_init (unused=<value optimized out>)
    at init/main.c:755
#10 0x00000000600294d7 in run_kernel_thread (fn=0x600014a0 <kernel_init>, 
    arg=0x0, jmp_ptr=<value optimized out>) at arch/um/os-Linux/process.c:267
#11 0x0000000060018cc7 in new_thread_handler () at arch/um/kernel/process.c:151
#12 0x0000000000000000 in ?? ()


So I missed out on -H newc when creating the cpio archive; adding
that, the problem was resolved. But the panic message did not make it
to my xterm, which I think should be fixed.
(To reproduce, feed it a non-newc cpio archive.)
Version used is the most recent (v2.6.27-rc6-99-g45e9c0d).



thanks,
Jan
