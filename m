Return-Path: <linux-kernel-owner+w=401wt.eu-S1763076AbXHFGph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763076AbXHFGph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXHFGpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:45:10 -0400
Received: from mail.cs.umn.edu ([128.101.34.202]:47812 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbXHFGpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:45:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18102.49994.250514.93818@gargle.gargle.HOWL>
Date: Mon, 6 Aug 2007 01:44:26 -0500
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] Fix /proc/pid/pagemap return length calculation
X-Mailer: VM 7.19 under Emacs 21.4.1
In-Reply-To: <af12424c6e31474e5e7227e34854b29fa8a128db.1186382353.git.boutcher@cs.umn.edu>
References: <af12424c6e31474e5e7227e34854b29fa8a128db.1186382353.git.boutcher@cs.umn.edu> 
From: boutcher@cs.umn.edu (Dave Boutcher)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/pid/pagemap has a header (usually 8 bytes) the length
of which needs to be compensated for when converting from
proc file offset to page number.  The calculation of the
starting page number (svpfn) compensates for this, but the
calculation of the ending page number (evpfn) does not, resulting
in reads returning 8 bytes more than were asked for.

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

