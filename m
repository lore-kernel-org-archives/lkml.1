Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYDIR1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYDIR1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYDIR1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:27:14 -0400
Received: from rtr.ca ([76.10.145.34]:2689 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbYDIR1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:27:11 -0400
Message-ID: <47FCFC6B.7060405@rtr.ca>
Date: Wed, 09 Apr 2008 13:27:07 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Network <linux-net@vger.kernel.org>
Subject: re: Regression: 2.6.25-rc8: FTP transfer errors
References: <SvnMeM-aZi.A.S3E.b-_-HB@albercik> <47FC4C87.1020705@rtr.ca> <47FCC6B5.70804@rtr.ca> <47FCF2DD.30705@garzik.org> <47FCF9DD.6080007@rtr.ca>
In-Reply-To: <47FCF9DD.6080007@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeff Garzik wrote:
>> Mark Lord wrote:
>>> Mark Lord wrote:
>>>> Today I've been using 2.6.25-rc8 with an old embedded build system here
>>>> for my empegs.  One shell script calls out to /usr/bin/ftp to transfer
>>>> an image to a remote system, and then read it back again and compare.
>>>>
>>>> The compare is failing, most (but not all) of the time,
>>>> but only on 2.6.25-rc8, not on 2.6.24.  Verified by switching
>>>> back and forth between kernel versions for a short spell.
>>>>
>>>> The ftp client is netkit-ftp 0.17-16 on Kubuntu feisty.
>>>>
>>>> Switching to ncftpput/ncftpget avoids it on 2.6.25,
>>>> but I wonder where the problem is.
>>> ..
>>>
>>> Now verified that the data loss occurs in the outbound direction.
>>> The readback data is the same, regardless of which client s/w is used.
>>>
>>> So something in 2.6.25 is incompatible with the ftp client binary, or 
>>> libs, that are installed here.  Or some other problem.
>>
>> Or maybe it uses sendfile, and that is broken?
> ..
> 
> No, it uses read()/write() calls (from the strace).
> Here's the most recent update:
> 
>> Recap, with more info:
>>
>> The host system is running 2.6.25-rc8-git.  It uses netkit-ftp to
>> send a file to the remote system.  Using strace shows that the
>> entire file was read, and passed to write() for the outbound socket.
>>
>> The remote system is running linux-2.2.xx, and is reporting -EPIPE
>> from net/socket.c::sock_recvmsg() before all of the data has been 
>> received,
>> and thus ends up with a short file, missing data at the end.
>>
>> This exact sequence, with the exact same software,
>> works fine when the host system is NOT running 2.6.25-*,
>> (eg. 2.6.11 through 2.6.24 are fine).
>>
>> Something may be broken here.
> ..
> 
> The failing FTP client software issues a close() on the socket after
> the final data write().  This close seems to be propagated to the other
> end before the data is fully received.
> 
> I suppose a wireshark capture is next, once I dig out my ancient hub
> so we can sniff it from an independent box.
..

Meanwhile, here is the strace of the FTP client from the host side.
Nothing strange -- it opens the socket, the file, and does read()/write()
pairs to move all of the data down the line to the remote.
It then close()s both of them, and gets the "426 Connection failed"
response after the remote end sees a premature -EPIPE from sock_recvmsg().

Cheers

execve("/usr/bin/ftp", ["ftp", "10.0.0.26"], [/* 39 vars */]) = 0
brk(0)                                  = 0x9b36000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f70000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=104744, ...}) = 0
mmap2(NULL, 104744, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f56000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libreadline.so.5", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\317\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=196560, ...}) = 0
mmap2(NULL, 199764, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f25000
mmap2(0xb7f51000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2c) = 0xb7f51000
mmap2(0xb7f55000, 3156, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f55000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libncurses.so.5", O_RDONLY)  = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\362"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=268600, ...}) = 0
mmap2(NULL, 273860, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7ee2000
mmap2(0xb7f1c000, 36864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x39) = 0xb7f1c000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0`\1\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=1307104, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7ee1000
mmap2(NULL, 1312164, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7da0000
mmap2(0xb7edb000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13b) = 0xb7edb000
mmap2(0xb7ede000, 9636, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ede000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libdl.so.2", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0P\n\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=9684, ...}) = 0
mmap2(NULL, 12412, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d9c000
mmap2(0xb7d9e000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb7d9e000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7d9b000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7d9b6c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7edb000, 4096, PROT_READ)   = 0
munmap(0xb7f56000, 104744)              = 0
brk(0)                                  = 0x9b36000
brk(0x9b57000)                          = 0x9b57000
open("/etc/nsswitch.conf", O_RDONLY)    = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=513, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6f000
read(3, "# /etc/nsswitch.conf\n#\n# Example"..., 4096) = 513
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb7f6f000, 4096)                = 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=104744, ...}) = 0
mmap2(NULL, 104744, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f56000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/i686/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/i686/cmov", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/lib/tls/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/i686", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/lib/tls/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/tls/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/sse2", 0xbff8bf20)     = -1 ENOENT (No such file or directory)
open("/lib/tls/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls/cmov", 0xbff8bf20)     = -1 ENOENT (No such file or directory)
open("/lib/tls/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/tls", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/lib/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i686/sse2", 0xbff8bf20)    = -1 ENOENT (No such file or directory)
open("/lib/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i686/cmov", 0xbff8bf20)    = -1 ENOENT (No such file or directory)
open("/lib/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i686", 0xbff8bf20)         = -1 ENOENT (No such file or directory)
open("/lib/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/sse2/cmov", 0xbff8bf20)    = -1 ENOENT (No such file or directory)
open("/lib/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/sse2", 0xbff8bf20)         = -1 ENOENT (No such file or directory)
open("/lib/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/cmov", 0xbff8bf20)         = -1 ENOENT (No such file or directory)
open("/lib/libnss_db.so.2", O_RDONLY)   = -1 ENOENT (No such file or directory)
stat64("/lib", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/usr/lib/tls/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/i686/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/i686/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/i686", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/tls/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/tls", 0xbff8bf20)      = -1 ENOENT (No such file or directory)
open("/usr/lib/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i686/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i686/cmov", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/usr/lib/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i686", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/usr/lib/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/sse2", 0xbff8bf20)     = -1 ENOENT (No such file or directory)
open("/usr/lib/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/cmov", 0xbff8bf20)     = -1 ENOENT (No such file or directory)
open("/usr/lib/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib", {st_mode=S_IFDIR|0755, st_size=122880, ...}) = 0
open("/lib/i486-linux-gnu/tls/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/tls/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls/i686/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/tls/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls/i686/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/tls/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls/i686", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/tls/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/tls/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/tls/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/tls/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/tls", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/i686/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/i686/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/i686", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/lib/i486-linux-gnu/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i486-linux-gnu", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/usr/lib/i486-linux-gnu/tls/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/tls/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls/i686/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/tls/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls/i686/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/tls/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls/i686", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/tls/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/tls/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/tls/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/tls/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/tls", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/i686/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/i686/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/i686/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/i686/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/i686/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/i686/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/i686/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/i686", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/sse2/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/sse2/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/sse2/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/sse2", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/cmov/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu/cmov", 0xbff8bf20) = -1 ENOENT (No such file or directory)
open("/usr/lib/i486-linux-gnu/libnss_db.so.2", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i486-linux-gnu", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
munmap(0xb7f56000, 104744)              = 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=104744, ...}) = 0
mmap2(NULL, 104744, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f56000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_files.so.2", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\0\31\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=38416, ...}) = 0
mmap2(NULL, 41624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d90000
mmap2(0xb7d99000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x8) = 0xb7d99000
close(3)                                = 0
munmap(0xb7f56000, 104744)              = 0
open("/etc/services", O_RDONLY)         = 3
fcntl64(3, F_GETFD)                     = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
fstat64(3, {st_mode=S_IFREG|0644, st_size=18038, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6f000
read(3, "# Network services, Internet sty"..., 4096) = 4096
close(3)                                = 0
munmap(0xb7f6f000, 4096)                = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
readlink("/proc/self/fd/0", "/dev/pts/2", 511) = 10
access("/var/run/utmpx", F_OK)          = -1 ENOENT (No such file or directory)
open("/var/run/utmp", O_RDWR)           = 3
fcntl64(3, F_GETFD)                     = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
_llseek(3, 0, [0], SEEK_SET)            = 0
alarm(0)                                = 0
rt_sigaction(SIGALRM, {0xb7ea29e0, [], 0}, {SIG_DFL}, 8) = 0
alarm(1)                                = 0
fcntl64(3, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=0, len=0}) = 0
read(3, "\2\0\0\0\0\0\0\0~\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\1\0\0\0002\0\0\0~\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\6\0\0\0\341\v\0\0tty4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\6\0\0\0\350\v\0\0tty3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\6\0\0\0\352\v\0\0tty1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\6\0\0\0\342\v\0\0tty5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\6\0\0\0\346\v\0\0tty2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\6\0\0\0\353\v\0\0tty6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "\7\0\0\0W\20\0\0:0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(3, "", 384)                        = 0
fcntl64(3, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=0, len=0}) = 0
alarm(0)                                = 1
rt_sigaction(SIGALRM, {SIG_DFL}, NULL, 8) = 0
close(3)                                = 0
getuid32()                              = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 3
fcntl64(3, F_GETFL)                     = 0x2 (flags O_RDWR)
fcntl64(3, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_FILE, SOCK_STREAM, 0)         = 3
fcntl64(3, F_GETFL)                     = 0x2 (flags O_RDWR)
fcntl64(3, F_SETFL, O_RDWR|O_NONBLOCK)  = 0
connect(3, {sa_family=AF_FILE, path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=104744, ...}) = 0
mmap2(NULL, 104744, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f56000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_compat.so.2", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\16\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=30436, ...}) = 0
mmap2(NULL, 33348, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d87000
mmap2(0xb7d8e000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6) = 0xb7d8e000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnsl.so.1", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`0\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=79596, ...}) = 0
mmap2(NULL, 91944, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d70000
mmap2(0xb7d83000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x12) = 0xb7d83000
mmap2(0xb7d85000, 5928, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7d85000
close(3)                                = 0
munmap(0xb7f56000, 104744)              = 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=104744, ...}) = 0
mmap2(NULL, 104744, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f56000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libnss_nis.so.2", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\20\31\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=34352, ...}) = 0
mmap2(NULL, 37436, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7d66000
mmap2(0xb7d6e000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7) = 0xb7d6e000
close(3)                                = 0
munmap(0xb7f56000, 104744)              = 0
open("/etc/passwd", O_RDONLY)           = 3
fcntl64(3, F_GETFD)                     = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
_llseek(3, 0, [0], SEEK_CUR)            = 0
fstat64(3, {st_mode=S_IFREG|0644, st_size=1577, ...}) = 0
mmap2(NULL, 1577, PROT_READ, MAP_SHARED, 3, 0) = 0xb7f6f000
_llseek(3, 1577, [1577], SEEK_SET)      = 0
munmap(0xb7f6f000, 1577)                = 0
close(3)                                = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigaction(SIGINT, {0x8053a32, [INT], 0}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGPIPE, {SIG_IGN}, {SIG_DFL}, 8) = 0
socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 3
connect(3, {sa_family=AF_INET, sin_port=htons(21), sin_addr=inet_addr("10.0.0.26")}, 16) = 0
getsockname(3, {sa_family=AF_INET, sin_port=htons(41102), sin_addr=inet_addr("10.0.0.6")}, [16]) = 0
setsockopt(3, SOL_IP, IP_TOS, [16], 4)  = 0
fcntl64(3, F_GETFL)                     = 0x2 (flags O_RDWR)
fstat64(3, {st_mode=S_IFSOCK|0777, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6f000
_llseek(3, 0, 0xbff8c3cc, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
dup(3)                                  = 4
dup(3)                                  = 5
fcntl64(5, F_GETFL)                     = 0x2 (flags O_RDWR)
fstat64(5, {st_mode=S_IFSOCK|0777, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6e000
_llseek(5, 0, 0xbff8c3cc, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 2), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6d000
write(1, "Connected to 10.0.0.26.\n", 24Connected to 10.0.0.26.
) = 24
read(3, "220 Connected.\r\n", 1024)     = 16
write(1, "220 Connected.\n", 15220 Connected.
)        = 15
setsockopt(-1, SOL_SOCKET, SO_OOBINLINE, [1], 4) = -1 EBADF (Bad file descriptor)
open("/root/.netrc", O_RDONLY|O_LARGEFILE) = 6
uname({sys="Linux", node="corey", ...}) = 0
fstat64(6, {st_mode=S_IFREG|0600, st_size=66, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6c000
read(6, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"..., 4096) = 66
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0xb7f6c000, 4096)                = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
readlink("/proc/self/fd/0", "/dev/pts/2", 511) = 10
access("/var/run/utmpx", F_OK)          = -1 ENOENT (No such file or directory)
open("/var/run/utmp", O_RDWR)           = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
_llseek(6, 0, [0], SEEK_SET)            = 0
alarm(0)                                = 0
rt_sigaction(SIGALRM, {0xb7ea29e0, [], 0}, {SIG_DFL}, 8) = 0
alarm(1)                                = 0
fcntl64(6, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=0, len=0}) = 0
read(6, "\2\0\0\0\0\0\0\0~\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\1\0\0\0002\0\0\0~\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\6\0\0\0\341\v\0\0tty4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\6\0\0\0\350\v\0\0tty3\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\6\0\0\0\352\v\0\0tty1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\6\0\0\0\342\v\0\0tty5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\6\0\0\0\346\v\0\0tty2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\6\0\0\0\353\v\0\0tty6\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "\7\0\0\0W\20\0\0:0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 384) = 384
read(6, "", 384)                        = 0
fcntl64(6, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=0, len=0}) = 0
alarm(0)                                = 1
rt_sigaction(SIGALRM, {SIG_DFL}, NULL, 8) = 0
close(6)                                = 0
getuid32()                              = 0
open("/etc/passwd", O_RDONLY)           = 6
fcntl64(6, F_GETFD)                     = 0
fcntl64(6, F_SETFD, FD_CLOEXEC)         = 0
_llseek(6, 0, [0], SEEK_CUR)            = 0
fstat64(6, {st_mode=S_IFREG|0644, st_size=1577, ...}) = 0
mmap2(NULL, 1577, PROT_READ, MAP_SHARED, 6, 0) = 0xb7f6c000
_llseek(6, 1577, [1577], SEEK_SET)      = 0
munmap(0xb7f6c000, 1577)                = 0
close(6)                                = 0
fstat64(0, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 2), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6c000
write(1, "Name (10.0.0.26:root): ", 23Name (10.0.0.26:root): ) = 23
read(0,
"\n", 1024)                     = 1
write(5, "USER root\r\n", 11)           = 11
read(3, "230 Login okay.\r\n", 1024)    = 17
write(1, "230 Login okay.\n", 16230 Login okay.
)       = 16
write(5, "SYST\r\n", 6)                 = 6
read(3, "215 UNIX Type: L8.\r\n", 1024) = 20
write(1, "Remote system type is UNIX.\n", 28Remote system type is UNIX.
) = 28
write(1, "Using binary mode to transfer fi"..., 37Using binary mode to transfer files.
) = 37
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigaction(SIGINT, {0x8053a32, [INT], 0}, {0x8053a32, [INT], 0}, 8) = 0
rt_sigaction(SIGPIPE, {SIG_IGN}, {SIG_IGN}, 8) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
access("/root/.terminfo/x/xterm", R_OK) = -1 ENOENT (No such file or directory)
access("/etc/terminfo/x/xterm", R_OK)   = -1 ENOENT (No such file or directory)
access("/lib/terminfo/x/xterm", R_OK)   = 0
open("/lib/terminfo/x/xterm", O_RDONLY|O_LARGEFILE) = 6
read(6, "\32\1\34\0\35\0\17\0\235\1&\5", 12) = 12
read(6, "xterm|X11 terminal emulator\0", 28) = 28
read(6, "\0\1\0\0\1\0\0\0\1\0\0\0\0\1\1\0\0\0\0\0\0\0\1\0\0\1\0"..., 29) = 29
read(6, "\0", 1)                        = 1
read(6, "P\0\10\0\30\0\377\377\377\377\377\377\377\377\377\377\377"..., 30) = 30
read(6, "\0\0\4\0\6\0\10\0\31\0\36\0&\0*\0.\0\377\3779\0J\0L\0P"..., 826) = 826
read(6, "\33[Z\0\7\0\r\0\33[%i%p1%d;%p2%dr\0\33[3g\0\33["..., 1318) = 1318
read(6, "", 10)                         = 0
close(6)                                = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, TIOCGWINSZ, {ws_row=55, ws_col=138, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(0, TIOCGWINSZ, {ws_row=55, ws_col=138, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(0, TIOCGWINSZ, {ws_row=55, ws_col=138, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(0, TIOCSWINSZ, {ws_row=55, ws_col=138, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/locale.alias", O_RDONLY) = 6
fstat64(6, {st_mode=S_IFREG|0644, st_size=2586, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6b000
read(6, "# Locale name alias data base.\n#"..., 4096) = 2586
read(6, "", 4096)                       = 0
close(6)                                = 0
munmap(0xb7f6b000, 4096)                = 0
open("/usr/lib/locale/en_CA.UTF-8/LC_CTYPE", O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/lib/locale/en_CA.utf8/LC_CTYPE", O_RDONLY) = 6
fstat64(6, {st_mode=S_IFREG|0644, st_size=238336, ...}) = 0
mmap2(NULL, 238336, PROT_READ, MAP_PRIVATE, 6, 0) = 0xb7d2b000
close(6)                                = 0
open("/usr/lib/gconv/gconv-modules.cache", O_RDONLY) = 6
fstat64(6, {st_mode=S_IFREG|0644, st_size=25460, ...}) = 0
mmap2(NULL, 25460, PROT_READ, MAP_SHARED, 6, 0) = 0xb7d24000
close(6)                                = 0
stat64("/root/.inputrc", 0xbff8c4b0)    = -1 ENOENT (No such file or directory)
stat64("/etc/inputrc", {st_mode=S_IFREG|0644, st_size=1723, ...}) = 0
open("/etc/inputrc", O_RDONLY)          = 6
read(6, "# /etc/inputrc - global inputrc "..., 1723) = 1723
close(6)                                = 0
rt_sigprocmask(SIG_BLOCK, [INT], [], 8) = 0
ioctl(0, TIOCGWINSZ, {ws_row=55, ws_col=138, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(0, TIOCSWINSZ, {ws_row=55, ws_col=138, ws_xpixel=0, ws_ypixel=0}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig -icanon -echo ...}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig -icanon -echo ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [INT QUIT ALRM TSTP TTIN TTOU], [], 8) = 0
rt_sigaction(SIGINT, {0xb7f43bf0, [], 0}, {0x8053a32, [INT], 0}, 8) = 0
rt_sigaction(SIGTERM, {0xb7f43bf0, [], 0}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGQUIT, {0xb7f43bf0, [], 0}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGALRM, {0xb7f43bf0, [], 0}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGTSTP, {0xb7f43bf0, [], 0}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGTTOU, {0xb7f43bf0, [], 0}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGTTIN, {0xb7f43bf0, [], 0}, {SIG_DFL}, 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGWINCH, {0xb7f43ba0, [], SA_RESTART}, {SIG_DFL}, 8) = 0
write(1, "ftp> ", 5ftp> )                    = 5
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "p", 1)                         = 1
write(1, "p", 1p)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "u", 1)                         = 1
write(1, "u", 1u)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "t", 1)                         = 1
write(1, "t", 1t)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, " ", 1)                         = 1
write(1, " ", 1 )                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "z", 1)                         = 1
write(1, "z", 1z)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "I", 1)                         = 1
write(1, "I", 1I)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "m", 1)                         = 1
write(1, "m", 1m)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "a", 1)                         = 1
write(1, "a", 1a)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "g", 1)                         = 1
write(1, "g", 1g)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "e", 1)                         = 1
write(1, "e", 1e)                        = 1
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
read(0, "\r", 1)                        = 1
write(1, "\n", 1
)                       = 1
rt_sigprocmask(SIG_BLOCK, [INT], [], 8) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig -icanon -echo ...}) = 0
ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGINT, {0x8053a32, [INT], 0}, {0xb7f43bf0, [], 0}, 8) = 0
rt_sigaction(SIGTERM, {SIG_DFL}, {0xb7f43bf0, [], 0}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_DFL}, {0xb7f43bf0, [], 0}, 8) = 0
rt_sigaction(SIGALRM, {SIG_DFL}, {0xb7f43bf0, [], 0}, 8) = 0
rt_sigaction(SIGTSTP, {SIG_DFL}, {0xb7f43bf0, [], 0}, 8) = 0
rt_sigaction(SIGTTOU, {SIG_DFL}, {0xb7f43bf0, [], 0}, 8) = 0
rt_sigaction(SIGTTIN, {SIG_DFL}, {0xb7f43bf0, [], 0}, 8) = 0
rt_sigaction(SIGWINCH, {SIG_DFL}, {0xb7f43ba0, [], SA_RESTART}, 8) = 0
time(NULL)                              = 1207749100
write(1, "local: zImage remote: zImage\n", 29local: zImage remote: zImage
) = 29
write(5, "TYPE I\r\n", 8)               = 8
read(3, "200 Okay.\r\n", 1024)          = 11
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
open("zImage", O_RDONLY|O_LARGEFILE)    = 6
fstat64(6, {st_mode=S_IFREG|0755, st_size=494008, ...}) = 0
socket(PF_INET, SOCK_STREAM, IPPROTO_IP) = 7
bind(7, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("10.0.0.6")}, 16) = 0
getsockname(7, {sa_family=AF_INET, sin_port=htons(37402), sin_addr=inet_addr("10.0.0.6")}, [16]) = 0
listen(7, 1)                            = 0
write(5, "PORT 10,0,0,6,146,26\r\n", 22) = 22
read(3, "200 Okay.\r\n", 1024)          = 11
write(1, "200 Okay.\n", 10200 Okay.
)             = 10
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
write(5, "STOR zImage\r\n", 13)         = 13
read(3, "150 Opening data connection.\r\n", 1024) = 30
write(1, "150 Opening data connection.\n", 29150 Opening data connection.
) = 29
accept(7, {sa_family=AF_INET, sin_port=htons(20), sin_addr=inet_addr("10.0.0.26")}, [16]) = 8
close(7)                                = 0
setsockopt(8, SOL_IP, IP_TOS, [8], 4)   = 0
fcntl64(8, F_GETFL)                     = 0x2 (flags O_RDWR)
fstat64(8, {st_mode=S_IFSOCK|0777, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6b000
_llseek(8, 0, 0xbff8a2cc, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
gettimeofday({1207749100, 847425}, NULL) = 0
read(6, "\0\0\240\341\0\0\240\341\0\0\240\341\0\0\240\341\0\0\240"..., 8192) = 8192
write(8, "\0\0\240\341\0\0\240\341\0\0\240\341\0\0\240\341\0\0\240"..., 8192) = 8192
read(6, "\0 \206\345\0\0Q\343\1\0\0\352\337\0\0\353\0\0P\343\362"..., 8192) = 8192
write(8, "\0 \206\345\0\0Q\343\1\0\0\352\337\0\0\353\0\0P\343\362"..., 8192) = 8192
read(6, "\231z\247v\271\275\245\275.\344\3Sls\273\254v\247\301n"..., 8192) = 8192
write(8, "\231z\247v\271\275\245\275.\344\3Sls\273\254v\247\301n"..., 8192) = 8192
read(6, "\36\"\231\350k\34;\314h\223\343\325\367\242~\350*\36\""..., 8192) = 8192
write(8, "\36\"\231\350k\34;\314h\223\343\325\367\242~\350*\36\""..., 8192) = 8192
read(6, "\247X\313\r\03437\346\254\300<\321|\321~\374\3547\213i"..., 8192) = 8192
write(8, "\247X\313\r\03437\346\254\300<\321|\321~\374\3547\213i"..., 8192) = 8192
read(6, "(\3719\307\205\f\21\255\370\263\31t^\'~}%\361\342\242\344"..., 8192) = 8192
write(8, "(\3719\307\205\f\21\255\370\263\31t^\'~}%\361\342\242\344"..., 8192) = 8192
read(6, "\tD\334\345F\23\2766|.x\326\177>\7\236\240I\355\3\2109"..., 8192) = 8192
write(8, "\tD\334\345F\23\2766|.x\326\177>\7\236\240I\355\3\2109"..., 8192) = 8192
read(6, "\365\204\231\17\333\336\37\35\205.\27h\355v1\257\237R\346"..., 8192) = 8192
write(8, "\365\204\231\17\333\336\37\35\205.\27h\355v1\257\237R\346"..., 8192) = 8192
read(6, "+\333\331\200\203\210\363\275\211\256\255\226\274d\200"..., 8192) = 8192
write(8, "+\333\331\200\203\210\363\275\211\256\255\226\274d\200"..., 8192) = 8192
read(6, "\331WAG\252\250D\\\246\0226i^J\305\373w\361\3731\327\315"..., 8192) = 8192
write(8, "\331WAG\252\250D\\\246\0226i^J\305\373w\361\3731\327\315"..., 8192) = 8192
read(6, "\353\37\313\376\375\27\365\17k1\313\277\214\3518h\v\332"..., 8192) = 8192
write(8, "\353\37\313\376\375\27\365\17k1\313\277\214\3518h\v\332"..., 8192) = 8192
read(6, "$\6\333\356\236d\314\230<\306\232mB\356R)\255\231\27:\313"..., 8192) = 8192
write(8, "$\6\333\356\236d\314\230<\306\232mB\356R)\255\231\27:\313"..., 8192) = 8192
read(6, "e\232\262\226\366uO\244\320n\247O\27\344q\247\346(jx\345"..., 8192) = 8192
write(8, "e\232\262\226\366uO\244\320n\247O\27\344q\247\346(jx\345"..., 8192) = 8192
read(6, "m\265\367-\261\316Se\374\360j\31\247\342q\235\t\310!A\316"..., 8192) = 8192
write(8, "m\265\367-\261\316Se\374\360j\31\247\342q\235\t\310!A\316"..., 8192) = 8192
read(6, "\233\33\231jtg\376\355:\3057y\357&\334s\310\3u\373\375"..., 8192) = 8192
write(8, "\233\33\231jtg\376\355:\3057y\357&\334s\310\3u\373\375"..., 8192) = 8192
read(6, "\362\276o?\243m\205\270g\243\377\307\243cy_P\343\205\224"..., 8192) = 8192
write(8, "\362\276o?\243m\205\270g\243\377\307\243cy_P\343\205\224"..., 8192) = 8192
read(6, "\354\226\202/\255\300\265\r\327Q\\gp5\331\225)w\236\210"..., 8192) = 8192
write(8, "\354\226\202/\255\300\265\r\327Q\\gp5\331\225)w\236\210"..., 8192) = 8192
read(6, "\316\247\5\253{\243\320\331[\364\374\360}\22\247\n:\231"..., 8192) = 8192
write(8, "\316\247\5\253{\243\320\331[\364\374\360}\22\247\n:\231"..., 8192) = 8192
read(6, "\332\"\233\320\36\346\33\374)\372\362,\3322\307P}\371\317"..., 8192) = 8192
write(8, "\332\"\233\320\36\346\33\374)\372\362,\3322\307P}\371\317"..., 8192) = 8192
read(6, "Y*q\245\321A\3101\375\316\n\3103\2641\264\333\t|\357pV"..., 8192) = 8192
write(8, "Y*q\245\321A\3101\375\316\n\3103\2641\264\333\t|\357pV"..., 8192) = 8192
read(6, "\262\256\0053\251\322\270.;\33\262S*9\337]a\21\363s\375"..., 8192) = 8192
write(8, "\262\256\0053\251\322\270.;\33\262S*9\337]a\21\363s\375"..., 8192) = 8192
read(6, "\t\366\'\201\36a\355|\225v\vb\211\236|\265&\363\22\350"..., 8192) = 8192
write(8, "\t\366\'\201\36a\355|\225v\vb\211\236|\265&\363\22\350"..., 8192) = 8192
read(6, "\n\306\324\342\234\231\330\330\323#u\2447x\323b\16\336"..., 8192) = 8192
write(8, "\n\306\324\342\234\231\330\330\323#u\2447x\323b\16\336"..., 8192) = 8192
read(6, "\236[\316\365\230\30\24\32\362I\361o)\\\353\16{H\260\247"..., 8192) = 8192
write(8, "\236[\316\365\230\30\24\32\362I\361o)\\\353\16{H\260\247"..., 8192) = 8192
read(6, "\342\255\26\323\30\346\312\310u\213\31\263\22\320\364\246"..., 8192) = 8192
write(8, "\342\255\26\323\30\346\312\310u\213\31\263\22\320\364\246"..., 8192) = 8192
read(6, "m4z\245\255b\333\3130g\3278Q\233I\347\222\314%07`\2147"..., 8192) = 8192
write(8, "m4z\245\255b\333\3130g\3278Q\233I\347\222\314%07`\2147"..., 8192) = 8192
read(6, "\253:\213\336J\377\351a\2712\221\32~43\36\2373\3102\205"..., 8192) = 8192
write(8, "\253:\213\336J\377\351a\2712\221\32~43\36\2373\3102\205"..., 8192) = 8192
read(6, "_\356\221\357\347\363\"\337\377}\206\355\243>\310\177\312"..., 8192) = 8192
write(8, "_\356\221\357\347\363\"\337\377}\206\355\243>\310\177\312"..., 8192) = 8192
read(6, "z8\266qGx\177\352@\305\260\370\356%\347\313\263\344*\222"..., 8192) = 8192
write(8, "z8\266qGx\177\352@\305\260\370\356%\347\313\263\344*\222"..., 8192) = 8192
read(6, "(s\373)H\333\365P\226o*rl\327J\277\362\v\350\203\302m6"..., 8192) = 8192
write(8, "(s\373)H\333\365P\226o*rl\327J\277\362\v\350\203\302m6"..., 8192) = 8192
read(6, "\246+\20\373\337m\363\23\252\315E!\366\353NO\227\7\33\353"..., 8192) = 8192
write(8, "\246+\20\373\337m\363\23\252\315E!\366\353NO\227\7\33\353"..., 8192) = 8192
read(6, "\301\311-VXhcJ&\311\356\201\250\304\203\251\244}\200>A"..., 8192) = 8192
write(8, "\301\311-VXhcJ&\311\356\201\250\304\203\251\244}\200>A"..., 8192) = 8192
read(6, "!\256\234\226?\327\223\216\3371\5s\27r\227\312\316\270"..., 8192) = 8192
write(8, "!\256\234\226?\327\223\216\3371\5s\27r\227\312\316\270"..., 8192) = 8192
read(6, "\214\307\217\225p\33\375[\5\354Q\277\'\270\356`\275\030"..., 8192) = 8192
write(8, "\214\307\217\225p\33\375[\5\354Q\277\'\270\356`\275\030"..., 8192) = 8192
read(6, "\242\264VI\373\265\244\341\177\202h\266S\372\340\34\215"..., 8192) = 8192
write(8, "\242\264VI\373\265\244\341\177\202h\266S\372\340\34\215"..., 8192) = 8192
read(6, "\237m\206\206\261S\321\266F\3316\254?\320\303`\364\277"..., 8192) = 8192
write(8, "\237m\206\206\261S\321\266F\3316\254?\320\303`\364\277"..., 8192) = 8192
read(6, "\341X\316\336\30!Ft^66=\332\343\223\370\356\320\305\205"..., 8192) = 8192
write(8, "\341X\316\336\30!Ft^66=\332\343\223\370\356\320\305\205"..., 8192) = 8192
read(6, "8\303\230\276G\216\251{\236\361\237\34w|\354\261=\230\350"..., 8192) = 8192
write(8, "8\303\230\276G\216\251{\236\361\237\34w|\354\261=\230\350"..., 8192) = 8192
read(6, "\316\t\3639&\346smt\rb5\321|\206\275\223*\347\263\217\347"..., 8192) = 8192
write(8, "\316\t\3639&\346smt\rb5\321|\206\275\223*\347\263\217\347"..., 8192) = 8192
read(6, "\226\351\243I\310\221+\263\272\0\242\313\362\374D\234!"..., 8192) = 8192
write(8, "\226\351\243I\310\221+\263\272\0\242\313\362\374D\234!"..., 8192) = 8192
read(6, "\361\377\"\372_#q\357/b~\3440\363#\27\322\377Y\314\247"..., 8192) = 8192
write(8, "\361\377\"\372_#q\357/b~\3440\363#\27\322\377Y\314\247"..., 8192) = 8192
read(6, "\37\16c\376\227B&hb\16?b>\340\371\351v\247\353\257\17\355"..., 8192) = 8192
write(8, "\37\16c\376\227B&hb\16?b>\340\371\351v\247\353\257\17\355"..., 8192) = 8192
read(6, "\236\32N\242\316\271X(C\31l\31\336}y5x\23\261\374\361\233"..., 8192) = 8192
write(8, "\236\32N\242\316\271X(C\31l\31\336}y5x\23\261\374\361\233"..., 8192) = 8192
read(6, "\25\343\306\277m\334\370s\354\333\242\36\256@\207\33\27"..., 8192) = 8192
write(8, "\25\343\306\277m\334\370s\354\333\242\36\256@\207\33\27"..., 8192) = 8192
read(6, "\17\257\26?a\243S\360G\367\231J\177\242/\nq\333\211\225"..., 8192) = 8192
write(8, "\17\257\26?a\243S\360G\367\231J\177\242/\nq\333\211\225"..., 8192) = 8192
read(6, "s\245\340O|Pl\256\306\232\210\344BR\347\3649)\306xM\v0"..., 8192) = 8192
write(8, "s\245\340O|Pl\256\306\232\210\344BR\347\3649)\306xM\v0"..., 8192) = 8192
read(6, ",\371\246\26f\353\254iS1\307\247\322\306\370\32\322\1\306"..., 8192) = 8192
write(8, ",\371\246\26f\353\254iS1\307\247\322\306\370\32\322\1\306"..., 8192) = 8192
read(6, "\231\224\335\303\276:\206\v\337\343\30\236\2116\374\355"..., 8192) = 8192
write(8, "\231\224\335\303\276:\206\v\337\343\30\236\2116\374\355"..., 8192) = 8192
read(6, "a\236\23\304\270+\377\251df\326\357\363|\361s\236\377\324"..., 8192) = 8192
write(8, "a\236\23\304\270+\377\251df\326\357\363|\361s\236\377\324"..., 8192) = 8192
read(6, "\253\264\234\371*\312\310Y\206c\204\360~\352\37\277\337"..., 8192) = 8192
write(8, "\253\264\234\371*\312\310Y\206c\204\360~\352\37\277\337"..., 8192) = 8192
read(6, "-\203S\235Hq\303\260\271\2076\\K\274\274\320;a\361#+y\347"..., 8192) = 8192
write(8, "-\203S\235Hq\303\260\271\2076\\K\274\274\320;a\361#+y\347"..., 8192) = 8192
read(6, "\t\344\311R\310\223\202\311\257i\305Q2%\317\247\210\245"..., 8192) = 8192
write(8, "\t\344\311R\310\223\202\311\257i\305Q2%\317\247\210\245"..., 8192) = 8192
read(6, "\357\334L\211\330\376\177,o\373o(\333\377\212Jm\373?\310"..., 8192) = 8192
write(8, "\357\334L\211\330\376\177,o\373o(\333\377\212Jm\373?\310"..., 8192) = 8192
read(6, "=\300q\25\347}\337\273w\322Y\34\322\235t6\3028\360\364"..., 8192) = 8192
write(8, "=\300q\25\347}\337\273w\322Y\34\322\235t6\3028\360\364"..., 8192) = 8192
read(6, "\374\30\321\200\226k\315\326\323\300\327\255z\32\370\30"..., 8192) = 8192
write(8, "\374\30\321\200\226k\315\326\323\300\327\255z\32\370\30"..., 8192) = 8192
read(6, "\240T\256&\335\203\\#\316\3670L\254\255\v&4\0278\307\f"..., 8192) = 8192
write(8, "\240T\256&\335\203\\#\316\3670L\254\255\v&4\0278\307\f"..., 8192) = 8192
read(6, "\323K,\311&0*O\340\261\354\265\3~\227\3539XNt\212*\305"..., 8192) = 8192
write(8, "\323K,\311&0*O\340\261\354\265\3~\227\3539XNt\212*\305"..., 8192) = 8192
read(6, "\10\271\337\323\226\320Y\26L\5TkaD2>\17\353+\205\3655\\"..., 8192) = 8192
write(8, "\10\271\337\323\226\320Y\26L\5TkaD2>\17\353+\205\3655\\"..., 8192) = 8192
read(6, "\7\240\313]F\273\322\355c\3057P\273\340N\32\363\366\n\351"..., 8192) = 8192
write(8, "\7\240\313]F\273\322\355c\3057P\273\340N\32\363\366\n\351"..., 8192) = 8192
read(6, "(\r\224\5\242\363\212\264?B\277>\233S\374\3238\320\"\215"..., 8192) = 8192
write(8, "(\r\224\5\242\363\212\264?B\277>\233S\374\3238\320\"\215"..., 8192) = 8192
read(6, ")\243\6\376\376\2\337\316\361\264\265\232\247\227O\363"..., 8192) = 2488
write(8, ")\243\6\376\376\2\337\316\361\264\265\232\247\227O\363"..., 2488) = 2488
read(6, "", 8192)                       = 0
gettimeofday({1207749101, 467913}, NULL) = 0
close(6)                                = 0
close(8)                                = 0
munmap(0xb7f6b000, 4096)                = 0
read(3, "426 Connection failed.\r\n", 1024) = 24
write(1, "426 Connection failed.\n", 23426 Connection failed.
) = 23
write(1, "494008 bytes sent in 0.62 secs ("..., 44494008 bytes sent in 0.62 secs (777.5 kB/s)
) = 44
...

