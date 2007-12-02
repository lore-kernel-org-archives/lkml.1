Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbXLBU1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbXLBU1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbXLBU1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:27:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbXLBU1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:27:37 -0500
Date: Sun, 2 Dec 2007 12:26:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Simon Holm Th?gersen <odie@cs.aau.dk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fix the long standing exec vs kill race
In-Reply-To: <20071202171805.GA14701@tv-sign.ru>
Message-ID: <alpine.LFD.0.9999.0712021218290.8458@woody.linux-foundation.org>
References: <20071202151454.GA13180@tv-sign.ru> <1196615193.5698.8.camel@odie.local> <20071202171805.GA14701@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Dec 2007, Oleg Nesterov wrote:
> 
> exec() from the signal handler doesn't do sys_sigreturn(), so we don't unblock
> the signal, and it remains blocked after exec().
> 
> Hmm. Is this linux bug, or application bug?

I think that's an application bug.

The kernel does the obvious (and required) thing: it preserves the 
list of blocked signals over the execve(). And if you call execve() from 
within a signal handler, that list of blocked signals will obviously 
include the signals that got blocked by the execution of the signal 
itself.

(Side note: I also suspect that the program is not strictly POSIX 
conforming, and that execve() isn't in the list of functions that are safe 
to call from a signal handler in the first place, but that's a totally 
separate issue).

So if havign the signal blocked isn't what the application wants, I'd 
suggest one of:
 - just set the signal mask by hand to whatever mask you want (perhaps 
   also marking the signal handler with SIGIGN or SIGDFL or whatever)
 - alternatively, if you control the program being execve'd, just do it in 
   that progam instead.
 - use siglongjmp in the signal handler to get out of the signal handler 
   context and do it that way.
 - use a "sigatomic_t" flag, set it in the signal handler, and then do the 
   execve() in the main loop if it's set.

The last one is the safest one in many ways (since it doesn't care if you 
get a hundred of those signals in close succession - and you could also 
make it a counter or something if you want to actually count those 
things).

		Linus
