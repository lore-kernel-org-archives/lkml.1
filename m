Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXEaXVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXEaXVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXEaXVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:21:08 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbXEaXVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:21:07 -0400
Date: Thu, 31 May 2007 16:20:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
Message-Id: <20070531162021.4cd4e91a.akpm@linux-foundation.org>
In-Reply-To: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 14:09:15 -0400
Ulrich Drepper <drepper@redhat.com> wrote:

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
> 
> ...
>
> diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
> index c154b9d..b847741 100644
> --- a/include/asm-generic/fcntl.h
> +++ b/include/asm-generic/fcntl.h
> @@ -48,6 +48,9 @@
>  #ifndef O_NOATIME
>  #define O_NOATIME	01000000
>  #endif
> +#ifndef O_CLOEXEC
> +#define O_CLOEXEC	02000000	/* set close_on_exec */
> +#endif
>  #ifndef O_NDELAY
>  #define O_NDELAY	O_NONBLOCK
>  #endif

This will break xtensa, because that architecture (and only that
architecture) doesn't include asm-generic/fcntl.h from asm/fcntl.h.

But let's leave this patch as-is: it's xtensa which needs fixing.

