Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZKPTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZKPTNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZKPTNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:13:16 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57546 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZKPTNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M81ZFEn0TtTAlPZi5VD9b2P/8MXbhWvf+ayjz0+faw9UyLUPXAewDvToWj1r6usgKu
         CJTcOYHFNDxjoARLwvJ8O2aNELwJKdm/9xCPixZYy8bBL0cPPzGaiOpYHX4KMsGWVJyW
         rwEEMnppF4g2ZoNjwAhhNoV3Q2RQ6nkCsullI=
MIME-Version: 1.0
In-Reply-To: <20091116083521.GC20672@elte.hu>
References: <1258311859-6189-1-git-send-email-HIGHGuY@gmail.com>
	 <20091116083521.GC20672@elte.hu>
Date: Mon, 16 Nov 2009 20:13:20 +0100
Message-ID: <c76f371a0911161113v60eef516qee0a1a9cf99d2ae@mail.gmail.com>
Subject: Re: [RFC] observe and act upon workload parallelism: 
	PERF_TYPE_PARALLELISM (Was: [RFC][PATCH] sched_wait_block: wait for blocked 
	threads)
From: Stijn Devriendt <highguy@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrea Arcangeli <andrea@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It should not be limited to a single task, and it should work with
> existing syscall APIs - i.e. be fd based.
>
> Incidentally we already have a syscall and a kernel subsystem that is
> best suited to deal with such types of issues: perf events. I think we
> can create a new, special performance event type that observes
> task/workload (or CPU) parallelism:
>
>        PERF_TYPE_PARALLELISM
>
> With a 'parallelism_threshold' attribute. (which is '1' for a single
> task. See below.)

On one side this looks like it's exactly where it belongs as you're
monitoring performance to keep it up to speed, but it does make
the userspace component depend on a profiling-oriented optional
kernel interface.

>
> And then we can use poll() in the thread manager task to observe PIDs,
> workloads or full CPUs. The poll() implementation of perf events is fast
> and scalable.

I've had a quick peek at the perf code and how it currently hooks into
the scheduler and at first glance it looks like 2 additional context switches
are required when using perf. The scheduler will first schedule the idle
thread to later find out that the schedule tail woke up another process
to run. My initial solution woke up the process before making a
scheduling decision. Depending on context switch times the original
blocking operation may have been unblocked (especially on SMP);
e.g. a blocked user-space mutex which was held shortly.
Feel free to correct me here as it was merely a quick peek.

>
> This would make a very powerful task queueing framework. It basically
> allows a 'lazy' user-space scheduler, which only activates if the kernel
> scheduler has run out of work.
>
> What do you think?
>
>        Ingo

I definately like the way this approach can also work globally.

Stijn
