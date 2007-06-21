Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbXFUEdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbXFUEdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbXFUEbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:31:23 -0400
Received: from mail.suse.de ([195.135.220.2]:41746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbXFUEbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:31:22 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:31:12 +1000
Message-Id: <1070621043112.1144@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit based on RAM size
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>


Our original NFSv4 delegation policy was to give out a read delegation
on any open when it was possible to.

Since the lifetime of a delegation isn't limited to that of an open, a
client may quite reasonably hang on to a delegation as long as it has
the inode cached.  This becomes an obvious problem the first time a
client's inode cache approaches the size of the server's total memory.

Our first quick solution was to add a hard-coded limit.  This patch
makes a mild incremental improvement by varying that limit according to
the server's total memory size, allowing at most 4 delegations per
megabyte of RAM.

My quick back-of-the-envelope calculation finds that in the worst case
(where every delegation is for a different inode), a delegation could
take about 1.5K, which would make the worst case usage about 6% of
memory.  The new limit works out to be about the same as the old on a
1-gig server.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4state.c       |   15 ++++++++++++++-
 ./include/linux/nfsd/nfsd.h |    1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff .prev/fs/nfsd/nfs4state.c ./fs/nfsd/nfs4state.c
--- .prev/fs/nfsd/nfs4state.c	2007-06-21 14:09:23.000000000 +1000
+++ ./fs/nfsd/nfs4state.c	2007-06-21 14:14:47.000000000 +1000
@@ -150,6 +150,7 @@ get_nfs4_file(struct nfs4_file *fi)
 }
 
 static int num_delegations;
+unsigned int max_delegations = 0;
 
 /*
  * Open owner state (share locks)
@@ -193,7 +194,7 @@ alloc_init_deleg(struct nfs4_client *clp
 	struct nfs4_callback *cb = &stp->st_stateowner->so_client->cl_callback;
 
 	dprintk("NFSD alloc_init_deleg\n");
-	if (num_delegations > STATEID_HASH_SIZE * 4)
+	if (num_delegations > max_delegations)
 		return NULL;
 	dp = kmem_cache_alloc(deleg_slab, GFP_KERNEL);
 	if (dp == NULL)
@@ -3198,6 +3199,17 @@ get_nfs4_grace_period(void)
 	return max(user_lease_time, lease_time) * HZ;
 }
 
+static void
+set_max_delegations()
+{
+	struct sysinfo sys;
+
+	si_meminfo(&sys);
+	sys.totalram *= sys.mem_unit;
+	sys.totalram >>= (18 - PAGE_SHIFT);
+	max_delegations = (unsigned int) sys.totalram;
+}
+
 /* initialization to perform when the nfsd service is started: */
 
 static void
@@ -3213,6 +3225,7 @@ __nfs4_state_start(void)
 	       grace_time/HZ);
 	laundry_wq = create_singlethread_workqueue("nfsd4");
 	queue_delayed_work(laundry_wq, &laundromat_work, grace_time);
+	set_max_delegations();
 }
 
 int

diff .prev/include/linux/nfsd/nfsd.h ./include/linux/nfsd/nfsd.h
--- .prev/include/linux/nfsd/nfsd.h	2007-06-21 14:13:57.000000000 +1000
+++ ./include/linux/nfsd/nfsd.h	2007-06-21 14:14:47.000000000 +1000
@@ -148,6 +148,7 @@ extern int nfsd_max_blksize;
  * NFSv4 State
  */
 #ifdef CONFIG_NFSD_V4
+extern unsigned int max_delegations;
 void nfs4_state_init(void);
 int nfs4_state_start(void);
 void nfs4_state_shutdown(void);
