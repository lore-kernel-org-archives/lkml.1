Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033Ab0AGVAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0AGVAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004Ab0AGVAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:00:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42330 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab0AGVA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:00:29 -0500
To: Trond.Myklebust@netapp.com
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Andi Kleen <andi@firstfloor.org>
References: <1262896174.2659.3.camel@localhost>
Date: Thu, 07 Jan 2010 22:00:26 +0100
In-Reply-To: <1262896174.2659.3.camel@localhost> (Trond Myklebust's message of "Thu, 07 Jan 2010 15:29:34 -0500")
Message-ID: <87zl4pmxzp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Linus,
>
> Please pull from the "bugfixes" branch of the repository at
>
>    git pull git://git.linux-nfs.org/projects/trondmy/nfs-2.6.git bugfixes
>
> This will update the following files through the appended changesets.

How about the mmap lock order inversion patch?

That problem is still there and hits immediately after mounting root 
with a lockdep warning on any lockdep enabled NFS root kernel.

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
