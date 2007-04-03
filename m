Return-Path: <linux-kernel-owner+w=401wt.eu-S1030279AbXDCO2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbXDCO2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030284AbXDCO2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:28:14 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54696 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279AbXDCO2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:28:12 -0400
Message-ID: <4612642F.90407@gmail.com>
Date: Tue, 03 Apr 2007 16:26:55 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com> <46104954.50608@gmail.com> <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI> <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI> <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI> <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI> <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI>
Content-Type: multipart/mixed;
 boundary="------------000004060002060706030501"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000004060002060706030501
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/03/2007 08:57 AM, Pekka J Enberg wrote:

[ re-including linux-kernel ]

> Does this change the dd case?
> 
> diff --git a/drivers/cdrom/mcdx.c b/drivers/cdrom/mcdx.c
> index f574962..6c613d0 100644
> --- a/drivers/cdrom/mcdx.c
> +++ b/drivers/cdrom/mcdx.c
> @@ -1248,6 +1248,7 @@ #endif
>  	disk->private_data = stuffp;
>  	disk->queue = mcdx_queue;
>  	add_disk(disk);
> +	blk_queue_hardsect_size(mcdx_queue, MCDX_CDBLK);
>  	printk(msg);
>  	return 0;
>  }

No, I'm afraid not. It's still the same effect:

root@5va2:~# dmesg -c >/dev/null
root@5va2:~# strace -o dd.strace dd if=/dev/mcdx0 of=/dev/null
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00438956 seconds, 0.0 kB/s
root@5va2:~# dmesg >dd.xtrace

dd.strace again attached. I've dropped the mutex patch for now and now
the xtrace is littered with waitqueue debugging. I'll see if I can
disable that particular debugging trace I guess. dd.xtrace sent privately...

"readcd dev=/dev/mcdx0 f=foo.img" is still an immediate hard lockup also
without the mutex. I believe the "tar" runs has produced something
useful now though:

root@5va2:~# dmesg -c >/dev/null
root@5va2:~# strace -o tar.strace tar cvf foo.tar /mnt/cdrom
tar: Removing leading `/' from member names
/mnt/cdrom/
/mnt/cdrom/dott/
/mnt/cdrom/dott/adlib.ims
/mnt/cdrom/dott/dott.bat
/mnt/cdrom/dott/dotticon.ico
/mnt/cdrom/dott/gmidi.ims
/mnt/cdrom/dott/maniac/
rlogin: connection closed.
rene@7ixe4:~$

When I now switch the monitor to 5va2 directly, there is an oops on the
screen, with a backtrace saying (manual transcription):

Call Trace:
   [<c1047eb6>] drain_array+0x94/0xc3
   [   ...    ] cache_reap+0x55/0xe9
   [   ...    ] run_workqueue+0x8f/0x14d
   [   ...    ] cache_reap+0x0//0xe9
   [   ...    ] worker_thread+0x122/0x14b
   [   ...    ] default_wake_function+0x0/0xc
   [   ...    ] default_wake_function+0x0/0xc
   [   ...    ] worker_thread+0x0/0x14b
   [   ...    ] kthread+0x72/0x97
   [   ...    ] kthread+0x0/0x97
   [   ...    ] kernel_thread_helper+0x7/0x10
   =======================
Code: [ ... ]
EIP: [<c1047787>] free_block+0x58/0xcf SS:ESP [ ... ]

Couple of functions mentioned twice in that backtrace. That looks a
little off no?

"tar.strace" made it to disk, so it's attached as well.

Rene.


--------------000004060002060706030501
Content-Type: text/plain;
 name="dd.strace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dd.strace"

execve("/bin/dd", ["dd", "if=/dev/mcdx0", "of=/dev/null"], [/* 28 vars */]) = 0
uname({sys="Linux", node="5va2", ...})  = 0
brk(0)                                  = 0x8052000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=47774, ...}) = 0
mmap2(NULL, 47774, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fb3000
close(3)                                = 0
open("/lib/tls/librt.so.1", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\35\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=34763, ...}) = 0
mmap2(NULL, 29260, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7fab000
mmap2(0xb7fb1000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5) = 0xb7fb1000
close(3)                                = 0
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20O\1\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1441201, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7faa000
mmap2(NULL, 1240284, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e7b000
mmap2(0xb7fa4000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x128) = 0xb7fa4000
mmap2(0xb7fa8000, 7388, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7fa8000
close(3)                                = 0
open("/lib/tls/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20H\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=88005, ...}) = 0
mmap2(NULL, 70104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e69000
mmap2(0xb7e77000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd) = 0xb7e77000
mmap2(0xb7e79000, 4568, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7e79000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e68000
mprotect(0xb7fa4000, 4096, PROT_READ)   = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e686c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb7fb3000, 47774)               = 0
set_tid_address(0xb7e68708)             = 1173
rt_sigaction(SIGRTMIN, {0xb7e6d3a0, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb7e6d420, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
_sysctl({{CTL_KERN, KERN_VERSION}, 2, 0xbfba055c, 32, (nil), 0}) = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
brk(0)                                  = 0x8052000
brk(0x8073000)                          = 0x8073000
open("/usr/share/locale/locale.alias", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2586, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fbe000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2586
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb7fbe000, 4096)                = 0
open("/usr/lib/locale/en_US/LC_IDENTIFICATION", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=378, ...}) = 0
mmap2(NULL, 378, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fbe000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MEASUREMENT", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=28, ...}) = 0
mmap2(NULL, 28, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fbd000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_TELEPHONE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=64, ...}) = 0
mmap2(NULL, 64, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fbc000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_ADDRESS", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=160, ...}) = 0
mmap2(NULL, 160, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fbb000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_NAME", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=82, ...}) = 0
mmap2(NULL, 82, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fba000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_PAPER", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=39, ...}) = 0
mmap2(NULL, 39, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fb9000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MESSAGES", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MESSAGES/SYS_LC_MESSAGES", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
mmap2(NULL, 57, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fb8000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MONETARY", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=291, ...}) = 0
mmap2(NULL, 291, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fb7000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_TIME", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2456, ...}) = 0
mmap2(NULL, 2456, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fb6000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_NUMERIC", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=59, ...}) = 0
mmap2(NULL, 59, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7fb5000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_CTYPE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=178476, ...}) = 0
mmap2(NULL, 178476, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7e3c000
close(3)                                = 0
close(0)                                = 0
open("/dev/mcdx0", O_RDONLY|O_LARGEFILE) = 0
_llseek(0, 0, [0], SEEK_CUR)            = 0
close(1)                                = 0
open("/dev/null", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 1
rt_sigaction(SIGUSR1, NULL, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
rt_sigaction(SIGUSR1, {0x8049910, [INT USR1], 0}, NULL, 8) = 0
rt_sigaction(SIGINT, {0x8049900, [INT USR1], SA_NOMASK|SA_ONESHOT}, NULL, 8) = 0
clock_gettime(CLOCK_MONOTONIC, {203, 63871340}) = 0
read(0, "", 512)                        = 0
close(0)                                = 0
close(1)                                = 0
clock_gettime(CLOCK_MONOTONIC, {203, 68260899}) = 0
open("/usr/share/locale/en_US/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "0+0 records in\n0+0 records out\n", 31) = 31
write(2, "0 bytes (0 B) copied", 20)    = 20
write(2, ", 0.00438956 seconds, 0.0 kB/s\n", 31) = 31
close(1)                                = -1 EBADF (Bad file descriptor)
exit_group(0)                           = ?


--------------000004060002060706030501
Content-Type: text/plain;
 name="tar.strace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tar.strace"

execve("/bin/tar", ["tar", "cvf", "foo.tar", "/mnt/cdrom"], [/* 28 vars */]) = 0
uname({sys="Linux", node="5va2", ...})  = 0
brk(0)                                  = 0x8079000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=47774, ...}) = 0
mmap2(NULL, 47774, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f5b000
close(3)                                = 0
open("/lib/tls/librt.so.1", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\35\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=34763, ...}) = 0
mmap2(NULL, 29260, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f53000
mmap2(0xb7f59000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x5) = 0xb7f59000
close(3)                                = 0
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20O\1\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1441201, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f52000
mmap2(NULL, 1240284, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e23000
mmap2(0xb7f4c000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x128) = 0xb7f4c000
mmap2(0xb7f50000, 7388, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f50000
close(3)                                = 0
open("/lib/tls/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20H\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=88005, ...}) = 0
mmap2(NULL, 70104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e11000
mmap2(0xb7e1f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xd) = 0xb7e1f000
mmap2(0xb7e21000, 4568, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7e21000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e10000
mprotect(0xb7f4c000, 4096, PROT_READ)   = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e106c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb7f5b000, 47774)               = 0
set_tid_address(0xb7e10708)             = 1179
rt_sigaction(SIGRTMIN, {0xb7e153a0, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb7e15420, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
_sysctl({{CTL_KERN, KERN_VERSION}, 2, 0xbf8be31c, 32, (nil), 0}) = 0
clock_gettime(CLOCK_REALTIME, {1175605400, 150858645}) = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
brk(0)                                  = 0x8079000
brk(0x809a000)                          = 0x809a000
open("/usr/share/locale/locale.alias", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2586, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f66000
read(3, "# Locale name alias data base.\n#"..., 4096) = 2586
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb7f66000, 4096)                = 0
open("/usr/lib/locale/en_US/LC_IDENTIFICATION", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=378, ...}) = 0
mmap2(NULL, 378, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f66000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MEASUREMENT", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=28, ...}) = 0
mmap2(NULL, 28, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f65000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_TELEPHONE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=64, ...}) = 0
mmap2(NULL, 64, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f64000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_ADDRESS", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=160, ...}) = 0
mmap2(NULL, 160, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f63000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_NAME", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=82, ...}) = 0
mmap2(NULL, 82, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f62000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_PAPER", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=39, ...}) = 0
mmap2(NULL, 39, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f61000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MESSAGES", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MESSAGES/SYS_LC_MESSAGES", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
mmap2(NULL, 57, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f60000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_MONETARY", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=291, ...}) = 0
mmap2(NULL, 291, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f5f000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_TIME", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2456, ...}) = 0
mmap2(NULL, 2456, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f5e000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_NUMERIC", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=59, ...}) = 0
mmap2(NULL, 59, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f5d000
close(3)                                = 0
open("/usr/lib/locale/en_US/LC_CTYPE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=178476, ...}) = 0
mmap2(NULL, 178476, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7de4000
close(3)                                = 0
rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
open("foo.tar", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
open("/usr/share/locale/en_US/LC_MESSAGES/tar.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/tar.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "tar: ", 5)                    = 5
write(2, "Removing leading `/\' from member"..., 38) = 38
write(2, "\n", 1)                       = 1
lstat64("/mnt/cdrom", {st_mode=S_IFDIR|0555, st_size=2048, ...}) = 0
open("/mnt/cdrom", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0555, st_size=2048, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 8 entries */, 2048)    = 232
getdents64(4, /* 0 entries */, 2048)    = 0
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_GETFL)                     = 0x2 (flags O_RDWR)
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_GETFL)                     = 0x2 (flags O_RDWR)
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/etc/nsswitch.conf", O_RDONLY)    = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=1083, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f5c000
read(4, "#\n# /etc/nsswitch.conf\n#\n# An ex"..., 4096) = 1083
read(4, "", 4096)                       = 0
close(4)                                = 0
munmap(0xb7f5c000, 4096)                = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=47774, ...}) = 0
mmap2(NULL, 47774, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7dd8000
close(4)                                = 0
open("/lib/tls/libnss_compat.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\340\20"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0755, st_size=39243, ...}) = 0
mmap2(NULL, 37488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7dce000
mmap2(0xb7dd6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x7) = 0xb7dd6000
close(4)                                = 0
open("/lib/tls/libnsl.so.1", O_RDONLY)  = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0 5\0\000"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0755, st_size=92279, ...}) = 0
mmap2(NULL, 88064, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7db8000
mmap2(0xb7dca000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x11) = 0xb7dca000
mmap2(0xb7dcc000, 6144, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7dcc000
close(4)                                = 0
munmap(0xb7dd8000, 47774)               = 0
open("/etc/ld.so.cache", O_RDONLY)      = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=47774, ...}) = 0
mmap2(NULL, 47774, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7dd8000
close(4)                                = 0
open("/lib/tls/libnss_nis.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\34\0\000"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0755, st_size=41139, ...}) = 0
mmap2(NULL, 37416, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7dae000
mmap2(0xb7db6000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x7) = 0xb7db6000
close(4)                                = 0
open("/lib/tls/libnss_files.so.2", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\33\0\000"..., 512) = 512
fstat64(4, {st_mode=S_IFREG|0755, st_size=45361, ...}) = 0
mmap2(NULL, 41612, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4, 0) = 0xb7da3000
mmap2(0xb7dac000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x8) = 0xb7dac000
close(4)                                = 0
munmap(0xb7dd8000, 47774)               = 0
open("/etc/passwd", O_RDONLY)           = 4
fcntl64(4, F_GETFD)                     = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
_llseek(4, 0, [0], SEEK_CUR)            = 0
fstat64(4, {st_mode=S_IFREG|0644, st_size=707, ...}) = 0
mmap2(NULL, 707, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f5c000
_llseek(4, 707, [707], SEEK_SET)        = 0
munmap(0xb7f5c000, 707)                 = 0
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_GETFL)                     = 0x2 (flags O_RDWR)
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 4
fcntl64(4, F_GETFL)                     = 0x2 (flags O_RDWR)
fcntl64(4, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(4, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(4)                                = 0
open("/etc/group", O_RDONLY)            = 4
fcntl64(4, F_GETFD)                     = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
_llseek(4, 0, [0], SEEK_CUR)            = 0
fstat64(4, {st_mode=S_IFREG|0644, st_size=467, ...}) = 0
mmap2(NULL, 467, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f5c000
_llseek(4, 467, [467], SEEK_SET)        = 0
munmap(0xb7f5c000, 467)                 = 0
close(4)                                = 0
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f5c000
write(1, "/mnt/cdrom/\n", 12)           = 12
lstat64("/mnt/cdrom/dott", {st_mode=S_IFDIR|0555, st_size=2048, ...}) = 0
open("/mnt/cdrom/dott", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0555, st_size=2048, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 14 entries */, 2048)   = 432
getdents64(4, /* 0 entries */, 2048)    = 0
close(4)                                = 0
write(1, "/mnt/cdrom/dott/\n", 17)      = 17
lstat64("/mnt/cdrom/dott/adlib.ims", {st_mode=S_IFREG|0555, st_size=21896, ...}) = 0
open("/mnt/cdrom/dott/adlib.ims", O_RDONLY|O_LARGEFILE) = 4
write(1, "/mnt/cdrom/dott/adlib.ims\n", 26) = 26
read(4, "MZ\210\1+\0\2\0 \0>\2\377\377\0\0\0\0n\267\0\0\0\0\36\0"..., 8704) = 8704
write(3, "mnt/cdrom/\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 10240) = 10240
read(4, "\203\373\20uP\213V\10\213\302*\344\213\310\212\340*\300"..., 10240) = 10240
write(3, "\203\373\20uP\213V\10\213\302*\344\213\310\212\340*\300"..., 10240) = 10240
read(4, "\301\343\5+\330\212\207P\"*\344\367\330^_\311\303\220\v"..., 2952) = 2952
fstat64(4, {st_mode=S_IFREG|0555, st_size=21896, ...}) = 0
close(4)                                = 0
lstat64("/mnt/cdrom/dott/dott.bat", {st_mode=S_IFREG|0555, st_size=13, ...}) = 0
open("/mnt/cdrom/dott/dott.bat", O_RDONLY|O_LARGEFILE) = 4
write(1, "/mnt/cdrom/dott/dott.bat\n", 25) = 25
read(4, "cd ..\r\ndott\r\n", 13)        = 13
fstat64(4, {st_mode=S_IFREG|0555, st_size=13, ...}) = 0
close(4)                                = 0
lstat64("/mnt/cdrom/dott/dotticon.ico", {st_mode=S_IFREG|0555, st_size=766, ...}) = 0
open("/mnt/cdrom/dott/dotticon.ico", O_RDONLY|O_LARGEFILE) = 4
write(1, "/mnt/cdrom/dott/dotticon.ico\n", 29) = 29
read(4, "\0\0\1\0\1\0  \20\0\0\0\0\0\350\2\0\0\26\0\0\0(\0\0\0 "..., 766) = 766
fstat64(4, {st_mode=S_IFREG|0555, st_size=766, ...}) = 0
close(4)                                = 0
lstat64("/mnt/cdrom/dott/gmidi.ims", {st_mode=S_IFREG|0555, st_size=19360, ...}) = 0
open("/mnt/cdrom/dott/gmidi.ims", O_RDONLY|O_LARGEFILE) = 4
write(1, "/mnt/cdrom/dott/gmidi.ims\n", 26) = 26
read(4, "MZ\240\1&\0\2\0 \0\272\1\377\377\0\0\0\0\361}\0\0\0\0\36"..., 4096) = 4096
write(3, "\301\343\5+\330\212\207P\"*\344\367\330^_\311\303\220\v"..., 10240) = 10240
read(4, "\2\213\360\v\366u\3\351\204\0\377v\n\377v\10V\377V\376"..., 10240) = 10240
write(3, "\2\213\360\v\366u\3\351\204\0\377v\n\377v\10V\377V\376"..., 10240) = 10240
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 5024) = 5024
fstat64(4, {st_mode=S_IFREG|0555, st_size=19360, ...}) = 0
close(4)                                = 0
lstat64("/mnt/cdrom/dott/maniac", {st_mode=S_IFDIR|0555, st_size=4096, ...}) = 0
open("/mnt/cdrom/dott/maniac", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0555, st_size=4096, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 56 entries */, 2048)   = 1776
getdents64(4, /* 0 entries */, 2048)    = 0
close(4)                                = 0
write(1, "/mnt/cdrom/dott/maniac/\n", 24) = 24
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV +++


--------------000004060002060706030501--
