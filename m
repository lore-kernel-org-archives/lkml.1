Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXB0QDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXB0QDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933070AbXB0QDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:03:55 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2419 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063AbXB0QDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:03:54 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Feb 2007 08:03:53 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] epoll reduced (to 1) number of passes over the ready
 set ...
In-Reply-To: <200702271015.33123.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0702270802140.5315@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702261819250.4949@alien.or.mcafeemobile.com>
 <200702271015.33123.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007, Eric Dumazet wrote:

> On Tuesday 27 February 2007 03:32, Davide Libenzi wrote:
> > Epoll is doing multiple passes over the ready set at the moment, because
> > of the constraints over the f_op->poll() call. Looking at the code again,
> > I noticed that we already hold the epoll semaphore in read, and this
> > (together with other locking conditions that hold while doing an
> > epoll_wait()) can lead to a smarter way to "ship" events to userspace (in
> > a single pass). I added more (even) more comments to the code to explain
> > the conditions why certain operations are safe.
> > This is a stress application that can be used to test the new code. It
> > spwans multiple thread and call epoll_wait() and epoll_ctl() from many
> > threads. Stress tested on my dual Opteron 254 w/out any problems.
> 
> Davide,
> 
> This is really cool, because the size of epitem would fit now in 128 bytes 
> instead of 192 (on x86_64 platforms). So we also reduce memory usage.

Yeah, I forgot to mention that I removed the txlink member.



> I have one comment :
> 
> >  	 */
> > -	list_for_each(lnk, txlist) {
> > -		epi = list_entry(lnk, struct epitem, txlink);
> > +	for (eventcnt = 0; !list_empty(txlist) && eventcnt < maxevents;) {
> > +		epi = list_entry(txlist->next, struct epitem, rdllink);
> 
> Now that we scan the rdllist list once, it may be usefull to use a prefetch() 
> hint. 
> 
> list_for_each() has one prefetch(pos->next) automatically included, but not 
> your open coded loop.
> 
> I suggest adding after epi = list_entry(txlist->next, struct epitem, rdllink);
> prefetch(epi->rdllink.next);

Will do in the next version, thx!



- Davide


