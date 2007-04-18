Return-Path: <linux-kernel-owner+w=401wt.eu-S1422881AbXDRLiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422881AbXDRLiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 07:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422883AbXDRLiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 07:38:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:4414 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422881AbXDRLiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 07:38:17 -0400
X-IronPort-AV: i="4.14,422,1170662400"; 
   d="dif'208?scan'208,208"; a="52245804:sNHT23670003"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070418040730.GC24044@iucha.net>
References: <1176792399.3035.30.camel@twins>
	 <20070416125905.GA2769@iucha.net> <1176792399.3035.30.camel@twins>
	 <1176796503.3035.33.camel@twins> <87hcrfaqam.fsf@duaron.myhome.or.jp>
	 <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	 <20070417195823.943f9472.akpm@linux-foundation.org>
	 <1176865565.6796.16.camel@heimdal.trondhjem.org>
	 <20070418033055.GA24044@iucha.net>
	 <1176868485.6796.42.camel@heimdal.trondhjem.org>
	 <20070418040730.GC24044@iucha.net>
Content-Type: multipart/mixed; boundary="=-/0JY98UYz9kVASyjoAfv"
Organization: Network Appliance Inc
Date: Wed, 18 Apr 2007 07:38:07 -0400
Message-Id: <1176896287.6796.47.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 18 Apr 2007 11:38:19.0396 (UTC) FILETIME=[0FDFB440:01C781AE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/0JY98UYz9kVASyjoAfv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-04-17 at 23:07 -0500, Florin Iucha wrote:
> When 'big-copy' hangs, if I switch to a different console and run
> 'lsof', '[u]mount', or use shell completion on a network mount then that
> process goes into D state.  I cannot umount the network shares nor
> stop autofs.  I cannot do a clean reboot, I have to ssh
> in and "echo s > /proc/sysrq-trigger; echo u > /proc/sysrq-trigger;
> echo b > /proc/sysrq-trigger" .

What happens if you issue "echo 0 >/proc/sys/sunrpc/rpc_debug"?

> I am not mounting anything using CIFS, but I could give it a try.
> 
> I could transfer 75 GB without hiccup with 2.6.19 using NFS4 and CIFS,
> and with 2.6.20 using CIFS.  2.6.20 works fine under reasonably light
> load, with gnome sessions logging in and out several times a day.

How about NFSv3? I'd like to eliminate any issues with NFSv4 state.

I've also attached a little patch that I used in order to debug the list
consistency issues. Could you try it on top of the 4 I sent last night?

Cheers
  Trond



--=-/0JY98UYz9kVASyjoAfv
Content-Disposition: inline; filename=linux-2.6.21-031-debugging_do_not_merge.dif
Content-Type: message/rfc822; name=linux-2.6.21-031-debugging_do_not_merge.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sun, 15 Apr 2007 19:02:47 -0400
NFS: Debugging code. Do not merge...
Subject: No Subject
Message-Id: <1176896287.6796.48.camel@heimdal.trondhjem.org>
Mime-Version: 1.0

Adds consistency checks for nfs_page list operations

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/write.c           |    8 ++++++--
 include/linux/nfs_page.h |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index cadbf3c..9be626d 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -194,6 +194,7 @@ static int nfs_writepage_setup(struct nfs_open_context *ctx, struct page *page,
 	nfs_grow_file(page, offset, count);
 	/* Set the PG_uptodate flag? */
 	nfs_mark_uptodate(page, offset, count);
+	WARN_ON(test_bit(PG_NEED_COMMIT,&(req)->wb_flags));
 	nfs_unlock_request(req);
 	return 0;
 }
@@ -459,6 +460,7 @@ nfs_mark_request_commit(struct nfs_page *req)
 	struct inode *inode = req->wb_context->dentry->d_inode;
 	struct nfs_inode *nfsi = NFS_I(inode);
 
+	WARN_ON(nfs_dirty_request(req));
 	spin_lock(&nfsi->req_lock);
 	nfs_list_add_request(req, &nfsi->commit);
 	nfsi->ncommit++;
@@ -552,7 +554,7 @@ static void nfs_cancel_commit_list(struct list_head *head)
 		req = nfs_list_entry(head->next);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 		nfs_list_remove_request(req);
-		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
+		WARN_ON(!test_and_clear_bit(PG_NEED_COMMIT,&(req)->wb_flags));
 		nfs_inode_remove_request(req);
 		nfs_unlock_request(req);
 	}
@@ -1033,6 +1035,7 @@ static void nfs_writeback_done_full(struct rpc_task *task, void *calldata)
 
 		if (nfs_write_need_commit(data)) {
 			memcpy(&req->wb_verf, &data->verf, sizeof(req->wb_verf));
+			set_bit(PG_NEED_COMMIT,&(req)->wb_flags);
 			nfs_mark_request_commit(req);
 			nfs_end_page_writeback(page);
 			dprintk(" marked for commit\n");
@@ -1206,6 +1209,7 @@ nfs_commit_list(struct inode *inode, struct list_head *head, int how)
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		WARN_ON(!test_and_clear_bit(PG_NEED_COMMIT,&(req)->wb_flags));
 		nfs_clear_page_writeback(req);
 	}
 	return -ENOMEM;
@@ -1229,7 +1233,7 @@ static void nfs_commit_done(struct rpc_task *task, void *calldata)
 	while (!list_empty(&data->pages)) {
 		req = nfs_list_entry(data->pages.next);
 		nfs_list_remove_request(req);
-		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
+		WARN_ON(!test_and_clear_bit(PG_NEED_COMMIT,&(req)->wb_flags));
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 
 		dprintk("NFS: commit (%s/%Ld %d@%Ld)",
diff --git a/include/linux/nfs_page.h b/include/linux/nfs_page.h
index 41afab6..75c2d34 100644
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -116,6 +116,9 @@ nfs_lock_request(struct nfs_page *req)
 static inline void
 nfs_list_add_request(struct nfs_page *req, struct list_head *head)
 {
+	BUG_ON(!list_empty(&req->wb_list));
+	BUG_ON(req->wb_list_head != NULL);
+
 	list_add_tail(&req->wb_list, head);
 	req->wb_list_head = head;
 }

--=-/0JY98UYz9kVASyjoAfv--
