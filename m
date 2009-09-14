Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZINRCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZINRCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 13:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZINRC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 13:02:29 -0400
Received: from verein.lst.de ([213.95.11.210]:52178 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZINRC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:02:29 -0400
Date: Mon, 14 Sep 2009 19:02:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       drepper@redhat.com, viro@zeniv.linux.org.uk, kyle@mcmartin.ca
Subject: Re: [PATCHv2 18/16] implement posix O_SYNC and O_DSYNC semantics
Message-ID: <20090914170203.GA26378@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz> <20090910202521.GA20261@lst.de> <20090911191600.GA16390@lst.de> <20090914165419.GD25549@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914165419.GD25549@duck.suse.cz>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 06:54:19PM +0200, Jan Kara wrote:
>   I've sent Linus a pull request without this patch (I have some comments
> to it). When this patch is ready, you can merge it yourself or I can do
> it if you like.

Yeah, much better anyway.  I'll also post a O_RSYNC implementation later
today.

> > Index: linux-2.6/fs/afs/write.c
> > ===================================================================
> > --- linux-2.6.orig/fs/afs/write.c	2009-09-10 21:02:06.710003950 -0300
> > +++ linux-2.6/fs/afs/write.c	2009-09-11 16:11:50.439008144 -0300
> > @@ -692,8 +692,9 @@ ssize_t afs_file_write(struct kiocb *ioc
> >  	}
> >  
> >  	/* return error values for O_SYNC and IS_SYNC() */
> > -	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_SYNC) {
> > -		ret = afs_fsync(iocb->ki_filp, dentry, 1);
> > +	if (IS_SYNC(&vnode->vfs_inode) || iocb->ki_filp->f_flags & O_DSYNC) {
> > +		ret = afs_fsync(iocb->ki_filp, dentry,
> > +				(iocb->ki_filp->f_flags & __O_SYNC) ? 0 : 1);
> >  		if (ret < 0)
> >  			result = ret;
> >  	}
>   This code can go away because generic_file_aio_write() already calls
> fsync()...

Yes, but that should be a separate patch.

> > Index: linux-2.6/arch/mips/include/asm/fcntl.h
> > ===================================================================
> > --- linux-2.6.orig/arch/mips/include/asm/fcntl.h	2009-09-10 21:02:06.443262027 -0300
> > +++ linux-2.6/arch/mips/include/asm/fcntl.h	2009-09-11 16:11:50.495015560 -0300
> > @@ -10,7 +10,7 @@
> >  
> >  
> >  #define O_APPEND	0x0008
> > -#define O_SYNC		0x0010
> > +#define O_DSYNC		000010	/* used to be O_SYNC, see below */
>   The value used to be in hex, not in octal. Moreover I don't see O_SYNC
> defined in the header now...

Thanks, fixed up both bits.

> > Index: linux-2.6/arch/mips/kernel/kspd.c
> > ===================================================================
> > --- linux-2.6.orig/arch/mips/kernel/kspd.c	2009-09-10 21:02:06.465005782 -0300
> > +++ linux-2.6/arch/mips/kernel/kspd.c	2009-09-11 16:11:50.499009085 -0300
> > @@ -82,6 +82,7 @@ static int sp_stopping = 0;
> >  #define MTSP_O_SHLOCK		0x0010
> >  #define MTSP_O_EXLOCK		0x0020
> >  #define MTSP_O_ASYNC		0x0040
> > +/* XXX: check which of these is actually O_SYNC vs O_DSYNC */
> >  #define MTSP_O_FSYNC		O_SYNC
> >  #define MTSP_O_NOFOLLOW		0x0100
> >  #define MTSP_O_SYNC		0x0080
>   Since noone uses MTSP_O_FSYNC and it's not exported, I guess it's your
> choice ;). Looking at the code, it looks slightly incomplete - probably
> open_flags_table should contain all the MTSP_O_... flags but I don't really
> know.

Yeah, I'll hope someone who knows this are better is going to chime in.

>   So for parisc, programs compiled against old headers will fail open
> O_SYNC because of the check in open() you've added will bail out with
> EINVAL. I don't like it  but I'm not sure we can do better...

Hmm.  let me thing about something for parisc.

> > @@ -287,10 +287,11 @@ SYSCALL_DEFINE1(fdatasync, unsigned int,
> >   */
> >  int generic_write_sync(struct file *file, loff_t pos, loff_t count)
> >  {
> > -	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> > +	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
> >  		return 0;
> >  	return vfs_fsync_range(file, file->f_path.dentry, pos,
> > -			       pos + count - 1, 1);
> > +			       pos + count - 1,
> > +			       (file->f_flags & __O_SYNC) ? 1 : 0);
>   The logic is inverted here, isn't it?

Yeah, already correct in my tree after I started to the barrier
testing in qemu that noticed it.
