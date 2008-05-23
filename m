Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbYEWB6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbYEWB6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYEWB5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:57:51 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:31488 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbYEWB5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SJS253Cpc30rWoRXVAMDtQa/s1Z7xyGFo9JUDWwxxyW5ChMIFXM+3dOi/WiXv8nw4nU7YShlYqa/tNeJYamBwWjo6WopD9QsKJZLMFvvvwOFcB/IASJgOISNNZQWokUd4Jpw9j5g1uXFx4vvAGcm88Yimf3WlNuh1Ya29JlCD9I=
Message-ID: <524f69650805221857p7ff6e539m18902362b1d30a72@mail.gmail.com>
Date: Thu, 22 May 2008 20:57:48 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] cifs: Push the BKL down into the fs ioctl code
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080522225243.0da12b58@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522225243.0da12b58@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cifs already converted to unlocked ioctl last week.

On Thu, May 22, 2008 at 4:52 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Switch to unlocked_ioctl. Wrap the ioctl handler internally with
> lock_kernel until someone can prove it isn't needed or fix it so it isn't.
>
> Signed-off-by: Alan Cox <alan@redhat.com>
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 427a7c6..b6436b8 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -657,7 +657,7 @@ const struct file_operations cifs_file_ops = {
>        .splice_read = generic_file_splice_read,
>        .llseek = cifs_llseek,
>  #ifdef CONFIG_CIFS_POSIX
> -       .ioctl  = cifs_ioctl,
> +       .unlocked_ioctl = cifs_ioctl,
>  #endif /* CONFIG_CIFS_POSIX */
>
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> @@ -677,7 +677,7 @@ const struct file_operations cifs_file_direct_ops = {
>        .flush = cifs_flush,
>        .splice_read = generic_file_splice_read,
>  #ifdef CONFIG_CIFS_POSIX
> -       .ioctl  = cifs_ioctl,
> +       .unlocked_ioctl  = cifs_ioctl,
>  #endif /* CONFIG_CIFS_POSIX */
>        .llseek = cifs_llseek,
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> @@ -697,7 +697,7 @@ const struct file_operations cifs_file_nobrl_ops = {
>        .splice_read = generic_file_splice_read,
>        .llseek = cifs_llseek,
>  #ifdef CONFIG_CIFS_POSIX
> -       .ioctl  = cifs_ioctl,
> +       .unlocked_ioctl = cifs_ioctl,
>  #endif /* CONFIG_CIFS_POSIX */
>
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> @@ -716,7 +716,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
>        .flush = cifs_flush,
>        .splice_read = generic_file_splice_read,
>  #ifdef CONFIG_CIFS_POSIX
> -       .ioctl  = cifs_ioctl,
> +       .unlocked_ioctl  = cifs_ioctl,
>  #endif /* CONFIG_CIFS_POSIX */
>        .llseek = cifs_llseek,
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
> @@ -731,7 +731,7 @@ const struct file_operations cifs_dir_ops = {
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
>        .dir_notify = cifs_dir_notify,
>  #endif /* CONFIG_CIFS_EXPERIMENTAL */
> -       .ioctl  = cifs_ioctl,
> +       .unlocked_ioctl  = cifs_ioctl,
>  };
>
>  static void
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index cd1301a..1312ae7 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -95,8 +95,8 @@ extern int    cifs_setxattr(struct dentry *, const char *, const void *,
>                        size_t, int);
>  extern ssize_t cifs_getxattr(struct dentry *, const char *, void *, size_t);
>  extern ssize_t cifs_listxattr(struct dentry *, char *, size_t);
> -extern int cifs_ioctl(struct inode *inode, struct file *filep,
> -                      unsigned int command, unsigned long arg);
> +extern long cifs_ioctl(struct file *filep, unsigned int command,
> +                                                       unsigned long arg);
>
>  #ifdef CONFIG_CIFS_EXPERIMENTAL
>  extern const struct export_operations cifs_export_ops;
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 5c792df..396811f 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -22,6 +22,7 @@
>  */
>
>  #include <linux/fs.h>
> +#include <linux/smp_lock.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
>  #include "cifsproto.h"
> @@ -30,9 +31,9 @@
>
>  #define CIFS_IOC_CHECKUMOUNT _IO(0xCF, 2)
>
> -int cifs_ioctl(struct inode *inode, struct file *filep,
> -               unsigned int command, unsigned long arg)
> +long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  {
> +       struct inode *inode = filep->f_path.dentry->d_inode;
>        int rc = -ENOTTY; /* strange error - but the precedent */
>        int xid;
>        struct cifs_sb_info *cifs_sb;
> @@ -45,6 +46,8 @@ int cifs_ioctl(struct inode *inode, struct file *filep,
>                (struct cifsFileInfo *)filep->private_data;
>  #endif /* CONFIG_CIFS_POSIX */
>
> +       lock_kernel();
> +
>        xid = GetXid();
>
>        cFYI(1, ("ioctl file %p  cmd %u  arg %lu", filep, command, arg));
> @@ -58,6 +61,7 @@ int cifs_ioctl(struct inode *inode, struct file *filep,
>        else {
>                rc = -EIO;
>                FreeXid(xid);
> +               unlock_kernel();
>                return -EIO;
>        }
>  #endif /* CONFIG_CIFS_POSIX */
> @@ -106,5 +110,6 @@ int cifs_ioctl(struct inode *inode, struct file *filep,
>        }
>
>        FreeXid(xid);
> +       unlock_kernel();
>        return rc;
>  }
>



-- 
Thanks,

Steve
