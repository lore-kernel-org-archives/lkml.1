Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYHHDns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYHHDns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYHHDni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:43:38 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39754 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbYHHDnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:43:37 -0400
X-Sasl-enc: s6p7VOSB+1TX7xHE5VC8kEEhdnWNB/9/Ja+8moLXRLZV 1218167015
Subject: Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080807141041.e0d5cccc.akpm@linux-foundation.org>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
	 <20080807114030.4142.76568.stgit@web.messagingengine.com>
	 <20080807141041.e0d5cccc.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 11:39:19 +0800
Message-Id: <1218166760.17093.69.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-07 at 14:10 -0700, Andrew Morton wrote:
> On Thu, 07 Aug 2008 19:40:31 +0800
> Ian Kent <raven@themaw.net> wrote:
> >
> > Subject: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
> 
> I fixed that spello
> 
> > Patch to add a miscellaneous device to the autofs4 module for routing
> > ioctls. This provides the ability to obtain an ioctl file handle for
> > an autofs mount point that is possibly covered by another mount.
> > 
> > The actual problem with autofs is that it can't reconnect to existing
> > mounts. Immediately one things of just adding the ability to remount
> > autofs file systems would solve it, but alas, that can't work. This is
> > because autofs direct mounts and the implementation of "on demand mount
> > and expire" of nested mount trees have the file system mounted on top of
> > the mount trigger dentry.
> > 
> > To resolve this a miscellaneous device node for routing ioctl commands
> > to these mount points has been implemented in the autofs4 kernel module
> > and a library added to autofs. This provides the ability to open a file
> > descriptor for these over mounted autofs mount points.
> > 
> > Please refer to Documentation/filesystems/autofs4-mount-control.txt for
> > a discussion of the problem, implementation alternatives considered and
> > a description of the interface.
> > 
> >
> > ...
> >
> > +
> > +#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
> > +
> > +typedef int (*ioctl_fn)(struct file *,
> > +struct autofs_sb_info *, struct autofs_dev_ioctl *);
> 
> Weird layout, which I fixed.

Auuuhh .. didn't want to do this. I personally like declarations like
this to be on a single line but checkpatch.pl complained about it.

> 
> > +static int check_name(const char *name)
> > +{
> > +	if (!strchr(name, '/'))
> > +		return -EINVAL;
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Check a string doesn't overrun the chunk of
> > + * memory we copied from user land.
> > + */
> > +static int invalid_str(char *str, void *end)
> > +{
> > +	while ((void *) str <= end)
> > +		if (!*str++)
> > +			return 0;
> > +	return -EINVAL;
> > +}
> 
> What is this?  gWwe copy strings in from userspace in 10000 different
> places without needing checks such as this?

Yeah, that's true.
Since you recommend I get rid of I'll do so.

> 
> > +/*
> > + * Check that the user compiled against correct version of autofs
> > + * misc device code.
> > + *
> > + * As well as checking the version compatibility this always copies
> > + * the kernel interface version out.
> > + */
> > +static int check_dev_ioctl_version(int cmd, struct autofs_dev_ioctl *param)
> > +{
> > +	int err = 0;
> > +
> > +	if ((AUTOFS_DEV_IOCTL_VERSION_MAJOR != param->ver_major) ||
> > +	    (AUTOFS_DEV_IOCTL_VERSION_MINOR < param->ver_minor)) {
> > +		AUTOFS_WARN("ioctl control interface version mismatch: "
> > +		     "kernel(%u.%u), user(%u.%u), cmd(%d)",
> > +		     AUTOFS_DEV_IOCTL_VERSION_MAJOR,
> > +		     AUTOFS_DEV_IOCTL_VERSION_MINOR,
> > +		     param->ver_major, param->ver_minor, cmd);
> > +		err = -EINVAL;
> > +	}
> > +
> > +	/* Fill in the kernel version. */
> > +	param->ver_major = AUTOFS_DEV_IOCTL_VERSION_MAJOR;
> > +	param->ver_minor = AUTOFS_DEV_IOCTL_VERSION_MINOR;
> > +
> > +	return err;
> > +}
> > +
> > +/*
> > + * Copy parameter control struct, including a possible path allocated
> > + * at the end of the struct.
> > + */
> > +static struct autofs_dev_ioctl *copy_dev_ioctl(struct autofs_dev_ioctl __user *in)
> > +{
> > +	struct autofs_dev_ioctl tmp, *ads;
> 
> Variables called `tmp' get me upset, but it seems appropriate here.
> 
> > +	if (copy_from_user(&tmp, in, sizeof(tmp)))
> > +		return ERR_PTR(-EFAULT);
> > +
> > +	if (tmp.size < sizeof(tmp))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	ads = kmalloc(tmp.size, GFP_KERNEL);
> > +	if (!ads)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	if (copy_from_user(ads, in, tmp.size)) {
> > +		kfree(ads);
> > +		return ERR_PTR(-EFAULT);
> > +	}
> > +
> > +	return ads;
> > +}
> > +
> > +static inline void free_dev_ioctl(struct autofs_dev_ioctl *param)
> > +{
> > +	kfree(param);
> > +	return;
> > +}
> > +
> > +/*
> > + * Check sanity of parameter control fields and if a path is present
> > + * check that it has a "/" and is terminated.
> > + */
> > +static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
> > +{
> > +	int err = -EINVAL;
> > +
> > +	if (check_dev_ioctl_version(cmd, param)) {
> > +		AUTOFS_WARN("invalid device control module version "
> > +		     "supplied for cmd(0x%08x)", cmd);
> > +		goto out;
> 
> check_dev_ioctl_version() carefully returned a -EFOO value, but this
> caller dropped it on the floor.

Will fix.

> 
> > +	}
> > +
> > +	if (param->size > sizeof(*param)) {
> > +		err = check_name(param->path);
> > +		if (err) {
> > +			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
> > +				    cmd);
> > +			goto out;
> > +		}
> > +
> > +		err = invalid_str(param->path,
> > +				 (void *) ((size_t) param + param->size));
> > +		if (err) {
> > +			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
> > +				    cmd);
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	err = 0;
> > +out:
> > +	return err;
> > +}
> > +
> >
> > ...
> >
> > +static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
> > +{
> > +	struct files_struct *files = current->files;
> > +	struct fdtable *fdt;
> > +
> > +	spin_lock(&files->file_lock);
> > +	fdt = files_fdtable(files);
> > +	BUG_ON(fdt->fd[fd] != NULL);
> > +	rcu_assign_pointer(fdt->fd[fd], file);
> > +	FD_SET(fd, fdt->close_on_exec);
> > +	spin_unlock(&files->file_lock);
> > +}
> 
> urgh, it's bad to have done a copy-n-paste on fd_install() here.  It
> means that if we go and change the locking in core kernel (quite
> possible) then people won't udpate this code.
> 
> Do we have alternative here?  Can we set close_on_exec outside the lock
> and just call fd_install()?  Probably not.
> 
> Can we export set_close_on_exec() then call that after having called
> fd_install()?  I think so.
> 
> But not this, please.

No problem.
You mentioned this last time as well.

Since there are a couple of possible approaches and I wasn't sure which
way to go I thought I'd post it as is and get feedback then make it a
followup patch.

Could the pthreads user space daemon exec something between fd_install()
and set_close_on_exec()? 

Perhaps there are some other alternative approaches to this.

Suggestions?

Ian


