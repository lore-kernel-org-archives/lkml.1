Return-Path: <linux-kernel-owner+w=401wt.eu-S1767466AbXDFBYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767466AbXDFBYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767473AbXDFBYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:24:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767466AbXDFBYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:24:09 -0400
Date: Thu, 5 Apr 2007 18:24:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] epoll cleanups - epoll include diet ...
Message-Id: <20070405182407.a785b895.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704051806300.27713@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.19972.1175650506.1>
	<20070405175905.733705cf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704051806300.27713@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 18:12:58 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Thu, 5 Apr 2007, Andrew Morton wrote:
> 
> > epoll uses signal stuff and might need signal.h.  It implements syscalls
> > and it certainly needs to have those syscall's prototypes in scope.  It
> > surely uses stuff from mm.h (doesn't everything??)
> 
> Ack about signal.h, I forgot about the pwait code :(
> Why syscalls.h? The eventpoll.c file expots syscalls, but it doesn't use 
> anything declared in there.

So that the compiler can verify that our declarations of sys_epoll_foo()
match our definitions of them.

> What does eventpoll.c use *directly* from mm.h? If eventpoll.c uses, let's 
> say sched.h, and sched.h needs mm.h, it is sched.h responsibility to 
> include the mm.h file not eventpoll.c one.
> 

Sure.  But if epoll.c _does_ use something from mm.h (or uses something
from a header which mm.h includes) then if we later remove the #include
mm.h from sched.h, eventpoll.c will break.

The general rule is: include in .c the header files which provide the stuff
which that .c file uses.  Now, it maybe that eventpoll.c indeed uses nothing
which mm.h provides, and nothing which mm.h's includees provide.  But it is
non-trivial to prove that.  Once added, includes are hard to remove :(
