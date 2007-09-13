Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbXIMBxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbXIMBxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbXIMBxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:53:17 -0400
Received: from mail.fieldses.org ([66.93.2.214]:34223 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbXIMBxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:53:16 -0400
Date: Wed, 12 Sep 2007 21:53:05 -0400
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, nfsv4@linux-nfs.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [NFSv4] 2.6.23-rc4 oops in nfs4_cb_recall...
Message-ID: <20070913015305.GA2887@fieldses.org>
References: <6278d2220709040405i4f816afemb3a44d9cd95f9cc@mail.gmail.com> <20070909210400.GA7136@fieldses.org> <6278d2220709100739lbb75a6duf34e62de80f71765@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220709100739lbb75a6duf34e62de80f71765@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 03:39:23PM +0100, Daniel J Blueman wrote:
> On 09/09/2007, J. Bruce Fields <bfields@fieldses.org> wrote:
> > > When accessing a directory inode from a single other client, NFSv4
> > > callbacks catastrophically failed [1] on the NFS server with
> > > 2.6.23-rc4 (unpatched); clients are both 2.6.22 (Ubuntu Gutsy build).
> > > Seems not easy to reproduce, since this kernel was running smoothly
> > > for 7 days on the server.
> > >
> > > What information will help track this down, or is there a known
> > > failure mechanism?
> >
> > I haven't seen that before.
> >
> > > I can map stack frames to source lines with objdump, if that helps.
> 
> > If it's still easy, it might help to figure out exactly where in
> > xprt_reserve() it died, and why.  If we've got some race that can lead
> > to freeing the client while a callback is in progress, then perhaps this
> > is on the first dereference of xprt?
> 
> I've raised the bug report into bugzilla, added other observations
> from a second occurrence recently and disassembled xprt_reserve with
> line numbers.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9003
> 
> Ping me for any more detail/info and thanks!

If you or anyone else that's seen this problem could test the following,
that would be helpful.  Thanks!

--b.

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index c1cb7e0..9d536a8 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -486,6 +486,7 @@ out_put_cred:
 	/* Success or failure, now we're either waiting for lease expiration
 	 * or deleg_return. */
 	dprintk("NFSD: nfs4_cb_recall: dp %p dl_flock %p dl_count %d\n",dp, dp->dl_flock, atomic_read(&dp->dl_count));
+	put_nfs4_client(clp);
 	nfs4_put_delegation(dp);
 	return;
 }
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6256492..6f182d2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -358,9 +358,22 @@ alloc_client(struct xdr_netobj name)
 	return clp;
 }
 
+static void
+shutdown_callback_client(struct nfs4_client *clp)
+{
+	struct rpc_clnt *clnt = clp->cl_callback.cb_client;
+
+	/* shutdown rpc client, ending any outstanding recall rpcs */
+	if (clnt) {
+		clp->cl_callback.cb_client = NULL;
+		rpc_shutdown_client(clnt);
+	}
+}
+
 static inline void
 free_client(struct nfs4_client *clp)
 {
+	shutdown_callback_client(clp);
 	if (clp->cl_cred.cr_group_info)
 		put_group_info(clp->cl_cred.cr_group_info);
 	kfree(clp->cl_name.data);
@@ -375,18 +388,6 @@ put_nfs4_client(struct nfs4_client *clp)
 }
 
 static void
-shutdown_callback_client(struct nfs4_client *clp)
-{
-	struct rpc_clnt *clnt = clp->cl_callback.cb_client;
-
-	/* shutdown rpc client, ending any outstanding recall rpcs */
-	if (clnt) {
-		clp->cl_callback.cb_client = NULL;
-		rpc_shutdown_client(clnt);
-	}
-}
-
-static void
 expire_client(struct nfs4_client *clp)
 {
 	struct nfs4_stateowner *sop;
@@ -396,8 +397,6 @@ expire_client(struct nfs4_client *clp)
 	dprintk("NFSD: expire_client cl_count %d\n",
 	                    atomic_read(&clp->cl_count));
 
-	shutdown_callback_client(clp);
-
 	INIT_LIST_HEAD(&reaplist);
 	spin_lock(&recall_lock);
 	while (!list_empty(&clp->cl_delegations)) {
@@ -1346,6 +1345,7 @@ void nfsd_break_deleg_cb(struct file_lock *fl)
 	 * lock) we know the server hasn't removed the lease yet, we know
 	 * it's safe to take a reference: */
 	atomic_inc(&dp->dl_count);
+	atomic_inc(&dp->dl_client->cl_count);
 
 	spin_lock(&recall_lock);
 	list_add_tail(&dp->dl_recall_lru, &del_recall_lru);
@@ -1354,8 +1354,12 @@ void nfsd_break_deleg_cb(struct file_lock *fl)
 	/* only place dl_time is set. protected by lock_kernel*/
 	dp->dl_time = get_seconds();
 
-	/* XXX need to merge NFSD_LEASE_TIME with fs/locks.c:lease_break_time */
-	fl->fl_break_time = jiffies + NFSD_LEASE_TIME * HZ;
+	/*
+	 * We don't want the locks code to timeout the lease for us;
+	 * we'll remove it ourself if the delegation isn't returned
+	 * in time.
+	 */
+	fl->fl_break_time = 0;
 
 	t = kthread_run(do_recall, dp, "%s", "nfs4_cb_recall");
 	if (IS_ERR(t)) {
@@ -1364,6 +1368,7 @@ void nfsd_break_deleg_cb(struct file_lock *fl)
 		printk(KERN_INFO "NFSD: Callback thread failed for "
 			"for client (clientid %08x/%08x)\n",
 			clp->cl_clientid.cl_boot, clp->cl_clientid.cl_id);
+		put_nfs4_client(dp->dl_client);
 		nfs4_put_delegation(dp);
 	}
 }
