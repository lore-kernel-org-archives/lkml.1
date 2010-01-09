Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528Ab0AIByX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0AIByX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 20:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711Ab0AIByW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 20:54:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45980 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab0AIByW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 20:54:22 -0500
Date: Sat, 9 Jan 2010 01:54:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] NFS: Fix a potential deadlock in
	nfs_file_mmap()
Message-ID: <20100109015419.GF30528@ZenIV.linux.org.uk>
References: <20100109005624.7473.33215.stgit@localhost.localdomain> <20100109005624.7473.15560.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100109005624.7473.15560.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 07:56:24PM -0500, Trond Myklebust wrote:
> We cannot call nfs_invalidate_mapping() inside file->f_ops->mmap(), since
> this would cause us to grab the inode->i_mutex while already holding the
> current->mm->mmap_sem (thus causing a potential ABBA deadlock with the file
> write code, which can grab those locks in the opposite order).
> 
> We can fix this situation for the mmap() system call by using the new
> mmap_pgoff() callback, which is called prior to taking the
> current->mm->mmap_sem mutex.
> 
> We also add ensure that open() invalidates the mapping if the inode data is
> stale so that other users of mmap() (mainly the exec and uselib system
> calls) get up to date data too.
 
> +	status = nfs_revalidate_mapping(inode, file->f_mapping);
> +	if (status < 0)
> +		return status;
> +
> +	return generic_file_mmap_pgoff(file, addr, len, prot, flags, pgoff);

This is completely bogus.  Why do you need i_mutex for that and what
the <expletives> does that really prevent?  You might wait for a _loong_
time waiting for that mmap_sem, so what is really going on there?
