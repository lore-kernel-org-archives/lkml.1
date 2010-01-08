Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483Ab0AHApS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0AHApS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431Ab0AHApR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:45:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab0AHApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:45:15 -0500
Date: Fri, 8 Jan 2010 01:45:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
Message-ID: <20100108004513.GF16076@basil.fritz.box>
References: <1262896174.2659.3.camel@localhost> <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost> <20100107235149.GD16076@basil.fritz.box> <1262909682.2659.45.camel@localhost> <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If that is ok, then why do the revalidate at all? Just do the open/close 
> consistency and validate at open time, not mmap time.

That's exactly what my patch does :)

-Andi

---


NFS: don't revalidate in mmap v2

nfs_revalidate_mapping takes i_mutex, but mmap already has mmap_sem
and taking i_mutex inside mmap_sem is not allowed by the VFS.

So don't revalidate on mmap time. In theory users could
rely on it, but it's unlikely enough for mmap.

This fixes a lockdep warning that happens at every boot
on my nfsroot test system.

v2: Fix unused variable warning, add comment

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux/fs/nfs/file.c
===================================================================
--- linux.orig/fs/nfs/file.c
+++ linux/fs/nfs/file.c
@@ -291,20 +291,20 @@ static int
 nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
 {
 	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
 	int	status;
 
 	dprintk("NFS: mmap(%s/%s)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	/* Note: generic_file_mmap() returns ENOSYS on nommu systems
-	 *       so we call that before revalidating the mapping
-	 */
 	status = generic_file_mmap(file, vma);
-	if (!status) {
+	/*
+	 * This used to be a synchronization point,
+	 * but this causes lock order inversions with i_mutex / mmap_sem.
+	 * It's unclear anyone relies on mmap being a synchronization
+	 * point anyways, so just removed it here -AK
+	 */
+	if (!status)
 		vma->vm_ops = &nfs_file_vm_ops;
-		status = nfs_revalidate_mapping(inode, file->f_mapping);
-	}
 	return status;
 }
 

-- 
ak@linux.intel.com -- Speaking for myself only.
