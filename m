Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZGMUy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZGMUy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbZGMUy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:54:57 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57122 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbZGMUy4 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:54:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.31-rc1-mmotm0702 - ps command hangs inside kernel
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247518491_4148P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Jul 2009 16:54:51 -0400
Message-ID: <47423.1247518491@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247518491_4148P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <47416.1247518491.1@turing-police.cc.vt.edu>

Several times recently, I've had the 'ps' command hang inside the kernel
for extended periods of time - usually around 1100 seconds, but today I
had one that hung there for 2351 seconds.

Info:  It's always reading the same file - /proc/<pid>/status, where the
pid is the 'pcscd' daemon.  And eventually, it manages to exit on its own.
Whatever is getting horked up resets itself - subsequent 'ps' commands work
just fine.

My best guess is that it's getting onto a squirrely vma in
get_stack_usage_in_bytes() in the for/follow_page loop.  Possibly highly
relevant - /usr/sbin/pcscd is one of the few 32-bit binaries running in
a mostly 64-bit runtime.

Here's the traceback of the ps, as reported by 2 alt-sysrq-t several
minutes apart:

ps            R  running task     3936 26646  26580 0x00000080
 ffff88005a599be8 ffffffff81499842 ffff88005a599b78 ffffffff8103589b
 ffffffff81035805 ffff88007e71ea40 ffff880002120f80 ffff8800657d8fe0
 000000000000df78 ffff8800657d8fe0 000000000000df78 ffff8800657d8fe8
Call Trace:
 [<ffffffff81499842>] ? thread_return+0xb6/0xfa
 [<ffffffff8103589b>] ? finish_task_switch+0xd1/0xf4
 [<ffffffff81035805>] ? finish_task_switch+0x3b/0xf4
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8101f76b>] ? smp_apic_timer_interrupt+0x81/0x8f
 [<ffffffff81046231>] ? irq_exit+0xaf/0xb4
 [<ffffffff8100bd80>] restore_args+0x0/0x30
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8101f76b>] ? smp_apic_timer_interrupt+0x81/0x8f
 [<ffffffff810b8222>] ? IS_ERR+0x25/0x2c
 [<ffffffff810b8f22>] ? follow_page+0x28/0x2e3
 [<ffffffff81121a04>] ? proc_pid_status+0x60c/0x694
 [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8111e42c>] ? proc_single_show+0x57/0x74
 [<ffffffff810e90b4>] ? seq_read+0x249/0x49b
 [<ffffffff8116c840>] ? security_file_permission+0x11/0x13
 [<ffffffff810d05e1>] ? vfs_read+0xe0/0x141
 [<ffffffff810d8191>] ? path_put+0x1d/0x21
 [<ffffffff810d06f8>] ? sys_read+0x45/0x69
 [<ffffffff8100b2ab>] ? system_call_fastpath+0x16/0x1b

ps            R  running task     3936 26646  26580 0x00000080
 ffff88005a599bd8 ffffffff81499842 ffff88000213bf80 0000000000000000
 ffff88005a599b78 ffffffff8103589b ffffffff81035805 ffff88007e71ea40
 ffff88000213bf80 ffff8800657d8fe0 000000000000df78 ffff8800657d8fe8
Call Trace:
 [<ffffffff81499842>] ? thread_return+0xb6/0xfa
 [<ffffffff8103589b>] ? finish_task_switch+0xd1/0xf4
 [<ffffffff81035805>] ? finish_task_switch+0x3b/0xf4
 [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
 [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8101f76b>] smp_apic_timer_interrupt+0x81/0x8f
 [<ffffffff81046231>] ? irq_exit+0xaf/0xb4
 [<ffffffff8100bd80>] ? restore_args+0x0/0x30
 [<ffffffff810b8222>] ? IS_ERR+0x25/0x2c
 [<ffffffff810b8222>] ? IS_ERR+0x25/0x2c
 [<ffffffff810b8f22>] ? follow_page+0x28/0x2e3
 [<ffffffff810b91d9>] ? follow_page+0x2df/0x2e3
 [<ffffffff811219d8>] ? proc_pid_status+0x5e0/0x694
 [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8111e42c>] ? proc_single_show+0x57/0x74
 [<ffffffff810e90b4>] ? seq_read+0x249/0x49b
 [<ffffffff8116c840>] ? security_file_permission+0x11/0x13
 [<ffffffff810d05e1>] ? vfs_read+0xe0/0x141
 [<ffffffff810d8191>] ? path_put+0x1d/0x21
 [<ffffffff810d06f8>] ? sys_read+0x45/0x69
 [<ffffffff8100b2ab>] ? system_call_fastpath+0x16/0x1b

Here's the output of 'cat /proc/2031/maps' currently - I didn't think to
get one during the last event:

# cat /proc/2031/maps
08047000-0805e000 r-xp 00000000 fe:05 51682                              /usr/sbin/pcscd
0805e000-0805f000 rw-p 00016000 fe:05 51682                              /usr/sbin/pcscd
0805f000-080e8000 rw-p 00000000 00:00 0
09990000-099b1000 rw-p 00000000 00:00 0                                  [heap]
44368000-4436f000 r-xp 00000000 fe:05 20682                              /usr/lib/libusb-0.1.so.4.4.4
4436f000-44371000 rw-p 00006000 fe:05 20682                              /usr/lib/libusb-0.1.so.4.4.4
45c81000-45cab000 r-xp 00000000 fe:00 8715                               /lib/libgcc_s-4.4.0-20090708.so.1
45cab000-45cac000 rw-p 0002a000 fe:00 8715                               /lib/libgcc_s-4.4.0-20090708.so.1
47c00000-47c20000 r-xp 00000000 fe:00 8266                               /lib/ld-2.10.1.so
47c20000-47c21000 r--p 0001f000 fe:00 8266                               /lib/ld-2.10.1.so
47c21000-47c22000 rw-p 00020000 fe:00 8266                               /lib/ld-2.10.1.so
47c24000-47d8f000 r-xp 00000000 fe:00 8360                               /lib/libc-2.10.1.so
47d8f000-47d90000 ---p 0016b000 fe:00 8360                               /lib/libc-2.10.1.so
47d90000-47d92000 r--p 0016b000 fe:00 8360                               /lib/libc-2.10.1.so
47d92000-47d93000 rw-p 0016d000 fe:00 8360                               /lib/libc-2.10.1.so
47d93000-47d96000 rw-p 00000000 00:00 0 
47d98000-47d9b000 r-xp 00000000 fe:00 8388                               /lib/libdl-2.10.1.so
47d9b000-47d9c000 r--p 00002000 fe:00 8388                               /lib/libdl-2.10.1.so
47d9c000-47d9d000 rw-p 00003000 fe:00 8388                               /lib/libdl-2.10.1.so
47d9f000-47db5000 r-xp 00000000 fe:00 8675                               /lib/libpthread-2.10.1.so
47db5000-47db6000 ---p 00016000 fe:00 8675                               /lib/libpthread-2.10.1.so
47db6000-47db7000 r--p 00016000 fe:00 8675                               /lib/libpthread-2.10.1.so
47db7000-47db8000 rw-p 00017000 fe:00 8675                               /lib/libpthread-2.10.1.so
47db8000-47dba000 rw-p 00000000 00:00 0
f6c00000-f6c21000 rw-p 00000000 00:00 0
f6c21000-f6d00000 ---p 00000000 00:00 0
f6dff000-f6e00000 ---p 00000000 00:00 0
f6e00000-f7600000 rw-p 00000000 00:00 0
f7600000-f7621000 rw-p 00000000 00:00 0
f7621000-f7700000 ---p 00000000 00:00 0
f773b000-f773c000 ---p 00000000 00:00 0
f773c000-f7f3f000 rw-p 00000000 00:00 0
f7f50000-f7f51000 rw-s 0000f000 fe:09 86049                              /var/run/pcscd.pub
f7f51000-f7f52000 rw-s 0000e000 fe:09 86049                              /var/run/pcscd.pub
f7f52000-f7f53000 rw-s 0000d000 fe:09 86049                              /var/run/pcscd.pub
f7f53000-f7f54000 rw-s 0000c000 fe:09 86049                              /var/run/pcscd.pub
f7f54000-f7f55000 rw-s 0000b000 fe:09 86049                              /var/run/pcscd.pub
f7f55000-f7f56000 rw-s 0000a000 fe:09 86049                              /var/run/pcscd.pub
f7f56000-f7f57000 rw-s 00009000 fe:09 86049                              /var/run/pcscd.pub
f7f57000-f7f58000 rw-s 00008000 fe:09 86049                              /var/run/pcscd.pub
f7f58000-f7f59000 rw-s 00007000 fe:09 86049                              /var/run/pcscd.pub
f7f59000-f7f5a000 rw-s 00006000 fe:09 86049                              /var/run/pcscd.pub
f7f5a000-f7f5b000 rw-s 00005000 fe:09 86049                              /var/run/pcscd.pub
f7f5b000-f7f5c000 rw-s 00004000 fe:09 86049                              /var/run/pcscd.pub
f7f5c000-f7f5d000 rw-s 00003000 fe:09 86049                              /var/run/pcscd.pub
f7f5d000-f7f5e000 rw-s 00002000 fe:09 86049                              /var/run/pcscd.pub
f7f5e000-f7f5f000 rw-s 00001000 fe:09 86049                              /var/run/pcscd.pub
f7f5f000-f7f60000 rw-s 00000000 fe:09 86049                              /var/run/pcscd.pub
f7f60000-f7f61000 r-xp 00000000 00:00 0                                  [vdso]
fffe8000-ffffd000 rw-p 00000000 00:00 0                                  [stack]


--==_Exmh_1247518491_4148P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKW58bcC3lWbTT17ARAq6TAJ9jfdEKd7UfKADPRU8D9bW5Qm49wQCg7zy0
QTX9X5nqifBHT+hj+AjS5rk=
=wfdo
-----END PGP SIGNATURE-----

--==_Exmh_1247518491_4148P--
