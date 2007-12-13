Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbXLMVWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbXLMVWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbXLMVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:22:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbXLMVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:22:34 -0500
Date: Thu, 13 Dec 2007 13:21:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Changli Gao" <xiaosuo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: file descriptors leak when sys_pipe failed with -EFAULT
Message-Id: <20071213132148.8f18a107.akpm@linux-foundation.org>
In-Reply-To: <412e6f7f0712130434h93ce8ffi9f7d91ea1589f84c@mail.gmail.com>
References: <412e6f7f0712130434h93ce8ffi9f7d91ea1589f84c@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 20:34:11 +0800
"Changli Gao" <xiaosuo@gmail.com> wrote:

> If an invalid address is passed to system call pipe as argument, file
> descriptors will leak.

Yup.  I added linux-kernel to cc.

> System call pipe is implemented as following on most architectures:
> 
>     int fd[2];
>     int error;
> 
>     error = do_pipe(fd);
>     if (!error) {
>         if (copy_to_user(fildes, fd, 2*sizeof(int)))
>             error = -EFAULT;
>     }
>     return error;
> 
> Invalid memory address makes copy_to_user failed. But the descriptors
> allocated for the pipe will be left open.
> A workaround fix will be like this:
> 
>     int fd[2];
>     int error;
> 
>     error = do_pipe(fd);
>     if (!error) {
>         if (copy_to_user(fildes, fd, 2*sizeof(int))) {
>             sys_close(fd[0]);
>             sys_close(fd[1]);
>             error = -EFAULT;
>         }
>     }
>     return error;
> 
> I don't understand the others architectures(such as
> sh/sh64/mips/sparc/sparc64)  which implement pipe in the other ways,
> so I just indicate this bug and provide my fixing way instead of
> patching it.

The consequences of this are that the application may eventually run out of
file descriptors and they will be cleaned up when the application exits
anyway, so it isn't terribly serious.

However it does seem fairly dumb of us to leave the fds open given that
at least one or possibly both of the file descriptors are unknown to the
application anyway.  Probably it'd be better to close them off immediately.

This would be an application-visible change: subsequent open()s will return
lower-numbered descriptors than they do at present.  That shouldn't matter.
