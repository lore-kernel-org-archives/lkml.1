Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZFET7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZFET7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZFET7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:59:02 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47915 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814AbZFET7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:59:00 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191850.822207200@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:22 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 03/11] Use this_cpu operations for NFS statistics
Content-Disposition: inline; filename=this_cpu_nfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify NFS statistics and allow the use of optimized
arch instructions.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/nfs/iostat.h |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/nfs/iostat.h
===================================================================
--- linux-2.6.orig/fs/nfs/iostat.h	2009-06-04 17:40:55.000000000 -0500
+++ linux-2.6/fs/nfs/iostat.h	2009-06-05 12:51:54.000000000 -0500
@@ -25,13 +25,7 @@ struct nfs_iostats {
 static inline void nfs_inc_server_stats(const struct nfs_server *server,
 					enum nfs_stat_eventcounters stat)
 {
-	struct nfs_iostats *iostats;
-	int cpu;
-
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
-	iostats->events[stat]++;
-	put_cpu_no_resched();
+	this_cpu_inc(server->io_stats->events[stat]);
 }
 
 static inline void nfs_inc_stats(const struct inode *inode,
@@ -44,13 +38,13 @@ static inline void nfs_add_server_stats(
 					enum nfs_stat_bytecounters stat,
 					unsigned long addend)
 {
-	struct nfs_iostats *iostats;
-	int cpu;
-
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
-	iostats->bytes[stat] += addend;
-	put_cpu_no_resched();
+	/*
+	 * bytes is larger than word size on 32 bit platforms.
+	 * Thus we cannot use this_cpu_add() here.
+	 */
+	preempt_disable();
+	*this_cpu_ptr(&server->io_stats->bytes[stat]) +=  addend;
+	preempt_enable_no_resched();
 }
 
 static inline void nfs_add_stats(const struct inode *inode,
@@ -65,13 +59,7 @@ static inline void nfs_add_fscache_stats
 					 enum nfs_stat_fscachecounters stat,
 					 unsigned long addend)
 {
-	struct nfs_iostats *iostats;
-	int cpu;
-
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(NFS_SERVER(inode)->io_stats, cpu);
-	iostats->fscache[stat] += addend;
-	put_cpu_no_resched();
+	this_cpu_add(NFS_SERVER(inode)->io_stats->fscache[stat], addend);
 }
 #endif
 

-- 
