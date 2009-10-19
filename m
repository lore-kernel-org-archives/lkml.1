Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZJSTRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZJSTRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZJSTRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:17:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:35103 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZJSTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:17:41 -0400
Message-ID: <4ADCBB58.5020803@windriver.com>
Date: Mon, 19 Oct 2009 14:17:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: booting up: blocking indefinitely on kgdb?
References: <804dabb00910162243m47c038e3xa744ab165317b300@mail.gmail.com> <804dabb00910170040v27feb935mc95a751b0b7b4086@mail.gmail.com> <4ADC6884.9000603@windriver.com> <804dabb00910190854m4f18e55cpf5600ebc0f1b7502@mail.gmail.com>
In-Reply-To: <804dabb00910190854m4f18e55cpf5600ebc0f1b7502@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 19:17:44.0030 (UTC) FILETIME=[D5A64FE0:01CA50F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> On Mon, Oct 19, 2009 at 9:24 AM, Jason Wessel
> <jason.wessel@windriver.com> wrote:
>   
>> This is actually a real problem.  It is a race condition, and there are
>> actually two separate problems.
>>
>> 1) When a processor kernel thread is put into the single step state,
>> kgdb expects it to hit the single trap on the same processor the single
>> step request was made on.
>>
>>     
>
> sorry for being irrelevant....can i ask this:   even if the present
> CPU is in single step mode, all other CPU can be fully running and
> executing all the time, correct?  

It is not quite that simple.  The single step mode is a kernel task state.

When kgdb does a single step on the x86 architecture, the HW single step
bit is set in the active kernel task on CPU 2 for instance.   Then kgdb
starts just that CPU.   If an interrupt occurs or any kind of
preemption, is when the problem case arises.  This task may get
scheduled onto a different CPU at a later point, and dead lock ensues.


>  kgdb is not designed to handle more
> than one CPU in single step mode, right?   if wrong, then i supposed
> there must be a way to switch among processor, which i don't know how.
>   not sure if the same concept pertained to kdb?
>
>   

Kgdb will not single step more that one task at a time.  In kdb it has
the capability of switching CPUs, and in the kgdb+kdb merge branch I
implemented that functionality as well.  Either way it it still can only
single step one kernel thread at a time.

>> On an SMP system a process or kernel thread can migrate to another
>> processor after kgdb resumes.  This will result in a hard hang in the
>> cpu roundup part of kgdb.
>>     
>
> not sure if it is ok if i can know more about the reason for the hard
> hang (in slightly more detail).   The reason is because i am trying to
> understand if this same problem does exists in any other parts of the
> kernel?   eg, kdb? or anywhere in the suspend-resume cycle?  or
> perhaps it can be generalized into a smatch or sparse rules for
> standard error pattern recognition?  or perhaps inlined into the
> kernel source some kind of dynamic test to test/identify the problem?
>
>   

This particular problem does not exist anywhere else in the kernel.  It
is unique to the way kgdb deals with stopping and starting the system. 

In kernel/kgdb.c the key is in anything that touches the variable
"kgdb_cpu_doing_single_step".  It is up to each architecture that makes
use of kgdb to set/unset this variable.  The x86 arch sets it, and what
it does is not allow the other CPUs to run when single stepping.  If we
remove the set on the x86 arch, then you end up with the task migration
issue, so I was proposing putting in the fix to both issues, until a
displaced solution with kprobes or another implementation is completed.

You trade one problem for another of course with allowing the CPU's to run.

The original problem was a "hard hang".   The new problem is the
possibility of a missed break point.   For instance if you set a
breakpoint in a chunk of common code that can execute in parallel on two
different CPUs.  The breakpoint gets removed, the single step HW flag is
set, and if another CPU or task runs through that chunk of code, the
break point is missed.  My preference is to trade the hard hang away for
the time being.

Jason.
