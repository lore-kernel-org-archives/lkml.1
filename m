Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbYCFElm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbYCFElm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 23:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbYCFEld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 23:41:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53000 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbYCFElc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 23:41:32 -0500
Message-ID: <47CF75F9.1050406@np.css.fujitsu.com>
Date: Thu, 06 Mar 2008 13:41:29 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH][BUGFIX][RFC] fix soft lock up at NFS mount by making limitation
 of dentry_unused
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Summary]
  Make a limitation of dentry_unused to avoid soft lock up at NFS mounts
 and remounting any filesystem.

[Descriptions]
- background
 dentry_unused is a list of dentries which is not in use. This works
 as a cache against not-exisiting files. dentry_unused grows up when
 directories or files are removed. This list can be *verrry* long
 if there is no memory  pressure, because there is no limit.

- what's problem
 When prune_dcache() is called, it scans *all* dentry_unused linearly
 under spin_lock(). This scan costs very much if there are many entries.
 For example, prune_dcache() is called at mounting NFS.
 In our test, when there are 100,000,000 of unused dentries, mounting
 NFS took 1 minutes and almost all user programs hang during it.

  100,000,000 is possible number on large systems.

 This problem already happend on our system.
 Therefore, we need a limitation of dentry_unused.

- How to fix
 Limit number of unused dentries to suitable value.

 Threshold is as follows:
 dentry_unused_ratio: default value is 10000(%). If the amount of
 dentry_unused reaches to 10000% of the amount of dentry_in_use,
 5% of them are freed.

 I feel we need more tests to determine resonable value to any system.
 So, please test.

 This patch is based on linux-2.6.25-rc4.

-Test Results

 Result on 24GB boxes with excessive unused dentries.
Without patch:
# cat /proc/sys/fs/dentry-state
103327453       103313783       45      0       0
# time mount -t nfs 192.168.0.2:/export /mnt
real    1m4.698s
user    0m0.000s
sys     1m4.672s

 With this patch:
# cat /proc/sys/fs/dentry-state
118681  117225  45      0       0       0
# time mount -t nfs 192.168.0.2:/export /mnt
real    0m0.103s
user    0m0.004s
sys     0m0.076s

Tested on Intel Itanium 2 9050 (dualcore) x12 MEM 24GB , kernel-2.6.25-rc4
I found no peformance regression in my tests.


Best Regards,
Kentaro Makita

Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
---
 fs/dcache.c |    7 +++++++
 1 files changed, 7 insertions(+)
diff -rupN -X linux-2.6.25-rc4/Documentation/dontdiff linux-2.6.25-rc4/fs/dcache.c linux-2.6.25-rc4mod/fs/dcache.c
--- linux-2.6.25-rc4/fs/dcache.c	2008-03-05 13:33:54.000000000 +0900
+++ linux-2.6.25-rc4mod/fs/dcache.c	2008-03-05 16:47:18.000000000 +0900
@@ -42,6 +42,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOC

 EXPORT_SYMBOL(dcache_lock);

+/* threshold to limit dentry_unused */
+unsigned int dentry_unused_ratio = 10000;
 static struct kmem_cache *dentry_cache __read_mostly;

 #define DNAME_INLINE_LEN (sizeof(struct dentry)-offsetof(struct dentry,d_iname))
@@ -61,6 +63,7 @@ static unsigned int d_hash_mask __read_m
 static unsigned int d_hash_shift __read_mostly;
 static struct hlist_head *dentry_hashtable __read_mostly;
 static LIST_HEAD(dentry_unused);
+static void prune_dcache(int count, struct super_block *sb);

 /* Statistics gathering. */
 struct dentry_stat_t dentry_stat = {
@@ -214,6 +217,10 @@ repeat:
   	}
  	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
+	/* Prune unused dentry over threshold level */
+	int nr_in_use = (dentry_stat.nr_dentry - dentry_stat.nr_unused);
+	if (dentry_stat.nr_dentry > nr_in_use * dentry_unused_ratio / 100)
+		prune_dcache(dentry_stat.nr_unused * 5 / 100 , NULL);
 	return;

 unhash_it:
