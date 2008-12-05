Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYLEHyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYLEHyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYLEHyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:54:14 -0500
Received: from ozlabs.org ([203.10.76.45]:59832 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYLEHyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:54:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18744.56857.259756.129894@cargo.ozlabs.ibm.com>
Date: Fri, 5 Dec 2008 18:54:01 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
In-Reply-To: <20081205063131.GB12785@elte.hu>
References: <20081204225345.654705757@linutronix.de>
	<18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	<20081205063131.GB12785@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
> 
> * Paul Mackerras <paulus@samba.org> wrote:
[snip]
> > One thing that this sort of thing can't do is to get values from 
> > multiple counters that correlate with each other.  For instance, we 
> > would often want to count, say, L2 cache misses and instructions 
> > completed at the same time, and be able to read both counters at very 
> > close to the same time, so that we can measure average L2 cache misses 
> > per instruction completed, which is useful.
> 
> This can be done in a very natural way with our abstraction, and the 
> "hello.c" example happens to do exactly that:

Has hello.c been posted?  I can't find it in any of the posts from you
or Thomas.  Am I just being blind? :)

>   aldebaran:~/perf-counter-test> ./hello
>   doing perf_counter_open() call:
>   counter[0]... fd: 3.
>   counter[1]... fd: 4.
>   counter[0] delta: 10866 cycles
>   counter[1] delta: 414 cycles
>   counter[0] delta: 23640 cycles
>   counter[1] delta: 3673 cycles
>   counter[0] delta: 28225 cycles
>   counter[1] delta: 3695 cycles
> 
> This counts cycles executed and instructions executed, and reads the two 
> counters out at the same time.

Isn't it two separate read() calls to read the two counters?  If so,
the only way the two values are actually going to correspond to the
same point in time is if the task being monitored is stopped.  In
which case the monitoring task needs to use ptrace or something
similar in order to make sure that the monitored task is actually
stopped.

If the monitored task is not stopped, then the interval between the
two reads will be sufficient to render the results useless -
particularly since the monitoring task could get preempted for an
arbitrary length of time between the two reads.  But even if it
doesn't, the hundreds of cycles between the two reads will introduce
considerable imprecision in the results.

There really is value in being able to read all the counters you're
using in one system call.

Paul.
