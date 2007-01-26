Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbXAZMkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbXAZMkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 07:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXAZMkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 07:40:10 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:4172 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbXAZMkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 07:40:08 -0500
Message-ID: <45B9F939.8070701@openvz.org>
Date: Fri, 26 Jan 2007 15:51:05 +0300
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] have pipefs ensure i_ino uniqueness by calling iunique
 and hashing the inode
References: <200612291911.kBTJBLvx019107@dantu.rdu.redhat.com>
In-Reply-To: <200612291911.kBTJBLvx019107@dantu.rdu.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

is 100% uniqeness is so much required for pipe inode numbers?
AFAIU, it is not that critical for pipefs (unlike smb, nfs etc.)

Thanks,
Kirill

> This converts pipefs to use the new scheme. Here we're calling iunique to get
> a unique i_ino value for the new inode, and then hashing it afterward. We
> call iunique with a max_reserved value of 1 to avoid collision with the root
> inode.  Since the inode is now hashed, we need to take care that we end up in
> generic_delete_inode rather than generic_forget_inode or we'll create a nasty
> leak, so we clear_nlink when we destroy the pipe info.
> 
> I'm not certain that this is the right place to add the clear_nlink, though
> it does seem to work. I'm open to suggestions on a better place to put
> this, or of a better way to make sure that we end up with i_nlink == 0 at
> iput time.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 68090e8..1d44ff0 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -825,6 +825,7 @@ void free_pipe_info(struct inode *inode)
>  {
>  	__free_pipe_info(inode->i_pipe);
>  	inode->i_pipe = NULL;
> +	clear_nlink(inode);
>  }
>  
>  static struct vfsmount *pipe_mnt __read_mostly;
> @@ -871,6 +872,8 @@ static struct inode * get_pipe_inode(void)
>  	inode->i_uid = current->fsuid;
>  	inode->i_gid = current->fsgid;
>  	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_ino = iunique(pipe_mnt->mnt_sb, 1);
> +	insert_inode_hash(inode);
>  
>  	return inode;
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

