Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYISM5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYISM5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYISM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:57:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:38863 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbYISM5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:57:38 -0400
Message-ID: <48D3A1B4.8000505@windriver.com>
Date: Fri, 19 Sep 2008 07:57:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Denis Joseph Barrow <D.Barow@option.com>
CC: KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, gareth@valinux.com,
       markus.t.metzger@intel.com
Subject: Re: getting false SIGTRAP breakpoints in kernel i.e. kernel hung
 unless gdb remotely attached on x86 & cont is issued
References: <48D10A70.8050202@option.com> <48D10C43.90605@windriver.com> <48D1122F.6080101@option.com> <48D26B64.5080605@windriver.com> <48D39B9F.8010404@option.com>
In-Reply-To: <48D39B9F.8010404@option.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2008 12:57:25.0487 (UTC) FILETIME=[4391B7F0:01C91A57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Joseph Barrow wrote:
> Hi Jason,
> Sorry for nitpicking & a big thanks for your patch.
> While this patch stops the big problem, the kernel halting, gdb
> debugging the userland code still doesn't behave correctly
> now. Trying to stepi over a sysenter call in gdb doesn't return
> to the gdb debugger ctrl-c in the debugger still works however.
> Some code probably needs to be also fixed in arch/x86/kernel/ptrace.c
> or ideally the generic kernel/ptrace.c, seeing as this works
> with gdb on a normal kernel it's not a gdb issue even if
> it can be kludge fixed there.
> I'm running GNU gdb 6.8-debian from ubuntu 8.04 hardy heron
>
>

The patch I sent is not yet included the kgdb stream because I was
waiting for further comment.  I do not see any issues however in the
case that you describe, so I will describe how I tested it and then
perhaps you can explain further the case that does not work.

Given that I still had your test program, I used it to set a
breakpoint at read(), after performing an attach as you described
previous with attaching to the running process.  At this point kgdboc
is loaded and configured.

gdb commands:

att PID_OF_randsleep
break read
continue

At this point to hit the breakpoint, I had to type some input on the
ttyS0 which randsleep where randsleep was connected.  At that point I
was able to step the system call with enough "si" commands.  In the
example shown below I did have to provide some more input after the
"si" for address 0xffffe419 so that the system call would come out of
the sleep state because it happened to be a blocking read.

Example:
(gdb) continue
Continuing.

Breakpoint 1, 0x08056b30 in read ()
(gdb) si
0x08056b38 in read ()
(gdb)
0x08056b3a in __read_nocancel ()
(gdb)
0x08056b3b in __read_nocancel ()
(gdb)
0x08056b3f in __read_nocancel ()
(gdb)
0x08056b43 in __read_nocancel ()
(gdb)
0x08056b47 in __read_nocancel ()
(gdb)
0x08056b4c in __read_nocancel ()
(gdb)
0xffffe414 in __kernel_vsyscall ()
(gdb) disas $pc $pc+8
Dump of assembler code from 0xffffe414 to 0xffffe41c:
0xffffe414 <__kernel_vsyscall+0>:       push   %ecx
0xffffe415 <__kernel_vsyscall+1>:       push   %edx
0xffffe416 <__kernel_vsyscall+2>:       push   %ebp
0xffffe417 <__kernel_vsyscall+3>:       mov    %esp,%ebp
0xffffe419 <__kernel_vsyscall+5>:       sysenter
0xffffe41b <__kernel_vsyscall+7>:       nop  
End of assembler dump.
(gdb) si
0xffffe415 in __kernel_vsyscall ()
(gdb)
0xffffe416 in __kernel_vsyscall ()
(gdb)
0xffffe417 in __kernel_vsyscall ()
(gdb)
0xffffe419 in __kernel_vsyscall ()
(gdb)
0xffffe424 in __kernel_vsyscall ()
(gdb)


At least this case appears to work fine with or without kgdb
loaded.  Perhaps you have a different case you can describe?

Thanks,
Jason.






