Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZKNCAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZKNCAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZKNCAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:00:39 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:13556 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZKNCAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:00:39 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 21:00:39 EST
X-Spam-Processed: digidescorp.com, Fri, 13 Nov 2009 19:52:23 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.47.27
X-Return-Path: prvs=156933d12f=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: linux-kernel@vger.kernel.org
Cc: "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] procfs: Use proper units for noMMU statm
Date: Fri, 13 Nov 2009 19:52:14 -0600
Message-Id: <1258163534-3617-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On no-MMU systems, sizes reported in /proc/n/statm have units of bytes. 
Per Documentation/filesystems/proc.txt, these values should be in pages.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c	2009-11-13 16:48:14.000000000 -0600
+++ b/fs/proc/task_nommu.c	2009-11-13 16:51:09.000000000 -0600
@@ -110,8 +110,11 @@ int task_statm(struct mm_struct *mm, int
 		}
 	}
 
-	size += (*text = mm->end_code - mm->start_code);
-	size += (*data = mm->start_stack - mm->start_data);
+	size >>= PAGE_SHIFT;
+	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
+		>> PAGE_SHIFT;
+	*data = (mm->start_stack - mm->start_data) >> PAGE_SHIFT;
+	size += *text + *data;
 	up_read(&mm->mmap_sem);
 	*resident = size;
 	return size;

