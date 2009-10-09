Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbZJIKKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbZJIKKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbZJIKKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:10:45 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:49938 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbZJIKKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:10:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19151.3066.304514.621378@pilspetsen.it.uu.se>
Date: Fri, 9 Oct 2009 12:10:02 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2.6.32-rc3] fix pcpu_embed_first_chunk() compile warnings
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling 2.6.32-rc3 on i686 I get the following new warnings:

mm/percpu.c: In function 'pcpu_embed_first_chunk':
mm/percpu.c:1873: warning: comparison of distinct pointer types lacks a cast
mm/percpu.c:1879: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'size_t'

They are caused by 6ea529a2037ce662fc6bfa572b46d47407d08805
"make embedding first chunk allocator check vmalloc space size".

The first warning is because max() is applied to one operand of
type 'size_t' and another of type 'unsigned long'. Fix: cast the
second one to 'size_t'.

For the second warning: always use '%z' to format 'size_t' operands.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 mm/percpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.32-rc3/mm/percpu.c.~1~	2009-10-08 15:36:27.000000000 +0200
+++ linux-2.6.32-rc3/mm/percpu.c	2009-10-09 11:39:13.000000000 +0200
@@ -1870,13 +1870,13 @@ int __init pcpu_embed_first_chunk(size_t
 	max_distance = 0;
 	for (group = 0; group < ai->nr_groups; group++) {
 		ai->groups[group].base_offset = areas[group] - base;
-		max_distance = max(max_distance, ai->groups[group].base_offset);
+		max_distance = max(max_distance, (size_t)ai->groups[group].base_offset);
 	}
 	max_distance += ai->unit_size;
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
-		pr_warning("PERCPU: max_distance=0x%lx too large for vmalloc "
+		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
 			   "space 0x%lx\n",
 			   max_distance, VMALLOC_END - VMALLOC_START);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
