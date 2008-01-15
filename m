Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbYAOMrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbYAOMrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYAOMrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:47:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33675 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYAOMrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:47:33 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1200400787.5887.129.camel@johannes.berg>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>  <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>  <1200307896.5887.42.camel@johannes.berg>
	 <1200393685.5887.113.camel@johannes.berg> <1200399661.26045.13.camel@twins>
	 <1200400787.5887.129.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 13:47:25 +0100
Message-Id: <1200401245.26045.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 13:39 +0100, Johannes Berg wrote:
> > > To make sure now:
> > > 	same key - different name	- BAD
> > > 	same key - same name		- OK
> > > 	different key - same name	- OK
> > 
> > Strictly speaking one can do that, although I would recommend against it
> > - it leads to confusion as to which lock got into trouble when looking
> > at lockdep/stat output.
> 
> True, but I don't see a good way to avoid that. Similar things also
> happen with
> 
> 	mutex_init(&priv->mtx);
> 
> for example, no?

Yeah, it happens, I tend to 'fix' them when I encounter it though,
sometimes by just slightly altering the expression. It helps when
grepping the tree.

> > > mac80211 for example wants to allocate a (single-threaded) workqueue for
> > > each hardware that is plugged in and wants to call it by the hardware
> > > name.
> > 
> > Right, that would require a new key for each instance.
> 
> Except, how could I do that though? Keys are required to be static, so I
> can't have the object as the key. In any case, I don't think it matters
> much because the workqueues are per-hardware but all have similar users,
> I think that the other users here probably behave similarly.

Yeah, I think so too, but never underestimate the creativity of driver
authors:-)

> > > If you think the patch is a correct way to solve the problem I'll submit
> > > it formally and it should then be included in 2.6.24 to avoid
> > > regressions with the workqueue API (the workqueue lockup detection was
> > > merged early in 2.6.24.)
> > 
> > The patch looks ok, one important thing to note is that it means that
> > all workqueues instantiated by the same __create_workqueue() call-site
> > share lock dependency chains - I'm unsure if that might get us into
> > trouble or not.
> 
> It doesn't seem to have so far ;) I don't think it should. If some code
> allocates a per-instance workqueue that's much like having an inode lock
> or so.

We had to split up the inode lock to per filesystem classes, just
because the lock chains were conflicting between them...

> > Me and Ingo :-)
> 
> Alright, I'll write a patch description and send it in a minute.

Great, thanks for the effort.

