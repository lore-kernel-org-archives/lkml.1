Return-Path: <linux-kernel-owner+w=401wt.eu-S1767831AbXCJGGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767831AbXCJGGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767837AbXCJGGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:06:04 -0500
Received: from ms-smtp-04.texas.rr.com ([24.93.47.43]:56461 "EHLO
	ms-smtp-04.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767831AbXCJGGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:06:02 -0500
Message-ID: <45F24AD3.3010003@austin.rr.com>
Date: Sat, 10 Mar 2007 00:06:11 -0600
From: Steve French <smfrench@austin.rr.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CIFS: reset file mode when CIFS client notices that ATTR_READONLY
 is no longer set
References: <200703092049.l29KnKgh009449@dantu.rdu.redhat.com>
In-Reply-To: <200703092049.l29KnKgh009449@dantu.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> This problem and patch were discovered and written by Alan Tyson of HP, who
> asked that I post this. The problem is this:
>
> When the CIFS client mounts a share that does not have Unix extensions, it
> will turn off the "w" bits in the file mode if it sees that ATTR_READONLY is
> set. It has no corresponding logic, however, to reenable write permissions if
> the ATTR_READONLY flag is later removed. This results in a situation where a
> file gets "stuck" as read-only. Steps to reproduce this bug are in the
> following samba.org BZ:
>
> https://bugzilla.samba.org/show_bug.cgi?id=4443
>
> The patch below corrects this with the following logic:
>
> If unix extensions were not negotiated for the mount, and the server does not
> report ATTR_READONLY being set for the file then check the mode bits on the
> inode. If no write bits are set, then assume that ATTR_READONLY was previously
> set for this file but is not now, and set any write bits allowed by the
> mnt_file_mode.
>
> This logic seems reasonable, but I'm not certain that there aren't cases where
> it would fall down. Comments and/or ACK's appreciated...
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 86b9dbb..e75a844 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -494,6 +494,12 @@ int cifs_get_inode_info(struct inode **pinode,
>  			   mode e.g. 555 */
>  			if (cifsInfo->cifsAttrs & ATTR_READONLY)
>  				inode->i_mode &= ~(S_IWUGO);
> +			else if ((inode->i_mode & S_IWUGO) == 0)
> +				/* the ATTR_READONLY flag may have been	*/
> +				/* changed on server -- set any w bits	*/
> +				/* allowed by mnt_file_mode		*/
> +				inode->i_mode |= (S_IWUGO &
> +						  cifs_sb->mnt_file_mode);
>  		/* BB add code here -
>  		   validate if device or weird share or device type? */
>  		}
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 44cfb52..2a374d5 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -219,6 +219,10 @@ static void fill_in_inode(struct inode *tmp_inode, int new_buf_type,
>  		tmp_inode->i_mode |= S_IFREG;
>  		if (attr & ATTR_READONLY)
>  			tmp_inode->i_mode &= ~(S_IWUGO);
> +		else if ((tmp_inode->i_mode & S_IWUGO) == 0)
> +			/* the ATTR_READONLY flag may have been changed on   */
> +		   	/* server -- set any w bits allowed by mnt_file_mode */
> +			tmp_inode->i_mode |= (S_IWUGO & cifs_sb->mnt_file_mode);
>  	} /* could add code here - to validate if device or weird share type? */
>  
>  	/* can not fill in nlink here as in qpathinfo version and Unx search */
>
>   
OK - this is checked in to cifs tree.  Let me know if you think it is 
important enough to push up at this stage to mainline.
