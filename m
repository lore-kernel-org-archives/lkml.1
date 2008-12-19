Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYLSEiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYLSEiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYLSEhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:37:52 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:3783 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbYLSEhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:37:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACqESkl5LB1f/2dsb2JhbAC+UViQXYMG
X-IronPort-AV: E=Sophos;i="4.36,247,1228051800"; 
   d="scan'208";a="278977598"
Date: Fri, 19 Dec 2008 15:37:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ankit Jain <me@ankitjain.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, mfasheh@suse.com,
       linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH v2] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
Message-ID: <20081219043744.GC17177@disturbed>
Mail-Followup-To: Ankit Jain <me@ankitjain.org>,
	Al Viro <viro@zeniv.linux.org.uk>, mfasheh@suse.com,
	linux-kernel@vger.kernel.org, joel.becker@oracle.com,
	Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	ocfs2-devel@oss.oracle.com
References: <494ABEBC.8060101@ankitjain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <494ABEBC.8060101@ankitjain.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 02:51:00AM +0530, Ankit Jain wrote:
> This patch adds ioctls to vfs for compatibility with legacy XFS
> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
> effectively invokes sys_fallocate for the new ioctls.
> Note: These legacy ioctls are also implemented by OCFS2.
> 
> Changes in v2:
> - Dropped the incorrect handling of *UNRESVSP* ioctl.
> - Made the ioctl and argument structure kernel only (__KERNEL__)
> 
> Signed-off-by: Ankit Jain <me@ankitjain.org>
.....
> @@ -361,6 +393,9 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
>  		return put_user(inode->i_sb->s_blocksize, p);
>  	case FIONREAD:
>  		return put_user(i_size_read(inode) - filp->f_pos, p);
> +	case F_IOC_RESVSP:
> +	case F_IOC_RESVSP64:
> +		return ioctl_preallocate(filp, arg);
>  	}
>  
>  	return vfs_ioctl(filp, cmd, arg);

Adding this here breaks XFS_IOC_RESVSP in subtle and interesting
ways.

XFS_IOC_RESVSP supports invisible I/O, and that means
XFS_IOC_RESVSP needs to be passed through to vfs_ioctl()
to vector to XFS to handle.

This happenѕ because:

> +struct space_resv {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start;
> +	__s64		l_len;		/* len == 0 means until end of file */
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area			    */
> +};
> +
> +#define F_IOC_RESVSP		_IOW('X', 40, struct space_resv)
> +#define F_IOC_RESVSP64		_IOW('X', 42, struct space_resv)

Is the same as:

#define XFS_IOC_RESVSP          _IOW ('X', 40, struct xfs_flock64)
#define XFS_IOC_RESVSP64        _IOW ('X', 42, struct xfs_flock64)

because:

typedef struct xfs_flock64 {
        __s16           l_type;
        __s16           l_whence;
        __s64           l_start;
        __s64           l_len;          /* len == 0 means until end of file */
        __s32           l_sysid;
        __u32           l_pid;
        __s32           l_pad[4];       /* reserve area                     */
} xfs_flock64_t;


is the same size as struct space_resv. Hence existing calls to
XFS_IOC_RESVSP will now vector incorrectly down the fallocate path
resulting in invisible operations will now be visible....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
