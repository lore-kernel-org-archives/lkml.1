Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYGAOJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYGAOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYGAOJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:09:44 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:7059 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYGAOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ecWgzIq9ZEKOD7xUclm11SU3ORhRAAs1RfI7B47NUdxA8qcVwgAWHfaxmua/C5whWO
         ScnNxrqOlO0MIhL8uj2r4ieY7WOizpZzSH9G+LJlUqBq1OQ2gGhU3OIvuRskA3r1IwK9
         9QjrGeYVlr6PLCeXGZO46YBobNePgr8sFClXk=
Message-ID: <cfd18e0f0807010709veab05adg2c6566a79b7baabb@mail.gmail.com>
Date: Tue, 1 Jul 2008 16:09:40 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch 1/4] vfs: utimes: move owner check into inode_change_ok()
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, "Ulrich Drepper" <drepper@redhat.com>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <20080701130150.978939061@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701130125.529844715@szeredi.hu>
	 <20080701130150.978939061@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On Tue, Jul 1, 2008 at 3:01 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Add a new ia_valid flag: ATTR_TIMES_SET, to handle the
> UTIMES_OMIT/UTIMES_NOW and UTIMES_NOW/UTIMES_OMIT cases.  In these
> cases neither ATTR_MTIME_SET nor ATTR_ATIME_SET is in the flags, yet
> the POSIX draft specifies that permission checking is performed the
> same way as if one or both of the times was explicitly set to a
> timestamp.
>
> See the path "vfs: utimensat(): fix error checking for
> {UTIME_NOW,UTIME_OMIT} case" by Michael Kerrisk for the patch
> introducing this behavior.
>
> This is a cleanup, as well as allowing filesystems (NFS/fuse/...) to
> perform their own permission checking instead of the default.

What kernel version/tree is this patch against?

Cheers,

Michael

> CC: Ulrich Drepper <drepper@redhat.com>
> CC: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/attr.c          |    2 +-
>  fs/utimes.c        |   17 ++++-------------
>  include/linux/fs.h |   33 +++++++++++++++++----------------
>  3 files changed, 22 insertions(+), 30 deletions(-)
>
> Index: linux-2.6/fs/attr.c
> ===================================================================
> --- linux-2.6.orig/fs/attr.c    2008-06-27 22:09:08.000000000 +0200
> +++ linux-2.6/fs/attr.c 2008-07-01 13:52:20.000000000 +0200
> @@ -51,7 +51,7 @@ int inode_change_ok(struct inode *inode,
>        }
>
>        /* Check for setting the inode time. */
> -       if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
> +       if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_TIMES_SET)) {
>                if (!is_owner_or_cap(inode))
>                        goto error;
>        }
> Index: linux-2.6/fs/utimes.c
> ===================================================================
> --- linux-2.6.orig/fs/utimes.c  2008-07-01 08:10:12.000000000 +0200
> +++ linux-2.6/fs/utimes.c       2008-07-01 13:52:20.000000000 +0200
> @@ -101,7 +101,6 @@ long do_utimes(int dfd, char __user *fil
>                     times[1].tv_nsec == UTIME_NOW)
>                times = NULL;
>
> -       /* In most cases, the checks are done in inode_change_ok() */
>        newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
>        if (times) {
>                error = -EPERM;
> @@ -123,21 +122,13 @@ long do_utimes(int dfd, char __user *fil
>                        newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
>                        newattrs.ia_valid |= ATTR_MTIME_SET;
>                }
> -
>                /*
> -                * For the UTIME_OMIT/UTIME_NOW and UTIME_NOW/UTIME_OMIT
> -                * cases, we need to make an extra check that is not done by
> -                * inode_change_ok().
> +                * Tell inode_change_ok(), that this is an explicit time
> +                * update, even if neither ATTR_ATIME_SET nor ATTR_MTIME_SET
> +                * were used.
>                 */
> -               if (((times[0].tv_nsec == UTIME_NOW &&
> -                           times[1].tv_nsec == UTIME_OMIT)
> -                    ||
> -                    (times[0].tv_nsec == UTIME_OMIT &&
> -                           times[1].tv_nsec == UTIME_NOW))
> -                   && !is_owner_or_cap(inode))
> -                       goto mnt_drop_write_and_out;
> +               newattrs.ia_valid |= ATTR_TIMES_SET;
>        } else {
> -
>                /*
>                 * If times is NULL (or both times are UTIME_NOW),
>                 * then we need to check permissions, because
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h   2008-07-01 13:52:19.000000000 +0200
> +++ linux-2.6/include/linux/fs.h        2008-07-01 13:52:20.000000000 +0200
> @@ -317,22 +317,23 @@ typedef void (dio_iodone_t)(struct kiocb
>  * Attribute flags.  These should be or-ed together to figure out what
>  * has been changed!
>  */
> -#define ATTR_MODE      1
> -#define ATTR_UID       2
> -#define ATTR_GID       4
> -#define ATTR_SIZE      8
> -#define ATTR_ATIME     16
> -#define ATTR_MTIME     32
> -#define ATTR_CTIME     64
> -#define ATTR_ATIME_SET 128
> -#define ATTR_MTIME_SET 256
> -#define ATTR_FORCE     512     /* Not a change, but a change it */
> -#define ATTR_ATTR_FLAG 1024
> -#define ATTR_KILL_SUID 2048
> -#define ATTR_KILL_SGID 4096
> -#define ATTR_FILE      8192
> -#define ATTR_KILL_PRIV 16384
> -#define ATTR_OPEN      32768   /* Truncating from open(O_TRUNC) */
> +#define ATTR_MODE      (1 << 0)
> +#define ATTR_UID       (1 << 1)
> +#define ATTR_GID       (1 << 2)
> +#define ATTR_SIZE      (1 << 3)
> +#define ATTR_ATIME     (1 << 4)
> +#define ATTR_MTIME     (1 << 5)
> +#define ATTR_CTIME     (1 << 6)
> +#define ATTR_ATIME_SET (1 << 7)
> +#define ATTR_MTIME_SET (1 << 8)
> +#define ATTR_FORCE     (1 << 9) /* Not a change, but a change it */
> +#define ATTR_ATTR_FLAG (1 << 10)
> +#define ATTR_KILL_SUID (1 << 11)
> +#define ATTR_KILL_SGID (1 << 12)
> +#define ATTR_FILE      (1 << 13)
> +#define ATTR_KILL_PRIV (1 << 14)
> +#define ATTR_OPEN      (1 << 15) /* Truncating from open(O_TRUNC) */
> +#define ATTR_TIMES_SET (1 << 16)
>
>  /*
>  * This is the Inode Attributes structure, used for notify_change().  It
>
> --
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
