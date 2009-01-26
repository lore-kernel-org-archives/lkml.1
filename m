Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbZAZB3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbZAZB3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 20:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZAZB3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 20:29:04 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:38228 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZAZB3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 20:29:01 -0500
X-SourceIP: 62.24.72.246
From: Pavel Pisa <pisa@cmp.felk.cvut.cz>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: Unexpected cascaded epoll behavior - my mistake or kernel bug
Date: Mon, 26 Jan 2009 02:28:53 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200901230109.55706.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901241355120.9071@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0901241355120.9071@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WHRfJhB/1e1ng0u"
Message-Id: <200901260228.54098.pisa@cmp.felk.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WHRfJhB/1e1ng0u
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 24 January 2009 22:58:45 Davide Libenzi wrote:
> On Fri, 23 Jan 2009, Pavel Pisa wrote:
> > Hello Davide and all others,
> >
> > I have got to implementing yet another event library and I experience
> > something strange when level triggered epoll_wait() monitors another
> > level triggered epoll set. Top level epoll_wait() return information
> > about one event pending. The event points correctly to the monitored
> > second level epoll fd, but epoll_wait() on this fd with 0 or small
> > timeout returns zero/no events and top level epoll reporting is not reset
> > at this point so program enters busy loop. If there are events, they are
> > processed correctly. More interresting is, that the ill behavior is
> > prevented if I change number of debug writes into unrelated fd or if the
> > application is slowed down by strace to standard output. The strace to
> > the
> > file does not (fortunatelly) hide ill behavior to the strange behavior
> > of my code or kernel can be documented in attached straces. The both
> > traces documents the busy loop cause for case, where there is created
> > epoll set with fd #3, that set monitors fd #0. When character arrives
> > at fd #0, the new epoll fd set with fd #4 is created ad fd #3 is added
> > into this new top level fd set.
> >
> > epoll_create(8)                         = 3
> > epoll_ctl(3, EPOLL_CTL_ADD, 0, {EPOLLIN, {u32=6353264, u64=6353264}}) = 0
> > epoll_wait(3, {{EPOLLIN, {u32=6353264, u64=6353264}}}, 8, 20000) = 1
> > read(0, "E"..., 1)                      = 1
> > ...
> > epoll_create(8)                         = 4
> > epoll_ctl(4, EPOLL_CTL_ADD, 3, {EPOLLIN, {u32=6353664, u64=6353664}}) = 0
> > epoll_wait(4, {{EPOLLIN, {u32=6353664, u64=6353664}}}, 8, 19998) = 1
> > epoll_wait(3, {{EPOLLIN, {u32=6353264, u64=6353264}}}, 8, 0) = 1
> > read(0, "\n"..., 1)                     = 1
> > epoll_wait(4, {{EPOLLIN, {u32=6353664, u64=6353664}}}, 8, 19998) = 1
> > epoll_wait(3, {}, 8, 0)                 = 0
> > epoll_wait(4, {{EPOLLIN, {u32=6353664, u64=6353664}}}, 8, 19998) = 1
> > epoll_wait(3, {}, 8, 0)                 = 0
> >
> > You may ask, why that terrible clam starts to writting new event library
> > code and why he needs to cascade event handling mechanisms. I try to
> > defend myself a little. If you do not like beat me, you can skip next
> > section
>
> Pavel, can you give the patch below a spin? It's working fine in my two
> boxes, but it'd be great if you could confirm it too.
> Attached there's also a simple test program to check epoll behavior,
> especially the one related to recursion.
>

Hello Davide,

thanks for fast reply and effort.

I have tested your patch with patched and unpatched 2.6.28.2 kernel.
The outputs are attached. The patched kernel passes all your tests.

But I have bad news. My library code does not fall into busy loop
after your patching but my FIFO tests do not work even in
single level epoll scenario. The strace output is attached as well.
I try to do more testing tomorrow. I have returned from weekend trip
at the evening today and I have not much time for deeper analysis.

But it looks like write level sensitive events are not triggering
for epoll at all. The pipe is not fill by any character and specified
timeout is triggered with next message as fail results.
  @ pipe #X evptrig wr timeout
  @ pipe #X evptrig rd timeout
 
If you want to test the code on your box, download library

http://cmp.felk.cvut.cz/~pisa/ulan/ul_evpoll-090123.tar.gz

The simple "make" in the top directory should work.

Then you can test correct behavior with sysvpoll default events
monitoring. Run program "_compiled/bin-utils/ul_evpchk".
If you pres "p" once or multiple times and then Enter, you
should see, that FD 0 receives your characters

<5>@ fd #0 evptrig 1 count 1
'p'

Then there should be 10x burs series of 50 pipe writes and reads.
Each series is separated by short timed delay.

The print of last few reads and writes looks like this

<5>@ pipe #3 rd evptrig 1 count wr 499 rd 498
<5>@ pipe #4 wr evptrig 2 count wr 500 rd 499
<5>***** ul_evpoll_dispatch returned 1 *****
<5>***** ul_evpoll_dispatch called *****
<5>@ pipe #3 rd evptrig 1 count wr 500 rd 499
<5>@ pipe #3 rd final count reached
<4>@ pipe rd #3 wr #4 destroyed
<3>@ pipe active count reached 0 in 20131

The important is the last line, which confirms, that all FIFOs
has reached final count and that there is 0 active pipes now.
The last number informs about time in ms spent before
all pipes has finished. There are some distracting prints
about timers 1,2,3 to test timers support in parallel.
If you like to get rid of these, you can comment out 
or disable timer lines in

ulevloop/ul_evpchk.c

-  if(1) {
+  if(0) {
     add_my_timer(2000, 0);
     add_my_timer(3000, 20);
     add_my_timer(1400, 10);
   }

You can check the code with epoll event monitoring mechanism
then

_compiled/bin-utils/ul_evpchk lnxepoll

It works same way (correctly) without patch.
You can try to glib support as well - surprisingly by parameter "glib".

You can start with "lnxepoll" again and then pres "C"+Enter
to cascade epoll in glib main loop. Again worked correctly in past.
If you cascade by "E"+Enter, then cascading of epoll into epoll
is requested and it failed in default setup. If the output
has been redirected, then it worked correctly in some situations.

The other tests can be invoked by another letters
  "t" .. run 1000 active FDs in parallel
  "T" .. run 10000 active FDs in parallel
  "l"  .. create 1000 inactive FDs as load to epoll
   "L" .. created 8000 inactive FDs

The all these has been working with all mechanisms before patching,
even with cascading except epoll at epoll cascade.
These huge tests switch low debug level so only errors
and final reports are seen after test letter.
The glib based tests for 10000 FDs is horribly long, so I have
not found patience to run it at full.

There are some tests results for different tests and mechanisms.
Each test is invoked by initial command line. The first number is number
of active FDs (500 events scheduled for each), the second number
of inactive FDs, the third is mechanism (cascade means epoll cascaded
on glib), the last number is time in ms. 
All test has been run on Core 2 Duo T7300  @ 2.00GHz

t

1000 0 sysvpoll 1369
1000 0 epoll    1570
1000 0 glib     3046
1000 0 cascaded 1783

tttttttttt

10000 0 sysvpoll  17774
10000 0 epoll     20750
10000 0 glib     445341
10000 0 cascaded  23098

tltltltltltltltltltl

10000 10000 sysvpoll 18924
10000 10000 epoll    20748
10000 10000 glib        ?
10000 10000 cascaded 23370

llltllltll

2000 8000 sysvpoll  4014
2000 8000 epoll     3205
2000 8000 glib     87357
2000 8000 cascaded  3718


Thanks again for testing and if you have some time and interrest,
you can try my kernel torture on your boxes,

                       Pavel



--Boundary-00=_WHRfJhB/1e1ng0u
Content-Type: text/plain;
  charset="iso 8859-15";
  name="epoll_test-2.6.28-orig.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="epoll_test-2.6.28-orig.out"


********** Testing TTY events
Checking events for fd 0
	POLLOUT
Created epoll fd (3)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain

********** Testing TTY events
********** OK

********** Testing short wakeup chain
Checking events for fd 3
	POLLIN

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
Checking events for fd 3
	POLLIN

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
Checking events for fd 3
	POLLIN

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
********** FAIL (1)

********** Testing loopy poll chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
********** FAIL (1)

********** Testing loopy poll chain (HOLD ON)
Checking events for fd 3
	POLLIN

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
********** FAIL (1)

********** Testing loopy poll chain (HOLD ON)
********** FAIL (1)

--Boundary-00=_WHRfJhB/1e1ng0u
Content-Type: text/plain;
  charset="iso 8859-15";
  name="epoll_test-2.6.28-patched.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="epoll_test-2.6.28-patched.out"


********** Testing TTY events
Checking events for fd 0
	POLLOUT
Created epoll fd (3)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain

********** Testing TTY events
********** OK

********** Testing short wakeup chain
Checking events for fd 3
	POLLIN

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
Checking events for fd 3
	POLLIN

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
********** OK

********** Testing loopy poll chain (HOLD ON)

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
********** OK

********** Testing loopy poll chain (HOLD ON)
Checking events for fd 3

********** Testing TTY events
********** OK

********** Testing short wakeup chain
********** OK

********** Testing long wakeup chain (HOLD ON)
********** OK

********** Testing short poll chain
********** OK

********** Testing long poll chain (HOLD ON)
********** OK

********** Testing loopy wakeup chain (HOLD ON)
********** OK

********** Testing loopy poll chain (HOLD ON)
********** OK

--Boundary-00=_WHRfJhB/1e1ng0u
Content-Type: text/plain;
  charset="iso 8859-15";
  name="ul_evpchk-lnxepoll-2.6.28.2-patched.strace"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ul_evpchk-lnxepoll-2.6.28.2-patched.strace"

execve("/home/pi/repo/ulan/ulan-build/host/_compiled/bin-utils/ul_evpchk", ["/home/pi/repo/ulan/ulan-build/ho"..., "lnxepoll"], [/* 35 vars */]) = 0
brk(0)                                  = 0x60f000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fece603b000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fece6039000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=149762, ...}) = 0
mmap(NULL, 149762, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fece6014000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib/libglib-2.0.so.0", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0PM\1\0\0\0\0\0@"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=794168, ...}) = 0
mmap(NULL, 2891336, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fece5b5f000
mprotect(0x7fece5c20000, 2093056, PROT_NONE) = 0
mmap(0x7fece5e1f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xc0000) = 0x7fece5e1f000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\300\342\1\0\0\0\0\0@"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1375536, ...}) = 0
mmap(NULL, 3482232, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fece580c000
mprotect(0x7fece5956000, 2093056, PROT_NONE) = 0
mmap(0x7fece5b55000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x149000) = 0x7fece5b55000
mmap(0x7fece5b5a000, 17016, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fece5b5a000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib/libpcre.so.3", O_RDONLY) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\0\25\0\0\0\0\0\0@"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=162816, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fece6013000
mmap(NULL, 2258096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fece55e4000
mprotect(0x7fece560c000, 2093056, PROT_NONE) = 0
mmap(0x7fece580b000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x27000) = 0x7fece580b000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fece6012000
arch_prctl(ARCH_SET_FS, 0x7fece60126e0) = 0
mprotect(0x7fece5b55000, 12288, PROT_READ) = 0
munmap(0x7fece6014000, 149762)          = 0
write(2, "<3>"..., 3)                   = 3
write(2, "starting ul_evpchk application\n"..., 31) = 31
brk(0)                                  = 0x60f000
brk(0x630000)                           = 0x630000
epoll_create(8)                         = 3
epoll_ctl(3, EPOLL_CTL_ADD, 0, {EPOLLIN, {u32=6353840, u64=6353840}}) = 0
write(2, "<5>"..., 3)                   = 3
write(2, "ul_evplnxepoll_fdnode_sync: epoll"..., 63) = 63
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {{EPOLLIN, {u32=6353840, u64=6353840}}}, 8, 1359) = 1
write(2, "<5>"..., 3)                   = 3
write(2, "@ fd #0 evptrig 1 count 1\n"..., 26) = 26
read(0, "p"..., 1)                      = 1
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 2), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fece6038000
write(1, "'p'\n"..., 4)                 = 4
pipe([4, 5])                            = 0
epoll_ctl(3, EPOLL_CTL_ADD, 4, {EPOLLIN, {u32=6354448, u64=6354448}}) = 0
write(2, "<5>"..., 3)                   = 3
write(2, "ul_evplnxepoll_fdnode_sync: epoll"..., 63) = 63
epoll_ctl(3, EPOLL_CTL_ADD, 5, {EPOLLOUT, {u32=6354544, u64=6354544}}) = 0
write(2, "<5>"..., 3)                   = 3
write(2, "ul_evplnxepoll_fdnode_sync: epoll"..., 63) = 63
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {{EPOLLIN, {u32=6353840, u64=6353840}}}, 8, 905) = 1
write(2, "<5>"..., 3)                   = 3
write(2, "@ fd #0 evptrig 1 count 2\n"..., 26) = 26
read(0, "\n"..., 1)                     = 1
write(1, "'\n"..., 2)                   = 2
write(1, "'\n"..., 2)                   = 2
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 904)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 3)                 = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #3 evptrig 8 count 1\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 598)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #1 evptrig 8 count 1\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 799)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #3 evptrig 8 count 2\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 199)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #2 evptrig 8 count 1\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 999)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #1 evptrig 8 count 2\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 199)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #3 evptrig 8 count 3\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 293)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ pipe #4 evptrig rd timeout\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "@ pipe #5 evptrig wr timeout\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 1103)              = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #3 evptrig 8 count 4\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 399)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #2 evptrig 8 count 2\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #1 evptrig 8 count 3\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {}, 8, 999)               = 0
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #3 evptrig 8 count 5\n"..., 29) = 29
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
epoll_wait(3, {{EPOLLIN, {u32=6353840, u64=6353840}}}, 8, 999) = 1
write(2, "<5>"..., 3)                   = 3
write(2, "@ fd #0 evptrig 1 count 3\n"..., 26) = 26
read(0, "q"..., 1)                      = 1
write(1, "'q'\n"..., 4)                 = 4
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch called *"..., 38) = 38
write(2, "<5>"..., 3)                   = 3
write(2, "***** ul_evpoll_dispatch returned"..., 43) = 43
write(2, "<5>"..., 3)                   = 3
write(2, "***** breaking loop destroying po"..., 42) = 42
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #1 evptrig 32 count 4\n"..., 30) = 30
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #2 evptrig 32 count 3\n"..., 30) = 30
write(2, "<5>"..., 3)                   = 3
write(2, "@ timer #3 evptrig 32 count 6\n"..., 30) = 30
write(2, "<5>"..., 3)                   = 3
write(2, "UL_EVP_DONE not handled for 4 whe"..., 59) = 59
epoll_ctl(3, EPOLL_CTL_DEL, 4, {0, {u32=6354448, u64=6354448}}) = 0
write(2, "<5>"..., 3)                   = 3
write(2, "ul_evplnxepoll_fdnode_sync: epoll"..., 63) = 63
write(2, "<5>"..., 3)                   = 3
write(2, "UL_EVP_DONE not handled for 5 whe"..., 59) = 59
epoll_ctl(3, EPOLL_CTL_DEL, 5, {0, {u32=6354544, u64=6354544}}) = 0
write(2, "<5>"..., 3)                   = 3
write(2, "ul_evplnxepoll_fdnode_sync: epoll"..., 63) = 63
write(2, "<5>"..., 3)                   = 3
write(2, "UL_EVP_DONE not handled for -1 wh"..., 60) = 60
write(2, "<5>"..., 3)                   = 3
write(2, "@ fd #0 evptrig 32 count 4\n"..., 27) = 27
write(2, "<5>"..., 3)                   = 3
write(2, "UL_EVP_DONE not handled for 0 whe"..., 59) = 59
epoll_ctl(3, EPOLL_CTL_DEL, 0, {0, {u32=6353840, u64=6353840}}) = 0
write(2, "<5>"..., 3)                   = 3
write(2, "ul_evplnxepoll_fdnode_sync: epoll"..., 63) = 63
close(3)                                = 0
write(2, "<5>"..., 3)                   = 3
write(2, "***** breaking loop destroying po"..., 42) = 42
exit_group(0)                           = ?

--Boundary-00=_WHRfJhB/1e1ng0u--
