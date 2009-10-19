Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZJSNYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZJSNYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbZJSNYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:24:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:43937 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZJSNYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:24:19 -0400
Message-ID: <4ADC6884.9000603@windriver.com>
Date: Mon, 19 Oct 2009 08:24:20 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: booting up: blocking indefinitely on kgdb?
References: <804dabb00910162243m47c038e3xa744ab165317b300@mail.gmail.com> <804dabb00910170040v27feb935mc95a751b0b7b4086@mail.gmail.com>
In-Reply-To: <804dabb00910170040v27feb935mc95a751b0b7b4086@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 13:24:20.0974 (UTC) FILETIME=[77A4B8E0:01CA50BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> sorry....now I reboot it is ok.   I don't know why. sorry about that.
>
>   

This is actually a real problem.  It is a race condition, and there are
actually two separate problems.

1) When a processor kernel thread is put into the single step state,
kgdb expects it to hit the single trap on the same processor the single
step request was made on.

On an SMP system a process or kernel thread can migrate to another
processor after kgdb resumes.  This will result in a hard hang in the
cpu roundup part of kgdb.

2) Schedule lock contention can cause a hard hang.

On an SMP system kgdb for the x86 architecture single steps by running
only a single core.  This is quite problematic if you have the schedule
a lock held by a cpu which is in busy wait.  The system will deadlock on
the single step operation from kgdb.  This problem is easily observed by
doing on a 2 processor system by doing:

   while [ 1 ] ; do find /  2> /dev/null > /dev/null; done &
   while [ 1 ] ; do date > /dev/null ; done &
   echo V1 > /sys/module/kgdbts/parameters/kgdbts

For the first problem, I have a fix which is in the linux-next branch
and will I will send a merge request to Linus to get it into the
mainline tree.

For the second problem, I am going to merge a change to release all the
processors to run, at the expense of missing a breakpoint.   It is
possible to change the behavior of this dynamically, for someone who
might care about this behavior, until a longer term approach is
implemented.  I have an experimental patch which implements the longer
term approach of using displaced stepping. 

The experimental patch uses kprobes to manage software breakpoints.  The
kprobe allows the breakpoint to remain planted while stepping around it
by using out of line instruction execution, where you emulate the
original instruction using memory elsewhere, followed by another trap
instruction.

Thanks,
Jason.

> On Sat, Oct 17, 2009 at 1:43 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>   
>> Today, both my system (2.6.32.-rc4 from linus git tree and linux-next)
>> bootup blocked indefinitely on:
>>
>> kgdb: Registered I/O driver kgdbts.
>>
>> while booting up.   The expected line:
>>
>> kgdb: Unregistered I/O driver kgdbts, debugger disabled.
>>
>> never comes up.
>>
>> My bootup menu.lst:
>>
>> title Fedora (2.6.26-rc4-next-20080530)
>>        root (hd1,7)
>>        kernel /boot/vmlinuz-2.6.26-rc4-next-20080530 ro
>> root=UUID=d10fe8db-e7d4-4b42-b265-0109a3f3eedf
>>        initrd /boot/initrd-2.6.26-rc4-next-20080530.img
>> title Fedora (2.6.32-rc4)
>>        root (hd1,7)
>>        kernel /boot/vmlinuz-2.6.32-rc4 ro
>> root=UUID=d10fe8db-e7d4-4b42-b265-0109a3f3eedf
>>        initrd /boot/initrd-2.6.32-rc4.img
>>
>> and kgdb-related option:
>>
>> CONFIG_HAVE_ARCH_KGDB=y
>> CONFIG_KGDB=y
>> CONFIG_KGDB_SERIAL_CONSOLE=y
>> CONFIG_KGDB_TESTS=y
>> CONFIG_KGDB_TESTS_ON_BOOT=y
>> CONFIG_KGDB_TESTS_BOOT_STRING="y"
>>
>> The same 2.6.32-rc4 image have bootup previously before without any
>> problem.   So what could be the potential cause of this permanent
>> wait?
>>
>> --
>> Regards,
>> Peter Teoh
>>
>>     
>
>
>
>   

