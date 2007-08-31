Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbXHaEnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbXHaEnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXHaEnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:43:04 -0400
Received: from sandeen.net ([209.173.210.139]:21372 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXHaEnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:43:03 -0400
Message-ID: <46D79C62.1010304@sandeen.net>
Date: Thu, 30 Aug 2007 23:43:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: xfs-oss <xfs@oss.sgi.com>
Subject: [PATCH] Increase lockdep MAX_LOCK_DEPTH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The xfs filesystem can exceed the current lockdep 
MAX_LOCK_DEPTH, because when deleting an entire cluster of inodes,
they all get locked in xfs_ifree_cluster().  The normal cluster
size is 8192 bytes, and with the default (and minimum) inode size 
of 256 bytes, that's up to 32 inodes that get locked.  Throw in a 
few other locks along the way, and 40 seems enough to get me through
all the tests in the xfsqa suite on 4k blocks.  (block sizes
above 8K will still exceed this though, I think)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.23-rc3/include/linux/sched.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/sched.h
+++ linux-2.6.23-rc3/include/linux/sched.h
@@ -1125,7 +1125,7 @@ struct task_struct {
 	int softirq_context;
 #endif
 #ifdef CONFIG_LOCKDEP
-# define MAX_LOCK_DEPTH 30UL
+# define MAX_LOCK_DEPTH 40UL
 	u64 curr_chain_key;
 	int lockdep_depth;
 	struct held_lock held_locks[MAX_LOCK_DEPTH];

