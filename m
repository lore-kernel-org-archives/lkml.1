Return-Path: <linux-kernel-owner+w=401wt.eu-S1161057AbXBTXKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161057AbXBTXKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161065AbXBTXKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:10:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161057AbXBTXKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:10:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [PATCH] fix handling of SIGCHILD from reaped child
In-Reply-To: Oleg Nesterov's message of  Tuesday, 20 February 2007 20:20:49 +0300 <20070220172049.GA67@tv-sign.ru>
X-Shopping-List: (1) Chic competent expectation inquisitions
   (2) Exotic Ritz Cracker Crumbs
   (3) Neoclassical redeemer dividers
Message-Id: <20070220231007.29FB81800E4@magilla.sf.frob.com>
Date: Tue, 20 Feb 2007 15:10:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm usually the stickler for anal POSIX compliance, but this is one thing
that I did notice a while ago, realized Linux had never done it, and
decided I didn't care.

This is one of those parts of the standard that was originally written in a
single-threaded process frame of mind, and was never amended or clarified
later when multi-threaded semantics got well-specified in the standard.

It's clear what the requirement is trying to achieve.  It lets you have a
SIGCHLD signal handler that calls wait, and be sure its call never blocks,
as long as you block SIGCHLD while making any other wait calls.  But Linux
has never done this even for single-threaded processes, so existing
application code already has to cope with the race.  (Anyway, this
guarantee is not all that helpful if you have more than one child and so
might be running the handler once after SIGCHLD was generated more than
once.  You can't just use WNOHANG in your handler because you aren't
actually guaranteed that the zombie is ready already when you get the SIGCHLD.)

This guarantee is not of any use when there might be other threads with
SIGCHLD unblocked or other threads that call wait* functions (calls that
draw from the same pool of PIDs anyway).  There can always be another
thread that just dequeued the SIGCHLD but hasn't gotten into its handler
yet, so clearing the pending SIGCHLD doesn't really cover it.

Unhelpful as it is the multithreaded context, I think it's clear that the
standard's wording means "when SIGCHLD is blocked by the thread calling
wait", but in fact as to being a guarantee it's only meaningful when
SIGCHLD is blocked by all threads.  The mention of blocking the signal is
only there to remind you that well-defined semantics about a "pending"
signal only ever apply when the signal is blocked.  If any thread has it
unblocked, then "pending" is an ephemeral condition not necessarily
observable at all--as soon as you could say it's pending, some such thread
might be handling it.

The "if there is another child available" test is rather ugly to do
correctly now.  It would be less so if the children list moved into
signal_struct and was just shared directly.  The most "correct" it can get
is still not all that useful in a multithreaded context.  So I'm pretty
ambivalent about bothering with this.


Thanks,
Roland

