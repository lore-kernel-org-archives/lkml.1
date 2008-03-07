Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbYCGVUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbYCGVUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbYCGVUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:20:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbYCGVUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:20:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: do_tkill: don't use tasklist_lock
In-Reply-To: Oleg Nesterov's message of  Friday, 7 March 2008 23:13:46 +0300 <20080307201346.GA107@tv-sign.ru>
References: <20080307095813.GA8894@tv-sign.ru>
	<20080307193159.1AFF127010F@magilla.localdomain>
	<20080307201346.GA107@tv-sign.ru>
Emacs: Lovecraft was an optimist.
Message-Id: <20080307211955.A876226F990@magilla.localdomain>
Date: Fri,  7 Mar 2008 13:19:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, a question: we are buggy or just "not perfect" ? After all, the
> main thread actually exits although this is just linux's implementation
> detail.

I think it's buggy.  The SIGKILL should kill the whole process.

> Yep. kill_pid_info() does exactly this. Initially I was going to repeat
> this logic,

I think that precedent is enough reason to follow its example as the first
change.  We can consider more cleanups from there.

> Suppose that the main thread is already dead (dequeued SIGKILL), but
> not yet released. This window is not that small. In that window (before
> de_thread() switches pids) any private signal (even SIGKILL) sent to the
> main thread will be silently lost.

This is the big problem with exec that I've cited before.  It can even
happen with group-wide signals that should be fatal, but avoided the
__group_complete_signal special fatal case.  (e.g. the thread racing with
the exec thread just now unblocked the signal and dequeued it.)  IIRC it
was the biggest reason we wanted to revisit the whole MT exec plan.

> We can change __group_complete_signal/zap_other_threads so that they won't
> do sigaddset(), just signal_wake_up(). But in that case dequeue_signal()
> and recalc_signal() should take signal_group_exit into account...

I'd like to revisit the use of "fake" SIGKILL for group exits.  That goes
well with a rethink of MT exec.  But let's not get into all of that right now.


Thanks,
Roland
