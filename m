Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYKGJp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYKGJp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYKGJpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:45:49 -0500
Received: from gatekeeper-t.bruker.de ([149.236.160.250]:56604 "HELO
	e500.bruker.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751351AbYKGJpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:45:47 -0500
X-Greylist: delayed 3707 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 04:45:47 EST
Date: Fri, 7 Nov 2008 09:43:56 +0100 (CET)
From: Michael Dressel <Michael.Dressel@bruker-biospin.de>
X-X-Sender: midr@eleven.esr.bruker.de
To: linux-kernel@vger.kernel.org
Subject: pthread_mutex_lock hangs on unlocked mutex
Message-ID: <alpine.LSU.2.00.0811070856260.5231@eleven.esr.bruker.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-OriginalArrivalTime: 07 Nov 2008 08:43:56.0113 (UTC) FILETIME=[F8512C10:01C940B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(I'm not subscribed to the list, please CC me.)

in our software three processes are using several pthread mutexes.
Sometimes a process hangs inside pthread_mutex_lock even though the mutex is
not locked. I can tell it's not locked because another process is still
running and locking and unlocking the mutex.
When I connect with gdb to the hanging process I find:

#0  0xffffe430 in __kernel_vsyscall ()
#1  0xf7d5e7a9 in __lll_lock_wait () from /lib/libpthread.so.0
#2  0xf7d59c75 in _L_lock_288 () from /lib/libpthread.so.0
#3  0xf7d596c5 in pthread_mutex_lock () from /lib/libpthread.so.0
#4  0xf7e444b6 in pthread_mutex_lock () from /lib/libc.so.6
#5  0x080fb338 in <myfunction> (mutexP=0x70f4165c)

And the mutexP looks like this:
$1 = {__data = {__lock = 0, __count = 0, __owner = 0, __kind = 1,
     __nusers = 0, {__spins = 0, __list = {__next = 0x0}}},
   __size = '\0' <repeats 12 times>, "\001\000\000\000\000\000\000\000\000\000\00
0", __align = 0}

I guess the process had to wait for the mutex but when the mutex was unlocked
the signal to the waiting process got lost.

Our software was build on a SUUSE 10.1
 	kernel 2.6.16.13-4-default
 	glibc-32bit-2.4-27
system as 32 bit binary. On This system the problem does not occur.

The system showing the problem is a dual processor SUSE 11.0
 	kernel 2.6.25.18-0.2-default
 	glibc-32bit-2.8-14.1
system. Also if the second core is disabled in the BIOS we have the
problem. Some more details of the system are listed below.

When the system hangs it does not recover from that situation. But if
I send a kill -STOP <pid>; kill -CONT <pid> sequence to the hanging
process it does continue.
The same effect is reached by connecting and disconnecting with gdb.

Is there any way, either in configuring the system or pthread, to prevent
this problem?

Cheers,
Michael

openSUSE 11.0 (X86-64)

Linux 2.6.25.18-0.2-default #1 SMP 2008-10-21 16:30:26 +0200 x86_64 x86_64 x86_64 GNU/Linux

glibc-32bit-2.8-14.1

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz
stepping        : 11
cpu MHz         : 1998.000
cache size      : 4096 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 4658.50
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


