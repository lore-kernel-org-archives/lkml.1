Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYBEB6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYBEB6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYBEB6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:58:08 -0500
Received: from twin.jikos.cz ([213.151.79.26]:47042 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbYBEB6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:58:07 -0500
Date: Tue, 5 Feb 2008 02:57:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: brk randomization breaks columns
In-Reply-To: <20080204122837.GA1647@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
References: <20080204122837.GA1647@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ some CCs added ]

On Mon, 4 Feb 2008, Pavel Machek wrote:

> pavel@amd:~$ strace columns-bin
> execve("/usr/local/bin/columns-bin", ["columns-bin"], [/* 31 vars */])
> = 0
> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
> -1, 0) = 0xb7f78000
> mprotect(0xb7f79000, 21406, PROT_READ|PROT_WRITE|PROT_EXEC) = 0
> mprotect(0x8048000, 31345, PROT_READ|PROT_WRITE|PROT_EXEC) = 0
> stat("/etc/ld.so.cache", {st_mode=S_IFREG|0644, st_size=106939, ...})
> = 0
> open("/etc/ld.so.cache", O_RDONLY)      = 3
> old_mmap(NULL, 106939, PROT_READ, MAP_SHARED, 3, 0) = 0xb7f5d000
> close(3)                                = 0
> stat("/etc/ld.so.preload", 0xbf87f348)  = -1 ENOENT (No such file or
> directory)
> open("/home/pavel/lib/libc.so.5", O_RDONLY) = -1 ENOENT (No such file
> or directory)
> open("/lib/libc.so.5", O_RDONLY)        = 3
> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\32"...,
> 4096) = 4096
> old_mmap(NULL, 786432, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
> 0xb7e9d000
> old_mmap(0xb7e9d000, 552787, PROT_READ|PROT_EXEC,
> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0xb7e9d000
> old_mmap(0xb7f24000, 21848, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED, 3, 0x86000) = 0xb7f24000
> old_mmap(0xb7f2a000, 204908, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f2a000
> close(3)                                = 0
> mprotect(0xb7e9d000, 552787, PROT_READ|PROT_WRITE|PROT_EXEC) = 0
> munmap(0xb7f5d000, 106939)              = 0
> mprotect(0x8048000, 31345, PROT_READ|PROT_EXEC) = 0
> mprotect(0xb7e9d000, 552787, PROT_READ|PROT_EXEC) = 0
> mprotect(0xb7f79000, 21406, PROT_READ|PROT_EXEC) = 0
> personality(PER_LINUX)                  = 4194304
> geteuid()                               = 1000
> getuid()                                = 1000
> getgid()                                = 1002
> getegid()                               = 1002
> brk(0x8054098)                          = 0x8054098
> brk(0x8055000)                          = 0x8055000
> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> +++ killed by SIGSEGV (core dumped) +++
> Process 1517 detached
> pavel@amd:~$
> columns die due to
> Feb  4 12:29:32 amd kernel: columns-bin[4535]: segfault at 8052000 ip b7f08a9a sp bfb79628 error 6 in
> libc.so.5.4.33[b7e99000+87000]
> Just before death, 
> root@amd:~# cat /proc/4537/maps
> 08048000-08050000 r-xp 00000000 08:04 246209 /usr/local/bin/columns-bin
> 08050000-08051000 rwxp 00007000 08:04 246209 /usr/local/bin/columns-bin
> 08051000-08052000 rwxp 08051000 00:00 0
> b7f00000-b7f87000 r-xp 00000000 08:04 373330     /lib/libc.so.5.4.33
> b7f87000-b7f8d000 rwxp 00086000 08:04 373330     /lib/libc.so.5.4.33
> b7f8d000-b7fc0000 rwxp b7f8d000 00:00 0
> b7fdb000-b7fdc000 rwxp b7fdb000 00:00 0
> b7fdc000-b7fe2000 r-xp 00000000 08:04 373339 /lib/ld-linux.so.1.9.11
> b7fe2000-b7fe3000 rwxp 00005000 08:04 373339 /lib/ld-linux.so.1.9.11
> bface000-bfae3000 rwxp bffeb000 00:00 0          [stack]
> ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
> root@amd:~#

Actually, this clearly shows that either prehistoric libc.so.5 or the 
program itself are broken. 

- as you can easily see by repeated invocation of your program, the 
  arguments to brk() are always the same, no matter to what offset the brk 
  start gets randomized.

- i.e. the arguments passed to brk() strace shows clearly indicate that 
  the binary (or library) is assuming that brk starts in the very next
  page after code+bss (i.e. at the page following 0x08052000). That is wrong. 
  The program then accessess unmapped memory, which causes segfault.

> ...which is strange. Columns asked for brk, but kernel assigned it no
> heap. No wonder columns are crashing.

Now, you are right that the return value from brk() is bogus in these 
cases. The patch below should make it behave, as you can easily check with 
strace, right? Does anyone have any comments regarding this patch please?

Still, it will probably not fix your particular program crashes, just 
because it will always assume that brk starts immediately after the end of 
the bss, which is plain wrong and has never been assured. Could you please 
check whether there is any compat-* package available for you 
distribution, that upgrades libc.so.5 to any fixed version?

Thanks.


From: Jiri Kosina <jkosina@suse.cz>

brk: check the lower bound properly

There is a check in sys_brk(), that tries to make sure that we do not 
underflow the area that is dedicated to brk heap.

The check is however wrong, as it assumes that brk area starts immediately 
after the end of the code (+bss), which is wrong for example in 
environments with randomized brk start. The proper way is to check whether 
the address is not below the start_brk address.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/mm/mmap.c b/mm/mmap.c
index 8295577..1c3b48f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -241,7 +241,7 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 
 	down_write(&mm->mmap_sem);
 
-	if (brk < mm->end_code)
+	if (brk < mm->start_brk)
 		goto out;
 
 	/*
