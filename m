Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZGUKb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZGUKb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZGUKbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:31:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:37066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbZGUK2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:02 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/20] percpu: fix pcpu_reclaim() locking
Date: Tue, 21 Jul 2009 19:26:00 +0900
Message-Id: <1248171979-29166-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_reclaim() calls pcpu_depopulate_chunk() which makes use of pages
array and bitmap returned by pcpu_get_pages_and_bitmap() and thus
should be called under pcpu_alloc_mutex.  pcpu_reclaim() released the
mutex before calling depopulate leading to double free and other
strange problems caused by the unexpected concurrent usages of pages
array and bitmap.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f993dc8..c44a5b2 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1181,12 +1181,13 @@ static void pcpu_reclaim(struct work_struct *work)
 	}
 
 	spin_unlock_irq(&pcpu_lock);
-	mutex_unlock(&pcpu_alloc_mutex);
 
 	list_for_each_entry_safe(chunk, next, &todo, list) {
 		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
 		free_pcpu_chunk(chunk);
 	}
+
+	mutex_unlock(&pcpu_alloc_mutex);
 }
 
 /**
-- 
1.6.0.2

