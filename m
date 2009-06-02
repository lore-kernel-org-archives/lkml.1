Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbZFBOzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbZFBOzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbZFBOzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:55:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbZFBOzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:55:24 -0400
Date: Tue, 2 Jun 2009 16:50:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
Message-ID: <20090602144951.GA12123@redhat.com>
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com> <20090525000750.GA2301@redhat.com> <4A1AC5A3.9000600@gmail.com> <20090525172033.GA12586@redhat.com> <4A1AE02D.5080701@gmail.com> <20090525225150.GA12362@redhat.com> <4A25211C.8050504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A25211C.8050504@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Jiri Slaby wrote:
>
> On 05/26/2009 12:51 AM, Oleg Nesterov wrote:
> > Heh. In this case you have another (long-standing) issue, please note
> > the "if (p->flags & PF_EXITING)" check in wants_signal().
> >
> > There is no guarantee the signal will wake up the exiting task task.
> > Even SIGKILL, even if you use wait_event_interruptible() instead of
> > _killable.
>
> Last question, doesn't wait_event_interruptible return immediately in
> this case? signal_pending returns true

Yes, if a thread exits with the pending signal, then of course interruptible
wait doesn work.

> due to non-captured signal which
> killed the application

This signal can be already dequeued, but not necessary. Most probably,
when the process is killed by group the fatal signal, each thread will
exit with the shared signal pending.

> I think this is not much expected behavior, is
> it?

Well. I don't know. I'd say this is expected, but I don't think this
was specially designed ;)

> Shouldn't be that signal dequeued/cleared instead?

We can't. Think about the multithreads program. Some thread exits,
and we have a shared signal. We must not dequeue it.

We can clear TIF_SIGPENDING, and we can change recalc_sigpending_xxx()
to take PF_EXITING into account (or change their callers), but this
needs changes. And I am not sure this will right.

Oleg.

