Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0BOHAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:00:45 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:57113 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab0BOHAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D9AWcOh6b/8jZXdhkMmZHMhkYYA8NlE9Y/GsvysWNkIlSy2EoV+8pSJdRdbSa1pxBq
         rKD38iW/mYvFlMGzzz5HjocazghafHVaxJyLbkd/F4mEsKvyrZZHAHlZICNnTjy08qGl
         98qwssVwEcnI1umI0pUu3I5l9+5LTAnAQXIds=
Date: Mon, 15 Feb 2010 15:03:14 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] sysfs: Remove sysfs_get/put_active_two
Message-ID: <20100215070314.GB12076@hack.private>
References: <2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com> <4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org> <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org> <20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org> <4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org> <m14olnxt3s.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14olnxt3s.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 03:14:47PM -0800, Eric W. Biederman wrote:
>
>It turns out that holding an active reference on a directory is
>pointless.  The purpose of the active references are to allows us to
>block when removing sysfs entries that have custom methods so we don't
>remove modules while running modular code and to keep those custom
>methods from accessing data structures after the files have been
>removed.  Further sysfs_remove_dir remove all elements in the
>directory before removing the directory itself, so there is no chance
>we will remove a directory with active children.
>

Oh, I see... You are trying to change the meaning of s_active,
thus killing the lockdep warning that it triggers.

Hmm, I agree with your analysis above. As long as the order is that,
this change should be safe, since sysfs_remove_dir() should be
the only way to remove an sysfs dir.

It is a really nice patch!

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

>Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>---
> fs/sysfs/bin.c   |   50 +++++++++++++++++++++++++-------------------------
> fs/sysfs/dir.c   |   43 ++-----------------------------------------
> fs/sysfs/file.c  |   18 +++++++++---------
> fs/sysfs/sysfs.h |    4 ++--
> 4 files changed, 38 insertions(+), 77 deletions(-)
>
>diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
>index a0a500a..e9d2935 100644
>--- a/fs/sysfs/bin.c
>+++ b/fs/sysfs/bin.c
>@@ -54,14 +54,14 @@ fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
> 	int rc;
> 
> 	/* need attr_sd for attr, its parent for kobj */
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -ENODEV;
> 
> 	rc = -EIO;
> 	if (attr->read)
> 		rc = attr->read(kobj, attr, buffer, off, count);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 
> 	return rc;
> }
>@@ -125,14 +125,14 @@ flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
> 	int rc;
> 
> 	/* need attr_sd for attr, its parent for kobj */
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -ENODEV;
> 
> 	rc = -EIO;
> 	if (attr->write)
> 		rc = attr->write(kobj, attr, buffer, offset, count);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 
> 	return rc;
> }
>@@ -184,12 +184,12 @@ static void bin_vma_open(struct vm_area_struct *vma)
> 	if (!bb->vm_ops || !bb->vm_ops->open)
> 		return;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return;
> 
> 	bb->vm_ops->open(vma);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> }
> 
> static void bin_vma_close(struct vm_area_struct *vma)
>@@ -201,12 +201,12 @@ static void bin_vma_close(struct vm_area_struct *vma)
> 	if (!bb->vm_ops || !bb->vm_ops->close)
> 		return;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return;
> 
> 	bb->vm_ops->close(vma);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> }
> 
> static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>@@ -219,12 +219,12 @@ static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> 	if (!bb->vm_ops || !bb->vm_ops->fault)
> 		return VM_FAULT_SIGBUS;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return VM_FAULT_SIGBUS;
> 
> 	ret = bb->vm_ops->fault(vma, vmf);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return ret;
> }
> 
>@@ -241,12 +241,12 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> 	if (!bb->vm_ops->page_mkwrite)
> 		return 0;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return VM_FAULT_SIGBUS;
> 
> 	ret = bb->vm_ops->page_mkwrite(vma, vmf);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return ret;
> }
> 
>@@ -261,12 +261,12 @@ static int bin_access(struct vm_area_struct *vma, unsigned long addr,
> 	if (!bb->vm_ops || !bb->vm_ops->access)
> 		return -EINVAL;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -EINVAL;
> 
> 	ret = bb->vm_ops->access(vma, addr, buf, len, write);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return ret;
> }
> 
>@@ -281,12 +281,12 @@ static int bin_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
> 	if (!bb->vm_ops || !bb->vm_ops->set_policy)
> 		return 0;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -EINVAL;
> 
> 	ret = bb->vm_ops->set_policy(vma, new);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return ret;
> }
> 
>@@ -301,12 +301,12 @@ static struct mempolicy *bin_get_policy(struct vm_area_struct *vma,
> 	if (!bb->vm_ops || !bb->vm_ops->get_policy)
> 		return vma->vm_policy;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return vma->vm_policy;
> 
> 	pol = bb->vm_ops->get_policy(vma, addr);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return pol;
> }
> 
>@@ -321,12 +321,12 @@ static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
> 	if (!bb->vm_ops || !bb->vm_ops->migrate)
> 		return 0;
> 
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return 0;
> 
> 	ret = bb->vm_ops->migrate(vma, from, to, flags);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return ret;
> }
> #endif
>@@ -356,7 +356,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
> 
> 	/* need attr_sd for attr, its parent for kobj */
> 	rc = -ENODEV;
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		goto out_unlock;
> 
> 	rc = -EINVAL;
>@@ -384,7 +384,7 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
> 	bb->vm_ops = vma->vm_ops;
> 	vma->vm_ops = &bin_vm_ops;
> out_put:
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> out_unlock:
> 	mutex_unlock(&bb->mutex);
> 
>@@ -399,7 +399,7 @@ static int open(struct inode * inode, struct file * file)
> 	int error;
> 
> 	/* binary file operations requires both @sd and its parent */
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -ENODEV;
> 
> 	error = -EACCES;
>@@ -426,11 +426,11 @@ static int open(struct inode * inode, struct file * file)
> 	mutex_unlock(&sysfs_bin_lock);
> 
> 	/* open succeeded, put active references */
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return 0;
> 
>  err_out:
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	kfree(bb);
> 	return error;
> }
>diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
>index 5c4703d..1bdc42f 100644
>--- a/fs/sysfs/dir.c
>+++ b/fs/sysfs/dir.c
>@@ -93,7 +93,7 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
>  *	RETURNS:
>  *	Pointer to @sd on success, NULL on failure.
>  */
>-static struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
>+struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
> {
> 	if (unlikely(!sd))
> 		return NULL;
>@@ -124,7 +124,7 @@ static struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
>  *	Put an active reference to @sd.  This function is noop if @sd
>  *	is NULL.
>  */
>-static void sysfs_put_active(struct sysfs_dirent *sd)
>+void sysfs_put_active(struct sysfs_dirent *sd)
> {
> 	struct completion *cmpl;
> 	int v;
>@@ -145,45 +145,6 @@ static void sysfs_put_active(struct sysfs_dirent *sd)
> }
> 
> /**
>- *	sysfs_get_active_two - get active references to sysfs_dirent and parent
>- *	@sd: sysfs_dirent of interest
>- *
>- *	Get active reference to @sd and its parent.  Parent's active
>- *	reference is grabbed first.  This function is noop if @sd is
>- *	NULL.
>- *
>- *	RETURNS:
>- *	Pointer to @sd on success, NULL on failure.
>- */
>-struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd)
>-{
>-	if (sd) {
>-		if (sd->s_parent && unlikely(!sysfs_get_active(sd->s_parent)))
>-			return NULL;
>-		if (unlikely(!sysfs_get_active(sd))) {
>-			sysfs_put_active(sd->s_parent);
>-			return NULL;
>-		}
>-	}
>-	return sd;
>-}
>-
>-/**
>- *	sysfs_put_active_two - put active references to sysfs_dirent and parent
>- *	@sd: sysfs_dirent of interest
>- *
>- *	Put active references to @sd and its parent.  This function is
>- *	noop if @sd is NULL.
>- */
>-void sysfs_put_active_two(struct sysfs_dirent *sd)
>-{
>-	if (sd) {
>-		sysfs_put_active(sd);
>-		sysfs_put_active(sd->s_parent);
>-	}
>-}
>-
>-/**
>  *	sysfs_deactivate - deactivate sysfs_dirent
>  *	@sd: sysfs_dirent to deactivate
>  *
>diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
>index dc30d9e..8d6bd65 100644
>--- a/fs/sysfs/file.c
>+++ b/fs/sysfs/file.c
>@@ -85,13 +85,13 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
> 		return -ENOMEM;
> 
> 	/* need attr_sd for attr and ops, its parent for kobj */
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -ENODEV;
> 
> 	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
> 	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 
> 	/*
> 	 * The code works fine with PAGE_SIZE return but it's likely to
>@@ -203,12 +203,12 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
> 	int rc;
> 
> 	/* need attr_sd for attr and ops, its parent for kobj */
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -ENODEV;
> 
> 	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 
> 	return rc;
> }
>@@ -344,7 +344,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
> 		memmove(last_sysfs_file, p, strlen(p) + 1);
> 
> 	/* need attr_sd for attr and ops, its parent for kobj */
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		return -ENODEV;
> 
> 	/* every kobject with an attribute needs a ktype assigned */
>@@ -393,13 +393,13 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
> 		goto err_free;
> 
> 	/* open succeeded, put active references */
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return 0;
> 
>  err_free:
> 	kfree(buffer);
>  err_out:
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 	return error;
> }
> 
>@@ -437,12 +437,12 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
> 	struct sysfs_open_dirent *od = attr_sd->s_attr.open;
> 
> 	/* need parent for the kobj, grab both */
>-	if (!sysfs_get_active_two(attr_sd))
>+	if (!sysfs_get_active(attr_sd))
> 		goto trigger;
> 
> 	poll_wait(filp, &od->poll, wait);
> 
>-	sysfs_put_active_two(attr_sd);
>+	sysfs_put_active(attr_sd);
> 
> 	if (buffer->event != atomic_read(&od->event))
> 		goto trigger;
>diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
>index cdd9377..bb7723c 100644
>--- a/fs/sysfs/sysfs.h
>+++ b/fs/sysfs/sysfs.h
>@@ -124,8 +124,8 @@ extern const struct file_operations sysfs_dir_operations;
> extern const struct inode_operations sysfs_dir_inode_operations;
> 
> struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
>-struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
>-void sysfs_put_active_two(struct sysfs_dirent *sd);
>+struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
>+void sysfs_put_active(struct sysfs_dirent *sd);
> void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
> 		       struct sysfs_dirent *parent_sd);
> int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
>-- 
>1.6.5.2.143.g8cc62
>

-- 
Live like a child, think like the god.
 
