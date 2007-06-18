Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbXFRJ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbXFRJ4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbXFRJ4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:56:41 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:44127 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113AbXFRJ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:56:40 -0400
To: davem@davemloft.net
CC: akpm@linux-foundation.org, viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20070618.024807.45712241.davem@davemloft.net> (message from
	David Miller on Mon, 18 Jun 2007 02:48:07 -0700 (PDT))
Subject: Re: [PATCH] fix race in AF_UNIX
References: <E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu>
	<20070618.023520.102546505.davem@davemloft.net>
	<E1I0DmJ-0006yg-00@dorka.pomaz.szeredi.hu> <20070618.024807.45712241.davem@davemloft.net>
Message-Id: <E1I0Dx9-00071X-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 11:55:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Secondarily, this bug has been around for years and nobody noticed.
> > > The world will not explode if this bug takes a few more days or
> > > even a week to work out.  Let's do it right instead of ramming
> > > arbitrary turds into the kernel.
> > 
> > Fine, but just wishing a bug to get fixed won't accomplish anything.
> > I've spent a fair amount of time debugging this thing, and I'm out of
> > ideas.  Really.  So unless somebody steps up to look at this, it won't
> > _ever_ get fixed.
> 
> Somone just needs to find a way to only lock the socket as it is
> being operated upon.

No, you are still not getting it.  The problem is that the socket
needs to be locked for the _whole_ of the garbage collection.  This is
because the gc is done in two phases, in the first phase sockets which
are installed into file descriptors are collected as a "root set",
then the set is expanded by iterating over everything it's in there
and that's later added.  If a socket moves from in-flight to installed
_during_ the gc, then it can miss being collected.  So the socket must
be locked for the duration of _both_ phases.

> The race you are dealing with is rather simple, the queue check
> and the state check need to be done atomically.  The only chore
> is to find a way to make that happen in the context of what the
> garbage allocator is trying to do.
> 
> I'm not even convinced that your most recent attempt is deadlock free.
> Locking multiple objects the same way all at once like that is
> something that needs to be seriously audited.

It's doing trylocks and releasing all those locks within the same spin
locked region, how the f**k can that deadlock?

The only problem I've experienced with this patch (other than being
ugly) is that the multitude of locks it acquires makes the lockdep
code give up.  But I think we can live with that.

Miklos
