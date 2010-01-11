Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395Ab0AKDnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0AKDnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 22:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280Ab0AKDnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 22:43:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:49406 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab0AKDnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 22:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=NcBa2REXs1r8Atzdhq5hCeHYdV3MybcP456QR6eOq+I90lIkLNnfajEDhrkDqF3BXe
         aby1Z02ZiECYgdYQb0fkVFL4I+btSiHJse/X+V0aw3Z5dOBF/3y+XLLg1oZ4UjG+8LM5
         wEERpxswnvESWsRu1zO5c4uDh+G27PaX8XjlU=
Date: Mon, 11 Jan 2010 12:40:49 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 -mmotm-2010-01-06-14-34] Fix fault count of task in GUP
Message-Id: <20100111124049.dc651e69.minchan.kim@barrios-desktop>
In-Reply-To: <20100111114224.bbf0fc62.minchan.kim@barrios-desktop>
References: <20100111114224.bbf0fc62.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 * V2
  * Don't count in case of kernel thread

== CUT HERE ==

get_user_pagse calls handle_mm_fault to get the arguemented
task's page. handle_mm_fault cause major or minor fault and
get_user_pages counts it into task which is passed by argument.

But the fault happens in current task's context.
So we have to count it not argumented task's context but current
task's one.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
 mm/memory.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 521abf6..0eb9536 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1485,11 +1485,11 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 						return i ? i : -EFAULT;
 					BUG();
 				}
-				if (ret & VM_FAULT_MAJOR)
-					tsk->maj_flt++;
-				else
-					tsk->min_flt++;
-
+				if (!(current->flags & PF_KTHREAD))
+					if (ret & VM_FAULT_MAJOR)
+						current->maj_flt++;
+					else
+						current->min_flt++;
 				/*
 				 * The VM_FAULT_WRITE bit tells us that
 				 * do_wp_page has broken COW when necessary,
-- 
1.5.6.3


-- 
Kind regards,
Minchan Kim
