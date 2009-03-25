Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZCYIPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZCYIPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZCYIPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:15:37 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53071 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZCYIPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:15:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
Date: Wed, 25 Mar 2009 19:15:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: allow and require one-page mmap on counting counters
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

Currently the mmap code requires that the length of the mmap be at least
two pages.  That is fine for sampling counters, but for counting
counters the second and subsequent pages are just wasted, since counting
counters don't generate events.

This changes the code to require that the mmap be one page in length
for counting counters, and applies the existing check to sampling
counters.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Ingo, please pull this from the master branch of my perfcounters.git
repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master

 kernel/perf_counter.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index affe227..0412c7c 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1362,8 +1362,13 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	vma_size = vma->vm_end - vma->vm_start;
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
-	if (nr_pages == 0 || !is_power_of_2(nr_pages))
-		return -EINVAL;
+	if (counter->hw_event.record_type == PERF_RECORD_SIMPLE) {
+		if (nr_pages)
+			return -EINVAL;
+	} else {
+		if (nr_pages == 0 || !is_power_of_2(nr_pages))
+			return -EINVAL;
+	}
 
 	if (vma_size != PAGE_SIZE * (1 + nr_pages))
 		return -EINVAL;
-- 
1.5.6.3

