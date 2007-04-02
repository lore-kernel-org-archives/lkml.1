Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbXDBPUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbXDBPUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXDBPUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:20:22 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:49186 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXDBPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:20:21 -0400
Message-ID: <46111ED7.20201@gmail.com>
Date: Mon, 02 Apr 2007 17:18:47 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI> <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI>
Content-Type: multipart/mixed;
 boundary="------------070901060400090806070906"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070901060400090806070906
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/02/2007 10:55 AM, Pekka J Enberg wrote:

> On Mon, 2 Apr 2007, Jens Axboe wrote:

>> But as I wrote earlier, it'll take lots more to make this driver close 
>> to functional.
> 
> Heh, looking at the driver, that's quite an understatement =). Rene, 
> here's an untested attempt to use a mutex instead of the horribly broken 
> waitqueue "synchronization" in mcdx. It may or may not help so give it a 
> spin if you want.

Thanks again, spinning! I've split up the patch into its history and am 
now using the three available at:

http://members.home.nl/rene.herman/mcdx/

against 2.6.20.4. The mutex does change things but not so much for the 
better unfortunately. With this, I'm still able to do:

root@5va2:~# strace -o dd.strace dd if=/dev/mcdx0 of=foo.img

with the same result:

root@5va2:~# strace -o dd.strace dd if=/dev/mcdx0 of=foo.img
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00202698 seconds, 0.0 kB/s

(dd.strace attached) but the readcd and tar tests:

root@5va2:~# strace -o readcd.strace readcd dev=/dev/mcdx0 f=foo.img
root@5va2:~# strace -o tar.strace tar cvf foo.tar /mnt/cdrom

now lock up the machine hard each time; no pings replies, no nothing.

Using f=/dev/null with readcd does not change things. Using /dev/null 
with tar _does_ but tar seems to notice it's writing to /dev/null and 
"optimizes" the actual reading away so that's no surprise.

Thanks again! Still love inserting CDs in this thing, so I'll happily 
keep on testing... :-)

Rene.

--------------070901060400090806070906
Content-Type: text/plain;
 name="dd.strace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dd.strace"

execve("/bin/dd", ["dd", "if=/dev/mcdx0", "of=foo.img"], [/* 28 vars */]) = 0
uname({sys="Linux", node="5va2", ...})  = 0
brk(0)                                  = 0x8052000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=47774, ...}) = 0
mmap2(NULL, 47774, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f8d000
close(3)                                = 0
open("/lib/tls/librt.so.1", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\35\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=34763, ...}) = 0
mmap2(NULL, 29260, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f85000
mmap2(0xb7f8b000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5) = 0xb7f8b000
close(3)                                = 0
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20O\1\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1441201, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f84000
mmap2(NULL, 1240284, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e55000
mmap2(0xb7f7e000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x128) = 0xb7f7e000
mmap2(0xb7f82000, 7388, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f82000
close(3)                                = 0
open("/lib/tls/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20H\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=88005, ...}) = 0
mmap2(NULL, 70104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e43000
mmap2(0xb7e51000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd) = 0xb7e51000
mmap2(0xb7e53000, 4568, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7e53000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e42000
mprotect(0xb7f7e000, 4096, PROT_READ)   = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e426c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb7f8d000, 47774)               = 0
set_tid_address(0xb7e42708)             = 1177
rt_sigaction(SIGRTMIN, {0xb7e473a0, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb7e47420, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
_sysctl({{CTL_KERN, KERN_VERSION}, 2, 0xbf93cd5c, 32, (nil), 0}) = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
brk(0)                                  = 0x8052000
brk(0x8073000)                          = 0x8073000
open("/usr/share/locale/locale.alias", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2586, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f98000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2586
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb7f98000, 4096)                = 0
open("/usr/lib/locale/en_US/LC_IDENTIFICATION", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=378, ...}) = 0
mmap2(NULL, 378, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f98000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MEASUREMENT", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=28, ...}) = 0
mmap2(NULL, 28, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f97000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_TELEPHONE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=64, ...}) = 0
mmap2(NULL, 64, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f96000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_ADDRESS", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=160, ...}) = 0
mmap2(NULL, 160, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f95000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_NAME", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=82, ...}) = 0
mmap2(NULL, 82, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f94000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_PAPER", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=39, ...}) = 0
mmap2(NULL, 39, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f93000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MESSAGES", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MESSAGES/SYS_LC_MESSAGES", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
mmap2(NULL, 57, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f92000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MONETARY", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=291, ...}) = 0
mmap2(NULL, 291, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f91000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_TIME", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2456, ...}) = 0
mmap2(NULL, 2456, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f90000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_NUMERIC", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=59, ...}) = 0
mmap2(NULL, 59, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f8f000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_CTYPE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=178476, ...}) = 0
mmap2(NULL, 178476, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7e16000
close(3)                                = 0
close(0)                                = 0
open("/dev/mcdx0", O_RDONLY|O_LARGEFILE) = 0
_llseek(0, 0, [0], SEEK_CUR)            = 0
close(1)                                = 0
open("foo.img", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 1
rt_sigaction(SIGUSR1, NULL, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
rt_sigaction(SIGUSR1, {0x8049910, [INT USR1], 0}, NULL, 8) = 0
rt_sigaction(SIGINT, {0x8049900, [INT USR1], SA_NOMASK|SA_ONESHOT}, NULL, 8) = 0
clock_gettime(CLOCK_MONOTONIC, {141, 786339816}) = 0
read(0, "", 512)                        = 0
close(0)                                = 0
close(1)                                = 0
clock_gettime(CLOCK_MONOTONIC, {141, 788366793}) = 0
open("/usr/share/locale/en_US/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "0+0 records in\n0+0 records out\n", 31) = 31
write(2, "0 bytes (0 B) copied", 20)    = 20
write(2, ", 0.00202698 seconds, 0.0 kB/s\n", 31) = 31
close(1)                                = -1 EBADF (Bad file descriptor)
exit_group(0)                           = ?

--------------070901060400090806070906--
