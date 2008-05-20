Return-Path: <linux-kernel-owner+w=401wt.eu-S1765827AbYETSbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765827AbYETSbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbYETSax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:30:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:3054 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbYETSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U2iJBJcPOZpPiMGeFub969uxe1H9Fnch08m+1Lkj9OPHW9vY0O2/wFAFNlLTsP9b26RPlb6RuVT9KVZYuh61i3k9uoFNEJKN6+TPivdlh8NICRfgb5ai+A+AVsXl6ApAYp9/u2+GROG7dSGv0v03bziC5C4es3fSM+Dv8My9cSI=
Message-ID: <a4423d670805201130l649440acl3ef31f60503b279d@mail.gmail.com>
Date: Tue, 20 May 2008 22:30:49 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: Re: kgdb test suite failure
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4832EBCF.2000407@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>
	 <4832EBCF.2000407@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Jason Wessel <jason.wessel@windriver.com>:
> Alexander Beregalov wrote:
>> Hi
>> I tried to run the latest git kernel and got the following error.
>>
>> See an attachment for full dmesg.
>>
>> kgdbts: ERROR PUT: end of test buffer on 'do_fork_test' line 5
>> expected OK got $E02#a7
>> ------------[ cut here ]------------
>> WARNING: at drivers/misc/kgdbts.c:721 run_simple_test+0x1de/0x20e()
>> Modules linked in:
>> Pid: 6, comm: khelper Not tainted 2.6.26-rc1-00279-g28a4acb #12
>> [<c011a00a>] warn_on_slowpath+0x41/0x6c
>> [<c011aa77>] ? vprintk+0x3e7/0x407
>> [<c0254cf4>] ? number+0x10d/0x1cf
>> [<c012d3da>] ? sched_clock_cpu+0x70/0x88
>> [<c011aaac>] ? printk+0x15/0x17
>>
> Is this a problem you can reproduce every time?  Basically what line 5
Yes, it happened every time when kernel booted, even before init.

> of the test does is to write a value into the register struct to rewind
> the PC after hitting a breakpoint such that the instruction will be
> executed again.   This is stored in memory which will be used for a
> context switch back to the process.   The test also replaces the
> original instruction in memory.  In this case the memory write failed.
> This will certainly be fatal to the operation of the kernel and
> stability would be called into question if the kernel doesn't just crash
> and oops in strange ways immediately.
>
> I looked in your dmesg log and noticed:
> [   21.027632] Testing CPA: undo c035d000-c044e000
> [   21.083029] Testing CPA: write protecting again
> [   21.297278] kgdbts: ERROR PUT: end of test buffer on 'do_fork_test'
> line 5 expected OK got $E02#a7
>
>
> I looked through the kernel source in the tip of the tree for the
> "Testing CPA: write protecting again".  It seems this code is only used
> when CONFIG_DEBUG_RODATA is set.  Perhaps this option is mutually
> exclusive of the use of kgdb?  Today kgdb assumes it can write anywhere
> without any kind of special concession for page protection bits.
It seems like this.
The kernel with the following config can boot.
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"
# CONFIG_DEBUG_RODATA is not set

And kgdbts runs successfully:
[    7.579110] kgdb: Registered I/O driver kgdbts.
[    7.633491] kgdbts:RUN plant and detach test
[    7.686505] kgdbts:RUN sw breakpoint test
[    7.734031] kgdbts:RUN bad memory access test
[    7.786258] kgdbts:RUN singlestep test 1000 iterations
[    7.847832] kgdbts:RUN singlestep [0/1000]
[    7.905206] kgdbts:RUN singlestep [100/1000]
[    7.965778] kgdbts:RUN singlestep [200/1000]
[    8.026037] kgdbts:RUN singlestep [300/1000]
[    8.086507] kgdbts:RUN singlestep [400/1000]
[    8.146839] kgdbts:RUN singlestep [500/1000]
[    8.207588] kgdbts:RUN singlestep [600/1000]
[    8.267889] kgdbts:RUN singlestep [700/1000]
[    8.328643] kgdbts:RUN singlestep [800/1000]
[    8.388939] kgdbts:RUN singlestep [900/1000]
[    8.449322] kgdbts:RUN hw breakpoint test
[    8.497369] kgdbts:RUN hw write breakpoint test
[    8.551663] kgdbts:RUN access write breakpoint test
[    8.610117] kgdbts:RUN do_fork for 100 breakpoints

It's 2.6.26-rc3-00154-gc110a2b

>
> Certainly kgdb's memory write function could be changed based on the
> conditional CONFIG_DEBUG_RODATA if there is an api to
> check/change/revert the protection bits on the memory pages.  This of
> course is assuming that this is the root cause of the problem.
>
> Jason.
>
>
