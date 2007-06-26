Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXFZIzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXFZIzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXFZIy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:54:57 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:49653 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXFZIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:54:55 -0400
To: ebiederm@xmission.com
CC: davem@davemloft.net, viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <m1ir9eaahu.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [PATCH] fix race in AF_UNIX
References: <E1Hvo2m-00038P-00@dorka.pomaz.szeredi.hu>
	<20070605.224128.104032917.davem@davemloft.net>
	<E1HvqZB-0003Vc-00@dorka.pomaz.szeredi.hu>
	<20070607.184731.10907840.davem@davemloft.net>
	<E1HxgeN-0006Io-00@dorka.pomaz.szeredi.hu>
	<m17ipxfi9d.fsf@ebiederm.dsl.xmission.com>
	<E1I21IL-0004LH-00@dorka.pomaz.szeredi.hu> <m1ir9eaahu.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1I36oi-0002bb-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 Jun 2007 10:54:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Right.  But the devil is in the details, and (as you correctly point
> > out later) to implement this, the whole locking scheme needs to be
> > overhauled.  Problems:
> >
> >  - Using the queue lock to make the dequeue and the fd detach atomic
> >    wrt the GC is difficult, if not impossible: they are are far from
> >    each other with various magic in between.  It would need thorough
> >    understanding of these functions and _big_ changes to implement.
> >
> >  - Sleeping on u->readlock in GC is currently not possible, since that
> >    could deadlock with unix_dgram_recvmsg().  That function could
> >    probably be modified to release u->readlock, while waiting for
> >    data, similarly to unix_stream_recvmsg() at the cost of some added
> >    complexity.
> >
> >  - Sleeping on u->readlock is also impossible, because GC is holding
> >    unix_table_lock for the whole operation.  We could release
> >    unix_table_lock, but then would have to cope with sockets coming
> >    and going, making the current socket iterator unworkable.
> >
> > So theoretically it's quite simple, but it needs big changes.  And
> > this wouldn't even solve all the problems with the GC, like being a
> > possible DoS vector.
> 
> Making the GC fully incremental will solve the DoS vector problem as
> well.  Basically you do a fixed amount of reclaim in the new socket
> allocation code.

And I think incremental GC algorithms are much too complex for this
task.  What I've realized, is that in fact we don't require a generic
garbage collection algorithm, just a much more specialized cycle
collection algorithm, since refcounting in struct file takes care of
the rest.

This would help with localizing the problem to the problematic sockets
(which have an in-flight unix socket), instead of having to blindly
traverse _all_ unix sockets in the system.

I'll look at reimplementing the GC with such an algorithm.

> It appears clear that since we can't stop the world and garbage
> collect we need an incremental collector.

Constraining ourselves to stopping unix sockets from going in flight
or coming out of flight during garbage collection should be OK I
think.  There's still a possibility of a DoS there, but it would only
be able to affect _very_ few applications.

Miklos
