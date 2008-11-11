Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYKKVl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYKKVl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYKKVlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:41:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34106 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYKKVlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:41:18 -0500
Date: Tue, 11 Nov 2008 16:41:04 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081111164104.48f4dbd8@tleilax.poochiereds.net>
In-Reply-To: <x49vduunjh4.fsf@segfault.boston.devel.redhat.com>
References: <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
	<20081110135618.GI26778@kernel.dk>
	<49186C5A.5020809@telenet.dn.ua>
	<20081110173504.GL26778@kernel.dk>
	<49187D05.9050407@telenet.dn.ua>
	<x491vxjqmg0.fsf@segfault.boston.devel.redhat.com>
	<20081111093426.GS26778@kernel.dk>
	<20081111093540.GT26778@kernel.dk>
	<20081111115227.GU26778@kernel.dk>
	<4919B884.5000604@telenet.dn.ua>
	<20081111180659.GC26778@kernel.dk>
	<x49vduunjh4.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 14:36:07 -0500
Jeff Moyer <jmoyer@redhat.com> wrote:

> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > OK, that looks better. Can I talk you into just trying this little
> > patch, just to see what kind of performance that yields? Remove the cfq
> > patch first. I would have patched nfsd only, but this is just a quick'n
> > dirty.
> 
> I went ahead and gave it a shot.  The updated CFQ patch with no I/O
> context sharing does about 40MB/s reading a 1GB file.  Backing that
> patch out, and then adding the patch to share io_context's between
> kthreads yields 45MB/s.
> 

Here's a quick and dirty patch to make all of the nfsd's have the same
io_context. Comments appreciated -- I'm not that familiar with the IO
scheduling code. If this looks good, I'll clean it up, add some
comments and formally send it to Bruce.

----------------[snip]-------------------

>From dd15b19a0eab3e181a6f76f1421b97950e255b4b Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@redhat.com>
Date: Tue, 11 Nov 2008 15:43:15 -0500
Subject: [PATCH] knfsd: make all nfsd threads share an io_context

This apparently makes the I/O scheduler treat the threads as a group
which helps throughput when sequential I/O is multiplexed over several
nfsd's.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfsd/nfssvc.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 07e4f5d..6d87f74 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -22,6 +22,7 @@
 #include <linux/freezer.h>
 #include <linux/fs_struct.h>
 #include <linux/kthread.h>
+#include <linux/iocontext.h>
 
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/stats.h>
@@ -42,6 +43,7 @@ static int			nfsd(void *vrqstp);
 struct timeval			nfssvc_boot;
 static atomic_t			nfsd_busy;
 static unsigned long		nfsd_last_call;
+static struct io_context	*nfsd_io_context;
 static DEFINE_SPINLOCK(nfsd_call_lock);
 
 /*
@@ -173,6 +175,7 @@ static void nfsd_last_thread(struct svc_serv *serv)
 	nfsd_serv = NULL;
 	nfsd_racache_shutdown();
 	nfs4_state_shutdown();
+	nfsd_io_context = NULL;
 
 	printk(KERN_WARNING "nfsd: last server has exited, flushing export "
 			    "cache\n");
@@ -398,6 +401,28 @@ update_thread_usage(int busy_threads)
 }
 
 /*
+ * should be called while holding nfsd_mutex
+ */
+static void
+nfsd_set_io_context(void)
+{
+	int cpu, node;
+
+	if (!nfsd_io_context) {
+		cpu = get_cpu();
+		node = cpu_to_node(cpu);
+		put_cpu();
+
+		/*
+		 * get_io_context can return NULL if the alloc_context fails.
+		 * That's not technically fatal here, so we don't bother to
+		 * check for it.
+		 */
+		nfsd_io_context = get_io_context(GFP_KERNEL, node);
+	} else
+		copy_io_context(&current->io_context, &nfsd_io_context);
+}
+/*
  * This is the NFS server kernel thread
  */
 static int
@@ -410,6 +435,8 @@ nfsd(void *vrqstp)
 	/* Lock module and set up kernel thread */
 	mutex_lock(&nfsd_mutex);
 
+	nfsd_set_io_context();
+
 	/* At this point, the thread shares current->fs
 	 * with the init process. We need to create files with a
 	 * umask of 0 instead of init's umask. */
-- 
1.5.5.1

