Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbXEPH7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbXEPH7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759204AbXEPH7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:59:13 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55475 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758642AbXEPH7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:59:11 -0400
Date: Wed, 16 May 2007 09:57:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted
 filesystems
In-Reply-To: <20070514094329.GL4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:13, Bharata B Rao wrote:
>+
>+	if (flag & 0x2) {
>+		error = union_copyup(nd, flag);
>+		if (error)
>+			goto exit;
>+	}

What I dislike (and that also goes for fs/namei.c and such) that they use
numeral constants, i.e. 0x2. That seems error-prone. Could this (and
the in-kernel users of 0x1/0x2/0x4) be turned into some constant?

>+	if (IS_DEADDIR(parent->d_inode))
>+		goto error;
>+	err = -EACCES;	/* shouldn't it be ENOSYS? */

I do not think so. ENOSYS means Syscall not implemented. But it is
implemented. If ->i_op is not there does not imply ENOSYS.

Though, now that I grep through fs/*, I see that namei.c also
has that comment "shouldn't it be ENOSYS", so it's all at odds.

>+	if (!parent->d_inode->i_op || !parent->d_inode->i_op->create)
>+		goto error;

>+struct dentry * union_create_topmost(struct nameidata *nd, struct dentry *old)
>+{
>+	struct dentry *dentry;
>+	struct dentry *parent = nd->dentry;
>+
>+	UM_DEBUG_UID("dentry=%s\n", old->d_name.name);
>+
>+	BUG_ON(parent->d_sb == old->d_sb);
>+	if (!S_ISREG(old->d_inode->i_mode)) {
>+		UM_DEBUG("This filetype isn't supported!\n");

Does that mean I cannot create block devices, etc.?

>+int union_copy_file(struct dentry *old_dentry, struct vfsmount *old_mnt,
>+		    struct dentry *new_dentry, struct vfsmount *new_mnt)
>+{
>+	int ret;
>+	size_t size;
>+	loff_t offset;
>+	struct file *old_file, *new_file;
>[...]
>+	size = i_size_read(old_file->f_path.dentry->d_inode);
>+	if (((size_t)size != size) || ((ssize_t)size != size)) {

No need to cast, size is already size_t. And then that left part
is somewhat superfluous.

>+		ret = -EFBIG;
>+		goto fput_new;
>+	}
>+


	Jan
-- 
