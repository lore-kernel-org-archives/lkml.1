Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXLBSx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXLBSx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXLBSxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:53:49 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:35839 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbXLBSxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:53:49 -0500
Date: Sun, 2 Dec 2007 21:52:37 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Simon Holm Th?gersen <odie@cs.aau.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fix the long standing exec vs kill race
Message-ID: <20071202185237.GA88@tv-sign.ru>
References: <20071202151454.GA13180@tv-sign.ru> <1196615193.5698.8.camel@odie.local> <20071202171805.GA14701@tv-sign.ru> <1196618901.5698.23.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196618901.5698.23.camel@odie.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02, Simon Holm Th?gersen wrote:
>
> s??n, 02 12 2007 kl. 20:18 +0300, skrev Oleg Nesterov:
> > On 12/02, Simon Holm Th?gersen wrote:
> > > 
> > > I have an issue that sounds related, but I might be completely off. I
> > > would expect the simple attached program to keep receiving the same
> > > signal, i.e. respond to
> > > 	killall signal-exec -s SIGHUP
> > > 
> > > I tried your patches, but they didn't help.
> > > 
> > > Any ideas?
> > > 
> > > 
> > > Simon Holm Th??gersen
> > 
> > > #include <signal.h>
> > > #include <stdio.h>
> > > #include <unistd.h>
> > > 
> > > static char **argv_;
> > > 
> > > static void handler(int signal)
> > > {
> > > 	printf("got signal %d\n", signal);
> > > 	execv(argv_[0], argv_);
> > > }
> > > 
> > > int main(int argc, char *argv[])
> > > {
> > > 	printf("spawned\n");
> > > 	argv_ = argv;
> > > 	if (signal(SIGTERM, handler) == SIG_ERR)
> > > 		err(1, "could not set signal handler for SIGTERM");
> > > 	if (signal(SIGHUP, handler) == SIG_ERR)
> > > 		err(1, "could not set signal handler for SIGTERM");
> > > 	sleep(60);
> > > 	return 0;
> > > }
> > > 
> > 
> > I think this is another issue which should be solved (?).
> > 
> > exec() from the signal handler doesn't do sys_sigreturn(), so we don't unblock
> > the signal, and it remains blocked after exec().
> > 
> > Hmm. Is this linux bug, or application bug?
> 
> Good question. I haven't been able to find something in the
> documentation for execve(2) and signal(2) saying it shouldn't be
> possible, and it works on Solaris 10, so I'd say it is a Linux bug.

Well, as I said, I don't know what would be the right behaviour,

> Actually, having another look at the documentation, signal(7) mentions
> that POSIX.1-2003 requires that execve is safe to call from inside a
> signal handler.

... but this doesn't look very clear to me.

- Linux can perfectly exec from inside a signal handler

- the application should know that the signal is blocked when the handler runs

- exec should preserve the ->blocked mask

So, is this really buggy? Do we break the "execve should be signal-safe" rule?
I don't know, but our CC: list is good ;)

Oleg.

