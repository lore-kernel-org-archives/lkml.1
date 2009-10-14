Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZJNGEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZJNGEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZJNGEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:04:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:58673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZJNGDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:34 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH 01/16] vmalloc: fix use of non-existent percpu variable in put_cpu_var()
Date: Wed, 14 Oct 2009 15:01:50 +0900
Message-Id: <1255500125-3210-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc used non-existent percpu variable vmap_cpu_blocks instead of
the intended vmap_block_queue.  This went unnoticed because
put_cpu_var() didn't evaluate the parameter.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 mm/vmalloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 69511e6..b65cfe4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -760,7 +760,7 @@ static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
 	spin_lock(&vbq->lock);
 	list_add(&vb->free_list, &vbq->free);
 	spin_unlock(&vbq->lock);
-	put_cpu_var(vmap_cpu_blocks);
+	put_cpu_var(vmap_block_queue);
 
 	return vb;
 }
@@ -825,7 +825,7 @@ again:
 		}
 		spin_unlock(&vb->lock);
 	}
-	put_cpu_var(vmap_cpu_blocks);
+	put_cpu_var(vmap_block_queue);
 	rcu_read_unlock();
 
 	if (!addr) {
-- 
1.6.4.2

