Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbXFSJOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbXFSJOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXFSJOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:14:33 -0400
Received: from mail.screens.ru ([213.234.233.54]:46968 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbXFSJOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:14:31 -0400
Date: Tue, 19 Jun 2007 13:14:52 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070619091452.GA94@tv-sign.ru>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org> <1182064500.2798.6.camel@entropy> <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com> <1182108399.3794.4.camel@entropy> <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com> <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com> <1182127391.26853.207.camel@localhost.localdomain> <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Linus Torvalds wrote:
>
> On Mon, 18 Jun 2007, Benjamin Herrenschmidt wrote:
> > On Sun, 2007-06-17 at 17:20 -0700, Davide Libenzi wrote:
> > >
> > > Andrew or Linus, did you get Ben's patch?
> > 
> > It might have been missed... I can resend later today.
> 
> I did indeed just miss it. I intended to apply it (and actually thought I 
> had), but I see it's still just an email in that long thread. 
> 
> (It's often a good idea to re-write the subject line and make it be that 
> standard "[PATCH] ..description..", because that just makes it show up 
> much better when I go through my unread emails.. Not that that is any 
> kind of *guarantee* that I won't miss it).
> 
> Anyway, no need to re-send, it's now *really* in my queue of things to 
> apply.

>From another message on this thread,

	Davide Libenzi wrote:
	>
	> On Sun, 17 Jun 2007, Nicholas Miell wrote:
	>
	> > But there's still no way for multiple threads to read from a single
	> > signalfd and get their own thread-specific signals in addition to
	> > process-wide signals, right? I think this was agreed to be the least
	> > surprising behavior.
	>
	> Multiple threads can wait on the signalfd. Each one will dequeue either
	> its own private signals (tsk->pending) or the process shared ones
	> (tsk->signal->shared_pending). This will be the behaviour once Ben's patch
	> is applied.

The commited "Fix signalfd interaction with thread-private signals"
(commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
this.

We can do something like

	int signalfd_dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
	{
		if (tsk->tgid == current->tgid)
			tsk = current;

		return dequeue_signal(tsk, mask, info);
	}

(still I can't understand why should we change signalfd).

Oleg.

