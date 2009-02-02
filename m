Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZBBQ6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZBBQ6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 11:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZBBQ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 11:58:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47645 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZBBQ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 11:58:29 -0500
Date: Mon, 2 Feb 2009 17:56:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
Message-ID: <20090202165606.GA13346@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com> <20090201174159.4a52e15c.akpm@linux-foundation.org> <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Kaz Kylheku wrote:
>
> On Sun, Feb 1, 2009 at 10:45 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Kaz Kylheku wrote:
> >>
> >> Basically, if you call pthread_exit from the main thread of a process, and keep
> >> other threads running, the behavior is ugly.
> >
> > Yes, known problem.
> >
> > Please look at
> >
> >        [RFC,PATCH 3/3] do_wait: fix waiting for stopped group with dead leader
> >        http://marc.info/?t=119713920000003
> >
> > I'll try to re-do and re-send this patch this week.
>
> I believe that my straight-forward fix is pretty much good to go. I
> checked into my distro, so we will see how it holds up.

(the patch: http://sourceware.org/bugzilla/attachment.cgi?id=3702)

Well, perhaps something like your patch makes sense.

	+/*
	+ * A single thread is exiting, and it is the leader of the group.
	+ * This coresponds to the main thread calling pthread_exit.
	+ * In this case, the persists until all the other
	+ * threads call pthread_exit, or someone calls exit or _exit.
	+ * To implement this case, we park the thread leader in
	+ * a loop which waits until the thread list becomes empty,
	+ * or it receives a fatal signal.
                           ^^^^^^^^^^^^^^
The comment is not exactly right, we return on every signal, not only fatal.

	+int
	+do_leader_exit(void)
	+{
	+	int ret = 0;
	+
	+	if (unlikely(!thread_group_empty(current))) {
	+		DECLARE_WAITQUEUE(wait, current);
	+
	+		add_wait_queue(&current->signal->wait_chldexit, &wait);
	+
	+		set_current_state(TASK_INTERRUPTIBLE);
	+
	+		do {
	+			if (thread_group_empty(current))
	+				break;
	+
	+			try_to_freeze();
	+			schedule();
	+			if (signal_pending(current))
	+				ret = -ERESTARTSYS;
	+		} while (ret == 0);
	+
	+		remove_wait_queue(&current->signal->wait_chldexit, &wait);
	+
	+		__set_current_state(TASK_RUNNING);
	+	}
	+
	+	return ret;
	+}

the above is just the open-coded
wait_event_interruptible(&current->signal->wait_chldexit,
				thread_group_empty(current));


	 asmlinkage long sys_exit(int error_code)
	 {
	+	if (thread_group_leader(current)) {
	+		int ret = do_leader_exit();
	+		if (ret != 0)
	+			return ret;
	+	}
		do_exit((error_code&0xff)<<8);
	 }

afaics, -ERESTARTSYS is not exactly correct. We can dequeue the
signal without SA_RESTART. But we never should abort sys_exit().
ERESTARTNOINTR is better. But see below.

I am worried this patch can confuse the user-space. Because, when
the main thread does sys_exit(), the user-space has all rights
to assume it exits ;) But with this patch the main thread will
continue to handle the signals until the while group exits, I'm
afraid libpthread.so won't be happy.

And what if the signal handler does siglongjmp() and aborts sys_exit() ?

> It's a bad idea to allow the main thread to terminate. It should stick
> around because it serves as a facade for the process as a whole. If
> the main thread is allowed to bail all the way through do_exit, who
> knows what kind of problems may show up because of that.
>
> What if one of my developers is working on a server which has called
> pthread_exit in the main thread, and wants to attach gdb to it? Will
> that work if the main thread (a.k.a group leader) is a defunct
> process?

And I think gdb is wrong. It can see this process has other live threads,
and attach to them. I didn't check gdb, but iirc "strace -f" works
correctly in this case.

I cced other people. Let's see what they think.

Oleg.

