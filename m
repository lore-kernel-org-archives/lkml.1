Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZCFGug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZCFGug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbZCFGrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:56819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbZCFGrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:12 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/8] percpu: add an indirection ptr for chunk page map access
Date: Fri,  6 Mar 2009 15:46:26 +0900
Message-Id: <1236321988-19457-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow sharing page map, no functional difference yet

Make chunk->page access indirect by adding a pointer and renaming the
actual array to page_ar.  This will be used by future changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index a84cf99..5b47d9f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -80,7 +80,8 @@ struct pcpu_chunk {
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
 	bool			immutable;	/* no [de]population allowed */
-	struct page		*page[];	/* #cpus * UNIT_PAGES */
+	struct page		**page;		/* points to page array */
+	struct page		*page_ar[];	/* #cpus * UNIT_PAGES */
 };
 
 static int pcpu_unit_pages __read_mostly;
@@ -696,6 +697,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 				  PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
+	chunk->page = chunk->page_ar;
 
 	chunk->vm = get_vm_area(pcpu_chunk_size, GFP_KERNEL);
 	if (!chunk->vm) {
@@ -918,6 +920,7 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	schunk->vm = &first_vm;
 	schunk->map = smap;
 	schunk->map_alloc = ARRAY_SIZE(smap);
+	schunk->page = schunk->page_ar;
 	schunk->free_size = dyn_size;
 	schunk->contig_hint = schunk->free_size;
 
-- 
1.6.0.2

