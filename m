Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbXKNHdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbXKNHdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXKNHd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:33:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXKNHd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:33:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sigwait eats blocked default-ignore signals
In-Reply-To: Oleg Nesterov's message of  Tuesday, 13 November 2007 18:56:38 +0300 <20071113155638.GB74@tv-sign.ru>
References: <20071112234155.783744D04C9@magilla.localdomain>
	<20071113155638.GB74@tv-sign.ru>
X-Zippy-Says: Were these parsnips CORRECTLY MARINATED in TACO SAUCE?
Message-Id: <20071114073249.CEECC26F8B6@magilla.localdomain>
Date: Tue, 13 Nov 2007 15:32:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But I suspect we have other issues here. Let's suppose we have threads T1
> (main) and T2. T2 blocks SIGCHLD and does sigwait(SIGCHLD).
> 
> Now, we send SIGCHLD to the thread group. The signal is lost again because
> sig_ignored() returns true on T1's side.
> 
> Is this OK? [...]

Yes, it's OK if T1 has SIGCHLD unblocked.  When there are multiple threads
that either don't block the signal or are in sigwait for it, then it can go
to any of them and there are no guarantees at all about which.  So we
simply say that the signal went to the thread not in sigwait that has that
signal unblocked (T1).  When it got there, it was ignored.  The user
semantics are equivalent even if that thread never actually woke and
dequeued the signal to ignore it.

> I think __group_send_sig_info() shouldn't use sig_ignored() at
> all. Instead, we should split __group_complete_signal() into 2
> functions. The first one, say, choose_target() shoud be used instead. The
> second one, handle_fatal_signal() can also be used by tkill() and
> friends.

I will probably like any reorganization of the code that makes it cleaner.
But we don't need to change the behavior in this regard.  The most common
path is __group_send_sig_info (from sys_kill), so it would be a shame to
remove the short-circuit optimization there.  In fact, it is probably wrong
semantics to do so (for what applications expect, and possibly for POSIX
conformance).  That is, an unblocked, ignored (or default-ignore) signal
should not set TIF_SIGPENDING and interrupt a system call in progress or
just about to start.  Obviously this is not a huge problem, since that's
what happens under any debugger.  But still, an undesireable change of
semantics as well as de-optimization, I'd say.


Thanks,
Roland
