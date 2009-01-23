Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbZAWA2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbZAWA2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZAWA1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:27:54 -0500
Received: from viefep25-int.chello.at ([62.179.121.45]:60694 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZAWA1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:27:52 -0500
X-Greylist: delayed 1069 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2009 19:27:51 EST
X-SourceIP: 62.24.72.246
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: Unexpected cascaded epoll behavior - my mistake or kernel bug
Date: Fri, 23 Jan 2009 01:09:43 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1507430.ysuoxXTJqB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901230109.55706.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1507430.ysuoxXTJqB
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Davide and all others,

I have got to implementing yet another event library and I experience
something strange when level triggered epoll_wait() monitors another
level triggered epoll set. Top level epoll_wait() return information
about one event pending. The event points correctly to the monitored
second level epoll fd, but epoll_wait() on this fd with 0 or small timeout
returns zero/no events and top level epoll reporting is not reset at this
point so program enters busy loop. If there are events, they are processed
correctly. More interresting is, that the ill behavior is prevented if I
change number of debug writes into unrelated fd or if the application
is slowed down by strace to standard output. The strace to the
file does not (fortunatelly) hide ill behavior to the strange behavior
of my code or kernel can be documented in attached straces. The both
traces documents the busy loop cause for case, where there is created
epoll set with fd #3, that set monitors fd #0. When character arrives
at fd #0, the new epoll fd set with fd #4 is created ad fd #3 is added
into this new top level fd set.

epoll_create(8)                         =3D 3
epoll_ctl(3, EPOLL_CTL_ADD, 0, {EPOLLIN, {u32=3D6353264, u64=3D6353264}}) =
=3D 0
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 20000) =3D 1
read(0, "E"..., 1)                      =3D 1
=2E..
epoll_create(8)                         =3D 4
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19998) =3D 1
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 0) =3D 1
read(0, "\n"..., 1)                     =3D 1
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19998) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19998) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0

You may ask, why that terrible clam starts to writting new event library co=
de
and why he needs to cascade event handling mechanisms. I try to defend myse=
lf
a little. If you do not like beat me, you can skip next section

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I am part of CTU university group working on realtime and industrial control
projects (RT-Ethernet, CAN, CANopen, profibus etc). I work even for PiKRON
company on other similar projects. We have need for base libraries for fast
and small libraries for Linux, RTEMS and system less based applications.
Some runs with as less as LPC21xx and 32kB of RAM memory. We need some
generic containers code, XML or bytecode driven graphic and support for test
builds of system less APPs or RTEMS based apps on Linux and preparation
of higher control hierarchy applications on Linux.

The GLIB would be good base, but for embedded systems the LGPL license
could be problem, the 32kB RAM and 256 kB FLASH for whole application
in some cases are other reasons why GLIB is not usable for many cases.
Even GLIB implementation is nice from portability point, but effectiveness
of GLIB main loop, complexity of containers with needs of plenty of mallocs
is year another story. So the containers and generic constructs are solved
by uLUt library http://rtime.felk.cvut.cz/gitweb/ulut.git ,
http://cmp.felk.cvut.cz/~pisa/ulan/ulut.pdf.

Event processing on Linux or POSIX based OSes, I thought that libevent
is right way to go. It is yet another prerequisite for projects (acceptable=
),
but problem is, that in some cases, the libraries should allow the combinat=
ion
with frameworks based on other mainloop implementation (Qt, GTK, Python).
Problem is, that combining libraries expecting different main loop
implementation is a problem. That is why the ul_evpoll library has been
born. The initial idea has been to define absolute minimal compatability
layer and API, which allows to run applications above libevent and in case
of the need above GLIB. To test that concept and allow use of the library
even standalone, the simple implementation above Sys V poll() call
has been included. To test Linux most advanced feature, simple epoll
support has been added. The yet another target has been met, when
applications could run over ul_evpoll API under GLIB main loop now.
This solves even Qt compatibility, because most distributions ships
Qt compiled against GLIB main loop.
The other important feature is to be able to switch or cascade event
monitoring at runtime when some third party library enforcing
different main loop implementation is dynamically loaded.
This goal has been achieved as well now. Next complex scenarios
works now

 * start on ul_evpoll sysvpoll, when GLIB based library is required
    create new ul_evpoll based on glib, cascade original set with
    epoll above it and continue to run with GLIB main loop

 * start with ul_evpoll lnxepoll, create ul_evpoll based on glib
    continue to run

The events can be inserted by GLIB based applications as glib event sources,
by uLUt based applications as ul_evpoll  events into ul_evpoll wrapper or
over original sysvpoll or lnxepoll event bases and all runs concurrently
without problems in my first test round. The lnxepoll cascaded over glib ba=
se
has other nice feature, that it corrects GLIB ill behavior for C10K problem=
 for these
events, which are registered over ul_evpoll API as ul_evptrig_t into epoll =
based
ul_evpbase_t.

But because of generic approach of the code, I have tried to cascade
one ul_evpoll lnxepoll above another one for my curiosity and it does not
work as expected. It may be my bug, but strace result is strange
for me.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The ul_evpoll library code is developed in uLan CVS at this moment

http://ulan.cvs.sourceforge.net/viewvc/ulan/ulan/host/libs4c/ulevloop/

Preconfigured code snapshot is there

http://cmp.felk.cvut.cz/~pisa/ulan/ul_evpoll-090123.tar.gz

The bug triggers on my system, when Linux epoll based event loop is started

_compiled/bin-utils/ul_evpchk lnxepoll

and then key 'E' and Enter is pressed. This creates new epoll base
and cascades original event base into it.

Some parts from uLUt, OMK and ul_evpoll  are parts of other projects already

http://ulan.sourceforge.net/
http://www.ocera.org/download/components/WP7/index.html
http://frescor.org/
http://rtime.felk.cvut.cz/gitweb/frescor/forb.git

Best wishes and thanks for possible ideas and comments,

                Pavel Pisa
        e-mail: pisa@cmp.felk.cvut.cz
        www:    http://cmp.felk.cvut.cz/~pisa


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The test system is

Linux baree 2.6.27 #1 SMP PREEMPT Mon Oct 13 02:16:44 CEST 2008 x86_64 GNU/=
Linux

Core 2 Duo based MSI Laptop

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca =
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx l=
m constant_tsc=20
arch_perfmon pebs bts rep_good nopl pni monitor ds_cpl vmx est tm2 ssse3 cx=
16 xtpr lahf_lm ida
bogomips        : 3989.91
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

strace output without additional epoll fd retriggering

execve("/home/pi/repo/ulan/ulan-build/host/_compiled/bin-utils/ul_evpchk", =
["/home/pi/repo/ulan/ulan-build/ho"..., "lnxepoll"], [/* 38 vars */]) =3D 0
brk(0)                                  =3D 0x60f000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f4f03a5f000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f4f03a5d000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D149762, ...}) =3D 0
mmap(NULL, 149762, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7f4f03a38000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/usr/lib/libglib-2.0.so.0", O_RDONLY) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0PM\1\0\0\0\0\0@"...,=
 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D794168, ...}) =3D 0
mmap(NULL, 2891336, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x7f4f03583000
mprotect(0x7f4f03644000, 2093056, PROT_NONE) =3D 0
mmap(0x7f4f03843000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_=
DENYWRITE, 3, 0xc0000) =3D 0x7f4f03843000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300\342\1\0\0\0\0\0=
@"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1375536, ...}) =3D 0
mmap(NULL, 3482232, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x7f4f03230000
mprotect(0x7f4f0337a000, 2093056, PROT_NONE) =3D 0
mmap(0x7f4f03579000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x149000) =3D 0x7f4f03579000
mmap(0x7f4f0357e000, 17016, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_ANONYMOUS, -1, 0) =3D 0x7f4f0357e000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/usr/lib/libpcre.so.3", O_RDONLY) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\25\0\0\0\0\0\0@".=
=2E., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D162816, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f4f03a37000
mmap(NULL, 2258096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x7f4f03008000
mprotect(0x7f4f03030000, 2093056, PROT_NONE) =3D 0
mmap(0x7f4f0322f000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_=
DENYWRITE, 3, 0x27000) =3D 0x7f4f0322f000
close(3)                                =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f4f03a36000
arch_prctl(ARCH_SET_FS, 0x7f4f03a366e0) =3D 0
mprotect(0x7f4f03579000, 12288, PROT_READ) =3D 0
munmap(0x7f4f03a38000, 149762)          =3D 0
brk(0)                                  =3D 0x60f000
brk(0x630000)                           =3D 0x630000
epoll_create(8)                         =3D 3
epoll_ctl(3, EPOLL_CTL_ADD, 0, {EPOLLIN, {u32=3D6353264, u64=3D6353264}}) =
=3D 0
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 20000) =3D 1
read(0, "E"..., 1)                      =3D 1
fstat(1, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 3), ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f4f03a5c000
epoll_create(8)                         =3D 4
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19998) =3D 1
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 0) =3D 1
read(0, "\n"..., 1)                     =3D 1
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19998) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19998) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19997) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19996) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19995) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19995) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19994) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19993) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19992) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19992) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19991) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
=2E...........
=2E...........
BUSY LOOP THERE, epoll_wait on #4 instantly reports event
pointing on #3, but no event read on #3
=2E...........
=2E...........
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 17180) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 17180) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 17180) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 17179) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 17179) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 17178) =3D 1
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 0) =3D 1
read(0, "q"..., 1)                      =3D 1
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(3, EPOLL_CTL_DEL, 0, {0, {u32=3D6353264, u64=3D6353264}}) =3D 0
close(3)                                =3D 0
exit_group(0)                           =3D ?


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

strace output with additional epoll fd retriggering after each event

execve("/home/pi/repo/ulan/ulan-build/host/_compiled/bin-utils/ul_evpchk", =
["/home/pi/repo/ulan/ulan-build/ho"..., "lnxepoll"], [/* 38 vars */]) =3D 0
brk(0)                                  =3D 0x60f000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f12db6fa000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f12db6f8000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D149762, ...}) =3D 0
mmap(NULL, 149762, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7f12db6d3000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/usr/lib/libglib-2.0.so.0", O_RDONLY) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0PM\1\0\0\0\0\0@"...,=
 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D794168, ...}) =3D 0
mmap(NULL, 2891336, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x7f12db21e000
mprotect(0x7f12db2df000, 2093056, PROT_NONE) =3D 0
mmap(0x7f12db4de000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_=
DENYWRITE, 3, 0xc0000) =3D 0x7f12db4de000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300\342\1\0\0\0\0\0=
@"..., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1375536, ...}) =3D 0
mmap(NULL, 3482232, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x7f12daecb000
mprotect(0x7f12db015000, 2093056, PROT_NONE) =3D 0
mmap(0x7f12db214000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_DENYWRITE, 3, 0x149000) =3D 0x7f12db214000
mmap(0x7f12db219000, 17016, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP=
_ANONYMOUS, -1, 0) =3D 0x7f12db219000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/usr/lib/libpcre.so.3", O_RDONLY) =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\25\0\0\0\0\0\0@".=
=2E., 832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D162816, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f12db6d2000
mmap(NULL, 2258096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x7f12daca3000
mprotect(0x7f12daccb000, 2093056, PROT_NONE) =3D 0
mmap(0x7f12daeca000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_=
DENYWRITE, 3, 0x27000) =3D 0x7f12daeca000
close(3)                                =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f12db6d1000
arch_prctl(ARCH_SET_FS, 0x7f12db6d16e0) =3D 0
mprotect(0x7f12db214000, 12288, PROT_READ) =3D 0
munmap(0x7f12db6d3000, 149762)          =3D 0
brk(0)                                  =3D 0x60f000
brk(0x630000)                           =3D 0x630000
epoll_create(8)                         =3D 3
epoll_ctl(3, EPOLL_CTL_ADD, 0, {EPOLLIN, {u32=3D6353264, u64=3D6353264}}) =
=3D 0
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 20000) =3D 1
read(0, "E"..., 1)                      =3D 1
fstat(1, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 3), ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x7f12db6f7000
epoll_create(8)                         =3D 4
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19997) =3D 1
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 0) =3D 1
read(0, "\n"..., 1)                     =3D 1
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19998) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19997) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19995) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19994) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19993) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19991) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19990) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 19988) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
=2E...........
=2E...........
BUSY LOOP THERE, epoll_wait on #4 instantly reports event
pointing on #3, but no event read on #3
=2E...........
=2E...........
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 18254) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 18253) =3D 1
epoll_wait(3, {}, 8, 0)                 =3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_wait(4, {{EPOLLIN, {u32=3D6353664, u64=3D6353664}}}, 8, 18251) =3D 1
epoll_wait(3, {{EPOLLIN, {u32=3D6353264, u64=3D6353264}}}, 8, 0) =3D 1
read(0, "q"..., 1)                      =3D 1
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=3D6353664, u64=3D6353664}}) =
=3D 0
epoll_ctl(4, EPOLL_CTL_DEL, 3, {0, {u32=3D6353664, u64=3D6353664}}) =3D 0
epoll_ctl(3, EPOLL_CTL_DEL, 0, {0, {u32=3D6353264, u64=3D6353264}}) =3D 0
close(3)                                =3D 0
exit_group(0)                           =3D ?

--nextPart1507430.ysuoxXTJqB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl5CscACgkQQeDLWiU2Rb6TtQCfRB5q2vFxFrcccY3F/Xw43rJT
lBMAoINia19jU0/BwxNd8cUzWi2BeYu3
=0z3Z
-----END PGP SIGNATURE-----

--nextPart1507430.ysuoxXTJqB--
