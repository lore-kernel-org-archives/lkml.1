Return-Path: <linux-kernel-owner+w=401wt.eu-S1762211AbXHFCcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762211AbXHFCcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbXHFCcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:32:09 -0400
Received: from mail.cs.umn.edu ([128.101.32.202]:47727 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758033AbXHFCcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:32:08 -0400
X-Greylist: delayed 1700 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 22:32:08 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18102.33136.963233.867247@gargle.gargle.HOWL>
Date: Sun, 5 Aug 2007 21:03:28 -0500
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix /proc/pid/pagemap end address calculation
X-Mailer: VM 7.19 under Emacs 21.4.1
From: boutcher@cs.umn.edu (Dave Boutcher)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When dumping vma information the pagemap_read routine calculates
the minimum of what the user asks for and the end of the vma.
Unfortunately the code uses vma->vm_start rather than vma->vm_end
which can result in the end address being before the start, and
a nasty never-ending loop in the kernel.

Diffed against 2.6.23-rc1-mm2

Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
---
 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b2baeab..b12740c 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -671,7 +671,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 			ret = -EIO;
 			goto out_mm;
 		}
-		vend = min(vma->vm_start - 1, end - 1) + 1;
+		vend = min(vma->vm_end - 1, end - 1) + 1;
 		ret = pagemap_fill(&pm, vend);
 		if (ret || !pm.count)
 			break;
-- 
1.4.4.2

