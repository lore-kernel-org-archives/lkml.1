Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZF0BNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZF0BNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 21:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZF0BMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 21:12:55 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51300 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZF0BMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 21:12:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19013.29199.123045.531291@cargo.ozlabs.ibm.com>
Date: Sat, 27 Jun 2009 11:12:47 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/2] perfcounter: callchains with perf report
In-Reply-To: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
References: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> Here is a first shot for the sorted callchains per entries handling
> with per report.
> 
> I'll continue to improve it:
> 
> - symbol resolution
> - profit we have a tree to display a better graph hierarchy
> - let the user provide a limit for hit percentage, depth, number of
>   backtraces, etc...
> - better output
> - colors
> - and so on....

Nice!

I have just about finished doing the kernel piece of callchain support
on powerpc.  Because of the way function calls and returns work on
powerpc, working out the first one or two return addresses can be
tricky.  We potentially have a valid return address in the link
register (LR), or in the LR save area in the second stack frame, or
both, and you need extra information such as DWARF unwind tables to
work out which of those three possibilities you have, in general.
This is the case at each point where an interrupt or signal has
occurred.

Because I didn't want to go trawling through CFI tables at interrupt
time, particularly for user code, I made the kernel save both possible
return addresses in the callchain.  For the kernel part of the
callchain, I check those two addresses to see if they're valid kernel
addresses and set them to 0 if not, or if they're equal.

That means I need to make some changes to builtin-report.c to ignore
zero addresses.  I may need to add stuff to look for and use unwind
tables as well, if we want completely accurate call chains.

The other thing I did is to put PERF_CONTEXT_KERNEL markers in the
callchain every time we find an interrupt frame, and PERF_CONTEXT_USER
markers every time we find a signal frame, so that userspace knows
when it needs to do the unwinding.

Oh, and a third point is that on powerpc the sampled IP recorded if
you ask for PERF_SAMPLE_IP won't in general be the same as the first
IP in the callchain.  The reason is that the PERF_SAMPLE_IP value
points to the instruction that caused the counter overflow whereas the
first IP in the callchain tells you where the CPU took the interrupt.
That is almost always a few instructions further on, and can be quite
a way further on if interrupts were disabled when the counter overflow
occur.  In fact we regularly see the PERF_SAMPLE_IP value being in the
hypervisor but the first IP in the callchain being in the kernel.

Paul.
