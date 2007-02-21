Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbXBUAwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbXBUAwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXBUAwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:52:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49180 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXBUAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:52:49 -0500
Date: Wed, 21 Feb 2007 09:51:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@tv-sign.ru, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, mtk-manpages@gmx.net
Subject: Re: [PATCH] fix handling of SIGCHILD from reaped child
Message-Id: <20070221095151.63878ec8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070220231007.29FB81800E4@magilla.sf.frob.com>
References: <20070220172049.GA67@tv-sign.ru>
	<20070220231007.29FB81800E4@magilla.sf.frob.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 15:10:07 -0800 (PST)
Roland McGrath <roland@redhat.com> wrote:

> I'm usually the stickler for anal POSIX compliance, but this is one thing
> that I did notice a while ago, realized Linux had never done it, and
> decided I didn't care.
> 
Okay, I don't think this is a big trouble.

> This is one of those parts of the standard that was originally written in a
> single-threaded process frame of mind, and was never amended or clarified
> later when multi-threaded semantics got well-specified in the standard.
> 
> It's clear what the requirement is trying to achieve.  It lets you have a
> SIGCHLD signal handler that calls wait, and be sure its call never blocks,
> as long as you block SIGCHLD while making any other wait calls.  But Linux
> has never done this even for single-threaded processes, so existing
> application code already has to cope with the race.  (Anyway, this
> guarantee is not all that helpful if you have more than one child and so
> might be running the handler once after SIGCHLD was generated more than
> once.  You can't just use WNOHANG in your handler because you aren't
> actually guaranteed that the zombie is ready already when you get the SIGCHLD.)
> 
> This guarantee is not of any use when there might be other threads with
> SIGCHLD unblocked or other threads that call wait* functions (calls that
> draw from the same pool of PIDs anyway).  There can always be another
> thread that just dequeued the SIGCHLD but hasn't gotten into its handler
> yet, so clearing the pending SIGCHLD doesn't really cover it.
> 
> Unhelpful as it is the multithreaded context, I think it's clear that the
> standard's wording means "when SIGCHLD is blocked by the thread calling
> wait", but in fact as to being a guarantee it's only meaningful when
> SIGCHLD is blocked by all threads.  The mention of blocking the signal is
> only there to remind you that well-defined semantics about a "pending"
> signal only ever apply when the signal is blocked.  If any thread has it
> unblocked, then "pending" is an ephemeral condition not necessarily
> observable at all--as soon as you could say it's pending, some such thread
> might be handling it.
> 
> The "if there is another child available" test is rather ugly to do
> correctly now.  It would be less so if the children list moved into
> signal_struct and was just shared directly.  The most "correct" it can get
> is still not all that useful in a multithreaded context.  So I'm pretty
> ambivalent about bothering with this.
> 
Hmm, okay. It seems a good workaround to say "please use WNOHANG always in
your SIGCHLD handler's wait*() call" 

My only concerns is that LSB people say wait/waitpid meets SUSv3. 

Thanks,
-Kame

