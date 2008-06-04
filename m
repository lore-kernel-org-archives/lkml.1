Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYFDJ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYFDJ1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYFDJ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:27:31 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:56876 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbYFDJ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MSBMja6qBH7g/b9sMHdCUhWSjDFa9Jc2/t2VGKbLDEXpP+KwoHl6KCVov2xaUD6VDz8RZVhYK/QGTXVQhoLhA5tGpVMagg6Hkb+Iz16guy2y9KOjcwsyH1VGVw3z74EOeDAB0f7jK2mmLM5kgSWdCNyF77+XOYSpnVvI19BVEqk=
Message-ID: <cfd18e0f0806040227h448f146ap7754c194b50dadb8@mail.gmail.com>
Date: Wed, 4 Jun 2008 11:27:18 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [parch 3/4] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT} case
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       viro@zeniv.linux.org.uk, jamie@shareable.org, drepper@redhat.com,
       linux-fsdevel@vger.kernel.org, subrata@linux.vnet.ibm.com
In-Reply-To: <E1K3lIS-0007lg-4e@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4845C4CA.5070403@gmail.com>
	 <E1K3kkj-0007gR-Pb@pomaz-ex.szeredi.hu>
	 <E1K3lIS-0007lg-4e@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 7:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > Miklos suggested an alternative idea, migrating the
>> > is_owner_or_cap() checks into fs/attr.c:inode_change_ok() via
>> > the use of an ATTR_OWNER_CHECK flag.  Maybe we could do that
>> > later, but for now I've gone with this version, which is
>> > simpler, and can be more easily read as being correct.
>>
>> Wise decision.
>
> Or maybe not.  Isn't this a simpler and more readable patch?

The idea is okay (we talked about it already), but I don't like doing
it now because it only migrates *one* of the is_owner_or_cap() checks
out of do_utimes().  We could revisit this later in the context of
migrating both checks out of do_utimes(), but I'd prefer to leave that
for now.

> Index: linux/fs/attr.c
> ===================================================================
> --- linux.orig/fs/attr.c        2008-06-03 13:10:11.000000000 +0200
> +++ linux/fs/attr.c     2008-06-04 07:07:23.000000000 +0200
> @@ -51,7 +51,7 @@ int inode_change_ok(struct inode *inode,
>        }
>
>        /* Check for setting the inode time. */
> -       if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
> +       if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_UPDATE_TIMES)) {
>                if (!is_owner_or_cap(inode))
>                        goto error;
>        }
> Index: linux/fs/utimes.c
> ===================================================================
> --- linux.orig/fs/utimes.c      2008-06-03 13:10:11.000000000 +0200
> +++ linux/fs/utimes.c   2008-06-04 07:10:53.000000000 +0200
> @@ -102,9 +102,14 @@ long do_utimes(int dfd, char __user *fil
>        if (error)
>                goto dput_and_out;
>
> -       /* Don't worry, the checks are done in inode_change_ok() */
>        newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
>        if (times) {
> +               /*
> +                * Checking the owner is done in inode_change_ok(),
> +                * even for the special UTIME_OMIT/UTIME_NOW cases.
> +                */
> +               newattrs.ia_valid |= ATTR_UPDATE_TIMES
> +
>                error = -EPERM;
>                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
>                        goto mnt_drop_write_and_out;
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h       2008-06-03 13:10:25.000000000 +0200
> +++ linux/include/linux/fs.h    2008-06-04 07:07:43.000000000 +0200
> @@ -333,6 +333,7 @@ typedef void (dio_iodone_t)(struct kiocb
>  #define ATTR_FILE      8192
>  #define ATTR_KILL_PRIV 16384
>  #define ATTR_OPEN      32768   /* Truncating from open(O_TRUNC) */
> +#define ATTR_UPDATE_TIMES      (1 << 16)
>
>  /*
>  * This is the Inode Attributes structure, used for notify_change().  It
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
