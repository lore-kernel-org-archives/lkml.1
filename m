Return-Path: <linux-kernel-owner+w=401wt.eu-S933555AbZJGAEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbZJGAEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933124AbZJGAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:04:54 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:48078 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932921AbZJGAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:04:53 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091006233730.279506874@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:36:58 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 04/19] Use this_cpu operations for NFS statistics
Content-Disposition: inline; filename=this_cpu_nfs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify NFS statistics and allow the use of optimized
arch instructions.

Acked-by: Tejun Heo <tj@kernel.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/nfs/iostat.h |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/nfs/iostat.h
===================================================================
--- linux-2.6.orig/fs/nfs/iostat.h	2009-09-29 11:57:01.000000000 -0500
+++ linux-2.6/fs/nfs/iostat.h	2009-09-29 12:26:42.000000000 -0500
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
-	put_cpu();
+	this_cpu_inc(server->io_stats->events[stat]);
 }
 
 static inline void nfs_inc_stats(const struct inode *inode,
@@ -44,13 +38,7 @@ static inline void nfs_add_server_stats(
 					enum nfs_stat_bytecounters stat,
 					unsigned long addend)
 {
-	struct nfs_iostats *iostats;
-	int cpu;
-
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(server->io_stats, cpu);
-	iostats->bytes[stat] += addend;
-	put_cpu();
+	this_cpu_add(server->io_stats->bytes[stat], addend);
 }
 
 static inline void nfs_add_stats(const struct inode *inode,
@@ -65,13 +53,7 @@ static inline void nfs_add_fscache_stats
 					 enum nfs_stat_fscachecounters stat,
 					 unsigned long addend)
 {
-	struct nfs_iostats *iostats;
-	int cpu;
-
-	cpu = get_cpu();
-	iostats = per_cpu_ptr(NFS_SERVER(inode)->io_stats, cpu);
-	iostats->fscache[stat] += addend;
-	put_cpu();
+	this_cpu_add(NFS_SERVER(inode)->io_stats->fscache[stat], addend);
 }
 #endif
 

-- 
