Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbXLSAOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbXLSAOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbXLSAOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:14:46 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:48379 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXLSAOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:14:45 -0500
Message-ID: <47686269.2090103@cosmosbay.com>
Date: Wed, 19 Dec 2007 01:14:33 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/sys.c : Get rid of expensive divides in groups_sort()
Content-Type: multipart/mixed;
 boundary="------------040605090806020507030406"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 19 Dec 2007 01:14:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040605090806020507030406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

groups_sort() can be quite long if user loads a large gid table.

This is because GROUP_AT(group_info, some_integer) uses an integer divide.
So having to do XXX thousand divides during one syscall can lead to very high 
latencies. (NGROUPS_MAX=65536)

In the past (25 Mar 2006), an analog problem was found in groups_search()
(commit d74beb9f33a5f16d2965f11b275e401f225c949d ) and at that time I changed 
some variables to unsigned int.

I believe that a more generic fix is to make sure NGROUPS_PER_BLOCK is unsigned.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------040605090806020507030406
Content-Type: text/plain;
 name="NGROUPS_PER_BLOCK.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="NGROUPS_PER_BLOCK.patch"

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac3d496..725a491 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -775,7 +775,7 @@ static inline int above_background_load(void)
 
 struct io_context;			/* See blkdev.h */
 #define NGROUPS_SMALL		32
-#define NGROUPS_PER_BLOCK	((int)(PAGE_SIZE / sizeof(gid_t)))
+#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
 struct group_info {
 	int ngroups;
 	atomic_t usage;
diff --git a/kernel/sys.c b/kernel/sys.c
index d1fe71e..091e58f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1148,7 +1148,7 @@ static int groups_to_user(gid_t __user *grouplist,
 	int count = group_info->ngroups;
 
 	for (i = 0; i < group_info->nblocks; i++) {
-		int cp_count = min(NGROUPS_PER_BLOCK, count);
+		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
 		int off = i * NGROUPS_PER_BLOCK;
 		int len = cp_count * sizeof(*grouplist);
 
@@ -1168,7 +1168,7 @@ static int groups_from_user(struct group_info *group_info,
 	int count = group_info->ngroups;
 
 	for (i = 0; i < group_info->nblocks; i++) {
-		int cp_count = min(NGROUPS_PER_BLOCK, count);
+		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
 		int off = i * NGROUPS_PER_BLOCK;
 		int len = cp_count * sizeof(*grouplist);
 

--------------040605090806020507030406--
