Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966682Ab0B0AML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:12:11 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:27494 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966626Ab0B0AMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:12:09 -0500
Message-ID: <4B886333.7010505@oracle.com>
Date: Fri, 26 Feb 2010 16:11:31 -0800
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joel Becker <joel.becker@oracle.com>
CC: ocfs2-devel@oss.oracle.com, mfasheh@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 09/11] ocfs2_dlmfs: Don't honor truncate.
 The size of a dlmfs file is LVB_LEN
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com> <1265794074-19539-10-git-send-email-joel.becker@oracle.com>
In-Reply-To: <1265794074-19539-10-git-send-email-joel.becker@oracle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B886353.00C5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>


Joel Becker wrote:
> We want folks using dlmfs to be able to use the LVB in places other than
> just write(2)/read(2).  By ignoring truncate requests, we allow 'echo
> "contents" > /dlm/space/lockname' to work.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/dlmfs/dlmfs.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index e21ce0e..13ac2bf 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -220,6 +220,23 @@ static int dlmfs_file_release(struct inode *inode,
>  	return 0;
>  }
>  
> +/*
> + * We do ->setattr() just to override size changes.  Our size is the size
> + * of the LVB and nothing else.
> + */
> +static int dlmfs_file_setattr(struct dentry *dentry, struct iattr *attr)
> +{
> +	int error;
> +	struct inode *inode = dentry->d_inode;
> +
> +	attr->ia_valid &= ~ATTR_SIZE;
> +	error = inode_change_ok(inode, attr);
> +	if (!error)
> +		error = inode_setattr(inode, attr);
> +
> +	return error;
> +}
> +
>  static unsigned int dlmfs_file_poll(struct file *file, poll_table *wait)
>  {
>  	int event = 0;
> @@ -634,6 +651,7 @@ static const struct super_operations dlmfs_ops = {
>  
>  static const struct inode_operations dlmfs_file_inode_operations = {
>  	.getattr	= simple_getattr,
> +	.setattr	= dlmfs_file_setattr,
>  };
>  
>  static int dlmfs_get_sb(struct file_system_type *fs_type,
>   

