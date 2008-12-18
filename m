Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752700AbYLRJo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbYLRJo4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYLRJoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:44:44 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:57494 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYLRJon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:44:43 -0500
Message-ID: <494A1B69.70300@ankitjain.org>
Date: Thu, 18 Dec 2008 15:14:09 +0530
From: Ankit Jain <me@ankitjain.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, joel.becker@oracle.com,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for compatibility
 with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org> <20081217202815.GE8791@wotan.suse.de>
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Fasheh wrote:
>> 2. Should the corresponding ioctls be removed from ocfs2?
> 
> Well, a small amount of the code in fs/ocfs2/ioctl.c can certainly go away.
> Shouldn't we be talking about doing the same for xfs too?

Yep. I'll cook up cleanup patches for these two and post them.

-Ankit

> 
> 
>> Signed-off-by: Ankit Jain <me@ankitjain.org>
>> ---
>>  fs/ioctl.c             |   37 +++++++++++++++++++++++++++
>>  fs/open.c              |   51 ++++++++++++++++++-------------------
>>  include/linux/falloc.h |   19 ++++++++++++++
>>  include/linux/fs.h     |    2 +
>>  4 files changed, 83 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/ioctl.c b/fs/ioctl.c
>> index 43e8b2c..5e565c8 100644
>> --- a/fs/ioctl.c
>> +++ b/fs/ioctl.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/uaccess.h>
>>  #include <linux/writeback.h>
>>  #include <linux/buffer_head.h>
>> +#include <linux/falloc.h>
>>  
>>  #include <asm/ioctls.h>
>>  
>> @@ -346,6 +347,37 @@ EXPORT_SYMBOL(generic_block_fiemap);
>>  
>>  #endif  /*  CONFIG_BLOCK  */
>>  
>> +/*
>> + * This provides compatibility with legacy XFS pre-allocation ioctls
>> + * which predate the fallocate syscall.
>> + *
>> + * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
>> + * are used here, rest are ignored.
>> + */
>> +static int ioctl_preallocate(struct file *filp, unsigned long arg)
>> +{
>> +	struct inode *inode = filp->f_path.dentry->d_inode;
>> +	struct space_resv sr;
>> +
>> +	if (copy_from_user(&sr, (struct space_resv __user *) arg, sizeof(sr)))
>> +		return -EFAULT;
>> +
>> +	switch (sr.l_whence) {
>> +	case SEEK_SET:
>> +		break;
>> +	case SEEK_CUR:
>> +		sr.l_start += filp->f_pos;
>> +		break;
>> +	case SEEK_END:
>> +		sr.l_start += i_size_read(inode);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return do_fallocate(filp, FALLOC_FL_KEEP_SIZE, sr.l_start, sr.l_len);
>> +}
>> +
>>  static int file_ioctl(struct file *filp, unsigned int cmd,
>>  		unsigned long arg)
>>  {
>> @@ -361,6 +393,11 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
>>  		return put_user(inode->i_sb->s_blocksize, p);
>>  	case FIONREAD:
>>  		return put_user(i_size_read(inode) - filp->f_pos, p);
>> +	case F_IOC_RESVSP:
>> +	case F_IOC_RESVSP64:
>> +	case F_IOC_UNRESVSP:
>> +	case F_IOC_UNRESVSP64:
>> +		return ioctl_preallocate(filp, arg);
> 
> This patch is not implementing proper support for F_IOC_UNRESVSP and
> F_IOC_UNRESVSP64, so why are you catching those here? To be more clear,
> those are used for freeing space in a file ("puching holes"), which
> fallocate is not set up to do right now.
> 	--Mark
> 
> --
> Mark Fasheh

