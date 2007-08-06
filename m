Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbXHFDFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbXHFDFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 23:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXHFDF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 23:05:28 -0400
Received: from mail.cs.umn.edu ([128.101.34.202]:51144 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbXHFDF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 23:05:27 -0400
X-Greylist: delayed 3699 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 23:05:27 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18102.33131.876436.899189@gargle.gargle.HOWL>
Date: Sun, 5 Aug 2007 21:03:23 -0500
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix /proc/pid/pagemap return length calculation
X-Mailer: VM 7.19 under Emacs 21.4.1
From: boutcher@cs.umn.edu (Dave Boutcher)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


/proc/pid/pagemap has a header (usually 8 bytes) the length
of which needs to be compensated for when converting from
proc file offset to page number.  The calculation of the
starting page number (svpfn) compensates for this, but the
calculation of the ending page number (evpfn) does not, resulting
in reads returning 8 bytes more than were asked for and
nastily overwriting userspace memory.

Diffed against 2.6.23-rc1-mm2

Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
---
 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4594f15..b2baeab 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -627,7 +627,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	addr = PAGE_SIZE * svpfn;
 	if ((svpfn + 1) * sizeof(unsigned long) != src)
 		goto out;
-	evpfn = min((src + count) / sizeof(unsigned long),
+	evpfn = min((src + count) / sizeof(unsigned long) - 1,
 		    ((~0UL) >> PAGE_SHIFT) + 1);
 	count = (evpfn - svpfn) * sizeof(unsigned long);
 	end = PAGE_SIZE * evpfn;
-- 
1.4.4.2

