Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZFBTQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZFBTQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZFBTQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:16:43 -0400
Received: from smtp2e.orange.fr ([80.12.242.111]:7648 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbZFBTQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:16:42 -0400
X-ME-UUID: 20090602191641546.8570080000AF@mwinf2e03.orange.fr
Date: Tue, 2 Jun 2009 21:16:17 +0200
From: =?UTF-8?B?QW5kcsOp?= Gillibert <rcvlkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PROBLEM] Kernels fails to execute QMAGIC a.out executables with
 empty data segment
Message-ID: <20090602211617.5e500213@fixlaptop.gillibert.homelinux.net>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREAMBLE:
May a valid QMAGIC executable have an empty data segment?
GNU as+ld may produce such executable files. If this isn't a kernel bug, this might be a binutils bug.
I found nothing about that issue on Linux kernel bugzilla or through Google Web search.

I'm not 100% sure that this is a real bug, as I couldn't find any authoritative specification of QMAGIC executables.
I read the MAINTAINERS file, and found no one who maintain executable formats, expect the general maintainer: Linus Torvalds.
As Linus Torvalds gets too many e-mails and I'm not sure I found a real bug, I post on LKML for discussion.

KERNEL VERSION: 2.6.29.4

KEYWORDS: kernel, mmap, VMM, Virtual Memory Manager, a.out, binfmt_aout, QMAGIC, i386, data segment, empty, zero size, executable, SIGKILL.

SEVERITY: LOW
Not an obvious security risk.
Affects very few executable files of an obsolete file format.

REPRODUCIBLE: ALWAYS

SUMMARY: On i386 architecture, when a QMAGIC (magic = 0xCC or 0x6400CC) a.out executable, with an empty data segment, data segment size (32 bits word at offset 8 of the executable file) equals zero, is executed (execve) on a kernel with a.out support (CONFIG_BINFMT_AOUT), the processes receives a SIGKILL signals and terminates immediately.

SCOPE:
This seems to be a regression, applying to kernel versions from 2.6.12 up to latest kernel releases.
Older 2.6 kernel doesn't have this problem.
Tested with:
kernel 2.6.11.12: no problem.
kernel 2.6.12.6: has the problem.
kernel 2.6.29.4: has the problem.

ENVIRONMENT:
In theory: Applies to the i386 platform and any platform supporting QMAGIC executables. Tested on i386.
$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.66GHz
stepping        : 7
cpu MHz         : 2666.600
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid
bogomips        : 5332.37
clflush size    : 64
power management:
$ ./ver_linux
Linux fixlaptop 2.6.29.4 #4 Tue Jun 2 19:26:14 CEST 2009 i686 Intel(R) Pentium(R) 4 CPU 2.66GHz GenuineIntel GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.16.1
util-linux             2.13
mount                  2.13
module-init-tools      3.2.2
e2fsprogs              1.41.3
jfsutils               1.1.8
reiserfsprogs          3.6.19
reiser4progs           1.0.6
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.6
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.4
udev                   115

STEPS TO REPRODUCE:
1) Compile 2.6.29.4 kernel with CONFIG_BINFMT_AOUT=y
2) Create a 4096 bytes file whose 0x30 first bytes are:
00000000   CC 00 64 00 00 10 00 00  00 00 00 00 00 00 00 00  ..d.............
00000010   00 00 00 00 20 10 00 00  00 00 00 00 00 00 00 00  .... ...........
00000020   31 C0 31 DB 40 CD 80 00  00 00 00 00 00 00 00 00  1.1.@...........


Then, followed with 0x1000-0x30 padding bytes set to zero.

comments:
00000000   CC 00 64 00  00 10 00 00  00 00 00 00  00 00 00 00  ..d.............
comment:   [magic num ] [.text len]  [.data len ] [.bss len  ]
00000010   00 00 00 00  20 10 00 00  00 00 00 00  00 00 00 00  .... ...........
comment:   [symtbl len] [start addr] [.t rel len] [.d rel len]
00000020   31 C0 31 DB  40 CD 80 00  00 00 00 00  00 00 00 00  1.1.@...........
comment:   disassembly is:
xor %eax,%eax
xor %ebx,%ebx
inc %eax # %eax == 1 == __NR_exit
int $0x80

Note: Changing the magic number from CC 00 64 00 to CC 00 00 00 doesn't change the behavior.
I included this hex code to let you reproduce the bug without needing the exact same binutils than the ones I used, but the same file can be created with GNU binutils (2.16.1 on Gentoo Linux for i386).
$ cat trivial.S
.text
.globl _start
_start:
xor %eax,%eax
xor %ebx,%ebx
inc %eax
int $0x80
$ cat /usr/lib/binutils/i486-pc-linux-gnu/2.16.1/ldscripts/i386linux.x
/* Default linker script, for normal executables */
OUTPUT_FORMAT("a.out-i386-linux", "a.out-i386-linux",
              "a.out-i386-linux")
OUTPUT_ARCH(i386)
SEARCH_DIR("/usr/i486-pc-linux-gnuaout/lib");
PROVIDE (__stack = 0);
SECTIONS
{
  . = 0x1020;
  .text :
  {
    CREATE_OBJECT_SYMBOLS
    *(.text)
    /* The next six sections are for SunOS dynamic linking.  The order
       is important.  */
    *(.dynrel)
    *(.hash)
    *(.dynsym)
    *(.dynstr)
    *(.rules)
    *(.need)
    _etext = .;
    __etext = .;
  }
  . = ALIGN(0x1000);
  .data :
  {
    /* The first three sections are for SunOS dynamic linking.  */
    *(.dynamic)
    *(.got)
    *(.plt)
    *(.data)
    *(.linux-dynamic) /* For Linux dynamic linking.  */
    CONSTRUCTORS
    _edata  =  .;
    __edata  =  .;
  }
  .bss :
  {
    __bss_start = .;
   *(.bss)
   *(COMMON)
   . = ALIGN(4);
   _end = . ;
   __end = . ;
  }
}
$ as trivial.S -o trivial.o && ld -s trivial.o -o trivial -T /usr/lib/binutils/i486-pc-linux-gnu/2.16.1/ldscripts/i386linux.x

3) Run, on the new kernel, from a shell (e.g. bash 3.2 or dash 0.5.4)
$ ./trivial
Killed
$ echo $?
137
$ 

EXPECTED BEHAVIOR:
$ ./trivial
$ echo $?
0
$ 

WORKAROUND:
Have a non-empty .data section.
$ echo .data >> trivial.S
$ echo .byte 42 >> trivial.S
$ as trivial.S -o trivial.o && ld -s trivial.o -o trivial -T /usr/lib/binutils/i486-pc-linux-gnu/2.16.1/ldscripts/i386linux.x
$ stat -c %s trivial
8192
$ ./trivial
$ echo $?
0
$ 

PRESUMED CAUSE:
Kernel 2.6.12 fixed a mmap() SUSv3 compliance bug.
In kernel 2.6.11, mmap() successfully returned the mapping address when the mapping length is zero.
kernel 2.6.12 fails with error EINVAL.
The relevant change is in mm/mmap.c, function do_mmap_pgoff
if (!len)
	return addr;
In kernel 2.6.11, replaced with
if (!len)
	return -EINVAL;
In kernel 2.6.12 to 2.6.29

This affects do_mmap() behavior, called from fs/binfmt_aout.c
The relevant lines of code in kernel 2.6.29.4 are line [350, 358] in fs/binfmt_aout.c.

PATCH:
The following patch fixes this specific problem.
A similar patch may be added to support zero-length .text segments. That may make sense in a file with an empty .text segment, a non-empty .data segment and code in the .data segment.
Shared libraries might have issues too.

$ cd fs
$ diff -c binfmt_aout.c.old binfmt_aout.c
*** binfmt_aout.c.old   2009-06-02 17:57:30.000000000 +0200
--- binfmt_aout.c       2009-06-02 19:25:59.000000000 +0200
***************
*** 347,358 ****
                }
  
                down_write(&current->mm->mmap_sem);
!               error = do_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
!                               PROT_READ | PROT_WRITE | PROT_EXEC,
!                               MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
!                               fd_offset + ex.a_text);
                up_write(&current->mm->mmap_sem);
!               if (error != N_DATADDR(ex)) {
                        send_sig(SIGKILL, current, 0);
                        return error;
                }
--- 347,360 ----
                }
  
                down_write(&current->mm->mmap_sem);
!               if (ex.a_data) {
!                       error = do_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
!                                       PROT_READ | PROT_WRITE | PROT_EXEC,
!                                       MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
!                                       fd_offset + ex.a_text);
!               }
                up_write(&current->mm->mmap_sem);
!               if (ex.a_data && error != N_DATADDR(ex)) {
                        send_sig(SIGKILL, current, 0);
                        return error;
                }

OFF-TOPIC:
I've a few questions that a.out experts might answer unless it's inappropriate on LKML.
1) If you've any, could you give a link to a document specifying the QMAGIC executable format. Or is it an unspecified format?
The best I found is from a book "Linkers & Loaders", page 55
<http://books.google.com/books?id=Id9cYsIdjIwC&pg=PA55&dq=QMAGIC+a.out+executable>

2) May a segment, in the file, be declared to have a size that's not a multiple of 0x1000?
This is not accepted by current the Linux kernel, but, from this "Linkers & Loaders" book, it looks like it could be possible, making a double mapping for a page containing both some .text and some .data data (see fig 3-5, p55)?
Currently, the Linux kernel wants page-aligned segment sizes for QMAGIC executable files.

3) What's the difference between the CC 00 00 00 and CC 00 64 00 magic numbers?
GNU file says that the former is a "386 compact demand paged pure executable" while the latter is a "Linux/i386 demand-paged executable (QMAGIC)".
I just guess the Linux-specific is an extended format.

I'm new to LKML. I quickly read the FAQ, but, excuse me if I missed some guidelines.
I'm not an english native speaker. I'm sorry for bad syntax or grammar.

TIA
Have a nice day.
-- 
André Gillibert

