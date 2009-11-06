Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbZKFW2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbZKFW2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbZKFW20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:28:26 -0500
Received: from kroah.org ([198.145.64.141]:57123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbZKFWXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:32 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:50 2009
Message-Id: <20091106221550.079264596@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Terry Loftin <terry.loftin@hp.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [81/99] nfs: Panic when commit fails
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=nfs-panic-when-commit-fails.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Terry Loftin <terry.loftin@hp.com>

commit a8b40bc7e635831b61c43acc71a86d3a68b2dff0 upstream.

Actually pass the NFS_FILE_SYNC option to the server to avoid a
Panic in nfs_direct_write_complete() when a commit fails.

At the end of an nfs write, if the nfs commit fails, all the writes
will be rescheduled.  They are supposed to be rescheduled as NFS_FILE_SYNC
writes, but the rpc_task structure is not completely intialized and so
the option is not passed.  When the rescheduled writes complete, the
return indicates that they are NFS_UNSTABLE and we try to do another
commit.  This leads to a Panic because the commit data structure pointer
was set to null in the initial (failed) commit attempt.

Signed-off-by: Terry Loftin <terry.loftin@hp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/direct.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -457,6 +457,7 @@ static void nfs_direct_write_reschedule(
 	};
 	struct rpc_task_setup task_setup_data = {
 		.rpc_client = NFS_CLIENT(inode),
+		.rpc_message = &msg,
 		.callback_ops = &nfs_write_direct_ops,
 		.workqueue = nfsiod_workqueue,
 		.flags = RPC_TASK_ASYNC,


