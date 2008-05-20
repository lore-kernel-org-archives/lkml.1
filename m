Return-Path: <linux-kernel-owner+w=401wt.eu-S933582AbYETPTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbYETPTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932576AbYETPTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:19:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:52617 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760189AbYETPT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:19:29 -0400
Message-ID: <4832EBCF.2000407@windriver.com>
Date: Tue, 20 May 2008 10:18:39 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb test suite failure
References: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>
In-Reply-To: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2008 15:18:32.0494 (UTC) FILETIME=[C3E6F4E0:01C8BA8C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> Hi
> I tried to run the latest git kernel and got the following error.
>
> See an attachment for full dmesg.
>
> kgdbts: ERROR PUT: end of test buffer on 'do_fork_test' line 5
> expected OK got $E02#a7
> ------------[ cut here ]------------
> WARNING: at drivers/misc/kgdbts.c:721 run_simple_test+0x1de/0x20e()
> Modules linked in:
> Pid: 6, comm: khelper Not tainted 2.6.26-rc1-00279-g28a4acb #12
> [<c011a00a>] warn_on_slowpath+0x41/0x6c
> [<c011aa77>] ? vprintk+0x3e7/0x407
> [<c0254cf4>] ? number+0x10d/0x1cf
> [<c012d3da>] ? sched_clock_cpu+0x70/0x88
> [<c011aaac>] ? printk+0x15/0x17
>   
Is this a problem you can reproduce every time?  Basically what line 5
of the test does is to write a value into the register struct to rewind
the PC after hitting a breakpoint such that the instruction will be
executed again.   This is stored in memory which will be used for a
context switch back to the process.   The test also replaces the
original instruction in memory.  In this case the memory write failed. 
This will certainly be fatal to the operation of the kernel and
stability would be called into question if the kernel doesn't just crash
and oops in strange ways immediately.

I looked in your dmesg log and noticed:
[   21.027632] Testing CPA: undo c035d000-c044e000
[   21.083029] Testing CPA: write protecting again
[   21.297278] kgdbts: ERROR PUT: end of test buffer on 'do_fork_test'
line 5 expected OK got $E02#a7


I looked through the kernel source in the tip of the tree for the
"Testing CPA: write protecting again".  It seems this code is only used
when CONFIG_DEBUG_RODATA is set.  Perhaps this option is mutually
exclusive of the use of kgdb?  Today kgdb assumes it can write anywhere
without any kind of special concession for page protection bits.

Certainly kgdb's memory write function could be changed based on the
conditional CONFIG_DEBUG_RODATA if there is an api to
check/change/revert the protection bits on the memory pages.  This of
course is assuming that this is the root cause of the problem.

Jason.

