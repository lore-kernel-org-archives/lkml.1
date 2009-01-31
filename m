Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZAaEBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZAaEBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 23:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZAaEBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 23:01:40 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:55756 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZAaEBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 23:01:40 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Jan 2009 20:01:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
 macros
In-Reply-To: <alpine.LFD.2.00.0901301949110.3150@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901301951540.31741@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <alpine.LFD.2.00.0901301949110.3150@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Linus Torvalds wrote:

> > I chose to add an initial 'k' to the original names, instead of adding
> > a whole "_key", since the name of some of those macros is becoming
> > awfully long. No problem in using the "_key" naming, if others feel it.
> > Comments?
> 
> That whole "kwake" thing makes me just think mis-spelling, so it does need 
> to change. 
> 
> But even more I dislike the notion of this being a "key". It's not. It's 
> about poll events, nothing more. So renaming it to "_key()" in no way 
> helps.
> 
> Yes, _internally_ we send that "void *key" around, and then leave it to 
> lower levels to agree about how it is used, but at the level _you_ then 
> use it, that is no longer the case. When you do a 
> 
> 	kwake_up_interruptible(&tty->write_wait, POLLOUT);
> 
> that has _nothing_ to do with "keys" any more. So the 'k' prefix is wrong 
> and really odd-looking, but a '_key' postfix wouldn't be much better 
> either. Because when you pass in POLLOUT, you're not using it as a key, 
> you are very much using it as a poll-specific thing.
> 
> So the naming should match that. I suspect a '_poll' postfix (or a 'poll_' 
> prefix would work and make sense.

As I said in the patch, I'm really ok with any naming. Adding another 
pre/suf-fix seemed to render names a little on the long side, hence the 
'k' choice.




> So apart from that hating, I think the internal implementation and the use 
> of the existing 'key' parameter is fairly sane. The only downside is that 
> we've now really used up that key thing for something very epoll-specific, 
> but I don't see any better use for it, so I guess that's not a big 
> downside.
> 
> Oh, and numbers, please. How big of a win is this, really? Preferably with 
> something that really uses epoll for something real.

Will try to see if I can come up with something, although is not really 
easy to simulate what can happen in a real life scenario.
What happens today is that if you're waiting for POLLOUT, say in a socket, 
a new incoming packet will trigger a wakeup, epoll has to check the 
ready-list, call f_op->poll, verify that the event doesn't match the 
interest, and go back to sleep. Same if it was waiting for POLLIN, and 
write-space was triggered.



- Davide


