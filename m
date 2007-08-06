Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbXHFGpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbXHFGpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXHFGpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:45:09 -0400
Received: from mail.cs.umn.edu ([128.101.32.202]:47809 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbXHFGpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:45:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18102.50025.384989.809593@gargle.gargle.HOWL>
Date: Mon, 6 Aug 2007 01:44:57 -0500
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] Fix /proc/pid/pagemap unmapped page handling
X-Mailer: VM 7.19 under Emacs 21.4.1
In-Reply-To: <af12424c6e31474e5e7227e34854b29fa8a128db.1186382353.git.boutcher@cs.umn.edu>
References: <af12424c6e31474e5e7227e34854b29fa8a128db.1186382353.git.boutcher@cs.umn.edu> 
From: boutcher@cs.umn.edu (Dave Boutcher)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When reading /proc/pid/pagemap at an offset that
does not contain mapped pages, call pagemap_fill
to fill the buffer with -1 until either the end,
or a valid vma is encountered.

Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
---
 fs/proc/task_mmu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1f78cb4..3978f31 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -671,10 +671,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 			ret = -EIO;
 			goto out_mm;
 		}
-		vend = min(vma->vm_start - 1, end - 1) + 1;
-		ret = pagemap_fill(&pm, vend);
-		if (ret || !pm.count)
-			break;
+		if (pm.next < vma->vm_start) {
+			vend = min(vma->vm_start - 1, end - 1) + 1;
+			pagemap_fill(&pm, vend);
+			continue;
+		}
+
 		vend = min(vma->vm_end - 1, end - 1) + 1;
 		ret = walk_page_range(mm, vma->vm_start, vend,
 				      &pagemap_walk, &pm);
-- 
1.4.4.2

