Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYISMbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYISMbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYISMba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:31:30 -0400
Received: from mailer1.option.com ([81.246.70.162]:53937 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYISMb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:31:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEBAJ8400gKAAAZ/2dsb2JhbAAIsicIhm5eAwh8
Message-ID: <48D39B9F.8010404@option.com>
Date: Fri, 19 Sep 2008 14:31:27 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, gareth@valinux.com,
       markus.t.metzger@intel.com
Subject: Re: getting false SIGTRAP breakpoints in kernel i.e. kernel hung
 unless gdb remotely attached on x86 & cont is issued
References: <48D10A70.8050202@option.com> <48D10C43.90605@windriver.com> <48D1122F.6080101@option.com> <48D26B64.5080605@windriver.com>
In-Reply-To: <48D26B64.5080605@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2008 12:31:27.0080 (UTC) FILETIME=[A2AFAE80:01C91A53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
Sorry for nitpicking & a big thanks for your patch.
While this patch stops the big problem, the kernel halting, gdb
debugging the userland code still doesn't behave correctly
now. Trying to stepi over a sysenter call in gdb doesn't return
to the gdb debugger ctrl-c in the debugger still works however. 
Some code probably needs to be also fixed in arch/x86/kernel/ptrace.c
or ideally the generic kernel/ptrace.c, seeing as this works
with gdb on a normal kernel it's not a gdb issue even if
it can be kludge fixed there.
I'm running GNU gdb 6.8-debian from ubuntu 8.04 hardy heron




Jason Wessel wrote:
> Denis Joseph Barrow wrote:
>> Hi Jason,
>> The problem I believe is very reproducable.
> 
> It can be reproduced quite easily as it is a generic problem that
> appears to have existed for quite a long time.
> 
>> I'm doing nothing special with kgdb just using it to help me with 3g
>> modem driver development & my driver wasn't loaded when the problem
>> occured.  I have the following command in my /boot/grub/menu.lst
>> kernel parameter to enable gdb.
>>
>> kgdboc=/dev/ttyS0,115200 maxcpus=1
> 
> 
> This was the key detail that was missing.  Along with the program and
> other gdb details provided the source of the problem was not too hard
> to track down.
> 
> When you attach to the running program with ptrace (via gdb), it
> interrupts the system call and executing the high level "step" will
> result in gdb executing a number of instruction step operations to try
> to get back to an instruction which corresponds to the next valid line
> of high level source code.
> 
> It was the 3rd or 4th instruction step that jumped back into the
> kernel space because gdb ultimately tries to single step a system call
> in your example.  For the kernel, single stepping a system call is a
> special operation in that the system call must appear to complete
> atomically and the user space ends up on the next user space assembly
> instruction after the system call.  Behind the scenes the kernel
> executes the system call and tracks this condition.
> 
> It appears kgdb needs to account for this condition as well, by simply
> ignoring it when it occurs.
> 
> Please try the attached patch, as it will hopefully address the
> problem.
> 
> Jason.
> 


-- 
best regards,
D.J. Barrow
