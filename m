Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbXEaSfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbXEaSfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbXEaSfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:35:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2500 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845AbXEaSfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:35:15 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 31 May 2007 11:35:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
In-Reply-To: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Ulrich Drepper wrote:

> I've brought this topic up before but didn't provide a patch.  Well, here
> we go again, this time with a patch.  I even throw in a test program.
> 
> The problem is as follows: in multi-threaded code (or more correctly: all
> code using clone() with CLONE_FILES) we have a race when exec'ing.
> 
>    thread #1                       thread #2
> 
>    fd=open()
> 
>                                    fork + exec
> 
>   fcntl(fd,F_SETFD,FD_CLOEXEC)
> 
> In some applications this can happen frequently.  Take a web browser.  One
> thread opens a file and another thread starts, say, an external PDF viewer.
> The result can even be a security issue if that open file descriptor refers
> to a sensitive file and the external program can somehow be tricked into
> using that descriptor.
> 
> Just adding O_CLOEXEC support to open() doesn't solve the whole set of
> problems.  There are other ways to create file descriptors (socket,
> epoll_create, Unix domain socket transfer, etc).  These can and should
> be addressed separately though.  open() is such an easy case that it makes
> not much sense putting the fix off.

Isn't this better be a global process flag? Default should be, for legacy
reasons, !FD_CLOEXEC. But then you can call a sys_task_set_fflags(FD_CLOEXEC)
and all newly created files get that behavior by default. Then, in case 
you want some of them to cross the exec boundary, you explicitly
fcntl(fd, F_SETFD, !FD_CLOEXEC).
Most the MT+exec apps I write, would like FD_CLOEXEC for everything anyway.



- Davide


