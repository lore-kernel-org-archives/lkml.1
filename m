Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbZLOXiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbZLOXiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZLOXit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:38:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47123 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZLOXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:38:47 -0500
Date: Wed, 16 Dec 2009 00:38:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
Subject: Re: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091215233841.GE22392@basil.fritz.box>
References: <20091207115949.GA7610@basil.fritz.box> <20091207211216.E95E.A69D9226@jp.fujitsu.com> <20091207132009.GI18989@one.firstfloor.org> <20091215222134.GA27892@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215222134.GA27892@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:21:34PM +0000, Al Viro wrote:
> On Mon, Dec 07, 2009 at 02:20:09PM +0100, Andi Kleen wrote:
> > >    nfs_readdir
> > >      nfs_do_filldir
> > >        filldir
> > >          copy_to_user
> > >            [page_fault]			[grab mmap_sem]
> > > 
> > >  sys_mmap				[grab mmap_sem]
> > >    do_mmap_pgoff
> > >      mmap_region
> > >        nfs_file_mmap
> > >          nfs_revalidate_mapping  
> > >            nfs_invalidate_mapping	[grab i_mutex]
> > > 
> > > I guess recent lockdep improvement find old bug.
> > 
> > Thanks for the analysis.
> > 
> > I guess should never do copy_*_user while holding i_mutex? There might
> > be lots of cases like that.
> 
> No.  mmap_sem inside i_mutex is the normal order; NFS mmap is doing the
> wrong thing here.  Note that readdir() vs. NFS (file-only, thankfully ;-)
> mmap() is a non-issue; NFS mmap() vs. write() is much more interesting.

I see.

> 
> Again, a lot of mm/* code expects i_mutex, then mmap_sem order.  It's not
> just readdir().

I suppose an easy workaround would be to not revalidate in mmap,
because open should have already done that?

Very lightly tested RFC patch attached.

-Andi

---

NFS: don't revalidate in mmap

nfs_revalidate_mapping takes i_mutex, but mmap already has mmap_sem
hold and taking i_mutex inside mmap_sem is not allowed by the VFS.

So don't revalidate on mmap time and trust it has been already done.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/file.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6.32-ak/fs/nfs/file.c
===================================================================
--- linux-2.6.32-ak.orig/fs/nfs/file.c
+++ linux-2.6.32-ak/fs/nfs/file.c
@@ -297,14 +297,9 @@ nfs_file_mmap(struct file * file, struct
 	dprintk("NFS: mmap(%s/%s)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	/* Note: generic_file_mmap() returns ENOSYS on nommu systems
-	 *       so we call that before revalidating the mapping
-	 */
 	status = generic_file_mmap(file, vma);
-	if (!status) {
+	if (!status)
 		vma->vm_ops = &nfs_file_vm_ops;
-		status = nfs_revalidate_mapping(inode, file->f_mapping);
-	}
 	return status;
 }
 
-- 
ak@linux.intel.com -- Speaking for myself only.
