Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbYCLGmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbYCLGmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 02:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYCLGm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 02:42:26 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55908 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYCLGmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 02:42:25 -0400
Message-Id: <200803120635.m2C6Zc03091406@www262.sakura.ne.jp>
Subject: Re: [2.6.25-rc5-mm1] BUG() at mnt_want_write().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 15:35:38 +0900
References: <200803120137.m2C1bffL037440@www262.sakura.ne.jp> <1205291010.9828.60.camel@nimitz.home.sr71.net> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I modified /usr/share/initrd-tools/init and tested.

----- start of patch -----
diff -u /usr/share/initrd-tools/init.org /usr/share/initrd-tools/init
--- /usr/share/initrd-tools/init.org    2005-05-27 08:44:00.000000000 +0900
+++ /usr/share/initrd-tools/init        2008-03-12 15:14:31.000000000 +0900
@@ -359,7 +359,10 @@

 read root < bin/root
 umount -n bin
+echo "About to write real-root-dev"
+echo "hello" > proc/version
 echo $root > proc/sys/kernel/real-root-dev
+echo "Wrote real-root-dev"

 get_cmdline

@@ -415,7 +418,9 @@

 cd /
 mount -nt proc proc proc
+echo "About to read real-root-dev"
 rootdev=$(cat proc/sys/kernel/real-root-dev)
+echo "Read real-root-dev"
 cmdline=$(cat /proc/cmdline)
 umount -n proc
 if [ $rootdev != 256 ]; then
----- end of patch -----

The result was

-----------------------------------------------------------------------------
initrd-tools: 0.1.81.1
do_sys_open: bin/root
do_sys_open: /etc/ld.so.preload
do_sys_open: /etc/ld.so.cache
do_sys_open: /lib/tls/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/mmx/libblkid.so.1
do_sys_open: /lib/tls/i686/cmov/libblkid.so.1
do_sys_open: /lib/tls/i686/libblkid.so.1
do_sys_open: /lib/tls/mmx/cmov/libblkid.so.1
do_sys_open: /lib/tls/mmx/libblkid.so.1
do_sys_open: /lib/tls/cmov/libblkid.so.1
do_sys_open: /lib/tls/libblkid.so.1
do_sys_open: /lib/i686/mmx/cmov/libblkid.so.1
do_sys_open: /lib/i686/mmx/libblkid.so.1
do_sys_open: /lib/i686/cmov/libblkid.so.1
do_sys_open: /lib/i686/libblkid.so.1
do_sys_open: /lib/mmx/cmov/libblkid.so.1
do_sys_open: /lib/mmx/libblkid.so.1
do_sys_open: /lib/cmov/libblkid.so.1
do_sys_open: /lib/libblkid.so.1
do_sys_open: /lib/tls/libuuid.so.1
do_sys_open: /lib/libuuid.so.1
do_sys_open: /lib/tls/libc.so.6
do_sys_open: /etc/mtab
About to write real-root-dev
do_sys_open: proc/version
BUG: unable to handle kernel paging request at df366fe8
IP: [<c017e0d0>] mnt_want_write+0x41/0x5f
*pde = 1f884163 *pte = 1f366160
Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
last sysfs file:
Modules linked in:

Pid: 1, comm: init Not tainted (2.6.25-rc5-mm1 #2)
EIP: 0060:[<c017e0d0>] EFLAGS: 00010286 CPU: 0
EIP is at mnt_want_write+0x41/0x5f
EAX: 00000000 EBX: c1453460 ECX: 00000001 EDX: df366f78
ESI: df363f78 EDI: 00000000 EBP: df8e1ef0 ESP: df8e1ee4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process init (pid: 1, ti=df8e1000 task=df8f8020 task.ti=df8e1000)
Stack: ffffffeb 00000200 df8e1f20 df8e1f7c c0173481 ffffa87b 00000000 ffffff9c
       c053481a 00008242 00000000 00000002 00008241 df363f78 df56cf50 df363f78
       df56cf50 57b32ee9 00000007 df911005 00000300 00000000 00000000 c016a9ca
Call Trace:
 [<c0173481>] ? do_filp_open+0x233/0x52f
 [<c016a9ca>] ? get_unused_fd_flags+0xb3/0xbe
 [<c016aabd>] ? do_sys_open+0x50/0xd0
 [<c016ab53>] ? sys_open+0x16/0x18
 [<c0103966>] ? syscall_call+0x7/0xb
 =======================
Code: 8d 1c 02 89 d8 e8 d3 b4 1c 00 89 f0 e8 7e ff ff ff 85 c0 74 07 bf e2 ff ff ff eb 1f 8b 53 2c 39 f2 74 15 85 d2 74 0e 8b 43 28 90 <01> 42 70 c7 43 28
00 00 00 00 89 73 2c ff 43 28 89 d8 e8 cf b5
EIP: [<c017e0d0>] mnt_want_write+0x41/0x5f SS:ESP 0068:df8e1ee4
---[ end trace e13043ee7a72cd3f ]---
Kernel panic - not syncing: Attempted to kill init!
-----------------------------------------------------------------------------

"proc/version" caused the same problem with "proc/sys/kernel/real-root-dev".

And if I specify "bin/foo" instead of "proc/version", the result was

-----------------------------------------------------------------------------
About to write real-root-dev
do_sys_open: bin/foo
/sbin/init: 363: cannot create bin/foo: Read-only file system
do_sys_open: proc/sys/kernel/real-root-dev
BUG: unable to handle kernel paging request at df379fe8
-----------------------------------------------------------------------------

So, no problem with accessing "bin/", but has problem with "proc/".

Regards.
