Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZKJSlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZKJSlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbZKJSlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:41:12 -0500
Received: from fieldses.org ([174.143.236.118]:53083 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZKJSlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:41:11 -0500
Date: Tue, 10 Nov 2009 13:41:26 -0500
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Greg Banks <gnb@fmeh.org>
Subject: Re: 2.6.31 under "heavy" NFS load.
Message-ID: <20091110184126.GD15000@fieldses.org>
References: <4AF86DE4.5010607@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF86DE4.5010607@krogh.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 08:30:44PM +0100, Jesper Krogh wrote:
> When a lot (~60 all on 1GbitE) of NFS clients are hitting an NFS server
> that has an 10GbitE NIC sitting on it I'm seeing high IO-wait load
> (>50%) and load number over 100 on the server. This is a change since
> 2.6.29 where the IO-wait load under similar workload was less than 10%.
> 
> The system has 16 Opteron cores.
> 
> All data the NFS-clients are reading are "memory recident" since they
> are all reading off the same 10GB of data and the server has 32GB of
> main memory dedicated to nothing else than serving NFS.
> 
> A snapshot of top looks like this:
> http://krogh.cc/~jesper/top-hest-2.6.31.txt
> 
> The load is generally alot higher than on 2.6.29 and it "explodes" to
> over 100 when a few processes begin utillizing the disk while serving
> files over NFS. "dstat" reports a read-out of 10-20MB/s from disk which
> is close to what I'd expect. and the system delivers around 600-800MB/s
> over the NIC in this workload.

Is that the bandwidth you get with 2.6.31, with 2.6.29, or with both?

Are you just noticing a change in the statistics, or are there concrete
changes in the performance of the server?

> Sorry that I cannot be more specific, I can answer questions on a
> running 2.6.31 kernel, but I cannot reboot the system back to 2.6.29
> just to test since the system is "in production". I tried 2.6.30 and it
> has the same pattern as 2.6.31, so based on that fragile evidence the
> change should be found in between 2.6.29 and 2.6.30. I hope a "wague"
> report is better than none.

Can you test whether this helps?

--b.

commit 66135c1f822f7ace9742c987d3f691c523c1ed21
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Thu Aug 6 15:41:34 2009 -0400

    Revert "knfsd: avoid overloading the CPU scheduler with enormous load averages"
    
    This reverts commit 59a252ff8c0f2fa32c896f69d56ae33e641ce7ad.
    
    This helps in an entirely cached workload but not necessarily in
    workloads that require waiting on disk.
    
    Conflicts:
    
    	include/linux/sunrpc/svc.h
    	net/sunrpc/svc_xprt.c
    
    Reported-by: Simon Kirby <sim@hostway.ca>
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 52e8cb0..d1567d6 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -29,7 +29,6 @@ struct svc_pool_stats {
 	unsigned long	packets;
 	unsigned long	sockets_queued;
 	unsigned long	threads_woken;
-	unsigned long	overloads_avoided;
 	unsigned long	threads_timedout;
 };
 
@@ -50,7 +49,6 @@ struct svc_pool {
 	struct list_head	sp_sockets;	/* pending sockets */
 	unsigned int		sp_nrthreads;	/* # of threads in pool */
 	struct list_head	sp_all_threads;	/* all server threads */
-	int			sp_nwaking;	/* number of threads woken but not yet active */
 	struct svc_pool_stats	sp_stats;	/* statistics on pool operation */
 } ____cacheline_aligned_in_smp;
 
@@ -284,7 +282,6 @@ struct svc_rqst {
 						 * cache pages */
 	wait_queue_head_t	rq_wait;	/* synchronization */
 	struct task_struct	*rq_task;	/* service thread */
-	int			rq_waking;	/* 1 if thread is being woken */
 };
 
 /*
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 6f33d33..f0bf591 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -15,8 +15,6 @@
 
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
 
-#define SVC_MAX_WAKING 5
-
 static struct svc_deferred_req *svc_deferred_dequeue(struct svc_xprt *xprt);
 static int svc_deferred_recv(struct svc_rqst *rqstp);
 static struct cache_deferred_req *svc_defer(struct cache_req *req);
@@ -304,7 +302,6 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 	struct svc_pool *pool;
 	struct svc_rqst	*rqstp;
 	int cpu;
-	int thread_avail;
 
 	if (!(xprt->xpt_flags &
 	      ((1<<XPT_CONN)|(1<<XPT_DATA)|(1<<XPT_CLOSE)|(1<<XPT_DEFERRED))))
@@ -316,6 +313,12 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 
 	spin_lock_bh(&pool->sp_lock);
 
+	if (!list_empty(&pool->sp_threads) &&
+	    !list_empty(&pool->sp_sockets))
+		printk(KERN_ERR
+		       "svc_xprt_enqueue: "
+		       "threads and transports both waiting??\n");
+
 	if (test_bit(XPT_DEAD, &xprt->xpt_flags)) {
 		/* Don't enqueue dead transports */
 		dprintk("svc: transport %p is dead, not enqueued\n", xprt);
@@ -356,15 +359,7 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 	}
 
  process:
-	/* Work out whether threads are available */
-	thread_avail = !list_empty(&pool->sp_threads);	/* threads are asleep */
-	if (pool->sp_nwaking >= SVC_MAX_WAKING) {
-		/* too many threads are runnable and trying to wake up */
-		thread_avail = 0;
-		pool->sp_stats.overloads_avoided++;
-	}
-
-	if (thread_avail) {
+	if (!list_empty(&pool->sp_threads)) {
 		rqstp = list_entry(pool->sp_threads.next,
 				   struct svc_rqst,
 				   rq_list);
@@ -379,8 +374,6 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 		svc_xprt_get(xprt);
 		rqstp->rq_reserved = serv->sv_max_mesg;
 		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
-		rqstp->rq_waking = 1;
-		pool->sp_nwaking++;
 		pool->sp_stats.threads_woken++;
 		BUG_ON(xprt->xpt_pool != pool);
 		wake_up(&rqstp->rq_wait);
@@ -649,11 +642,6 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 		return -EINTR;
 
 	spin_lock_bh(&pool->sp_lock);
-	if (rqstp->rq_waking) {
-		rqstp->rq_waking = 0;
-		pool->sp_nwaking--;
-		BUG_ON(pool->sp_nwaking < 0);
-	}
 	xprt = svc_xprt_dequeue(pool);
 	if (xprt) {
 		rqstp->rq_xprt = xprt;
@@ -1210,16 +1198,15 @@ static int svc_pool_stats_show(struct seq_file *m, void *p)
 	struct svc_pool *pool = p;
 
 	if (p == SEQ_START_TOKEN) {
-		seq_puts(m, "# pool packets-arrived sockets-enqueued threads-woken overloads-avoided threads-timedout\n");
+		seq_puts(m, "# pool packets-arrived sockets-enqueued threads-woken threads-timedout\n");
 		return 0;
 	}
 
-	seq_printf(m, "%u %lu %lu %lu %lu %lu\n",
+	seq_printf(m, "%u %lu %lu %lu %lu\n",
 		pool->sp_id,
 		pool->sp_stats.packets,
 		pool->sp_stats.sockets_queued,
 		pool->sp_stats.threads_woken,
-		pool->sp_stats.overloads_avoided,
 		pool->sp_stats.threads_timedout);
 
 	return 0;
