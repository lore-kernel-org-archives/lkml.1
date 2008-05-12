Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbYELKdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbYELKdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761315AbYELKcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:32:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:51661 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761287AbYELKcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references:sender;
        b=gzd8fIYxAioQiy7DMjdeQs06I4KmMynf6LZ6wB9TXyPLiar5AKWazEpRAOARaR1/RxkHefYVqs83ydvdZRumxRQFHFnUHkG9HrL/gEVF9tiRKPGX7z+6BvWFqc2ALVcoK3rsZBsF5dv6/FTfLsjeN+4vjIPMYeE6JuV2L1g3Yrg=
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Cc: Jie Zhang <jie.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/4] [mm/nommu]: use copy_to_user_page to call flush icache for [#811] toolchain old bug
Date: Mon, 12 May 2008 18:32:04 +0800
Message-Id: <1210588325-11027-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

access_process_vm in mm/memory.c uses copy_to_user_page and
copy_from_user_page. So for !MMU we'd better do the same thing.
Other archs with mmu do the cache flush in copy_to_user_page.
It gives me hint that copy_to_user_page is designed to flush
the cache. On other side, no archs do the cache flush ptrace.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 mm/nommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index c11e5cc..56bb447 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1458,9 +1458,11 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 
 		/* only read or write mappings where it is permitted */
 		if (write && vma->vm_flags & VM_MAYWRITE)
-			len -= copy_to_user((void *) addr, buf, len);
+			copy_to_user_page(vma, NULL, NULL,
+					  (void *) addr, buf, len);
 		else if (!write && vma->vm_flags & VM_MAYREAD)
-			len -= copy_from_user(buf, (void *) addr, len);
+			copy_from_user_page(vma, NULL, NULL,
+					    buf, (void *) addr, len);
 		else
 			len = 0;
 	} else {
-- 
1.5.5

