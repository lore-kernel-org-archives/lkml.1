Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZAGOna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZAGOna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZAGOnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:43:20 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:44200 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZAGOnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:43:19 -0500
Subject: Re: [PATCH mmotm] nilfs2: insert checks and hole block allocation
 in page_mkwrite
From: Chris Mason <chris.mason@oracle.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1231333579-25296-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1231333579-25296-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 09:43:02 -0500
Message-Id: <1231339382.27813.10.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4964BF79.0117:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 22:06 +0900, Ryusuke Konishi wrote:
> Chris Mason told me that page_mkwrite() has some works to do.
> 
> On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> > nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
> > does more, including checks against i_size and others.
> 
> This will insert i_size check, and hole block allocation code in the
> nilfs_page_mkwrite.
> 
> Previously, the hole block allocation was delayed until just before
> writing for mmapped pages.  This accompanies removal of the delayed
> allocation code.
> 
> Cc: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
> ---
>  fs/nilfs2/file.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/nilfs2/segment.c |   42 ++++--------------------------------
>  2 files changed, 62 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 7ddd42e..146dc23 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -75,11 +75,66 @@ nilfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  
>  static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  {
> -	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
> -		return -EPERM;
> +	struct inode *inode = vma->vm_file->f_dentry->d_inode;
> +	struct address_space *mapping = inode->i_mapping;
> +	struct nilfs_transaction_info ti;
> +	struct buffer_head *bh, *head;
> +	int fully_mapped = 1;
> +	int ret = -EINVAL;
> +
> +	/*
> +	 * use i_alloc_sem to stop truncate operations on the inode
> +	 */
> +	down_read(&inode->i_alloc_sem);

I'm not 100% sure this is safe.  It seems likely the direct io paths
could trigger a mkwrite with the i_alloc_sem already held?

If I'm reading the code correctly you're:

* grab i_alloc sem to protect against truncate
* check to see if the page is mapped already (no holes)

* if there are holes, lock the page, start transaction and do the full
block_page_mkwrite

* drop i_alloc_sem

Would this work instead?:

* lock the page, check to see if it is mapped

* if there are holes, drop the lock, start transaction and do the full
block_page_mkwrite

-chris


