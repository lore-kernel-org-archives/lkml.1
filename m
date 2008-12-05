Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYLEJKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYLEJKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYLEJK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:10:28 -0500
Received: from ozlabs.org ([203.10.76.45]:41917 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYLEJKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:10:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18744.61429.548462.667020@cargo.ozlabs.ibm.com>
Date: Fri, 5 Dec 2008 20:10:13 +1100
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
In-Reply-To: <20081205080813.GA2030@elte.hu>
References: <20081204225345.654705757@linutronix.de>
	<18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	<20081205063131.GB12785@elte.hu>
	<18744.56857.259756.129894@cargo.ozlabs.ibm.com>
	<20081205080813.GA2030@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:
[...]
> > Isn't it two separate read() calls to read the two counters?  If so, 
> > the only way the two values are actually going to correspond to the 
> > same point in time is if the task being monitored is stopped.  In which 
> > case the monitoring task needs to use ptrace or something similar in 
> > order to make sure that the monitored task is actually stopped.
> 
> It doesnt matter in practice.

Can I ask - and this is a real question, I'm not being sarcastic - is
that statement made with substantial serious experience in performance
analysis behind it, or is it just an intuition?

I will happily admit that I am not a great expert on performance
analysis with years of experience.  But I have taken a bit of a look
at what people with that sort of experience do, and I don't think they
would agree with your "doesn't matter" statement.

> Such kind of 'group system call facility' has been suggested several 
> times in the past - but ... never got anywhere because system calls are 
> cheap enough, it really does not count in practice.
> 
> It could be implemented, and note that because our code uses a proper 
> Linux file descriptor abstraction, such a sys_read_fds() facility would 
> help _other_ applications as well, not just performance counters.
> 
> But it brings complications: demultiplexing of error conditions on 
> individual counters is a real pain with any compound abstraction. We very 
> consciously went with the 'one fd, one object, one counter' design.

And I think that is the fundamental flaw.  On the machines I am
familiar with, the performance counters as not separate things that
can individually and independently be assigned to count one thing or
another.

Rather, what the hardware provides is ONE performance monitor unit,
which the OS can context-switch between tasks.  The performance
monitor unit has several counters that can be assigned (within limits)
to count various aspects of the performance of the code being
executed.  That is why, for instance, if you ask for the counters to
be frozen when one of them overflows, they all get frozen at that
point.

And that's how the hardware is designed because that's how the people
that do performance analysis want to do their measurements.  This idea
of splitting things up into separate counters that look independent
but aren't is just going to cause unnecessary complications and
difficulties.

Paul.
