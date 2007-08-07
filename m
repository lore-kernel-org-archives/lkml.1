Return-Path: <linux-kernel-owner+w=401wt.eu-S936320AbXHGVfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936320AbXHGVfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936527AbXHGVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:09:52 -0400
Received: from pat.uio.no ([129.240.10.15]:38381 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936612AbXHGVJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:09:50 -0400
Subject: Re: [NFS] 2.6.23-rc1-mm2
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Neil Brown <neilb@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070803172137.GA3783@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de>
	 <20070803093830.39852a01.akpm@linux-foundation.org>
	 <1186160608.7255.10.camel@localhost>  <20070803172137.GA3783@tv-sign.ru>
Content-Type: multipart/mixed; boundary="=-DhVLaiptBvrBCxg63kbS"
Date: Tue, 07 Aug 2007 17:08:48 -0400
Message-Id: <1186520929.6625.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.108)
X-UiO-Scanned: 1AA6EC4B02935CC8FE0ECA8A7B24841BA1EBC902
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 80 total 3141315 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DhVLaiptBvrBCxg63kbS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2007-08-03 at 21:21 +0400, Oleg Nesterov wrote:
> On 08/03, Trond Myklebust wrote:
> > I'll have a look at this. I suspect that most if not all of our calls to
> > run_workqueue()/flush_scheduled_work() can now be replaced by more
> > targeted calls to cancel_work_sync() and cancel_delayed_work_sync().
> 
> Yes, please, if possible.

All the NFS and SUNRPC cases appear to be trivial. IOW: the only reason
for the flush_workqueue()/flush_scheduled_work() calls was to ensure
that the cancel_work()/cancel_delayed_work() calls preceding them have
completed. Nevertheless I've split the conversion into two patches,
since one touches only the NFS code, whereas the other touches the
SUNRPC client and server code.

The two patches have been tested, and appear to work...

Trond



--=-DhVLaiptBvrBCxg63kbS
Content-Disposition: inline; filename=linux-2.6.23-007-nfs_dont_call_flush_workqueue.dif
Content-Type: message/rfc822; name=linux-2.6.23-007-nfs_dont_call_flush_workqueue.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 7 Aug 2007 15:28:33 -0400
NFS: Replace flush_scheduled_work with cancel_work_sync() and friends
Subject: No Subject
Message-Id: <1186520901.6625.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

This will avoid deadlocks of the form:

stack backtrace:
 [<c0104fda>] show_trace_log_lvl+0x1a/0x30
 [<c0105c02>] show_trace+0x12/0x20
 [<c0105d15>] dump_stack+0x15/0x20
 [<c013ee42>] __lock_acquire+0xc22/0x1030
 [<c013f2b1>] lock_acquire+0x61/0x80
 [<c012edd9>] flush_workqueue+0x49/0x70
 [<c012ee0d>] flush_scheduled_work+0xd/0x10
 [<dcf55c0c>] nfs_release_automount_timer+0x2c/0x30 [nfs]
 [<dcf45d8e>] nfs_free_server+0x9e/0xd0 [nfs]
 [<dcf4e626>] nfs_kill_super+0x16/0x20 [nfs]
 [<c017b38d>] deactivate_super+0x7d/0xa0
 [<c018f94b>] mntput_no_expire+0x4b/0x80
 [<c018fd94>] expire_mount_list+0xe4/0x140
 [<c0191219>] mark_mounts_for_expiry+0x99/0xb0
 [<dcf55d1d>] nfs_expire_automounts+0xd/0x40 [nfs]
 [<c012e61b>] run_workqueue+0x12b/0x1e0
 [<c012f05b>] worker_thread+0x9b/0x100
 [<c0131c72>] kthread+0x42/0x70
 [<c0104c0f>] kernel_thread_helper+0x7/0x18
 =======================

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/namespace.c  |    6 ++----
 fs/nfs/nfs4renewd.c |    5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 7f86e65..aea76d0 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -175,10 +175,8 @@ static void nfs_expire_automounts(struct work_struct *work)
 
 void nfs_release_automount_timer(void)
 {
-	if (list_empty(&nfs_automount_list)) {
-		cancel_delayed_work(&nfs_automount_task);
-		flush_scheduled_work();
-	}
+	if (list_empty(&nfs_automount_list))
+		cancel_delayed_work_sync(&nfs_automount_task);
 }
 
 /*
diff --git a/fs/nfs/nfs4renewd.c b/fs/nfs/nfs4renewd.c
index 0505ca1..3ea352d 100644
--- a/fs/nfs/nfs4renewd.c
+++ b/fs/nfs/nfs4renewd.c
@@ -127,16 +127,15 @@ nfs4_schedule_state_renewal(struct nfs_client *clp)
 void
 nfs4_renewd_prepare_shutdown(struct nfs_server *server)
 {
-	flush_scheduled_work();
+	cancel_delayed_work(&server->nfs_client->cl_renewd);
 }
 
 void
 nfs4_kill_renewd(struct nfs_client *clp)
 {
 	down_read(&clp->cl_sem);
-	cancel_delayed_work(&clp->cl_renewd);
+	cancel_delayed_work_sync(&clp->cl_renewd);
 	up_read(&clp->cl_sem);
-	flush_scheduled_work();
 }
 
 /*

--=-DhVLaiptBvrBCxg63kbS
Content-Disposition: inline; filename=linux-2.6.23-008-sunrpc_dont_call_flush_workqueue.dif
Content-Type: message/rfc822; name=linux-2.6.23-008-sunrpc_dont_call_flush_workqueue.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 7 Aug 2007 15:33:01 -0400
SUNRPC: Replace flush_workqueue() with cancel_work_sync() and friends
Subject: No Subject
Message-Id: <1186520901.6625.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/cache.c    |    3 +--
 net/sunrpc/rpc_pipe.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 01c3c41..ebe344f 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -371,8 +371,7 @@ int cache_unregister(struct cache_detail *cd)
 	}
 	if (list_empty(&cache_list)) {
 		/* module must be being unloaded so its safe to kill the worker */
-		cancel_delayed_work(&cache_cleaner);
-		flush_scheduled_work();
+		cancel_delayed_work_sync(&cache_cleaner);
 	}
 	return 0;
 }
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 650af06..669e12a 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -132,8 +132,7 @@ rpc_close_pipes(struct inode *inode)
 		rpci->nwriters = 0;
 		if (ops->release_pipe)
 			ops->release_pipe(inode);
-		cancel_delayed_work(&rpci->queue_timeout);
-		flush_workqueue(rpciod_workqueue);
+		cancel_delayed_work_sync(&rpci->queue_timeout);
 	}
 	rpc_inode_setowner(inode, NULL);
 	mutex_unlock(&inode->i_mutex);

--=-DhVLaiptBvrBCxg63kbS--

