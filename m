Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbZAGRik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbZAGRik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZAGRiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:38:15 -0500
Received: from sh.osrg.net ([192.16.179.4]:32923 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZAGRiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:38:13 -0500
Date: Thu, 08 Jan 2009 02:33:45 +0900 (JST)
Message-Id: <20090108.023345.105818287.ryusuke@osrg.net>
To: chris.mason@oracle.com
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm] nilfs2: insert checks and hole block allocation
 in page_mkwrite
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1231339382.27813.10.camel@think.oraclecorp.com>
References: <1231333579-25296-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1231339382.27813.10.camel@think.oraclecorp.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jan 2009 09:43:02 -0500, Chris Mason wrote:
> On Wed, 2009-01-07 at 22:06 +0900, Ryusuke Konishi wrote:
> > Chris Mason told me that page_mkwrite() has some works to do.
> > 
> > On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> > > nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
> > > does more, including checks against i_size and others.
> > 
> > This will insert i_size check, and hole block allocation code in the
> > nilfs_page_mkwrite.
> > 
> > Previously, the hole block allocation was delayed until just before
> > writing for mmapped pages.  This accompanies removal of the delayed
> > allocation code.
<snip>
> >  static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> >  {
> > -	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
> > -		return -EPERM;
> > +	struct inode *inode = vma->vm_file->f_dentry->d_inode;
> > +	struct address_space *mapping = inode->i_mapping;
> > +	struct nilfs_transaction_info ti;
> > +	struct buffer_head *bh, *head;
> > +	int fully_mapped = 1;
> > +	int ret = -EINVAL;
> > +
> > +	/*
> > +	 * use i_alloc_sem to stop truncate operations on the inode
> > +	 */
> > +	down_read(&inode->i_alloc_sem);
> 
> I'm not 100% sure this is safe.  It seems likely the direct io paths
> could trigger a mkwrite with the i_alloc_sem already held?

vmtruncate() can change i_size outside the page lock, and it even
calls unmap_mapping_range(). Does it have any problems?

> If I'm reading the code correctly you're:
> 
> * grab i_alloc sem to protect against truncate
> * check to see if the page is mapped already (no holes)
> 
> * if there are holes, lock the page, start transaction and do the full
> block_page_mkwrite
> 
> * drop i_alloc_sem

Yes, it is.
 
> Would this work instead?:
> 
> * lock the page, check to see if it is mapped
> 
> * if there are holes, drop the lock, start transaction and do the full
> block_page_mkwrite
> 
> -chris

If we don't need care for vmtruncate(), I think it's better, too.

Regards,
Ryusuke
