Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZFJKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZFJKZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbZFJKZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:25:34 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37892 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZFJKZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:25:33 -0400
MIME-Version: 1.0
Date: Wed, 10 Jun 2009 13:25:34 +0300
Message-ID: <cc557aab0906100325o4fd55e0eveb958915214809e3@mail.gmail.com>
Subject: ERESTART_RESTARTBLOCK and ptrace()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: Nicolas Pitre <nico@cam.org>, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got bug in handling ERESTART_RESTARTBLOCK. Kernel version is 2.6.28.

Steps to reproduce:
1. Attach using ptrace() to process while it's in a syscall which use
ERESTART_RESTARTBLOCK
on interrupt. The easiest way is to attach to process which is in nanosleep().
2. Run a syscall in context of the process like it does gdb.
3. Continue the process.

Results:
Syscall(nanosleep) return error code 516(ERESTART_RESTARTBLOCK). It's
kernel's internal error
code and should never appear at userspace.

It seems ARM-related since I can't reproduce it on x86.

Example:
$ cat test.c
#include <errno.h>
#include <stdio.h>
#include <time.h>

int main()
{
        struct timespec ts;
        int ret;

        ts.tv_sec = 100;
        ts.tv_nsec = 0;

        errno = 0;
        ret = nanosleep(&ts, NULL);
        printf("ret: %d, errno: %d\n", ret, errno);

        return 0;
}
$ gcc test.c
$ ./a.out &
$ gdb -p "$(pidof a.out)" -ex 'call getuid()' -ex 'c' -ex 'quit'
GNU gdb (GDB) 6.8.50.20090417-debian
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "arm-linux-gnueabi".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Attaching to process 6136
Reading symbols from /root/a.out...(no debugging symbols found)...done.
Reading symbols from /lib/libc.so.6...Reading symbols from
/usr/lib/debug/lib/libc-2.5.so...(no debugging symbols found)...done.
(no debugging symbols found)...done.
Loaded symbols for /lib/libc.so.6
Reading symbols from /lib/ld-linux.so.3...Reading symbols from
/usr/lib/debug/lib/ld-2.5.so...(no debugging symbols found)...done.
(no debugging symbols found)...done.
Loaded symbols for /lib/ld-linux.so.3
0x400bf97c in nanosleep () from /lib/libc.so.6
0x400bf97c <nanosleep+28>:      mov     r7, r12
$1 = 0
Continuing.
ret: -1, errno: 516

Program exited normally.
[1] + Done                       ./a.out
