Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYEMSHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYEMSHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYEMSHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:07:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56278 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbYEMSHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:07:47 -0400
Date: Tue, 13 May 2008 11:05:09 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, stable@kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dm.n9107@gmail.com
Subject: Re: [stable] [PATCH] file descriptor leak in sys_pipe
Message-ID: <20080513180509.GB4077@kroah.com>
References: <200805050921.m459LvhU007242@devserv.devel.redhat.com> <20080505193425.9b913e43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505193425.9b913e43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 07:34:25PM -0700, Andrew Morton wrote:
> On Mon, 5 May 2008 05:21:57 -0400 Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > DM <dm.n9107@gmail.com> wrote:
> > > I realize this code is old, but wouldn't file descriptors leak if
> > > copy_to_user fails?
> > 
> > I think you're right.  The following should patch it for the remaining
> > C implementations which need that kind of patch.
> > 
> > 
> > Signed-off-by: Ulrich Drepper <drepper@redhat.com>
> > 
> > diff --git a/arch/cris/kernel/sys_cris.c b/arch/cris/kernel/sys_cris.c
> > index 8b99841..d124066 100644
> > --- a/arch/cris/kernel/sys_cris.c
> > +++ b/arch/cris/kernel/sys_cris.c
> > @@ -40,8 +40,11 @@ asmlinkage int sys_pipe(unsigned long __user * fildes)
> >          error = do_pipe(fd);
> >          unlock_kernel();
> >          if (!error) {
> > -                if (copy_to_user(fildes, fd, 2*sizeof(int)))
> > +                if (copy_to_user(fildes, fd, 2*sizeof(int))) {
> > +			sys_close(fd[0]);
> > +			sys_close(fd[1]);
> >                          error = -EFAULT;
> > +		}
> >          }
> >          return error;
> >  }
> > diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
> > index 6d7a80f..319c797 100644
> > --- a/arch/m32r/kernel/sys_m32r.c
> > +++ b/arch/m32r/kernel/sys_m32r.c
> > @@ -90,8 +90,11 @@ sys_pipe(unsigned long r0, unsigned long r1, unsigned long r2,
> >  
> >  	error = do_pipe(fd);
> >  	if (!error) {
> > -		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int)))
> > +		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int))) {
> > +			sys_close(fd[0]);
> > +			sys_close(fd[1]);
> >  			error = -EFAULT;
> > +		}
> >  	}
> >  	return error;
> >  }
> > diff --git a/fs/pipe.c b/fs/pipe.c
> > index 3499f9f..ec228bc 100644
> > --- a/fs/pipe.c
> > +++ b/fs/pipe.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/highmem.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/audit.h>
> > +#include <linux/syscalls.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/ioctls.h>
> > @@ -1086,8 +1087,11 @@ asmlinkage long __weak sys_pipe(int __user *fildes)
> >  
> >  	error = do_pipe(fd);
> >  	if (!error) {
> > -		if (copy_to_user(fildes, fd, sizeof(fd)))
> > +		if (copy_to_user(fildes, fd, sizeof(fd))) {
> > +			sys_close(fd[0]);
> > +			sys_close(fd[1]);
> >  			error = -EFAULT;
> > +		}
> >  	}
> >  	return error;
> >  }
> 
> OK.
> 
> Unfortunately the sys_pipe() code has changed a lot since 2.6.25 so if we
> wish to backport this fix into earlier kernels, it will need to be largely
> reimplemented.
> 
> What are the implications of the bug?  An errant applicaiton can exhaust
> its own fd table and eventually won't be able to open more files.  This
> gets fixed up when the application exits.  I don't think there are any
> worse implications?
> 
> In which case 2.6.25.x and earlier can perhaps live without the fix.

As the code is so different in 2.6.25.x, I can't see how to apply this
fix there, so I'll just not worry about it for now.

thanks,

greg k-h
