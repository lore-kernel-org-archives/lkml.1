Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbYHHFcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbYHHFcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 01:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYHHFbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 01:31:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbYHHFbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 01:31:49 -0400
Date: Thu, 7 Aug 2008 22:31:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
Message-Id: <20080807223109.e67f46e4.akpm@linux-foundation.org>
In-Reply-To: <1218166760.17093.69.camel@raven.themaw.net>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
	<20080807114030.4142.76568.stgit@web.messagingengine.com>
	<20080807141041.e0d5cccc.akpm@linux-foundation.org>
	<1218166760.17093.69.camel@raven.themaw.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 11:39:19 +0800 Ian Kent <raven@themaw.net> wrote:

> 
> On Thu, 2008-08-07 at 14:10 -0700, Andrew Morton wrote:
> > On Thu, 07 Aug 2008 19:40:31 +0800
> > Ian Kent <raven@themaw.net> wrote:
> > >
> > > Subject: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
> > 
> > I fixed that spello
> > 
> > > Patch to add a miscellaneous device to the autofs4 module for routing
> > > ioctls. This provides the ability to obtain an ioctl file handle for
> > > an autofs mount point that is possibly covered by another mount.
> > > 
> > > The actual problem with autofs is that it can't reconnect to existing
> > > mounts. Immediately one things of just adding the ability to remount
> > > autofs file systems would solve it, but alas, that can't work. This is
> > > because autofs direct mounts and the implementation of "on demand mount
> > > and expire" of nested mount trees have the file system mounted on top of
> > > the mount trigger dentry.
> > > 
> > > To resolve this a miscellaneous device node for routing ioctl commands
> > > to these mount points has been implemented in the autofs4 kernel module
> > > and a library added to autofs. This provides the ability to open a file
> > > descriptor for these over mounted autofs mount points.
> > > 
> > > Please refer to Documentation/filesystems/autofs4-mount-control.txt for
> > > a discussion of the problem, implementation alternatives considered and
> > > a description of the interface.
> > > 
> > >
> > > ...
> > >
> > > +
> > > +#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
> > > +
> > > +typedef int (*ioctl_fn)(struct file *,
> > > +struct autofs_sb_info *, struct autofs_dev_ioctl *);
> > 
> > Weird layout, which I fixed.
> 
> Auuuhh .. didn't want to do this. I personally like declarations like
> this to be on a single line but checkpatch.pl complained about it.

Well, that's why it's a checkpatch warning, not an error.  The way I
look at checkpatch is that it is for detecting possible mistakes.  Did
you _really_ mean to do that?  Usually the answer is "nope, and I
wouldn't have noticed unless you told me".  But sometimes the answer is
"yes, I really did mean that".

I routinely ignore checkpatch 80-col warnings, unless they are flagging
something which is just egregiously revolting.

Anyway, that's an aside.  Given that you decided to fit that typedef
into 80 cols, the way you did it was weird ;)

> > > +static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
> > > +{
> > > +	struct files_struct *files = current->files;
> > > +	struct fdtable *fdt;
> > > +
> > > +	spin_lock(&files->file_lock);
> > > +	fdt = files_fdtable(files);
> > > +	rcu_assign_pointer(fdt->fd[fd], file);
> > > +	FD_SET(fd, fdt->close_on_exec);
> > > +	spin_unlock(&files->file_lock);
> > > +}
> > 
> > urgh, it's bad to have done a copy-n-paste on fd_install() here.  It
> > means that if we go and change the locking in core kernel (quite
> > possible) then people won't udpate this code.
> > 
> > Do we have alternative here?  Can we set close_on_exec outside the lock
> > and just call fd_install()?  Probably not.
> > 
> > Can we export set_close_on_exec() then call that after having called
> > fd_install()?  I think so.
> > 
> > But not this, please.
> 
> No problem.
> You mentioned this last time as well.
> 
> Since there are a couple of possible approaches and I wasn't sure which
> way to go I thought I'd post it as is and get feedback then make it a
> followup patch.
> 
> Could the pthreads user space daemon exec something between fd_install()
> and set_close_on_exec()? 

Gee, I don't know, it would depend on the context.

Is that a private file*?  Was it just created, and is there no
possibility that any other thread can be sharing it anyway?  If so,
there's no problem.

> Perhaps there are some other alternative approaches to this.
> 
> Suggestions?

I don't know enough about autofs nor about what problem you're
attacking here to be able to say, sorry.  I don't even know why
close_on_exec is being set?


