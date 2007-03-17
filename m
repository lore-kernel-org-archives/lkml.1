Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXCQU6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXCQU6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 16:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXCQU6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 16:58:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:57707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXCQU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 16:58:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch 1/13] signal/timer/event fds v6 - anonymous inode source ...
Date: Sat, 17 Mar 2007 21:58:45 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.9367.1174004535.1>
In-Reply-To: <send-serie.davidel@xmailserver.org.9367.1174004535.1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172158.46252.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19nOZ6CxEyRfXQ9a/asXC4uwmA+jCCXz+aEMOn
 lDFsN7kn/XJ1m9CVb+LKTwNraVaPsMibuuAn89huqnVAJUT7CT
 2utmCR0faH+sjnmG9IIdg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 01:22:15 Davide Libenzi wrote:

> +
> +static int ainofs_delete_dentry(struct dentry *dentry);
> +static struct inode *aino_getinode(void);
> +static struct inode *aino_mkinode(void);
> +static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
> +			 const char *dev_name, void *data, struct vfsmount *mnt);
> +

In general, it would be good if you could just reorder your functions
so that you don't need any forward declarations like these. It makes
reviewing from bottom to top a little easier and it becomes obvious
that there are no recursions in the code.

> +static struct vfsmount *aino_mnt __read_mostly;
> +static struct inode *aino_inode;
> +static struct file_operations aino_fops = { };

Iirc, file_operations should be const.

> +int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
> +	       char const *name, const struct file_operations *fops, void *priv)
> +{

Since this is meant to be a generic interface that can be used
from other subsystems, a kerneldoc style comment would be nice

> +static int __init aino_init(void)
> +{
> +
> +	if (register_filesystem(&aino_fs_type))
> +		goto epanic;
> +
> +	aino_mnt = kern_mount(&aino_fs_type);
> +	if (IS_ERR(aino_mnt))
> +		goto epanic;
> +
> +	aino_inode = aino_mkinode();
> +	if (IS_ERR(aino_inode))
> +		goto epanic;
> +
> +	return 0;
> +
> +epanic:
> +	panic("aino_init() failed\n");
> +}

panic() is a little harsh from a loadable module. If you mean
the aino support to be used as a module, this should probably
just return an error.

> +static void __exit aino_exit(void)
> +{
> +	iput(aino_inode);
> +	unregister_filesystem(&aino_fs_type);
> +	mntput(aino_mnt);
> +}

but since the Makefile always has it as built-in, maybe you should
instead just kill the exit function and use fs_initcall instead
of init_module().

	Arnd <><
