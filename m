Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbYCDT40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbYCDT40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbYCDTyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:54:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23907 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376AbYCDTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:54:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=JLVctlcxwVrq/IgUdm/GUxT2Yv14L0IRPrI1JE4Lh6mItsfx+kOjYhkWrXIRDm391
	5XefmKv16+2gCKuG0NqXg==
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: parag.warudkar@gmail.com,
       Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <20080304070016.903E127010A@magilla.localdomain>
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
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 04 Mar 2008 11:52:56 -0800
Message-Id: <1204660376.9768.1.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put this on the patch but I'm emailing it as well.

On Mon, 2008-03-03 at 23:00 -0800, Roland McGrath wrote:
> Thanks for the detailed explanation and for bringing this to my attention.

You're quite welcome.

> This is a problem we knew about when I first implemented posix-cpu-timers
> and process-wide SIGPROF/SIGVTALRM.  I'm a little surprised it took this
> long to become a problem in practice.  I originally expected to have to
> revisit it sooner than this, but I certainly haven't thought about it for
> quite some time.  I'd guess that HZ=1000 becoming common is what did it.

Well, the iron is getting bigger, too, so it's beginning to be feasible
to run _lots_ of threads.

> The obvious implementation for the process-wide clocks is to have the
> tick interrupt increment shared utime/stime/sched_time fields in
> signal_struct as well as the private task_struct fields.  The all-threads
> totals accumulate in the signal_struct fields, which would be atomic_t.
> It's then trivial for the timer expiry checks to compare against those
> totals.
> 
> The concern I had about this was multiple CPUs competing for the
> signal_struct fields.  (That is, several CPUs all running threads in the
> same process.)  If the ticks on each CPU are even close to synchronized,
> then every single time all those CPUs will do an atomic_add on the same
> word.  I'm not any kind of expert on SMP and cache effects, but I know
> this is bad.  However bad it is, it's that bad all the time and however
> few threads (down to 2) it's that bad for that many CPUs.
> 
> The implementation we have instead is obviously dismal for large numbers
> of threads.  I always figured we'd replace that with something based on
> more sophisticated thinking about the CPU-clash issue.  
> 
> I don't entirely follow your description of your patch.  It sounds like it
> should be two patches, though.  The second of those patches (workqueue)
> sounds like it could be an appropriate generic cleanup, or like it could
> be a complication that might be unnecessary if we get a really good
> solution to main issue.  
> 
> The first patch I'm not sure whether I understand what you said or not.
> Can you elaborate?  Or just post the unfinished patch as illustration,
> marking it as not for submission until you've finished.

My first patch did essentially what you outlined above, incrementing
shared utime/stime/sched_time fields, except that they were in the
task_struct of the group leader rather than in the signal_struct.  It's
not clear to me exactly how the signal_struct is shared, whether it is
shared among all threads or if each has its own version.

So each timer routine had something like:

	/* If we're part of a thread group, add our time to the leader. */
	if (p->group_leader != NULL)
		p->group_leader->threads_sched_time += tmp;

and check_process_timers() had

	/* Times for the whole thread group are held by the group leader. */
	utime = cputime_add(utime, tsk->group_leader->threads_utime);
	stime = cputime_add(stime, tsk->group_leader->threads_stime);
	sched_time += tsk->group_leader->threads_sched_time;

Of course, this alone is insufficient.  It speeds things up a tiny bit
but not nearly enough.

The other issue has to do with the rest of the processing in
run_posix_cpu_timers(), walking the timer lists and walking the whole
thread group (again) to rebalance expiry times.  My second patch moved
all that work to a workqueue, but only if there were more than 100
threads in the process.  This basically papered over the problem by
moving the processing out of interrupt and into a kernel thread.  It's
still insufficient, though, because it takes just as long and will get
backed up just as badly on large numbers of threads.  This was made
clear in a test I ran yesterday where I generated some 200,000 threads.
The work queue was unreasonably large, as you might expect.

I am looking for a way to do everything that needs to be done in fewer
operations, but unfortunately I'm not familiar enough with the
SIGPROF/SIGVTALRM semantics or with the details of the Linux
implementation to know where it is safe to consolidate things.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

