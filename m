Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbXLBSBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbXLBSBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXLBSA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:00:57 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:37565 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbXLBSA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:00:57 -0500
Subject: Re: [PATCH 0/2] fix the long standing exec vs kill race
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071202171805.GA14701@tv-sign.ru>
References: <20071202151454.GA13180@tv-sign.ru>
	 <1196615193.5698.8.camel@odie.local>  <20071202171805.GA14701@tv-sign.ru>
Content-Type: text/plain; charset=utf-8
Date: Sun, 02 Dec 2007 19:08:21 +0100
Message-Id: <1196618901.5698.23.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


søn, 02 12 2007 kl. 20:18 +0300, skrev Oleg Nesterov:
> On 12/02, Simon Holm Th?gersen wrote:
> > 
> > s??n, 02 12 2007 kl. 18:14 +0300, skrev Oleg Nesterov:
> > > 
> > > Please comment, I think at least the idea is promising.
> > > 
> > I have an issue that sounds related, but I might be completely off. I
> > would expect the simple attached program to keep receiving the same
> > signal, i.e. respond to
> > 	killall signal-exec -s SIGHUP
> > 
> > I tried your patches, but they didn't help.
> > 
> > Any ideas?
> > 
> > 
> > Simon Holm Th??gersen
> 
> > #include <signal.h>
> > #include <stdio.h>
> > #include <unistd.h>
> > 
> > static char **argv_;
> > 
> > static void handler(int signal)
> > {
> > 	printf("got signal %d\n", signal);
> > 	execv(argv_[0], argv_);
> > }
> > 
> > int main(int argc, char *argv[])
> > {
> > 	printf("spawned\n");
> > 	argv_ = argv;
> > 	if (signal(SIGTERM, handler) == SIG_ERR)
> > 		err(1, "could not set signal handler for SIGTERM");
> > 	if (signal(SIGHUP, handler) == SIG_ERR)
> > 		err(1, "could not set signal handler for SIGTERM");
> > 	sleep(60);
> > 	return 0;
> > }
> > 
> 
> I think this is another issue which should be solved (?).
> 
> exec() from the signal handler doesn't do sys_sigreturn(), so we don't unblock
> the signal, and it remains blocked after exec().
> 
> Hmm. Is this linux bug, or application bug?

Good question. I haven't been able to find something in the
documentation for execve(2) and signal(2) saying it shouldn't be
possible, and it works on Solaris 10, so I'd say it is a Linux bug.
Actually, having another look at the documentation, signal(7) mentions
that POSIX.1-2003 requires that execve is safe to call from inside a
signal handler.


Simon Holm Thøgersen

