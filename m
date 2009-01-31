Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZAaDtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZAaDtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZAaDtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:49:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbZAaDtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:49:43 -0500
Date: Fri, 30 Jan 2009 19:49:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
In-Reply-To: <send-serie.davidel@xmailserver.org.16376.1233372317.3>
Message-ID: <alpine.LFD.2.00.0901301949110.3150@localhost.localdomain>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Davide Libenzi wrote:
>
> The following patch introduces new kwake_* macros that accepts an
> extra key parameter to be specified in the wakeup.

I really hate the naming.

> I chose to add an initial 'k' to the original names, instead of adding
> a whole "_key", since the name of some of those macros is becoming
> awfully long. No problem in using the "_key" naming, if others feel it.
> Comments?

That whole "kwake" thing makes me just think mis-spelling, so it does need 
to change. 

But even more I dislike the notion of this being a "key". It's not. It's 
about poll events, nothing more. So renaming it to "_key()" in no way 
helps.

Yes, _internally_ we send that "void *key" around, and then leave it to 
lower levels to agree about how it is used, but at the level _you_ then 
use it, that is no longer the case. When you do a 

	kwake_up_interruptible(&tty->write_wait, POLLOUT);

that has _nothing_ to do with "keys" any more. So the 'k' prefix is wrong 
and really odd-looking, but a '_key' postfix wouldn't be much better 
either. Because when you pass in POLLOUT, you're not using it as a key, 
you are very much using it as a poll-specific thing.

So the naming should match that. I suspect a '_poll' postfix (or a 'poll_' 
prefix would work and make sense.

So apart from that hating, I think the internal implementation and the use 
of the existing 'key' parameter is fairly sane. The only downside is that 
we've now really used up that key thing for something very epoll-specific, 
but I don't see any better use for it, so I guess that's not a big 
downside.

Oh, and numbers, please. How big of a win is this, really? Preferably with 
something that really uses epoll for something real.

		Linus
