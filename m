Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZI2PUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZI2PUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZI2PU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:20:29 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52779 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZI2PU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:20:28 -0400
Date: Tue, 29 Sep 2009 20:50:27 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, akpm@linux-foundation.org, rientjes@google.com
Subject: [PATCH] linux-next: 20090929 - android driver build breaks
Message-ID: <20090929152027.GC4373@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

	next-20090929 randconfig build breaks with
CONFIG_ANDROID_LOW_MEMORY_KILLER=y

drivers/staging/android/lowmemorykiller.c: In function 'lowmem_shrink':
drivers/staging/android/lowmemorykiller.c:111: error: 'struct mm_struct' has no member named 'oom_adj'
make[3]: *** [drivers/staging/android/lowmemorykiller.o] Error 1

Commit 0753ba01e126020bf0f8150934903b48935b697d was reverted back,
which moves back oom_adj from mm_struct to task_struct and commit 
28b83c5193e7ab951e402252278f2cc79dc4d298 moved the oomkilladj
from task_struct to signal_struct. 

Following patch reverts the changes introduced by commit 
a6a9f81ccc9f5c86ccc22bbed1960a57d0316e8b to
drivers/staging/android/lowmemorykiller.c 

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 drivers/staging/android/lowmemorykiller.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 935d281..63ef837 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -99,21 +99,19 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
-		struct mm_struct *mm;
 		int oom_adj;
 
 		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
+		if (!p->mm) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = mm->oom_adj;
+		oom_adj = p->signal->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(mm);
+		tasksize = get_mm_rss(p->mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
			
			Kamalesh
