Return-Path: <linux-kernel-owner+w=401wt.eu-S933749AbYB2T4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbYB2T4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYB2T4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:56:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:36447 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbYB2T4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:56:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=xWzjZI/a3PptDsO867OjmoB0hSnxfz1EGBstdisoaaUxWFlbx+dFismIYoNzQlkNB
	A/AQQCY5O7km2hDD0Qebg==
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: parag.warudkar@gmail.com
Cc: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 29 Feb 2008 11:55:04 -0800
Message-Id: <1204314904.4850.23.camel@peace.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 11:53 -0500, Parag Warudkar wrote:
> On Thu, 7 Feb 2008, Parag Warudkar wrote:
> > Yep. I will enable PREEMPT and see if it reproduces for me.
> 
> Not reproducible with PREEMPT either. 

Okay, here's an analysis of the problem and a potential solution.  I
mentioned this in the bug itself but I'll repeat it here:

A couple of us here have been investigating this thing and have
concluded that the problem lies in the implementation of
run_posix_cpu_timers() and specifically in the quadratic nature of the
implementation.  It calls check_process_timers() to sum the
utime/stime/sched_time (in 2.6.18.5, under another name in 2.6.24+) of
all threads in the thread group.  This means that runtime there grows
with the number of threads.  It can go through the list _again_ if and
when it decides to rebalance expiry times.

After thinking through it, it seems clear that the critical number of
threads is that in which run_posix_cpu_timers() takes as long as or
longer than a tick to get its work done.  The system makes progress to
that point but after that everything goes to hell as it gets further and
further behind.  This explains all the symptoms we've seen, including
seeing run_posix_cpu_timers() at the top of a bunch of profiling stats
(I saw it get more than a third of overall processing time on a bunch of
tests, even where the system _didn't_ hang!).  It explains the fact that
things get slow right before they go to hell and it explains why under
certain conditions the system can recover (if the threads have started
exiting by the time it hangs, for example).

I've come up with a potential fix for the problem.  It does two things.
First, rather than summing the utime/stime/sched_time at interrupt it
adds all of those times to a new task_struct field on the group leader
then at interrupt just consults those fields; this avoids repeatedly
blowing the cache as well as a loop across all the threads.

Second, if there are more than 1000 threads in the process (as noted in
task->signal->live), it just punts all of the processing to a workqueue.

With these changes I've gone from a hang at 4500 (or fewer) threads to
running out of resources at more than 32000 threads on a single-CPU box.
When I've finished testing I'll polish the patch a bit and submit it to
the LKML but I thought you guys might want to know the state of things.

Oh, and one more note:  This bug is also dependent on HZ, since it
matters how long a tick is.  I've been running with HZ=1000.  A faster
machine or one with HZ=100 would potentially need to generate a _lot_
more threads to see the hang.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

