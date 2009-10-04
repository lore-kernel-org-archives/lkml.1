Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZJDAhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZJDAhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 20:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZJDAhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 20:37:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:56788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbZJDAhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 20:37:13 -0400
Message-ID: <4AC7EE39.6010605@kernel.org>
Date: Sun, 04 Oct 2009 09:37:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu: fix compile warnings
References: <20091002134718.f577be51.sfr@canb.auug.org.au> <20091002094030.ffbde6ca.randy.dunlap@oracle.com> <4AC7EB84.1060506@kernel.org>
In-Reply-To: <4AC7EB84.1060506@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 04 Oct 2009 00:36:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following two compile warnings which show up on i386.

mm/percpu.c:1873: warning: comparison of distinct pointer types lacks a cast
mm/percpu.c:1879: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
---
This patch has been committed to percpu#for-next.  Thanks.

 mm/percpu.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index e4e08b8..ec158bb 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1868,13 +1868,14 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size,
 	max_distance = 0;
 	for (group = 0; group < ai->nr_groups; group++) {
 		ai->groups[group].base_offset = areas[group] - base;
-		max_distance = max(max_distance, ai->groups[group].base_offset);
+		max_distance = max_t(size_t, max_distance,
+				     ai->groups[group].base_offset);
 	}
 	max_distance += ai->unit_size;
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
-		pr_warning("PERCPU: max_distance=0x%lx too large for vmalloc "
+		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
 			   "space 0x%lx\n",
 			   max_distance, VMALLOC_END - VMALLOC_START);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-- 
1.6.4.2

