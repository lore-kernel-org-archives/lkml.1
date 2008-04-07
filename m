Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYDGVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYDGVc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYDGVcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:32:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYDGVcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:32:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=wnH+FZWhEupwWAAx+NoR356BBkYSiWMpjz2PAF9vLHHduELChBLt2c5D2mdJ9LCn/
	rPG3hj5+urWtLKxCVpcPg==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: frank@exit.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080407200804.5541926F992@magilla.localdomain>
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
	 <1206995072.14649.41.camel@bobble.smo.corp.google.com>
	 <20080402020707.151E126F8DC@magilla.localdomain>
	 <1207158164.11976.32.camel@bobble.smo.corp.google.com>
	 <20080402194836.4933026F98A@magilla.localdomain>
	 <1207168464.11976.48.camel@bobble.smo.corp.google.com>
	 <20080404231739.7E25126F8DC@magilla.localdomain>
	 <1207459608.94001.22.camel@jill.exit.com>
	 <20080407200804.5541926F992@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 07 Apr 2008 14:31:40 -0700
Message-Id: <1207603900.23968.18.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 13:08 -0700, Roland McGrath wrote: 
> > Yeah, I checked that out.  The one difference here is that that was a
> > race between do_exit() (actually release_task()/__exit_signal()) and
> > run_posix_cpu_timers().  While this race was the same in that respect,
> > there was also a race between all of the timer-tick routines that call
> > any of account_group_user_time(), account_group_system_time() or
> > account_group_exec_runtime() and __exit_signal().  This is because those
> > functions all dereference tsk->signal.
> 
> The essence that matters is the same: something that current does with its
> own ->signal on a tick vs something that the release_task path does.

True.  But see below.

> > Erm, well, this isn't reorganizing the data structures per se, since
> > these are new data structures.
> Tomato, tomato.  You're adding new data structures and lifetime rules to
> replace data that was described in a different data structure before, yet
> your new data's meaningful semantic lifetime exactly matches that of
> signal_struct.

This is one thing that has been unclear.  The relationship of
signal_struct to task_struct is, as far as I can tell, an unwritten one.
Certainly the interrupt routines are adjusting values that live only
inside task_struct and (with the exception of run_posix_cpu_timers())
leave signal_struct carefully alone.

>   You could as well make everything release_task cleans up be
> done in __put_task_struct instead, but that would not be a good idea
> either.  You've added a word to task_struct (100000 words per 100000-thread
> process, vs one word).  It's just not warranted.

While true, that's not the only reason to do it.  The tradeoff here is
between performance (i.e. having to do checks before dereferencing
tsk->signal) versus space.  It's really a judgment call.  (Although
adding 100Kwords does have a bit of weight.)

> > The upshot of this is that none of the timer routines dereference
> > tsk->signal, so the races go away, no locking needed.  From my
> > perspective this was the simplest solution, since lock dependency
> > ordering is _really_ a can of worms.
> 
> With the perspective of tunnel vision to just your one test case, adding
> something entirely new considering only that case always seems simplest.

Well, yes.  And not just "seems."

> That's not how we keep the entire system from getting the wrong kinds of
> complexity.

This isn't exactly how I would state it but yes, this is generally true
as well.  The problem is that knowing exactly what is "the wrong kinds"
relies on knowledge possessed by only a few.  Prying that knowledge out
of you guys can be a chore. :-)

> > Regarding the second approach, without locking wouldn't that still be
> > racy?  Couldn't exit_state change (and therefore __exit_signal() run)
> > between the check and the dereference?
> 
> No.  current->exit_state can go from zero to nonzero only by current
> running code in the do_exit path.  current does not progress on that
> path while current is inside one update_process_times call.

Well, okay, this is the vital bit of data that puts everything above
into perspective.  Had I known this, I would not have made the change I
did.

I guess the key bit of knowledge is that a "task" is really a scheduling
unit, right?  And, really, from the scheduler's perspective, "task" is
the same as "thread."  The only thing that makes a set of threads into a
multithreaded process is that they share a signal struct (well, and
their memory map, of course).  So a "task" can only be executed on a
single cpu at any time, it can't be executed on more than one cpu at a
time.  Therefore if a "task" is executing and is interrupted, the value
of "current" at the interrupt will be that task, which is entirely
suspended for the duration of the interrupt.

Is this correct?  (This is not just for this fix, but for my general
understanding of Linux scheduling.)

Unfortunately, these things are often implicit in the code but as far as
I know aren't written down anywhere.  This whole exercise has been for
me a process of becoming really familiar with the internals of the Linux
kernel for the first time.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

