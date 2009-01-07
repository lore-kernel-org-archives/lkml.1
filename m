Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZAGRry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZAGRry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759864AbZAGRrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:47:42 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:19857 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339AbZAGRrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:47:41 -0500
Subject: Re: [PATCH mmotm] nilfs2: insert checks and hole block allocation
 in page_mkwrite
From: Chris Mason <chris.mason@oracle.com>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090108.023345.105818287.ryusuke@osrg.net>
References: <1231333579-25296-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	 <1231339382.27813.10.camel@think.oraclecorp.com>
	 <20090108.023345.105818287.ryusuke@osrg.net>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 12:47:22 -0500
Message-Id: <1231350442.27813.36.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4964EAAE.007E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 02:33 +0900, Ryusuke Konishi wrote:
> On Wed, 07 Jan 2009 09:43:02 -0500, Chris Mason wrote:
> > On Wed, 2009-01-07 at 22:06 +0900, Ryusuke Konishi wrote:
> > > Chris Mason told me that page_mkwrite() has some works to do.
> > > 
> > > On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> > > > nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
> > > > does more, including checks against i_size and others.
> > > 
> > > This will insert i_size check, and hole block allocation code in the
> > > nilfs_page_mkwrite.
> > > 
> > > Previously, the hole block allocation was delayed until just before
> > > writing for mmapped pages.  This accompanies removal of the delayed
> > > allocation code.
> <snip>
> > >  static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> > >  {
> > > -	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
> > > -		return -EPERM;
> > > +	struct inode *inode = vma->vm_file->f_dentry->d_inode;
> > > +	struct address_space *mapping = inode->i_mapping;
> > > +	struct nilfs_transaction_info ti;
> > > +	struct buffer_head *bh, *head;
> > > +	int fully_mapped = 1;
> > > +	int ret = -EINVAL;
> > > +
> > > +	/*
> > > +	 * use i_alloc_sem to stop truncate operations on the inode
> > > +	 */
> > > +	down_read(&inode->i_alloc_sem);
> > 
> > I'm not 100% sure this is safe.  It seems likely the direct io paths
> > could trigger a mkwrite with the i_alloc_sem already held?
> 
> vmtruncate() can change i_size outside the page lock, and it even
> calls unmap_mapping_range(). Does it have any problems?
> 

You're right, i_size can change without you knowing about it, but before
vmtruncate does anything to the page itself, it locks the page.

So, we tend to do a somewhat racey check against i_size.  If the page is
outside i_size, we happily ignore it.  If it is inside i_size, we assume
it is part of the file.  Most of the code that does this checks i_size
once after locking the page and saves that value, so if i_size changes
later on the code at least does consistent operations based on a single
value of i_size.

If the page straddles i_size and someone extends the file, they are
expected to lock the page as well (see block_truncate_page and the
places it gets called).

-chris


