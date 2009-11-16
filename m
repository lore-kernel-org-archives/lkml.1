Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZKPOzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZKPOzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZKPOzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:55:45 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:47245 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZKPOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:55:42 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Nov 2009 09:55:42 EST
X-Spam-Processed: digidescorp.com, Mon, 16 Nov 2009 08:51:00 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1571e16926=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: steve@digidescorp.com
To: linux-kernel@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH v2] procfs: Use proper units for noMMU statm
Date: Mon, 16 Nov 2009 08:50:53 -0600
Message-Id: <1258383053-3425-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1258382853.3019.0.camel@iscandar.digidescorp.com>
References: <1258382853.3019.0.camel@iscandar.digidescorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reworked to guarantee page alignment of terms used in data size calculation
and to reduce time spent with mmap_sem held.

On no-MMU systems, sizes reported in /proc/n/statm have units of bytes. 
Per Documentation/filesystems/proc.txt, these values should be in pages.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---

diff -uprN a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c	2009-11-13 16:48:14.000000000 -0600
+++ b/fs/proc/task_nommu.c	2009-11-14 12:17:00.000000000 -0600
@@ -110,9 +110,13 @@ int task_statm(struct mm_struct *mm, int
 		}
 	}
 
-	size += (*text = mm->end_code - mm->start_code);
-	size += (*data = mm->start_stack - mm->start_data);
+	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
+		>> PAGE_SHIFT;
+	*data = (PAGE_ALIGN(mm->start_stack) - (mm->start_data & PAGE_MASK))
+		>> PAGE_SHIFT;
 	up_read(&mm->mmap_sem);
+	size >>= PAGE_SHIFT;
+	size += *text + *data;
 	*resident = size;
 	return size;
 }

