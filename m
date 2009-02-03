Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZBCULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZBCULi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZBCULa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:11:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbZBCUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:11:29 -0500
Date: Tue, 3 Feb 2009 12:10:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mingo@elte.hu, davem@davemloft.net
Subject: Re: [patch 2/6] epoll keyed wakeups v2 - introduce new *_poll()
 wakeup macros
Message-Id: <20090203121041.23d440be.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0902031116500.23050@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13601.1233518664.2>
	<20090203001401.cc960d4e.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902031011380.23050@alien.or.mcafeemobile.com>
	<alpine.DEB.1.10.0902031116500.23050@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 11:20:46 -0800 (PST)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Tue, 3 Feb 2009, Davide Libenzi wrote:
> 
> > On Tue, 3 Feb 2009, Andrew Morton wrote:
> > 
> > > On Sun, 01 Feb 2009 12:04:23 -0800 Davide Libenzi <davidel@xmailserver.org> wrote:
> > > 
> > > > +#define wake_up_nested_poll(x, m, s)					\
> > > > +do {									\
> > > > +	unsigned long flags;						\
> > > > +									\
> > > > +	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
> > > > +	wake_up_locked_poll(x, m);					\
> > > > +	spin_unlock_irqrestore(&(x)->lock, flags);			\
> > > > +} while (0)
> > > 
> > > I had to go and find the callsite to work out the type of `x' :(
> > > 
> > > - this macro can be passed the address of any structure which has a
> > >   `spinlock_t lock;' in it, which seems strange.
> > > 
> > > - It references its first arg three times.
> > > 
> > > Is there any reason why we can't implement this in C?  
> > 
> > I don't see any reason why these two couldn't be normal functions (I 
> > just referenced wake_up_nested(), that was a macro in the first place). 
> 
> Actually reading the comments helps :) It triggers an include-hell, if you 
> make them inline. Since they're lockdep debug thingies, I think it's kinda 
> wasted turn them into non-inline real functions, so they'd better remain 
> macros IMO.
> 

ho hum.  I think it'd be worth at least renaming the arguments to
something less daft, for readability reasons.

One could also do

do {
	wait_queue_head_t *__wqh = x;
	<use __wqh>
}

which would provide typechecking of the first arg (so people can no
longer "pass the address of any structure which has a `spinlock_t
lock;' in it") and which fixes the multiple-references-to-an-argument
issue.


