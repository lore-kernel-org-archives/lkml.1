Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZBJSnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZBJSnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 13:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZBJSnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 13:43:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48246 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbZBJSne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 13:43:34 -0500
Date: Tue, 10 Feb 2009 19:40:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@googlemail.com>
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Message-ID: <20090210184014.GA30545@redhat.com>
References: <20090209010233.GA26444@redhat.com> <20090209012824.GA26461@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com> <20090209193625.GA4808@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A1E82FE@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A1E82FE@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Metzger, Markus T wrote:
>
> If I understand this correctly, we have two problems left: 1. if the
> tracer thread dies without detaching, the process will not get the
> (locked) memory refunded.

Yes.

> 2. there is a race between a thread detaching
> and another thread releasing the same task.
>
>
> I do not really understand the second problem.
>
> As far as I know, there can only be one ptracer per task. This ptracer
> can either detach or release, but not both. That other thread that does
> do_wait() should not be able to see the tracee as long as it is ptraced
> (wait_consider_task() will ignore it).

Please note that do_wait() does

	tsk = current;
	do {

		ptrace_do_wait(tsk, ...);

		tsk = next_thread(tsk);
	} while (tsk != current);

So the sub-thread of the tracer can reap the tracee, please see below.

> Since ptrace_disable() is called
> before __ptrace_unlink(), we free the BTS buffer before do_wait() will
> consider the tracee.

They both can free it in parallel.

Suppose we have 2 threads T1 and T2, C is a child of T1 (this is not
strictly necessary, just for simplicity),

T1 attaches to C, does PTRACE_BTS_CONFIG, and then starts PTRACE_DETACH.
When it calls ptrace_detach(), C is TASK_TRACED.

C is killed by SIGKILL, C exits and becomes a zombie. Not a problem
for T1, it has a reference to task_struct.

T1 calls ptrace_disable()->ptrace_bts_detach().

T2 calls do_wait(), the second iteration of the "do while" loop above
finds the "eligible" child C, and calls wait_task_zombie(), which in
turn does release_task()->ptrace_unlink()->...->ptrace_bts_untrace().

Now, T1->ptrace_bts_detach() can race with T2->ptrace_bts_untrace(), they
both can see ->bts != NULL, and they both can do kfree/ds_release_bts.

(and we have another similar race with de_thread() which can call
 release_task() too).

> I do not see the race. Am I missing something?

Or perhaps it is me who missed something, I didn't try to verify the
problem...

> We could try to mimic that and add a ptrace_notify_exit() function that is
> called early in do_exit().  As long as I only put the ptrace_bts_detach()
> into the arch version of it, the changes should be relatively safe.

Yes, we can do untrace earlier, but we still have the problems with tasklist_lock.
Of course, we can add the special function which does ptrace_bts_untrace()
for each tracee under tasklist and returns the size of the freed buffer,
then we drop tasklist and update ->mm. But this is soooo ugly...

And this can't resolve the problem with do_wait/de_thread which
can do ptrace_bts_untrace() before us.

> What do you and Roland think about it? Do you have a better idea?

We should cleanup ptrace first ;) IOW, I don't have a good idea.

Perhaps, for 2.6.29, we can do something like the "patch" below?

(btw, do you agree with the change in copy_process() I sent? )

> I would appreciate, if
> you reviewed future patches in that area.

Please CC me, I'll try to review. But I only understand (more or
less) the process-management part of ptrace...

Oleg.

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -810,11 +810,15 @@ static void ptrace_bts_untrace(struct ta
 
 static void ptrace_bts_detach(struct task_struct *child)
 {
+	// We can race with de_thread/do_wait which
+	// can do ptrace_bts_untrace() before us
 	if (unlikely(child->bts)) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-
-		ptrace_bts_free_buffer(child);
+		// This all will be freed by ptrace_bts_untrace()
+		// later, but we should update ->mm
+		down_write(->mmap_sem);
+		mm->total_vm  -= bts_size;
+		mm->locked_vm -= bts_size);
+		up_write(->mmap_sem);
 	}
 }
 #else

