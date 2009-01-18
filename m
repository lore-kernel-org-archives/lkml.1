Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbZARRNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbZARRNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbZARRNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:13:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022AbZARRNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:13:42 -0500
Date: Sun, 18 Jan 2009 18:13:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] perf_counter: Add counter enable/disable ioctls
Message-ID: <20090118171333.GA3647@elte.hu>
References: <18801.34089.712558.878795@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18801.34089.712558.878795@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Impact: New perf_counter features
> 
> This primarily adds a way for perf_counter users to enable and disable
> counters and groups.  Enabling or disabling a counter or group also
> enables or disables all of the child counters that have been cloned
> from it to monitor children of the task monitored by the top-level
> counter.  The userspace interface to enable/disable counters is via
> ioctl on the counter file descriptor.
> 
> Along the way this extends the code that handles child counters to
> handle child counter groups properly.  A group with multiple counters
> will be cloned to child tasks if and only if the group leader has the
> hw_event.inherit bit set - if it is set the whole group is cloned as a
> group in the child task.
> 
> In order to be able to enable or disable all child counters of a given
> top-level counter, we need a way to find them all.  Hence I have added
> a child_list field to struct perf_counter, which is the head of the
> list of children for a top-level counter, or the link in that list for
> a child counter.  That list is protected by the perf_counter.mutex
> field.
> 
> This also adds a mutex to the perf_counter_context struct.  Previously
> the list of counters was protected just by the lock field in the
> context, which meant that perf_counter_init_task had to take that lock
> and then take whatever lock/mutex protects the top-level counter's
> child_list.  But the counter enable/disable functions need to take
> that lock in order to traverse the list, then for each counter take
> the lock in that counter's context in order to change the counter's
> state safely, which will lead to a deadlock.
> 
> To solve this, we now have both a mutex and a spinlock in the context,
> and taking either is sufficient to ensure the list of counters can't
> change - you have to take both before changing the list.  Now
> perf_counter_init_task takes the mutex instead of the lock (which
> incidentally means that inherit_counter can use GFP_KERNEL instead of
> GFP_ATOMIC) and thus avoids the possible deadlock.  Similarly the new
> enable/disable functions can take the mutex while traversing the list
> of child counters without incurring a possible deadlock when the
> counter manipulation code locks the context for a child counter.
> 
> We also had an misfeature that the first counter added to a context
> would possibly not go on until the next sched-in, because we were
> using ctx->nr_active to detect if the context was running on a CPU.
> But nr_active is the number of active counters, and if that was zero
> (because the context didn't have any counters yet) it would look like
> the context wasn't running on a cpu and so the retry code in
> __perf_install_in_context wouldn't retry.  So this adds an 'is_active'
> field that is set when the context is on a CPU, even if it has no
> counters.  The is_active field is only used for task contexts, not for
> per-cpu contexts.
> 
> If we enable a subsidiary counter in a group that is active on a CPU,
> and the arch code can't enable the counter, then we have to pull the
> whole group off the CPU.  We do this with group_sched_out, which gets
> moved up in the file so it comes before all its callers.  This also
> adds similar logic to __perf_install_in_context so that the "all on,
> or none" invariant of groups is preserved when adding a new counter to
> a group.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> This version fixes a silly bug (err uninitialized in perf_ioctl) and
> makes the state of a cloned counter follow the state of the parent
> counter (not its hw_event.disable bit).
> 
> This is in my perfcounters.git tree master branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master
> 
> Ingo - please pull.

Pulled into tip/percounters/core, thanks Paul!

	Ingo
