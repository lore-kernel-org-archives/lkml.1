Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab0BYPmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:42:10 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:40337 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab0BYPmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:42:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ezhUNj487nbIUq59K4YY3fwVUsdCy81xK6Rln+N7nGfXokAjaZj/SRVxwaQXqynXq1
         dQFHLe+ul0zbIR3glo3E14xYCzBJ10EvruzBbbcDdmxkPRWL5vHVaiJg7gtbY4ryahUS
         8k2C6cdCh7yN18gABEdvwHdD3KFdH5pLt/abI=
MIME-Version: 1.0
In-Reply-To: <20100225134023.GB3842@hack>
References: <cover.1266907495.git.andre.goddard@gmail.com> 
	<a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com> 
	<2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com> 
	<7b6bb4a51002242000x49f0b3bdncb40912bf18f90bb@mail.gmail.com> 
	<2375c9f91002242025n1ab73e18i5950aa4f14ea36db@mail.gmail.com> 
	<2375c9f91002242259n2fabb190ic77d6ca603bd1df7@mail.gmail.com> 
	<7b6bb4a51002250249t7e4f03c9r6b2b9a8f348a29aa@mail.gmail.com> 
	<20100225134023.GB3842@hack>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Thu, 25 Feb 2010 12:41:47 -0300
Message-ID: <b8bf37781002250741r3836a1calec3441ced7afb863@mail.gmail.com>
Subject: Re: [Patch] mqueue: fix the bad code in sys_mq_open()
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Xiaotian Feng <xtfeng@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Américo!

On Thu, Feb 25, 2010 at 10:40 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
> Fix bad code in ipc/mqueue.c.
>
> Inspired by André Goddard Rosa's  patch.
>
> a) do_create() and do_open() should not release the resources which
>   are not acquired within themselves, it's their caller's work;
>
> b) Fix an fd leak;
>
> c) The goto label 'out_upsem' doesn't make any sense, rename to
>   'out_unlock';
>
> d) mntget() should be called before looking up dentry within
>   ->mnt->mnt_root;
>
> e) When dealing with failure case, we should release the resources
>   in a reversed order of acquiring, so reorder the goto labels;
>
> f) Remove some unused labels due to reorder.
>
> Also, this shrinks the binary by 60 bytes:
>
>   text       data     bss       dec        hex filename
>   7674       1684        8      9366      2496 ipc/mqueue.o.BEFORE
>   7614       1684        8      9306      245a ipc/mqueue.o.AFTER
>
>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: André Goddard Rosa <andre.goddard@gmail.com>
>
> ---
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index c79bd57..fdd09da 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -650,8 +650,6 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct dentry *dir,
>  out_drop_write:
>        mnt_drop_write(ipc_ns->mq_mnt);
>  out:
> -       dput(dentry);
> -       mntput(ipc_ns->mq_mnt);
>        return ERR_PTR(ret);
>  }
>
> @@ -664,17 +662,11 @@ static struct file *do_open(struct ipc_namespace *ipc_ns,
>        static const int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
>                                                  MAY_READ | MAY_WRITE };
>
> -       if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY)) {
> -               dput(dentry);
> -               mntput(ipc_ns->mq_mnt);
> +       if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY))
>                return ERR_PTR(-EINVAL);
> -       }
>
> -       if (inode_permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE])) {
> -               dput(dentry);
> -               mntput(ipc_ns->mq_mnt);
> +       if (inode_permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE]))
>                return ERR_PTR(-EACCES);
> -       }
>
>        return dentry_open(dentry, ipc_ns->mq_mnt, oflag, cred);
>  }
> @@ -686,7 +678,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
>        struct file *filp;
>        char *name;
>        struct mq_attr attr;
> -       int fd, error;
> +       int fd, error = 0;
>        struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
>
>        if (u_attr && copy_from_user(&attr, u_attr, sizeof(struct mq_attr)))
> @@ -701,13 +693,13 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
>        if (fd < 0)
>                goto out_putname;
>
> +       mntget(ipc_ns->mq_mnt);
>        mutex_lock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);
>        dentry = lookup_one_len(name, ipc_ns->mq_mnt->mnt_root, strlen(name));
>        if (IS_ERR(dentry)) {
>                error = PTR_ERR(dentry);
> -               goto out_err;
> +               goto out_unlock;
>        }
> -       mntget(ipc_ns->mq_mnt);
>
>        if (oflag & O_CREAT) {
>                if (dentry->d_inode) {  /* entry already exists */
> @@ -731,24 +723,23 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
>
>        if (IS_ERR(filp)) {
>                error = PTR_ERR(filp);
> -               goto out_putfd;
> +               goto out;
>        }
>
>        fd_install(fd, filp);
> -       goto out_upsem;
> +       goto out_unlock;
>
>  out:
>        dput(dentry);
> -       mntput(ipc_ns->mq_mnt);
> -out_putfd:
> -       put_unused_fd(fd);
> -out_err:
> -       fd = error;
> -out_upsem:
> +out_unlock:
>        mutex_unlock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);
> +       if (error) {
> +               mntput(ipc_ns->mq_mnt);
> +               put_unused_fd(fd);
> +       }
>  out_putname:
>        putname(name);
> -       return fd;
> +       return error;
>  }
>
>  SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)

I have some questions below:

Inside do_open() and do_create() on mqueue.c, we call
dentry_open()/__dentry_open().

If dentry_open() fails, it'll automatically call:
        dput(dentry);
        mntput(mnt);

Then we'll go here and set "error":

>        if (IS_ERR(filp)) {
>                error = PTR_ERR(filp);
> -               goto out_putfd;
> +               goto out;
>        }
>

And finally here:

>  out:
>        dput(dentry);
> -       mntput(ipc_ns->mq_mnt);
> -out_putfd:
> -       put_unused_fd(fd);
> -out_err:
> -       fd = error;
> -out_upsem:
> +out_unlock:
>        mutex_unlock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);
> +       if (error) {
> +               mntput(ipc_ns->mq_mnt);
> +               put_unused_fd(fd);
> +       }

Is it ok to call:
        dput(dentry);
        mntput(ipc_ns->mq_mnt);

multiple times?

I also do not see where you set "error" to "fd":
> -       return fd;
> +       return error;

Am I missing something?

Could you please base your patch on top of mine?

Thank you,
André
