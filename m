Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbYAPEK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbYAPEK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbYAPEKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:10:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:48052 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbYAPEKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:10:13 -0500
Message-ID: <478D839A.4010201@windriver.com>
Date: Tue, 15 Jan 2008 22:10:02 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: State of kgdb on x86-64
References: <478BB35B.9060507@siemens.com> <478BB74E.6020506@windriver.com> <478C786A.3090709@siemens.com> <478CB724.3000900@windriver.com> <478CFF08.1090608@web.de>
In-Reply-To: <478CFF08.1090608@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2008 04:09:58.0235 (UTC) FILETIME=[A84E0AB0:01C857F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Jason Wessel wrote:
>   
>> Jan Kiszka wrote:
>>     
>>> Jason Wessel wrote:
>>>   
>>>       
>>>> It was working at the point that I tested it with the 2.6.24-rc5 on
>>>> x86_64.  However I suspect my kernel config may differ drastically from
>>>> what you are using.
>>>>
>>>> Without any other context provided than the generic message, it is hard
>>>> to know what might have happened. 
>>>>     
>>>>         
>>> Here is the promised .config. I could also dig out the backtrace of the
>>> panic as kgdb sees it if that helps, just let me know.
>>>
>>> Jan
>>>
>>>   
>>>       
>> The backtrace might be very telling as to what happened.  More
>> information is always better than less :-)
>>
>>     
>
> My primary test box is again out of reach, but meanwhile I was able to
> reproduce some kind of problem under QEMU - that one at least is
> triggered by SMP. With only one CPU -> all apparently fine. Once booting
> QEMU with "-smp 2" -> this happens:
>
> (gdb) tar remote /dev/pts/6
> Remote debugging using /dev/pts/6
> Not all CPUs have been synced for KGDB
> breakpoint () at kernel/kgdb.c:1895
> 1895            wmb(); /* Sync point after breakpoint */
> (gdb) c
> Continuing.
> Not all CPUs have been synced for KGDB
> [New Thread 32769]
>
> Program received signal SIGFPE, Arithmetic exception.
> [Switching to Thread 32769]
> 0xffffffff8020adb7 in default_idle () at include/asm/irqflags_64.h:140
> 140             __asm__ __volatile__("sti; hlt" : : : "memory");
> (gdb) bt
> #0  0xffffffff8020adb7 in default_idle () at include/asm/irqflags_64.h:140
> #1  0xffffffff8020ae65 in cpu_idle () at arch/x86/kernel/process_64.c:225
> #2  0xffffffff8021ccb9 in start_secondary () at arch/x86/kernel/smpboot_64.c:375
> #3  0x0000000000000000 in ?? ()
> (gdb)                                                                                     
>
> The problem seems to be related to continuing SMP boxes. I'm able to
> boot my box up if I leave kgdb unattached. But when I then later attach
> and continue execution, I get the same crash. Any ideas what goes wrong,
> any suggestion where to start digging? Maybe at "Not all CPUs have been
> synched"?
>   

Generally speaking when you get an error that the CPUs have not been
synced, it means that the IPI which was sent to all the non-master
processors failed.  I took a quick look and it appears that the DIE_TRAP
is occuring after kgdb sends the IPI to the non master cores with the call:

    send_IPI_allbutself(APIC_DM_NMI);

In prior kernels that ultimately resulted in an NMI trap.  I am not sure
of the cause of the DIE_TRAP as a result of the IPI.  For now, if you
add the statement "case DIE_TRAP:" right before "    case
DIE_NMIWATCHDOG:" in arch/x86/kernel/kgdb_64.c it will sync te
processors, however the kernel should not be trapping for this error
code from the IPI event.  I suspect there has been some kind of change
to the way the IPI/NMI handling is being done in the latest kernels.

Jason.
