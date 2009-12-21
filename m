Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbZLUNLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbZLUNLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZLUNLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:11:47 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:59235 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbZLUNLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:11:46 -0500
Message-ID: <4B2F7421.10005@byu.net>
Date: Mon, 21 Dec 2009 06:12:01 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
In-Reply-To: <87aaxclr4q.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to OGAWA Hirofumi on 12/21/2009 12:31 AM:
>> This in turn caused a regression in coreutils 8.2, visible through 'touch -a':
>> http://lists.gnu.org/archive/html/bug-coreutils/2009-12/msg00171.html
>>
>> GNU coreutils will end up working around the bug by calling fstat/[l]stat
>> prior to futimens/utimensat, and populating the mtime field with the
>> desired value rather than using UTIME_OMIT.  But this is a pointless stat
>> call, which could be avoided if the kernel were fixed to comply with POSIX
>> by updating ctime even when mtime is UTIME_OMIT.
> 
> I couldn't reproduce this with your test program on my machine (latest
> linus tree). And that utime path looks like no problem, um..., can you
> provide output of strace or something?

$ uname -a
Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
x86_64 GNU/Linux
$ strace ./foo
execve("./foo", ["./foo"], [/* 19 vars */]) = 0
brk(0)                                  = 0x16fc000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7fa7d94eb000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or
directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7fa7d94e9000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=42235, ...}) = 0
mmap(NULL, 42235, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fa7d94de000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or
directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\342"..., 832)
= 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1436976, ...}) = 0
mmap(NULL, 3543672, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0)
= 0x7fa7d8f6d000
mprotect(0x7fa7d90c5000, 2097152, PROT_NONE) = 0
mmap(0x7fa7d92c5000, 20480, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x158000) = 0x7fa7d92c5000
mmap(0x7fa7d92ca000, 17016, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fa7d92ca000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7fa7d94dd000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0x7fa7d94dc000
arch_prctl(ARCH_SET_FS, 0x7fa7d94dc6e0) = 0
mprotect(0x7fa7d92c5000, 12288, PROT_READ) = 0
munmap(0x7fa7d94de000, 42235)           = 0
creat("file", 0600)                     = 3
fstat(3, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigaction(SIGCHLD, NULL, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
nanosleep({1, 0}, {1, 0})               = 0
syscall_280(0x3, 0, 0x7fff707fb660, 0, 0, 0x7fff707fb360, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) = 0
fstat(3, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
exit_group(1)                           = ?
Process 13846 detached
$ stat file
  File: `file'
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: 811h/2065d	Inode: 1769273205  Links: 1
Access: (0600/-rw-------)  Uid: ( 1267/   ericb)   Gid: ( 1267/   ericb)
Access: 2001-09-08 21:46:40.000000000 -0400
Modify: 2009-12-21 08:06:03.425326531 -0500
Change: 2009-12-21 08:06:03.425326531 -0500
$

Note that ctime is still stuck at the same second as mtime, even though it
should be at least one second later since there was a sleep(1) in between
the file creation and the utimensat that adjusted the atime.

However, when I tried on a different machine, I did not see the failure:

$ uname -a
Linux vladim 2.6.31.6-166.fc12.i686 #1 SMP Wed Dec 9 11:14:59 EST 2009
i686 GNU/Linux

So it may be architecture-dependent.  The coreutils report was against:

> Host triplet: i686-pc-linux-gnu
> coreutils: 8.2
> kernel:    2.6.32.1

but I don't have access to a machine running that new of a kernel at the
moment.

-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
