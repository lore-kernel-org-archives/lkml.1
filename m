Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZJSS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZJSS6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZJSS6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:58:19 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48165 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755123AbZJSS6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:58:18 -0400
Date: Mon, 19 Oct 2009 13:58:13 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Cliff Wickman <cpw@sgi.com>, rja@sgi.com
Subject: Re: [PATCH 2/2] x86: UV hardware performance counter and topology access
Message-ID: <20091019185813.GA6122@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20090930210531.GC12090@sgi.com> <20091001074630.GA6738@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001074630.GA6738@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 09:46:30AM +0200, Ingo Molnar wrote:
>
> * Russ Anderson <rja@sgi.com> wrote:
>
> > Adds device named "/dev/uv_hwperf" that supports an ioctl interface
> > to call down into BIOS to read/write memory mapped performance
> > monitoring registers.
>
> That's not acceptable - please integrate this with perf events properly.
> See arch/x86/kernel/cpu/perf_event.c for details.

These performance counters come from the UV hub and give a myriad of
information about the performance of the SSI system.  There is one Hub
per node in the system.  The information obtained from the hubs includes:

 - Cache hit/miss/snoop information (on the QPI as well as across the NumaLink
   fabric)
 - Messaging bandwidth between various areas of the hub
 - TLB and execution information about the GRU (hardware data copy assist)
 - Detailed QPI and NumaLink traffic measurements

Unfortunately, the hub doesn't have dedicated registers for any
performance information.  There are many general purpose registers on
each hub that are available for use to collect performance information.
Most metrics require about 8 MMRs to be written in order to set up the
metric.

> Precisely what kinds of events are being exposed by the UV BIOS
> interface? Also, how does the BIOS get them?

On ia64 linux calls down into bios (SN_SAL calls) to get this information.
(See include/asm-ia64/linux/asm/sn/sn_sal.h)  The UV bios calls are
similar functionality ported to x86_64.  The ia64 code has topology and
performance counter code intermixed (due to comon routines).  It may
be cleaner to break them into separate patches to keep clear the
separate issues.

SGI bios stores information about the systems topology to configure
the hardware before booting the kernel.  This includes information
about the entire NUMAlink system, not just the part of the machine
running an individual kernel.  This includes hardware that the kernel
has no knowledge of (such as shared NUMAlink metarouters).  For example,
a system split into two partitions has two unique kernels on each half
of the machine.  The topology interface provides information to users
about hardware the kernel does not know about.  (Sample output below.)

For the performance counter, a call into the bios results in multiple
MMRs being written to get the requested information.  Due to the
complicated signal routing, we have made fixed "profiles" that group
related metrics together.  It is more than just a one-to-one mapping
of MMRs to bios calls.

>                                                The BIOS should be left out
> of that - the PMU driver should know about and access hardware registers
> directly.

That would significantly increase the amount of kernel code needed to
access the chipset performance counters.  It would also require more
low level hardware information to be passed to the kernel (such as
information to access share routers) and additional kernel code to
calculate topology information (that bios has already calculated).
The intent of the SN_SAL calls on ia64 was to simplify the kernel
code.

> If any of this needs enhancements in kernel/perf_event.c we'll be glad
> to help out.

Thanks for the offer.  I'm coming from the ia64 side and still
learning the different expectations on x86_64.

>       Ingo

Here is an example of topology output on ia64.
-------------------------------------------------------------------
revenue7:~ # cat /proc/sgi_sn/sn_topology
# sn_topology version 2
# objtype ordinal location partition [attribute value [, ...]]
partition 7 revenue7 local shubtype shub1, nasid_mask 0x0001ffc000000000, nasid_bits 48:38, system_size 11, sharing_size 9, coherency_domain 0, region_size 2
pcibus 0001:00 007=01#0-1 local brick IXbrick, widget 12, bus 0
pcibus 0002:00 007=01#0-2 local brick IXbrick, widget 12, bus 1
pcibus 0003:00 007=01#0-3 local brick IXbrick, widget 15, bus 0
pcibus 0004:00 007=01#0-4 local brick IXbrick, widget 15, bus 1
pcibus 0005:00 007=01#0-5 local brick IXbrick, widget 13, bus 0
pcibus 0006:00 007=01#0-6 local brick IXbrick, widget 13, bus 1
node 15 007c34#1 local asic SHub_1.1, nasid 0xde, near_mem_nodeid 15, near_cpu_nodeid 15, dist 35:29:35:29:35:29:35:29:31:25:31:25:31:25:21:10
cpu 30 007c34#1a local freq 900MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:31:31:25:25:31:31:25:25:31:31:25:25:21:21:10:10
cpu 31 007c34#1c local freq 900MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:31:31:25:25:31:31:25:25:31:31:25:25:21:21:10:10
numalink 0 007c34#1-0 local endpoint 007c34#0-0, protocol LLP4
numalink 1 007c34#1-1 local endpoint 007r26#0-4, protocol LLP4
node 14 007c34#0 local asic SHub_1.1, nasid 0xdc, near_mem_nodeid 14, near_cpu_nodeid 14, dist 29:35:29:35:29:35:29:35:25:31:25:31:25:31:10:21
cpu 28 007c34#0a local freq 900MHz, arch ia64, dist 29:29:35:35:29:29:35:35:29:29:35:35:29:29:35:35:25:25:31:31:25:25:31:31:25:25:31:31:10:10:21:21
cpu 29 007c34#0c local freq 900MHz, arch ia64, dist 29:29:35:35:29:29:35:35:29:29:35:35:29:29:35:35:25:25:31:31:25:25:31:31:25:25:31:31:10:10:21:21
numalink 2 007c34#0-0 local endpoint 007c34#1-0, protocol LLP4
numalink 3 007c34#0-1 local endpoint 007r24#0-4, protocol LLP4
router 0 007r26#0 local asic NL4Router
numalink 4 007r26#0-0 local endpoint 007r16#0-0, protocol LLP4
numalink 5 007r26#0-1 local endpoint 007c21#1-1, protocol LLP4
numalink 6 007r26#0-2 local endpoint 007c28#1-1, protocol LLP4
numalink 7 007r26#0-3 local endpoint 007c31#1-1, protocol LLP4
numalink 8 007r26#0-4 local endpoint 007c34#1-1, protocol LLP4
numalink 9 007r26#0-5 local endpoint 007r16#0-5, protocol LLP4
numalink 10 007r26#0-6 shared endpoint 004r39#0-6, protocol LLP4
numalink 11 007r26#0-7 shared endpoint 005r39#0-6, protocol LLP4
router 1 007r24#0 local asic NL4Router
numalink 12 007r24#0-0 local endpoint 007r14#0-0, protocol LLP4
numalink 13 007r24#0-1 local endpoint 007c21#0-1, protocol LLP4
numalink 14 007r24#0-2 local endpoint 007c28#0-1, protocol LLP4
numalink 15 007r24#0-3 local endpoint 007c31#0-1, protocol LLP4
numalink 16 007r24#0-4 local endpoint 007c34#0-1, protocol LLP4
numalink 17 007r24#0-5 local endpoint 007r14#0-5, protocol LLP4
numalink 18 007r24#0-6 shared endpoint 004r03#0-6, protocol LLP4
numalink 19 007r24#0-7 shared endpoint 005r03#0-6, protocol LLP4
router 2 007r16#0 local asic NL4Router
numalink 20 007r16#0-0 local endpoint 007r26#0-0, protocol LLP4
numalink 21 007r16#0-1 local endpoint 007c05#1-1, protocol LLP4
numalink 22 007r16#0-2 local endpoint 007c08#1-1, protocol LLP4
numalink 23 007r16#0-3 local endpoint 007c11#1-1, protocol LLP4
numalink 24 007r16#0-4 local endpoint 007c18#1-1, protocol LLP4
numalink 25 007r16#0-5 local endpoint 007r26#0-5, protocol LLP4
numalink 26 007r16#0-6 shared endpoint 004r37#0-6, protocol LLP4
numalink 27 007r16#0-7 shared endpoint 005r37#0-6, protocol LLP4
node 9 007c21#1 local asic SHub_1.1, nasid 0xd2, near_mem_nodeid 9, near_cpu_nodeid 9, dist 35:29:35:29:35:29:35:29:21:10:31:25:31:25:31:25
cpu 18 007c21#1a local freq 1300MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:21:21:10:10:31:31:25:25:31:31:25:25:31:31:25:25
cpu 19 007c21#1c local freq 1300MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:21:21:10:10:31:31:25:25:31:31:25:25:31:31:25:25
numalink 28 007c21#1-0 local endpoint 007c21#0-0, protocol LLP4
numalink 29 007c21#1-1 local endpoint 007r26#0-1, protocol LLP4
node 11 007c28#1 local asic SHub_1.2, nasid 0xd6, near_mem_nodeid 11, near_cpu_nodeid 11, dist 35:29:35:29:35:29:35:29:31:25:21:10:31:25:31:25
cpu 22 007c28#1a local freq 1300MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:31:31:25:25:21:21:10:10:31:31:25:25:31:31:25:25
cpu 23 007c28#1c local freq 1300MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:31:31:25:25:21:21:10:10:31:31:25:25:31:31:25:25
numalink 30 007c28#1-0 local endpoint 007c28#0-0, protocol LLP4
numalink 31 007c28#1-1 local endpoint 007r26#0-2, protocol LLP4
node 13 007c31#1 local asic SHub_1.2, nasid 0xda, near_mem_nodeid 13, near_cpu_nodeid 13, dist 35:29:35:29:35:29:35:29:31:25:31:25:21:10:31:25
cpu 26 007c31#1a local freq 1300MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:31:31:25:25:31:31:25:25:21:21:10:10:31:31:25:25
cpu 27 007c31#1c local freq 1300MHz, arch ia64, dist 35:35:29:29:35:35:29:29:35:35:29:29:35:35:29:29:31:31:25:25:31:31:25:25:21:21:10:10:31:31:25:25
numalink 32 007c31#1-0 local endpoint 007c31#0-0, protocol LLP4
numalink 33 007c31#1-1 local endpoint 007r26#0-3, protocol LLP4
router 3 004r39#0 shared asic NL4Router
numalink 34 004r39#0-0 foreign endpoint 001r26#0-6, protocol LLP4
numalink 35 004r39#0-1 foreign endpoint 002r26#0-6, protocol LLP4
numalink 36 004r39#0-2 foreign endpoint 003r26#0-6, protocol LLP4
numalink 37 004r39#0-3 foreign endpoint 004r26#0-6, protocol LLP4
numalink 38 004r39#0-4 foreign endpoint 005r26#0-6, protocol LLP4
numalink 39 004r39#0-5 foreign endpoint 006r26#0-6, protocol LLP4
numalink 40 004r39#0-6 shared endpoint 007r26#0-6, protocol LLP4
numalink 41 004r39#0-7 foreign endpoint 008r26#0-6, protocol LLP4
router 4 005r39#0 shared asic NL4Router
numalink 42 005r39#0-0 foreign endpoint 001r26#0-7, protocol LLP4
numalink 43 005r39#0-1 foreign endpoint 002r26#0-7, protocol LLP4
numalink 44 005r39#0-2 foreign endpoint 003r26#0-7, protocol LLP4
numalink 45 005r39#0-3 foreign endpoint 004r26#0-7, protocol LLP4
numalink 46 005r39#0-4 foreign endpoint 005r26#0-7, protocol LLP4
numalink 47 005r39#0-5 foreign endpoint 006r26#0-7, protocol LLP4
numalink 48 005r39#0-6 shared endpoint 007r26#0-7, protocol LLP4
numalink 49 005r39#0-7 foreign endpoint 008r26#0-7, protocol LLP4
router 5 007r14#0 local asic NL4Router
[...]
-------------------------------------------------------------------

The actual output is longer to cover all of the hardware.



-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
