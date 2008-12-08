Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYLHXZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYLHXZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYLHXYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:24:55 -0500
Received: from mail.fieldses.org ([66.93.2.214]:44143 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbYLHXYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:24:54 -0500
Date: Mon, 8 Dec 2008 18:24:18 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] EXPORTFS: handle NULL returns from
	fh_to_dentry()/fh_to_parent()
Message-ID: <20081208232418.GJ19417@fieldses.org>
References: <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org> <20081205162318.20732.73054.stgit@warthog.procyon.org.uk> <23235.1228502954@redhat.com> <alpine.LFD.2.00.0812051053190.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812051053190.3386@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

While 440037287c5 "[PATCH] switch all filesystems over to
d_obtain_alias" removed some cases where fh_to_dentry() and
fh_to_parent() could return NULL, there are still a few NULL returns
left in individual filesystems.  Thus it was a mistake for that commit
to remove the handling of NULL returns in the callers.

Revert those parts of 440037287c5 which removed the NULL handling.

(We could, alternatively, modify all implementations to return -ESTALE
instead of NULL, but that proves to require fixing a number of
filesystems, and in some cases it's arguably more natural to return
NULL.)

Thanks to David for original patch and Linus, Christoph, and Hugh for
review.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hugh@veritas.com>
---
 fs/exportfs/expfs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

On Fri, Dec 05, 2008 at 11:02:00AM -0800, Linus Torvalds wrote:
> So it really seems to make more sense to just make the ESTALE handling be 
> a NFS issue. 

This thread seems to have died out, and I didn't see any objections to
handling the error in the caller as Linus suggested, so here's the
patch.

Also available from the for-2.6.28 branch at

	git://linux-nfs.org/~bfields/linux.git for-2.6.28

--b.

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 80246ba..890e018 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -367,6 +367,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	 * Try to get any dentry for the given file handle from the filesystem.
 	 */
 	result = nop->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fileid_type);
+	if (!result)
+		result = ERR_PTR(-ESTALE);
 	if (IS_ERR(result))
 		return result;
 
@@ -420,6 +422,8 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 
 		target_dir = nop->fh_to_parent(mnt->mnt_sb, fid,
 				fh_len, fileid_type);
+		if (!target_dir)
+			goto err_result;
 		err = PTR_ERR(target_dir);
 		if (IS_ERR(target_dir))
 			goto err_result;
-- 
1.5.5.rc1
