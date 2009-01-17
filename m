Return-Path: <linux-kernel-owner+w=401wt.eu-S934095AbZAQCyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095AbZAQCyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbZAQCxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:53:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbZAQCxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:53:51 -0500
Date: Fri, 16 Jan 2009 21:53:48 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eric Paris <eparis@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: at kernel/trace/ftrace.c:434 ftrace_bug+0xdb/0x2b1()
 in 2.6.29-rc1-next-20090116
In-Reply-To: <1232158716.6614.20.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901162138410.9232@gandalf.stny.rr.com>
References: <1232144843.6614.14.camel@localhost.localdomain>  <alpine.DEB.1.10.0901161939320.9232@gandalf.stny.rr.com> <1232158716.6614.20.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Jan 2009, Eric Paris wrote:

> On Fri, 2009-01-16 at 19:47 -0500, Steven Rostedt wrote:
> > # mount -t debugfs none /sys/kernel/debug
> > # cat /sys/kernel/debug/tracing/dyn_ftrace_total_info
> 
> [root@unused ~]# cat /sys/kernel/debug/tracing/dyn_ftrace_total_info 
> 0 0 0
> 
> > And perhaps, if possible, could I get a copy of the vmlinux that was 
> > built, and a CONFIG to go with it.
> 
> check out http://people.redhat.com/~eparis/ftrace
> 
> You should find my config, the vmlinux, and my serial capture on that
> page.  I'll build again right now without all of my filesystem
> notification patches to make sure they aren't somehow screwing things up
> (but I pretty seriously doubt it.)

Thanks,

Something messed up in the creating of the mcount section. The secton
that is used to find all the places to modify.

Here's the output of your dump:

[    0.125980] ------------[ cut here ]------------
[    0.125980] WARNING: at kernel/trace/ftrace.c:434 
ftrace_bug+0xdb/0x2b1()
[    0.125980] Hardware name: VMware Virtual Platform
[    0.125980] Modules linked in:
[    0.125980] Pid: 0, comm: swapper Not tainted 2.6.29-rc1-next-20090116 
#256
[    0.125980] Call Trace:
[    0.125980]  [<ffffffff810515bc>] warn_slowpath+0xd8/0xf7

[...]

[    0.125980] ---[ end trace a7919e7f17c0a725 ]---
[    0.125980] ftrace failed to modify [<ffffffff812234de>] 
acpi_thermal_notify+0x7/0xc1
[    0.125980]  actual: 0f:1f:44:00:00

$ nm vmlinux |grep mcount_loc
ffffffff815bbb40 R __start_mcount_loc
ffffffff815e4df0 R __stop_mcount_loc

$ objdump -h vmlinux | grep __init_rodata
 11 __init_rodata 000292b0  ffffffff815bbb40  00000000015bbb40  007bbb40  2**3


The __mcount_loc section, which is where the data is stored, is the first 
section in the __init_rodata section. By doing:

$ readelf -x __init_rodata vmlinux |less

I get to see what is in that section:

Hex dump of section '__init_rodata':
  0x815bbb40 11a00081 ffffffff 98a10081 ffffffff ................
  0x815bbb50 4ba20081 ffffffff 60a20081 ffffffff K.......`.......
  0x815bbb60 85a20081 ffffffff 98a30081 ffffffff ................
[...]
  0x815d4710 df342281 ffffffff 51152281 ffffffff .4".....Q.".....
[...]
  0x815d4830 b6332281 ffffffff df342281 ffffffff .3"......4".....

Notice the df342281 ffffffff in the 0x815d4710 line.
Also notice that you have that in the 0x815d4830 line as well. This proves 
that we have two copies of the same function in the data section.


[    0.125980] ftrace failed to modify [<ffffffff812234de>]
acpi_thermal_notify+0x7/0xc1
[    0.125980]  actual: 0f:1f:44:00:00


acpi_thermal_notify+0x7 is at ffffffff812234de, and unfortunately the dump 
is in the wrong endian, but we do see that ffffffff812234df is listed 
twice. The recorded pointer is to the mcount relocation address, and the 
printed one ffffffff812234de is to the call site, which is one less than 
the relocation pointer.


Now the question is, how did that get listed twice?

Could you do a:

$ objdump -Dr -j __mcount_loc drivers/acpi/thermal.o 

and perhaps we can find a duplicate there?

Thanks,

-- Steve

