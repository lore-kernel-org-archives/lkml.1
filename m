Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbXLBRRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbXLBRRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXLBRRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:17:40 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60248 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXLBRRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:17:40 -0500
Date: Sun, 2 Dec 2007 20:18:05 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Simon Holm Th?gersen <odie@cs.aau.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fix the long standing exec vs kill race
Message-ID: <20071202171805.GA14701@tv-sign.ru>
References: <20071202151454.GA13180@tv-sign.ru> <1196615193.5698.8.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196615193.5698.8.camel@odie.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02, Simon Holm Th?gersen wrote:
> 
> s??n, 02 12 2007 kl. 18:14 +0300, skrev Oleg Nesterov:
> > 
> > Please comment, I think at least the idea is promising.
> > 
> I have an issue that sounds related, but I might be completely off. I
> would expect the simple attached program to keep receiving the same
> signal, i.e. respond to
> 	killall signal-exec -s SIGHUP
> 
> I tried your patches, but they didn't help.
> 
> Any ideas?
> 
> 
> Simon Holm Th??gersen

> #include <signal.h>
> #include <stdio.h>
> #include <unistd.h>
> 
> static char **argv_;
> 
> static void handler(int signal)
> {
> 	printf("got signal %d\n", signal);
> 	execv(argv_[0], argv_);
> }
> 
> int main(int argc, char *argv[])
> {
> 	printf("spawned\n");
> 	argv_ = argv;
> 	if (signal(SIGTERM, handler) == SIG_ERR)
> 		err(1, "could not set signal handler for SIGTERM");
> 	if (signal(SIGHUP, handler) == SIG_ERR)
> 		err(1, "could not set signal handler for SIGTERM");
> 	sleep(60);
> 	return 0;
> }
> 

I think this is another issue which should be solved (?).

exec() from the signal handler doesn't do sys_sigreturn(), so we don't unblock
the signal, and it remains blocked after exec().

Hmm. Is this linux bug, or application bug?

Oleg.

