Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbZJIBKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbZJIBKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760130AbZJIBJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:09:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40583 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510AbZJIBJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:09:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Fix memory leak of do_mbind()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20091009100527.1284.A69D9226@jp.fujitsu.com>
References: <20091009100527.1284.A69D9226@jp.fujitsu.com>
Message-Id: <20091009100837.128A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Oct 2009 10:09:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If migrate_prep is failed, new variable is leaked.
This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mempolicy.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 824abf3..38ce2a7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1027,7 +1027,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 		err = migrate_prep();
 		if (err)
-			return err;
+			goto mpol_out;
 	}
 	{
 		NODEMASK_SCRATCH(scratch);
@@ -1042,10 +1042,9 @@ static long do_mbind(unsigned long start, unsigned long len,
 			err = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 	}
-	if (err) {
-		mpol_put(new);
-		return err;
-	}
+	if (err)
+		goto mpol_out;
+
 	vma = check_range(mm, start, end, nmask,
 			  flags | MPOL_MF_INVERT, &pagelist);
 
@@ -1066,6 +1065,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 	}
 
 	up_write(&mm->mmap_sem);
+ mpol_out:
 	mpol_put(new);
 	return err;
 }
-- 
1.6.0.GIT



