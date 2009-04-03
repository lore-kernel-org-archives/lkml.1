Return-Path: <linux-kernel-owner+w=401wt.eu-S936278AbZDCQMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936278AbZDCQMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbZDCP5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:57:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56675 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934998AbZDCP5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:57:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 34/41] NFS: Add some new I/O counters for FS-Cache doing
	things for NFS [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:57:31 +0100
Message-ID: <20090403155731.28714.29107.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some new NFS I/O counters for FS-Cache doing things for NFS.  A new line is
emitted into /proc/pid/mountstats if caching is enabled that looks like:

	fsc: <rok> <rfl> <wok> <wfl> <unc>

Where <rok> is the number of pages read successfully from the cache, <rfl> is
the number of failed page reads against the cache, <wok> is the number of
successful page writes to the cache, <wfl> is the number of failed page writes
to the cache, and <unc> is the number of NFS pages that have been disconnected
from the cache.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/nfs/iostat.h            |   18 ++++++++++++++++++
 fs/nfs/super.c             |   11 +++++++++++
 include/linux/nfs_iostat.h |   12 ++++++++++++
 3 files changed, 41 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/iostat.h b/fs/nfs/iostat.h
index a369528..a2ab252 100644
--- a/fs/nfs/iostat.h
+++ b/fs/nfs/iostat.h
@@ -16,6 +16,9 @@
 
 struct nfs_iostats {
 	unsigned long long	bytes[__NFSIOS_BYTESMAX];
+#ifdef CONFIG_NFS_FSCACHE
+	unsigned long long	fscache[__NFSIOS_FSCACHEMAX];
+#endif
 	unsigned long		events[__NFSIOS_COUNTSMAX];
 } ____cacheline_aligned;
 
@@ -57,6 +60,21 @@ static inline void nfs_add_stats(const struct inode *inode,
 	nfs_add_server_stats(NFS_SERVER(inode), stat, addend);
 }
 
+#ifdef CONFIG_NFS_FSCACHE
+static inline void nfs_add_fscache_stats(struct inode *inode,
+					 enum nfs_stat_fscachecounters stat,
+					 unsigned long addend)
+{
+	struct nfs_iostats *iostats;
+	int cpu;
+
+	cpu = get_cpu();
+	iostats = per_cpu_ptr(NFS_SERVER(inode)->io_stats, cpu);
+	iostats->fscache[stat] += addend;
+	put_cpu_no_resched();
+}
+#endif
+
 static inline struct nfs_iostats *nfs_alloc_iostats(void)
 {
 	return alloc_percpu(struct nfs_iostats);
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 87f65ae..b5fea77 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -642,6 +642,10 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
 			totals.events[i] += stats->events[i];
 		for (i = 0; i < __NFSIOS_BYTESMAX; i++)
 			totals.bytes[i] += stats->bytes[i];
+#ifdef CONFIG_NFS_FSCACHE
+		for (i = 0; i < __NFSIOS_FSCACHEMAX; i++)
+			totals.fscache[i] += stats->fscache[i];
+#endif
 
 		preempt_enable();
 	}
@@ -652,6 +656,13 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
 	seq_printf(m, "\n\tbytes:\t");
 	for (i = 0; i < __NFSIOS_BYTESMAX; i++)
 		seq_printf(m, "%Lu ", totals.bytes[i]);
+#ifdef CONFIG_NFS_FSCACHE
+	if (nfss->options & NFS_OPTION_FSCACHE) {
+		seq_printf(m, "\n\tfsc:\t");
+		for (i = 0; i < __NFSIOS_FSCACHEMAX; i++)
+			seq_printf(m, "%Lu ", totals.bytes[i]);
+	}
+#endif
 	seq_printf(m, "\n");
 
 	rpc_print_iostats(m, nfss->client);
diff --git a/include/linux/nfs_iostat.h b/include/linux/nfs_iostat.h
index 1cb9a3f..68b10f5 100644
--- a/include/linux/nfs_iostat.h
+++ b/include/linux/nfs_iostat.h
@@ -116,4 +116,16 @@ enum nfs_stat_eventcounters {
 	__NFSIOS_COUNTSMAX,
 };
 
+/*
+ * NFS local caching servicing counters
+ */
+enum nfs_stat_fscachecounters {
+	NFSIOS_FSCACHE_PAGES_READ_OK,
+	NFSIOS_FSCACHE_PAGES_READ_FAIL,
+	NFSIOS_FSCACHE_PAGES_WRITTEN_OK,
+	NFSIOS_FSCACHE_PAGES_WRITTEN_FAIL,
+	NFSIOS_FSCACHE_PAGES_UNCACHED,
+	__NFSIOS_FSCACHEMAX,
+};
+
 #endif	/* _LINUX_NFS_IOSTAT */

