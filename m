Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZLBSkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZLBSkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZLBSkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:40:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbZLBSkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:40:19 -0500
Date: Wed, 2 Dec 2009 19:34:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091202183446.GA14799@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259697242.1697.1075.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Peter Zijlstra wrote:
>
> > +static inline __must_check int utrace_control_pid(
> > +	struct pid *pid, struct utrace_engine *engine,
> > +	enum utrace_resume_action action)
> > +{
> > +	/*
> > +	 * We don't bother with rcu_read_lock() here to protect the
> > +	 * task_struct pointer, because utrace_control will return
> > +	 * -ESRCH without looking at that pointer if the engine is
> > +	 * already detached.  A task_struct pointer can't die before
> > +	 * all the engines are detached in release_task() first.
> > +	 */
> > +	struct task_struct *task = pid_task(pid, PIDTYPE_PID);
> > +	return unlikely(!task) ? -ESRCH : utrace_control(task, engine, action);
> > +}
>
> Is that comment correct? Without rcu_read_lock() the pidhash can change
> under our feet and maybe cause funny things?

I already tried to answer, but I guess my email was not very clear. Let me
try again.

pid_task() by itself is safe, but yes, it is possible that utrace_control()
is called with target == NULL, or this task_task was already freed/reused.

utrace_control(target) path does not use target until it verifies it is
safe to dereference it.

get_utrace_lock() calls rcu_read_lock() and checks that engine->ops
is not cleared (NULL or utrace_detached_ops). If we see the valid ->ops
under rcu_read_lock() it is safe to dereference target, even if we race
with release_task() we know that it has not passed utrace_release_task()
yet, and thus we know call_rcu(delayed_put_task_struct) was not yet
called _before_ we took rcu_read_lock().

If it is safe to dereference target, we can take utrace->lock. Once
we take this lock (and re-check engine->ops) the task can't go away
until we drop it, get_utrace_lock() drops rcu lock and returns with
utrace->lock held.

utrace_control() can safely play with target under utrace->lock.

> > +	/*
> > +	 * If this flag is still set it's because there was a signal
> > +	 * handler setup done but no report_signal following it.  Clear
> > +	 * the flag before we get to user so it doesn't confuse us later.
> > +	 */
> > +	if (unlikely(utrace->signal_handler)) {
> > +		spin_lock(&utrace->lock);
> > +		utrace->signal_handler = 0;
> > +		spin_unlock(&utrace->lock);
> > +	}
>
> OK, so maybe you get to explain why this works..

Missed this part yesterday.

Well. ->signal_handler is set by handle_signal() when the signal was
delivered to the tracee. This flag is checked by utrace_get_signal()
to detect the stepping. But we should not return to user-mode with
this flag set, that is why utrace_resume() clears it.

However. This reminds me we were going to try to simplify this logic,
I'll try to think about this.

Oleg.

