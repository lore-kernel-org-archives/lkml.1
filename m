Return-Path: <linux-kernel-owner+w=401wt.eu-S1762343AbXKCXJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762343AbXKCXJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXKCXGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:06:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760039AbXKCXGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:06:42 -0400
Date: Sat, 3 Nov 2007 19:04:46 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 9/10] split VM and memory controllers
Message-ID: <20071103190446.722dffa3@bree.surriel.com>
In-Reply-To: <20071103184229.3f20e2f0@bree.surriel.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The memory controller code is still quite simple, so don't do
anything fancy for now trying to make it work better with the
split VM code.

Will be merged into 6/10 soon.

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.23-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.23-mm1.orig/mm/memcontrol.c
+++ linux-2.6.23-mm1/mm/memcontrol.c
@@ -210,7 +210,6 @@ unsigned long mem_cgroup_isolate_pages(u
 	struct list_head *src;
 	struct page_cgroup *pc;
 
-//TODO:  memory container maintain separate file/anon lists?
 	if (active)
 		src = &mem_cont->active_list;
 	else
@@ -222,6 +221,9 @@ unsigned long mem_cgroup_isolate_pages(u
 		page = pc->page;
 		VM_BUG_ON(!pc);
 
+		/*
+		 * TODO: play better with lumpy reclaim, grabbing anything.
+		 */
 		if (PageActive(page) && !active) {
 			__mem_cgroup_move_lists(pc, true);
 			scan--;
@@ -240,6 +242,9 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (page_zone(page) != z)
 			continue;
 
+		if (file != !!page_file_cache(page))
+			continue;
+
 		/*
 		 * Check if the meta page went away from under us
 		 */
