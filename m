Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZJSQBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZJSQBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZJSQBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:01:45 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:56633 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbZJSQBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pnXqPENR4N49lIIeyHchVSY6CRiWoiefvAHp3VofV1mO3GLPX7XXHA8JRuWlyIi/Zz
         gI/QF8G/FRlaiKweFooAtVXewSim9UIxX8PovVSfbi1HAb8CBlUN2WXfDIPDkwTP5z6O
         HhTmJuOeqcedBXEHolhK1yl6IBEk4/EjXnanQ=
MIME-Version: 1.0
In-Reply-To: <4ADC6884.9000603@windriver.com>
References: <804dabb00910162243m47c038e3xa744ab165317b300@mail.gmail.com>
	 <804dabb00910170040v27feb935mc95a751b0b7b4086@mail.gmail.com>
	 <4ADC6884.9000603@windriver.com>
Date: Mon, 19 Oct 2009 11:54:24 -0400
Message-ID: <804dabb00910190854m4f18e55cpf5600ebc0f1b7502@mail.gmail.com>
Subject: Re: booting up: blocking indefinitely on kgdb?
From: Peter Teoh <htmldeveloper@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thank you for the explanation.

On Mon, Oct 19, 2009 at 9:24 AM, Jason Wessel
<jason.wessel@windriver.com> wrote:
> Peter Teoh wrote:
>> sorry....now I reboot it is ok.   I don't know why. sorry about that.
>>
>>
>
> This is actually a real problem.  It is a race condition, and there are
> actually two separate problems.
>
> 1) When a processor kernel thread is put into the single step state,
> kgdb expects it to hit the single trap on the same processor the single
> step request was made on.
>

sorry for being irrelevant....can i ask this:   even if the present
CPU is in single step mode, all other CPU can be fully running and
executing all the time, correct?   kgdb is not designed to handle more
than one CPU in single step mode, right?   if wrong, then i supposed
there must be a way to switch among processor, which i don't know how.
  not sure if the same concept pertained to kdb?

> On an SMP system a process or kernel thread can migrate to another
> processor after kgdb resumes.  This will result in a hard hang in the
> cpu roundup part of kgdb.

not sure if it is ok if i can know more about the reason for the hard
hang (in slightly more detail).   The reason is because i am trying to
understand if this same problem does exists in any other parts of the
kernel?   eg, kdb? or anywhere in the suspend-resume cycle?  or
perhaps it can be generalized into a smatch or sparse rules for
standard error pattern recognition?  or perhaps inlined into the
kernel source some kind of dynamic test to test/identify the problem?

>
> 2) Schedule lock contention can cause a hard hang.
>
> On an SMP system kgdb for the x86 architecture single steps by running
> only a single core.  This is quite problematic if you have the schedule
> a lock held by a cpu which is in busy wait.  The system will deadlock on
> the single step operation from kgdb.  This problem is easily observed by
> doing on a 2 processor system by doing:
>
>   while [ 1 ] ; do find /  2> /dev/null > /dev/null; done &
>   while [ 1 ] ; do date > /dev/null ; done &
>   echo V1 > /sys/module/kgdbts/parameters/kgdbts
>
> For the first problem, I have a fix which is in the linux-next branch
> and will I will send a merge request to Linus to get it into the
> mainline tree.
>
> For the second problem, I am going to merge a change to release all the
> processors to run, at the expense of missing a breakpoint.   It is
> possible to change the behavior of this dynamically, for someone who
> might care about this behavior, until a longer term approach is
> implemented.  I have an experimental patch which implements the longer
> term approach of using displaced stepping.
>
> The experimental patch uses kprobes to manage software breakpoints.  The
> kprobe allows the breakpoint to remain planted while stepping around it
> by using out of line instruction execution, where you emulate the
> original instruction using memory elsewhere, followed by another trap
> instruction.
>
> Thanks,

thank you for the verbose explanation.......appreciate very much.
let me take some time to understand......

> Jason.
>
>> On Sat, Oct 17, 2009 at 1:43 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>>
>>> Today, both my system (2.6.32.-rc4 from linus git tree and linux-next)
>>> bootup blocked indefinitely on:
>>>
>>> kgdb: Registered I/O driver kgdbts.
>>>
>>> while booting up.   The expected line:
>>>
>>> kgdb: Unregistered I/O driver kgdbts, debugger disabled.
>>>
>>> never comes up.
>>>
>>> My bootup menu.lst:
>>>
>>> title Fedora (2.6.26-rc4-next-20080530)
>>>        root (hd1,7)
>>>        kernel /boot/vmlinuz-2.6.26-rc4-next-20080530 ro
>>> root=UUID=d10fe8db-e7d4-4b42-b265-0109a3f3eedf
>>>        initrd /boot/initrd-2.6.26-rc4-next-20080530.img
>>> title Fedora (2.6.32-rc4)
>>>        root (hd1,7)
>>>        kernel /boot/vmlinuz-2.6.32-rc4 ro
>>> root=UUID=d10fe8db-e7d4-4b42-b265-0109a3f3eedf
>>>        initrd /boot/initrd-2.6.32-rc4.img
>>>
>>> and kgdb-related option:
>>>
>>> CONFIG_HAVE_ARCH_KGDB=y
>>> CONFIG_KGDB=y
>>> CONFIG_KGDB_SERIAL_CONSOLE=y
>>> CONFIG_KGDB_TESTS=y
>>> CONFIG_KGDB_TESTS_ON_BOOT=y
>>> CONFIG_KGDB_TESTS_BOOT_STRING="y"
>>>
>>> The same 2.6.32-rc4 image have bootup previously before without any
>>> problem.   So what could be the potential cause of this permanent
>>> wait?
>>>
>>> --
>>> Regards,
>>> Peter Teoh
>>>
>>>
>>
>>
>>
>>
>
>



-- 
Regards,
Peter Teoh
