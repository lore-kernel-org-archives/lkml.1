Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0BRWpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:45:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:32646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0BRWpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:45:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,499,1262592000"; 
   d="scan'208";a="493662515"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] mm: Make copy_from_user() in migrate.c statically predictable
Date: Thu, 18 Feb 2010 14:43:53 -0800
Message-Id: <1266533033-24457-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

x86-32 has had a static test for copy_on_user() overflow for a while.
This test currently fails in mm/migrate.c resulting in an
allyesconfig/allmodconfig build failure on x86-32:

In function ‘copy_from_user’,
    inlined from ‘do_pages_stat’ at
    /home/hpa/kernel/git/mm/migrate.c:1012:
/home/hpa/kernel/git/arch/x86/include/asm/uaccess_32.h:212: error:
    call to ‘copy_from_user_overflow’ declared

Make the logic more explicit and therefore easier for gcc to
understand.

Reported-by: Len Brown <lenb@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

NOTE: Sending this patch directly rather than queueing it up since it is a
current build failure.

 mm/migrate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 9a0db5b..1a12f15 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1002,12 +1002,12 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 #define DO_PAGES_STAT_CHUNK_NR 16
 	const void __user *chunk_pages[DO_PAGES_STAT_CHUNK_NR];
 	int chunk_status[DO_PAGES_STAT_CHUNK_NR];
-	unsigned long i, chunk_nr = DO_PAGES_STAT_CHUNK_NR;
+	unsigned long i, chunk_nr;
 	int err;
 
 	for (i = 0; i < nr_pages; i += chunk_nr) {
-		if (chunk_nr > nr_pages - i)
-			chunk_nr = nr_pages - i;
+		chunk_nr = min(nr_pages - i,
+			       (unsigned long)DO_PAGES_STAT_CHUNK_NR);
 
 		err = copy_from_user(chunk_pages, &pages[i],
 				     chunk_nr * sizeof(*chunk_pages));
-- 
1.6.5.2

