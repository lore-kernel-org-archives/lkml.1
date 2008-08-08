Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYHHGQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYHHGQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYHHGQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:16:41 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42431 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbYHHGQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:16:40 -0400
X-Sasl-enc: DdRFF/mGmYHQq8TTL4sXfwnnwgIrWxEenj0+UW5enF+v 1218176198
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080807223109.e67f46e4.akpm@linux-foundation.org>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
	 <20080807114030.4142.76568.stgit@web.messagingengine.com>
	 <20080807141041.e0d5cccc.akpm@linux-foundation.org>
	 <1218166760.17093.69.camel@raven.themaw.net>
	 <20080807223109.e67f46e4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:12:21 +0800
Message-Id: <1218175943.17093.107.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-07 at 22:31 -0700, Andrew Morton wrote:
> On Fri, 08 Aug 2008 11:39:19 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > 
> > On Thu, 2008-08-07 at 14:10 -0700, Andrew Morton wrote:
> > > On Thu, 07 Aug 2008 19:40:31 +0800
> > > Ian Kent <raven@themaw.net> wrote:
> > > >
> > > > Subject: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
> > > 
> > > I fixed that spello
> > > 
> > > > Patch to add a miscellaneous device to the autofs4 module for routing
> > > > ioctls. This provides the ability to obtain an ioctl file handle for
> > > > an autofs mount point that is possibly covered by another mount.
> > > > 
> > > > The actual problem with autofs is that it can't reconnect to existing
> > > > mounts. Immediately one things of just adding the ability to remount
> > > > autofs file systems would solve it, but alas, that can't work. This is
> > > > because autofs direct mounts and the implementation of "on demand mount
> > > > and expire" of nested mount trees have the file system mounted on top of
> > > > the mount trigger dentry.
> > > > 
> > > > To resolve this a miscellaneous device node for routing ioctl commands
> > > > to these mount points has been implemented in the autofs4 kernel module
> > > > and a library added to autofs. This provides the ability to open a file
> > > > descriptor for these over mounted autofs mount points.
> > > > 
> > > > Please refer to Documentation/filesystems/autofs4-mount-control.txt for
> > > > a discussion of the problem, implementation alternatives considered and
> > > > a description of the interface.
> > > > 
> > > >
> > > > ...
> > > >
> > > > +
> > > > +#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
> > > > +
> > > > +typedef int (*ioctl_fn)(struct file *,
> > > > +struct autofs_sb_info *, struct autofs_dev_ioctl *);
> > > 
> > > Weird layout, which I fixed.
> > 
> > Auuuhh .. didn't want to do this. I personally like declarations like
> > this to be on a single line but checkpatch.pl complained about it.
> 
> Well, that's why it's a checkpatch warning, not an error.  The way I
> look at checkpatch is that it is for detecting possible mistakes.  Did
> you _really_ mean to do that?  Usually the answer is "nope, and I
> wouldn't have noticed unless you told me".  But sometimes the answer is
> "yes, I really did mean that".
> 
> I routinely ignore checkpatch 80-col warnings, unless they are flagging
> something which is just egregiously revolting.
> 
> Anyway, that's an aside.  Given that you decided to fit that typedef
> into 80 cols, the way you did it was weird ;)
> 
> > > > +static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
> > > > +{
> > > > +	struct files_struct *files = current->files;
> > > > +	struct fdtable *fdt;
> > > > +
> > > > +	spin_lock(&files->file_lock);
> > > > +	fdt = files_fdtable(files);
> > > > +	rcu_assign_pointer(fdt->fd[fd], file);
> > > > +	FD_SET(fd, fdt->close_on_exec);
> > > > +	spin_unlock(&files->file_lock);
> > > > +}
> > > 
> > > urgh, it's bad to have done a copy-n-paste on fd_install() here.  It
> > > means that if we go and change the locking in core kernel (quite
> > > possible) then people won't udpate this code.
> > > 
> > > Do we have alternative here?  Can we set close_on_exec outside the lock
> > > and just call fd_install()?  Probably not.
> > > 
> > > Can we export set_close_on_exec() then call that after having called
> > > fd_install()?  I think so.
> > > 
> > > But not this, please.
> > 
> > No problem.
> > You mentioned this last time as well.
> > 
> > Since there are a couple of possible approaches and I wasn't sure which
> > way to go I thought I'd post it as is and get feedback then make it a
> > followup patch.
> > 
> > Could the pthreads user space daemon exec something between fd_install()
> > and set_close_on_exec()? 
> 
> Gee, I don't know, it would depend on the context.
> 
> Is that a private file*?  Was it just created, and is there no
> possibility that any other thread can be sharing it anyway?  If so,
> there's no problem.

The problem is that autofs threads can exec mount or umount at any time
and we see annoying selinux file descriptor leak security violation
messages. So the point of this is to set the bit at the same time as the
file is inserted into the table.

> 
> > Perhaps there are some other alternative approaches to this.
> > 
> > Suggestions?
> 
> I don't know enough about autofs nor about what problem you're
> attacking here to be able to say, sorry.  I don't even know why
> close_on_exec is being set?

OK, sorry.

What I'm really after is:
Should I do this at all, given the above?
If this is sensible, should a parameter be added to fd_insall() to allow
it to be requested at descriptor install or should a new function, say,
fd_install_close_on_exec() be added?

Ian


