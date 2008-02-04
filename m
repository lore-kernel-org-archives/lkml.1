Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYBDM2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYBDM2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYBDM21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:28:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59532 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752535AbYBDM2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:28:25 -0500
Date: Mon, 4 Feb 2008 13:28:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: brk randomization breaks columns
Message-ID: <20080204122837.GA1647@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Columns is very popular game of year about 1993, and brk randomization
breaks it. (Along with my boot, but who cares about boot when game is
broken?)

echo 1 > /proc/sys/kernel/randomize_va_space

breaks columns

echo 0 > /proc/sys/kernel/randomize_va_space

fixes them.

root@amd:~# ls -al `which columns-bin`
-rwxr-xr-x 1 root root 100515 Aug  7  1997 /usr/local/bin/columns-bin*
root@amd:~# ldd `which columns-bin`
        libc.so.5 => /lib/libc.so.5 (0xb7e22000)
root@amd:~#

pavel@amd:~$ strace columns-bin
execve("/usr/local/bin/columns-bin", ["columns-bin"], [/* 31 vars */])
= 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xb7f78000
mprotect(0xb7f79000, 21406, PROT_READ|PROT_WRITE|PROT_EXEC) = 0
mprotect(0x8048000, 31345, PROT_READ|PROT_WRITE|PROT_EXEC) = 0
stat("/etc/ld.so.cache", {st_mode=S_IFREG|0644, st_size=106939, ...})
= 0
open("/etc/ld.so.cache", O_RDONLY)      = 3
old_mmap(NULL, 106939, PROT_READ, MAP_SHARED, 3, 0) = 0xb7f5d000
close(3)                                = 0
stat("/etc/ld.so.preload", 0xbf87f348)  = -1 ENOENT (No such file or
directory)
open("/home/pavel/lib/libc.so.5", O_RDONLY) = -1 ENOENT (No such file
or directory)
open("/lib/libc.so.5", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240\32"...,
4096) = 4096
old_mmap(NULL, 786432, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xb7e9d000
old_mmap(0xb7e9d000, 552787, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_FIXED, 3, 0) = 0xb7e9d000
old_mmap(0xb7f24000, 21848, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED, 3, 0x86000) = 0xb7f24000
old_mmap(0xb7f2a000, 204908, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f2a000
close(3)                                = 0
mprotect(0xb7e9d000, 552787, PROT_READ|PROT_WRITE|PROT_EXEC) = 0
munmap(0xb7f5d000, 106939)              = 0
mprotect(0x8048000, 31345, PROT_READ|PROT_EXEC) = 0
mprotect(0xb7e9d000, 552787, PROT_READ|PROT_EXEC) = 0
mprotect(0xb7f79000, 21406, PROT_READ|PROT_EXEC) = 0
personality(PER_LINUX)                  = 4194304
geteuid()                               = 1000
getuid()                                = 1000
getgid()                                = 1002
getegid()                               = 1002
brk(0x8054098)                          = 0x8054098
brk(0x8055000)                          = 0x8055000
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
+++ killed by SIGSEGV (core dumped) +++
Process 1517 detached
pavel@amd:~$

columns die due to

Feb  4 12:29:32 amd kernel: columns-bin[4535]: segfault at 8052000 ip b7f08a9a sp bfb79628 error 6 in
libc.so.5.4.33[b7e99000+87000]

Just before death, 

root@amd:~# cat /proc/4537/maps
08048000-08050000 r-xp 00000000 08:04 246209 /usr/local/bin/columns-bin
08050000-08051000 rwxp 00007000 08:04 246209 /usr/local/bin/columns-bin
08051000-08052000 rwxp 08051000 00:00 0
b7f00000-b7f87000 r-xp 00000000 08:04 373330     /lib/libc.so.5.4.33
b7f87000-b7f8d000 rwxp 00086000 08:04 373330     /lib/libc.so.5.4.33
b7f8d000-b7fc0000 rwxp b7f8d000 00:00 0
b7fdb000-b7fdc000 rwxp b7fdb000 00:00 0
b7fdc000-b7fe2000 r-xp 00000000 08:04 373339 /lib/ld-linux.so.1.9.11
b7fe2000-b7fe3000 rwxp 00005000 08:04 373339 /lib/ld-linux.so.1.9.11
bface000-bfae3000 rwxp bffeb000 00:00 0          [stack]
ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
root@amd:~#

...which is strange. Columns asked for brk, but kernel assigned it no
heap. No wonder columns are crashing.

(gdb) bt
#0  0xb7f6fa60 in memset () from /lib/libc.so.5
#1  0xb7f7b4a3 in initialize () from /lib/libc.so.5
#2  0x00000024 in ?? ()
#3  0x00000000 in ?? ()
(gdb)
(gdb) disassemble
Dump of assembler code for function memset:
0xb7f6fa60 <memset+0>:  push   %ebp
0xb7f6fa61 <memset+1>:  push   %edi
0xb7f6fa62 <memset+2>:  push   %esi
0xb7f6fa63 <memset+3>:  mov    0x10(%esp),%ebp
0xb7f6fa67 <memset+7>:  mov    0x18(%esp),%esi
0xb7f6fa6b <memset+11>: mov    %ebp,%edi
0xb7f6fa6d <memset+13>: movzbl 0x14(%esp),%eax
0xb7f6fa72 <memset+18>: cld
0xb7f6fa73 <memset+19>: cmp    $0xb,%esi
0xb7f6fa76 <memset+22>: jbe    0xb7f6fa9f <memset+63>
0xb7f6fa78 <memset+24>: mov    %eax,%edx
0xb7f6fa7a <memset+26>: shl    $0x8,%edx
0xb7f6fa7d <memset+29>: or     %edx,%eax
0xb7f6fa7f <memset+31>: mov    %eax,%edx
0xb7f6fa81 <memset+33>: shl    $0x10,%edx
0xb7f6fa84 <memset+36>: or     %edx,%eax
0xb7f6fa86 <memset+38>: mov    %ebp,%edx
0xb7f6fa88 <memset+40>: neg    %edx
0xb7f6fa8a <memset+42>: and    $0x3,%edx
0xb7f6fa8d <memset+45>: sub    %edx,%esi
0xb7f6fa8f <memset+47>: mov    %edx,%ecx
0xb7f6fa91 <memset+49>: rep stos %al,%es:(%edi)
0xb7f6fa93 <memset+51>: mov    %esi,%edx
0xb7f6fa95 <memset+53>: shr    $0x2,%edx
0xb7f6fa98 <memset+56>: mov    %edx,%ecx
0xb7f6fa9a <memset+58>: rep stos %eax,%es:(%edi)
0xb7f6fa9c <memset+60>: and    $0x3,%esi
0xb7f6fa9f <memset+63>: mov    %esi,%ecx
0xb7f6faa1 <memset+65>: rep stos %al,%es:(%edi)
0xb7f6faa3 <memset+67>: mov    %ebp,%eax
0xb7f6faa5 <memset+69>: pop    %esi
0xb7f6faa6 <memset+70>: pop    %edi
0xb7f6faa7 <memset+71>: pop    %ebp
0xb7f6faa8 <memset+72>: ret
End of assembler dump.
(gdb)
(gdb) i r
eax            0x3000   12288
ecx            0x8055000        134565888
edx            0xb7f8ac68       -1208439704
ebx            0xb7f8bb08       -1208435960
esp            0xbfae1db4       0xbfae1db4
ebp            0xb7fbf058       0xb7fbf058
esi            0xf68    3944
edi            0x8052000        134553600
eip            0xb7f6fa60       0xb7f6fa60 <memset>
eflags         0x282    [ SF IF ]
cs             0x73     115
ss             0x7b     123
ds             0x7b     123
es             0x7b     123
fs             0x0      0
gs             0x0      0
(gdb)


Hmm, code in binfmt_elf is really strange.

        elf_bss += load_bias;
        elf_brk += load_bias;
        start_code += load_bias;
        end_code += load_bias;
        start_data += load_bias;
        end_data += load_bias;

        /* Calling set_brk effectively mmaps the pages that we need
         * for the bss and break sections.  We must do this before
         * mapping in the interpreter, to make sure it doesn't wind
         * up getting placed where the bss needs to go.
         */
        retval = set_brk(elf_bss, elf_brk);

... so we allocate non-randoimzed brk, but later we just overwrite bss
variable with new, shiner and better randomized value... without
unmapping the old one... The code in binfmt_elf.c is really a mess.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
