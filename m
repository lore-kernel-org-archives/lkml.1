Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZKPWMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZKPWMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZKPWMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:12:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbZKPWMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:12:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 3/3] Add get_signal tracepoint
In-Reply-To: Masami Hiramatsu's message of  Monday, 16 November 2009 16:51:23 -0500 <4B01C95B.1070302@redhat.com>
References: <20091113225226.15079.90813.stgit@harusame>
	<20091113225240.15079.4863.stgit@harusame>
	<20091113235333.0E3CC15E8@magilla.sf.frob.com>
	<20091114001020.GB24738@elte.hu>
	<4B01C95B.1070302@redhat.com>
X-Windows: the defacto substandard.
Message-Id: <20091116220957.8E2142F@magilla.sf.frob.com>
Date: Mon, 16 Nov 2009 14:09:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I CC'd Oleg, who doesn't care much about tracepoints, but always stays up
to speed about all things related to signals.)

> >   - signal IPI/wakeup events
> 
> All signals might be used for IPI, isn't it? :-)
> Or, did you mean SIGSTOP/SIGCONT pare?

I suspect he means something approximating signal_wake_up() calls.  If a
signal is blocked, ignored, already pending, etc., then the "sending" event
does not lead to any kind of wakeup or interrupt.

i.e. perhaps something like:

@@ -529,8 +529,11 @@ void signal_wake_up(struct task_struct *t, int resume)
 	mask = TASK_INTERRUPTIBLE;
 	if (resume)
 		mask |= TASK_WAKEKILL;
-	if (!wake_up_state(t, mask))
+	trace_signal_wakeup(t, resume);
+	if (!wake_up_state(t, mask)) {
 		kick_process(t);
+		trace_signal_ipi(t, resume);
+	}

OTOH, kick_process() is only called from here.
Perhaps tracepoints in the sched layer can cover these.

Anyway, Ingo can be more precise about what he has in mind.

> >   - signal loss events (queue overflow)
> 
> Perhaps, this event is only for rt-signals, since
> legacy signals just overwritten if it was sent.

Not exactly.  Nothing is ever "overwritten".  If a non-RT signal is already
pending, then you just leave the existing queue elements alone--i.e. the
first one isn't overwritten, rather the second one is dropped.  But this is
not really the point.

The "queue overflow" happens in two ways.  For RT signals it really is a
"signal loss" event--but that's also reported to the sender as -EAGAIN.  So
a signal-generation tracepoint that reports the return value would already
cover that in a way.

For non-RT signals, a new signal is never lost.  But __sigqueue_alloc() can
still fail.  In this case, you get no queue element and thus no siginfo_t
stored, so you can lose some information about the signal.  You don't lose
the signal itself, but will later dequeue it with an all-zeros siginfo_t.
While calling this a "signal loss" is inaccurate, it is indeed a silent
failure of sorts (unlike the RT signal case, which the userland caller
knows about from the return value).


Thanks,
Roland
