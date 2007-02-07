Return-Path: <linux-kernel-owner+w=401wt.eu-S965702AbXBGSPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702AbXBGSPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965701AbXBGSPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:15:43 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:42699 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965703AbXBGSPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:15:42 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] FS : Speedup rw_verify_area()
Date: Wed, 7 Feb 2007 19:15:36 +0100
User-Agent: KMail/1.9.5
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com> <200702071750.55283.ak@suse.de> <20070207094344.0efdde10.akpm@linux-foundation.org>
In-Reply-To: <20070207094344.0efdde10.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JdhyFAERFWHlY1a"
Message-Id: <200702071915.37016.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JdhyFAERFWHlY1a
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

oprofile hunting showed a stall in rw_verify_area(), because of triple 
indirection and potential cache misses.
(file->f_path.dentry->d_inode->i_flock)

By moving initialization of 'struct inode' pointer before the pos/count sanity 
tests, we allow the compiler and processor to perform two loads by 
anticipation, reducing stall, without prefetch() hints. Even x86 arch has 
enough registers to not use temporary variables and not increase text size.

I validated this patch running a bench and studied oprofile changes, and 
absolute perf of the test program.

Results of my epoll_pipe_bench (source available on request) on a Pentium-M  
1.6 GHz machine

Before :
# ./epoll_pipe_bench -l 30 -t 20
Avg: 436089 evts/sec read_count=8843037 write_count=8843040 21.218390 samples 
per call
(best value out of 10 runs)

After :
# ./epoll_pipe_bench -l 30 -t 20
Avg: 470980 evts/sec read_count=9549871 write_count=9549894 21.216694 samples 
per call
(best value out of 10 runs)

oprofile CPU_CLK_UNHALTED events gave a reduction from 5.3401 % to 2.5851 % 
for the rw_verify_area() function.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--Boundary-00=_JdhyFAERFWHlY1a
Content-Type: text/plain;
  charset="iso-8859-1";
  name="rw_verify_area.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="rw_verify_area.patch"

--- linux-2.6.20/fs/read_write.c	2007-02-07 18:21:59.000000000 +0100
+++ linux-2.6.20-ed/fs/read_write.c	2007-02-07 18:23:41.000000000 +0100
@@ -197,13 +197,13 @@ int rw_verify_area(int read_write, struc
 	struct inode *inode;
 	loff_t pos;
 
+	inode = file->f_path.dentry->d_inode;
 	if (unlikely((ssize_t) count < 0))
 		goto Einval;
 	pos = *ppos;
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
 		goto Einval;
 
-	inode = file->f_path.dentry->d_inode;
 	if (unlikely(inode->i_flock && MANDATORY_LOCK(inode))) {
 		int retval = locks_mandatory_area(
 			read_write == READ ? FLOCK_VERIFY_READ : FLOCK_VERIFY_WRITE,

--Boundary-00=_JdhyFAERFWHlY1a--
