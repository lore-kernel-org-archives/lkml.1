Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZINQyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZINQyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZINQyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:54:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZINQyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:54:17 -0400
Date: Mon, 14 Sep 2009 18:54:19 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       drepper@redhat.com, viro@zeniv.linux.org.uk, kyle@mcmartin.ca
Subject: Re: [PATCHv2 18/16] implement posix O_SYNC and O_DSYNC semantics
Message-ID: <20090914165419.GD25549@duck.suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz> <20090910202521.GA20261@lst.de> <20090911191600.GA16390@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911191600.GA16390@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Fri 11-09-09 21:16:00, Christoph Hellwig wrote:
> While Linux provided an O_SYNC flag basically since day 1, it took until
> Linux 2.4.0-test12pre2 to actually get it implemented for filesystems,
> since that day we had generic_osync_around with only minor changes and the
> great "For now, when the user asks for O_SYNC, we'll actually give O_DSYNC"
> comment.  This patch intends to actually give us real O_SYNC semantics
> in addition to the O_DSYNC semantics.  After Jan's O_SYNC patches which
> are required before this patch it's actually surprisingly simple, we
> just need to figure out when to set the datasync flag to vfs_fsync_range
> and when not.
> 
> This patch renames the existing O_SYNC flag to O_DSYNC while keeping
> it's numerical value to keep binary compatibility, and adds a new real
> O_SYNC flag.  To guarantee backwards compatiblity it is defined as
> expanding to both the O_DSYNC and the new additional binary flag
> (__O_SYNC) to make sure we are backwards-compatible when compiled against
> the new headers.
> 
> This also means that all places that don't care about the differences
> can just check O_DSYNC and get the right behaviour for O_SYNC, too - only
> places that actuall care need to check __O_SYNC in addition.  Drivers
> and network filesystems have been updated in a fail safe way to always
> do the full sync magic if O_DSYNC is set.  The few places setting O_SYNC
> for lower layers are kept that way for now to stay failsafe.
> 
> Note that parisc really fucked up their headers as they already define
> a O_DSYNC that has always been a no-op.  We try to repair it by using it
> for the new O_DSYNC and redefinining O_SYNC to send both the traditional
> O_SYNC numerical value _and_ the O_DSYNC one.
  I've sent Linus a pull request without this patch (I have some comments
to it). When this patch is ready, you can merge it yourself or I can do
it if you like.

> Index: linux-2.6/fs/afs/write.c
> ===================================================================
> --- linux-2.6.orig/fs/afs/write.c	2009-09-10 21:02:06.710003950 -0300
> +++ linux-2.6/fs/afs/write.c	2009-09-11 16:11:50.439008144 -0300
> @@ -692,8 +692,9 @@ ssize_t afs_file_write(struct kiocb *ioc
>  	}
>  
>  	/* return error values for O_SYNC and IS_SYNC() */
> -	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_SYNC) {
> -		ret = afs_fsync(iocb->ki_filp, dentry, 1);
> +	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_DSYNC) {
> +		ret = afs_fsync(iocb->ki_filp, dentry,
> +				(iocb->ki_filp->f_flags & __O_SYNC) ? 0 : 1);
>  		if (ret < 0)
>  			result = ret;
>  	}
  This code can go away because generic_file_aio_write() already calls
fsync()...

> Index: linux-2.6/arch/mips/include/asm/fcntl.h
> ===================================================================
> --- linux-2.6.orig/arch/mips/include/asm/fcntl.h	2009-09-10 21:02:06.443262027 -0300
> +++ linux-2.6/arch/mips/include/asm/fcntl.h	2009-09-11 16:11:50.495015560 -0300
> @@ -10,7 +10,7 @@
>  
>  
>  #define O_APPEND	0x0008
> -#define O_SYNC		0x0010
> +#define O_DSYNC		000010	/* used to be O_SYNC, see below */
  The value used to be in hex, not in octal. Moreover I don't see O_SYNC
defined in the header now...

> Index: linux-2.6/arch/mips/kernel/kspd.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/kernel/kspd.c	2009-09-10 21:02:06.465005782 -0300
> +++ linux-2.6/arch/mips/kernel/kspd.c	2009-09-11 16:11:50.499009085 -0300
> @@ -82,6 +82,7 @@ static int sp_stopping = 0;
>  #define MTSP_O_SHLOCK		0x0010
>  #define MTSP_O_EXLOCK		0x0020
>  #define MTSP_O_ASYNC		0x0040
> +/* XXX: check which of these is actually O_SYNC vs O_DSYNC */
>  #define MTSP_O_FSYNC		O_SYNC
>  #define MTSP_O_NOFOLLOW		0x0100
>  #define MTSP_O_SYNC		0x0080
  Since noone uses MTSP_O_FSYNC and it's not exported, I guess it's your
choice ;). Looking at the code, it looks slightly incomplete - probably
open_flags_table should contain all the MTSP_O_... flags but I don't really
know.

> Index: linux-2.6/arch/parisc/include/asm/fcntl.h
> ===================================================================
> --- linux-2.6.orig/arch/parisc/include/asm/fcntl.h	2009-09-10 21:02:06.618023193 -0300
> +++ linux-2.6/arch/parisc/include/asm/fcntl.h	2009-09-11 16:11:50.512006342 -0300
> @@ -1,14 +1,13 @@
>  #ifndef _PARISC_FCNTL_H
>  #define _PARISC_FCNTL_H
>  
> -/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
> -   located on an ext2 file system */
>  #define O_APPEND	000000010
>  #define O_BLKSEEK	000000100 /* HPUX only */
>  #define O_CREAT		000000400 /* not fcntl */
>  #define O_EXCL		000002000 /* not fcntl */
>  #define O_LARGEFILE	000004000
> -#define O_SYNC		000100000
> +#define __O_SYNC	000100000
> +#define O_SYNC		(__O_SYNC|O_DSYNC)
>  #define O_NONBLOCK	000200004 /* HPUX has separate NDELAY & NONBLOCK */
>  #define O_NOCTTY	000400000 /* not fcntl */
>  #define O_DSYNC		001000000 /* HPUX only */
  So for parisc, programs compiled against old headers will fail open
O_SYNC because of the check in open() you've added will bail out with
EINVAL. I don't like it  but I'm not sure we can do better...

> Index: linux-2.6/fs/sync.c
> ===================================================================
> --- linux-2.6.orig/fs/sync.c	2009-09-11 16:11:49.725278522 -0300
> +++ linux-2.6/fs/sync.c	2009-09-11 16:11:50.516015792 -0300
> @@ -287,10 +287,11 @@ SYSCALL_DEFINE1(fdatasync, unsigned int,
>   */
>  int generic_write_sync(struct file *file, loff_t pos, loff_t count)
>  {
> -	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> +	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
>  		return 0;
>  	return vfs_fsync_range(file, file->f_path.dentry, pos,
> -			       pos + count - 1, 1);
> +			       pos + count - 1,
> +			       (file->f_flags & __O_SYNC) ? 1 : 0);
  The logic is inverted here, isn't it?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
