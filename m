Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZHJVZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZHJVZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZHJVZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:25:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZHJVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:24:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=wOOTm6TD6F486JFNRrPrAbYD/w8lNjGYFsYWKic2sQ7mzHvBZW2Sxwgian2vt98gu
	mAgMM4eObr7FdvbcSfczQ==
Date: Mon, 10 Aug 2009 14:24:48 -0700
From: Mandeep Singh Baines <msb@google.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: Re: [PATCH 3/3] vfs: change sb->s_maxbytes to a loff_t
Message-ID: <20090810212447.GC10147@google.com>
References: <1249906663-7572-1-git-send-email-jlayton@redhat.com> <1249906663-7572-4-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249906663-7572-4-git-send-email-jlayton@redhat.com>
X-Operating-System: Linux/2.6.24-gg24-generic (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton (jlayton@redhat.com) wrote:
> sb->s_maxbytes is supposed to indicate the maximum size of a file that
> can exist on the filesystem. It's declared as an unsigned long long.
> 
> Even if a filesystem has no inherent limit that prevents it from using
> every bit in that unsigned long long, it's still problematic to set it
> to anything larger than MAX_LFS_FILESIZE. There are places in the kernel
> that cast s_maxbytes to a signed value. If it's set too large then this
> cast makes it a negative number and generally breaks the comparison.
> 
> Change s_maxbytes to be loff_t instead. That should help eliminate the
> temptation to set it too large by making it a signed value.
> 
> Also, add a warning for couple of releases to help catch filesystems
> that set s_maxbytes too large. Eventually we can either convert this to
> a BUG() or just remove it and in the hope that no one will get it wrong
> now that it's a signed value.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/super.c         |   10 ++++++++++
>  include/linux/fs.h |    2 +-
>  2 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 2761d3e..660d437 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -889,6 +889,16 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
>   	if (error)
>   		goto out_sb;
>  
> +	/*
> +	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
> +	 * but s_maxbytes was an unsigned long long for many releases. Throw
> +	 * this warning for a little while to try and catch filesystems that
> +	 * violate this rule. This warning should be either removed or
> +	 * converted to a BUG() in 2.6.34. 
> +	 */
> +	WARN((mnt->mnt_sb->s_maxbytes < 0), "WARNING: %s set sb->s_maxbytes to "
> +		"negative value (%lld)\n", type->name, mnt->mnt_sb->s_maxbytes);
> +

Minor nit. "WARNING:" is redundant. I believe WARN() will already print
"WARNING: at <file>:<line>".

>  	mnt->mnt_mountpoint = mnt->mnt_root;
>  	mnt->mnt_parent = mnt;
>  	up_write(&mnt->mnt_sb->s_umount);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 67888a9..bfe3c08 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1316,7 +1316,7 @@ struct super_block {
>  	unsigned long		s_blocksize;
>  	unsigned char		s_blocksize_bits;
>  	unsigned char		s_dirt;
> -	unsigned long long	s_maxbytes;	/* Max file size */
> +	loff_t			s_maxbytes;	/* Max file size */

Looks good to me. Thanks!

>  	struct file_system_type	*s_type;
>  	const struct super_operations	*s_op;
>  	struct dquot_operations	*dq_op;
> -- 
> 1.6.0.6
> 
