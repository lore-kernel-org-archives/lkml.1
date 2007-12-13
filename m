Return-Path: <linux-kernel-owner+w=401wt.eu-S1765158AbXLMVuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765158AbXLMVuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933249AbXLMVu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:50:26 -0500
Received: from brick.kernel.dk ([87.55.233.238]:3220 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933200AbXLMVuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:50:25 -0500
Date: Thu, 13 Dec 2007 22:50:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: file descriptors leak when sys_pipe failed with -EFAULT
Message-ID: <20071213215020.GD19673@kernel.dk>
References: <412e6f7f0712130434h93ce8ffi9f7d91ea1589f84c@mail.gmail.com> <20071213132148.8f18a107.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213132148.8f18a107.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13 2007, Andrew Morton wrote:
> On Thu, 13 Dec 2007 20:34:11 +0800
> "Changli Gao" <xiaosuo@gmail.com> wrote:
> 
> > If an invalid address is passed to system call pipe as argument, file
> > descriptors will leak.
> 
> Yup.  I added linux-kernel to cc.
> 
> > System call pipe is implemented as following on most architectures:
> > 
> >     int fd[2];
> >     int error;
> > 
> >     error = do_pipe(fd);
> >     if (!error) {
> >         if (copy_to_user(fildes, fd, 2*sizeof(int)))
> >             error = -EFAULT;
> >     }
> >     return error;
> > 
> > Invalid memory address makes copy_to_user failed. But the descriptors
> > allocated for the pipe will be left open.
> > A workaround fix will be like this:
> > 
> >     int fd[2];
> >     int error;
> > 
> >     error = do_pipe(fd);
> >     if (!error) {
> >         if (copy_to_user(fildes, fd, 2*sizeof(int))) {
> >             sys_close(fd[0]);
> >             sys_close(fd[1]);
> >             error = -EFAULT;
> >         }
> >     }
> >     return error;
> > 
> > I don't understand the others architectures(such as
> > sh/sh64/mips/sparc/sparc64)  which implement pipe in the other ways,
> > so I just indicate this bug and provide my fixing way instead of
> > patching it.
> 
> The consequences of this are that the application may eventually run out of
> file descriptors and they will be cleaned up when the application exits
> anyway, so it isn't terribly serious.
> 
> However it does seem fairly dumb of us to leave the fds open given that
> at least one or possibly both of the file descriptors are unknown to the
> application anyway.  Probably it'd be better to close them off immediately.

I agree with the solution, closing the descriptors that do_pipe() opened
is clearly the right thing to do.

> This would be an application-visible change: subsequent open()s will return
> lower-numbered descriptors than they do at present.  That shouldn't matter.

I don't think that is a concern in this case :)

-- 
Jens Axboe

