Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYCaUY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYCaUY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYCaUYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:24:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbYCaUYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:24:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=iVghd8J3JMg+hygJ7IvKH11l4ndgpKs+qsVQIDnqou4/q4C68pwhh5m05mVPhLM/x
	ehgw0xALHveZeujnbRbOA==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080331054404.78CDB26F8E9@magilla.localdomain>
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
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
	 <1206380079.21896.20.camel@bobble.smo.corp.google.com>
	 <20080331054404.78CDB26F8E9@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 31 Mar 2008 13:24:32 -0700
Message-Id: <1206995072.14649.41.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, I'm very much having to read between the lines of what you've
written.  And, obviously, getting it wrong at least half the time. :-)

So you've cleared part of my understanding with your latest email.
Here's what I've gotten from it:

        struct task_cputime {
        	cputime_t utime;		/* User time. */
        	cputime_t stime;		/* System time. */
        	unsigned long long sched_runtime; /* Scheduler time. */
        };
        
This is for both SMP and UP, defined before signal_struct in sched.h
(since that structure refers to this one).  Following that:

        struct thread_group_cputime;

Which is a forward reference to the real definition later in the file.
The inline functions depend on signal_struct and task_struct, so they
have to come after:

        #ifdef SMP

        struct thread_group_cputime {
        	struct task_cputime *totals;
        };

        < ... inline functions ... >

        #else /* SMP */

        struct thread_group_cputime {
        	struct task_cputime totals;
        };

        < ... inline functions ... >

        #endif

The SMP version is percpu, the UP version is just a substructure.  In
signal_struct itself, delete utime & stime, add
        struct thread_group_cputime cputime;

The inline functions include the ones you defined for UP plus equivalent
ones for SMP.  The SMP inlines check the percpu pointer
(sig->cputime.totals) and don't update if it's NULL.  One small
correction to one of your inlines, in thread_group_cputime:
                *cputime = sig->cputime;
should be
                *cputime = sig->cputime.totals;

A representative inline for SMP is:

        static inline void account_group_system_time(struct task_struct *task,
        					      cputime_t cputime)
        {
        	struct task_cputime *times;
        
        	if (!sig->cputime.totals)
        		return;
        	times = per_cpu_ptr(sig->cputime.totals, get_cpu());
        	times->stime = cputime_add(times->stime, cputime);
        	put_cpu_no_resched();
        }
        
To deal with the need for bookkeeping with multiple threads in the SMP
case (where there isn't a per-cpu structure until it's needed), I'll
allocate the per-cpu structure in __exit_signal() where the relevant
fields are updated.  I'll also allocate it where I do now, in
do_setitimer(), when needed.  The allocation will be a "return 0" for UP
and a call to "thread_group_times_alloc_smp()" (which lives in sched.c)
for SMP.

I'll also optimize run_posix_cpu_timers() as you suggest, and eliminate
rlim_expires.

Expect a new patch fairly soon.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

