Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYA0Q5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYA0Q5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYA0Q5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:57:18 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:42034 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYA0Q5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b+Gj2fyiF8GGWhT+zeygh5Oj6nOIXH9AJeX3eVWBXSicfFGewcopcTLBECV/ekLSi+cP2Tyh2iwBYQ285RMuKVlploFNOfqP4OK5ITk06hrmQsWh/r8WfRe4Givxckt8z5+GPGChgC2pLCDtsOKZgIy26WqxL/f8p/nqjMAZWJ8=
Message-ID: <524f69650801270857i6610e736q4189dc6af9b22360@mail.gmail.com>
Date: Sun, 27 Jan 2008 10:57:14 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Cc: Trond.Myklebust@netapp.com, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20080127021714.A223614D2E@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127317.043953000@suse.de>
	 <20080127021714.A223614D2E@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't you need to a spinlock/spinunlock(i_lock) or something similar
(there isn't a spinlock in the file struct unfortunately) around the
reads and writes from f_pos in fs/read_write.c in remote_llseek with
your patch since the reads/writes from that field are not necessarily
atomic and threads could be racing in seek on the same file struct?

On Jan 26, 2008 8:17 PM, Andi Kleen <ak@suse.de> wrote:
>
> - Replace remote_llseek with remote_llseek_unlocked (to force compilation
> failures in all users)
> - Change all users to either use remote_llseek directly or take the
> BKL around. I changed the file systems who don't use the BKL
> for anything (CIFS, GFS) to call it directly. NCPFS and SMBFS and NFS
> take the BKL, but explicitely in their own source now.
>
> I moved them all over in a single patch to avoid unbisectable sections.
>
> Cc: Trond.Myklebust@netapp.com
> Cc: swhiteho@redhat.com
> Cc: sfrench@samba.org
> Cc: vandrove@vc.cvut.cz
>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> ---
>  fs/cifs/cifsfs.c   |    2 +-
>  fs/gfs2/ops_file.c |    4 ++--
>  fs/ncpfs/file.c    |   12 +++++++++++-
>  fs/nfs/file.c      |    6 +++++-
>  fs/read_write.c    |    7 +++----
>  fs/smbfs/file.c    |   11 ++++++++++-
>  include/linux/fs.h |    3 ++-
>  7 files changed, 34 insertions(+), 11 deletions(-)
>
> Index: linux/fs/cifs/cifsfs.c
> ===================================================================
> --- linux.orig/fs/cifs/cifsfs.c
> +++ linux/fs/cifs/cifsfs.c
> @@ -549,7 +549,7 @@ static loff_t cifs_llseek(struct file *f
>                 if (retval < 0)
>                         return (loff_t)retval;
>         }
> -       return remote_llseek(file, offset, origin);
> +       return remote_llseek_unlocked(file, offset, origin);
>  }
>
>  static struct file_system_type cifs_fs_type = {
> Index: linux/fs/gfs2/ops_file.c
> ===================================================================
> --- linux.orig/fs/gfs2/ops_file.c
> +++ linux/fs/gfs2/ops_file.c
> @@ -107,11 +107,11 @@ static loff_t gfs2_llseek(struct file *f
>                 error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
>                                            &i_gh);
>                 if (!error) {
> -                       error = remote_llseek(file, offset, origin);
> +                       error = remote_llseek_unlocked(file, offset, origin);
>                         gfs2_glock_dq_uninit(&i_gh);
>                 }
>         } else
> -               error = remote_llseek(file, offset, origin);
> +               error = remote_llseek_unlocked(file, offset, origin);
>
>         return error;
>  }
> Index: linux/fs/ncpfs/file.c
> ===================================================================
> --- linux.orig/fs/ncpfs/file.c
> +++ linux/fs/ncpfs/file.c
> @@ -18,6 +18,7 @@
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sched.h>
> +#include <linux/smp_lock.h>
>
>  #include <linux/ncp_fs.h>
>  #include "ncplib_kernel.h"
> @@ -281,9 +282,18 @@ static int ncp_release(struct inode *ino
>         return 0;
>  }
>
> +static loff_t ncp_remote_llseek(struct file *file, loff_t offset, int origin)
> +{
> +       loff_t ret;
> +       lock_kernel();
> +       ret = remote_llseek_unlocked(file, offset, origin);
> +       unlock_kernel();
> +       return ret;
> +}
> +
>  const struct file_operations ncp_file_operations =
>  {
> -       .llseek         = remote_llseek,
> +       .llseek         = ncp_remote_llseek,
>         .read           = ncp_file_read,
>         .write          = ncp_file_write,
>         .ioctl          = ncp_ioctl,
> Index: linux/fs/read_write.c
> ===================================================================
> --- linux.orig/fs/read_write.c
> +++ linux/fs/read_write.c
> @@ -58,11 +58,10 @@ loff_t generic_file_llseek(struct file *
>
>  EXPORT_SYMBOL(generic_file_llseek);
>
> -loff_t remote_llseek(struct file *file, loff_t offset, int origin)
> +loff_t remote_llseek_unlocked(struct file *file, loff_t offset, int origin)
>  {
>         long long retval;
>
> -       lock_kernel();
>         switch (origin) {
>                 case SEEK_END:
>                         offset += i_size_read(file->f_path.dentry->d_inode);
> @@ -73,15 +72,15 @@ loff_t remote_llseek(struct file *file,
>         retval = -EINVAL;
>         if (offset>=0 && offset<=file->f_path.dentry->d_inode->i_sb->s_maxbytes) {
>                 if (offset != file->f_pos) {
> +                       /* AK: do we need a lock for those? */
>                         file->f_pos = offset;
>                         file->f_version = 0;
>                 }
>                 retval = offset;
>         }
> -       unlock_kernel();
>         return retval;
>  }
> -EXPORT_SYMBOL(remote_llseek);
> +EXPORT_SYMBOL(remote_llseek_unlocked);
>
>  loff_t no_llseek(struct file *file, loff_t offset, int origin)
>  {
> Index: linux/fs/smbfs/file.c
> ===================================================================
> --- linux.orig/fs/smbfs/file.c
> +++ linux/fs/smbfs/file.c
> @@ -422,9 +422,18 @@ smb_file_permission(struct inode *inode,
>         return error;
>  }
>
> +static loff_t smb_remote_llseek(struct file *file, loff_t offset, int origin)
> +{
> +       loff_t ret;
> +       lock_kernel();
> +       ret = remote_llseek_unlocked(file, offset, origin);
> +       unlock_kernel();
> +       return ret;
> +}
> +
>  const struct file_operations smb_file_operations =
>  {
> -       .llseek         = remote_llseek,
> +       .llseek         = smb_remote_llseek,
>         .read           = do_sync_read,
>         .aio_read       = smb_file_aio_read,
>         .write          = do_sync_write,
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h
> +++ linux/include/linux/fs.h
> @@ -1825,7 +1825,8 @@ extern void
>  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
>  extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
>  extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
> -extern loff_t remote_llseek(struct file *file, loff_t offset, int origin);
> +extern loff_t remote_llseek_unlocked(struct file *file, loff_t offset,
> +                       int origin);
>  extern int generic_file_open(struct inode * inode, struct file * filp);
>  extern int nonseekable_open(struct inode * inode, struct file * filp);
>
> Index: linux/fs/nfs/file.c
> ===================================================================
> --- linux.orig/fs/nfs/file.c
> +++ linux/fs/nfs/file.c
> @@ -166,6 +166,7 @@ force_reval:
>
>  static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
>  {
> +       loff_t loff;
>         /* origin == SEEK_END => we must revalidate the cached file length */
>         if (origin == SEEK_END) {
>                 struct inode *inode = filp->f_mapping->host;
> @@ -173,7 +174,10 @@ static loff_t nfs_file_llseek(struct fil
>                 if (retval < 0)
>                         return (loff_t)retval;
>         }
> -       return remote_llseek(filp, offset, origin);
> +       lock_kernel();  /* BKL needed? */
> +       loff = remote_llseek_unlocked(filp, offset, origin);
> +       unlock_kernel();
> +       return loff;
>  }
>
>  /*
>



-- 
Thanks,

Steve
