Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYDHV2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYDHV2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYDHV21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:28:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYDHV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:28:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=v9/28Gp1ZHMME5MAjU7SwlA4pV9gyV+fMLEvQ4J7/CAFA7v7zGssxyrU8v1Az25dv
	PCg1r6lmROQN5+zgSnEYQ==
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
Date: Tue, 08 Apr 2008 14:27:54 -0700
Message-Id: <1207690074.4687.18.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 13:08 -0700, Roland McGrath wrote:
> > Regarding the second approach, without locking wouldn't that still be
> > racy?  Couldn't exit_state change (and therefore __exit_signal() run)
> > between the check and the dereference?
> No.  current->exit_state can go from zero to nonzero only by current
> running code in the do_exit path.  current does not progress on that
> path while current is inside one update_process_times call.

Okay.  One of the paths to the update code is through update_curr() in
sched_fair.c, which (in my tree) calls account_group_exec_runtime() to
update the sum_exec_runtime field:

	delta_exec = (unsigned long)(now - curr->exec_start);

	__update_curr(cfs_rq, curr, delta_exec);
	curr->exec_start = now;

	if (entity_is_task(curr)) {
		struct task_struct *curtask = task_of(curr);

		cpuacct_charge(curtask, delta_exec);
		account_group_exec_runtime(curtask, delta_exec);
	}

To make sure that I understand what's going on, I put an invariant at
the beginning of account_group_exec_runtime():

static inline void account_group_exec_runtime(struct task_struct *tsk,
					       unsigned long long ns)
{
	struct signal_struct *sig = tsk->signal;
	struct task_cputime *times;

	BUG_ON(tsk != current);
	if (unlikely(tsk->exit_state))
		return;
	if (!sig->cputime.totals)
		return;
	times = per_cpu_ptr(sig->cputime.totals, get_cpu());
	times->sum_exec_runtime += ns;
	put_cpu_no_resched();
}

And, you guessed it, the invariant gets violated.  Apparently the passed
task_struct isn't the same as "current" at this point.

Any ideas?  Am I checking the wrong thing?  If we're really not updating
current then the task we are updating could very easily be running
through __exit_signal() on another CPU.  (And while I wait for your
response I will of course continue to try to figure this out.)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

