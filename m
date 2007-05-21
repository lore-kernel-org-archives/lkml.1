Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbXEUE3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbXEUE3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbXEUE3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:29:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652AbXEUE33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:29:29 -0400
Date: Sun, 20 May 2007 21:26:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Davi Arnaut <davi@haxent.com.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signalfd: retrieve multiple signals with one read()
 call
Message-Id: <20070520212627.398ffd23.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705202112230.22011@alien.or.mcafeemobile.com>
References: <464F912F.3040205@haxent.com.br>
	<20070520210210.9a895eec.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705202112230.22011@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 21:14:38 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Sun, 20 May 2007, Andrew Morton wrote:
> 
> > If 'count' is not a multiple of sizeof(struct signalfd_siginfo)), the read()
> > will return the next smallest multiple of `count'.
> > 
> > That is, unless `count' happens to be less than 1*sizeof(struct
> > signalfd_siginfo)), in which case we return -EINVAL.
> > 
> > This seems inconsistent.
> 
> I think it fits the rule "buffer must be big enough for at least one sigingo".
> We use the special return 0; as indicator that the process we were 
> monitoring signals, detached the sighand.
> 

hm.  Kernel violates proper read() semantics in many places.  Looks like we
just did it again.

> 
> > Also, I'm desperately hunting for the place where we zero out that local
> > siginfo_t, and I ain't finding it.  Someone please convince me that we're
> > not leaking bits of kernel memory out to userspace in that thing.
> 
> Hmm, __clear_user()?

oic, yes, that thing.  Usually we'd zero out the on-stack struct, assemble
it then copy out the whole thing.  I guess doing it the way you have saves
a few instructions.  But it's the cache hit against *uinfo which will have
most of the cost, and we can't do anything about that.

Unless we just remove the __clear_user() altogether.  Who said that "Unused
memebers should be zero"?

