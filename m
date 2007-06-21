Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbXFUEd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbXFUEd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbXFUEba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:31:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:59926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411AbXFUEb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:31:29 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:31:19 +1000
Message-Id: <1070621043119.1159@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 008 of 8] knfsd: nfsd4: don't delegate files that have had conflicts
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>


One more incremental delegation policy improvement: don't give out a
delegation on a file if conflicting access has previously required that
a delegation be revoked on that file.  (In practice we'll forget about
the conflict when the struct nfs4_file is removed on close, so this is
of limited use for now, though it should at least solve a temporary
problem with self-conflicts on write opens from the same client.)

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4state.c        |    4 ++++
 ./include/linux/nfsd/state.h |    1 +
 2 files changed, 5 insertions(+)

diff .prev/fs/nfsd/nfs4state.c ./fs/nfsd/nfs4state.c
--- .prev/fs/nfsd/nfs4state.c	2007-06-21 14:14:47.000000000 +1000
+++ ./fs/nfsd/nfs4state.c	2007-06-21 14:16:21.000000000 +1000
@@ -194,6 +194,8 @@ alloc_init_deleg(struct nfs4_client *clp
 	struct nfs4_callback *cb = &stp->st_stateowner->so_client->cl_callback;
 
 	dprintk("NFSD alloc_init_deleg\n");
+	if (fp->fi_had_conflict)
+		return NULL;
 	if (num_delegations > max_delegations)
 		return NULL;
 	dp = kmem_cache_alloc(deleg_slab, GFP_KERNEL);
@@ -1002,6 +1004,7 @@ alloc_init_file(struct inode *ino)
 		list_add(&fp->fi_hash, &file_hashtbl[hashval]);
 		fp->fi_inode = igrab(ino);
 		fp->fi_id = current_fileid++;
+		fp->fi_had_conflict = false;
 		return fp;
 	}
 	return NULL;
@@ -1328,6 +1331,7 @@ do_recall(void *__dp)
 {
 	struct nfs4_delegation *dp = __dp;
 
+	dp->dl_file->fi_had_conflict = true;
 	nfsd4_cb_recall(dp);
 	return 0;
 }

diff .prev/include/linux/nfsd/state.h ./include/linux/nfsd/state.h
--- .prev/include/linux/nfsd/state.h	2007-06-21 14:09:31.000000000 +1000
+++ ./include/linux/nfsd/state.h	2007-06-21 14:16:21.000000000 +1000
@@ -224,6 +224,7 @@ struct nfs4_file {
 	struct inode		*fi_inode;
 	u32                     fi_id;      /* used with stateowner->so_id 
 					     * for stateid_hashtbl hash */
+	bool			fi_had_conflict;
 };
 
 /*
