Return-Path: <linux-kernel-owner+w=401wt.eu-S1751418AbZL1Cqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbZL1Cqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 21:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZL1Cqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 21:46:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34235 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZL1Cqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 21:46:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [cleanup][PATCH 2/2] mlock_vma_pages_range() only return success or failure
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20091228114519.A678.A69D9226@jp.fujitsu.com>
References: <20091228114519.A678.A69D9226@jp.fujitsu.com>
Message-Id: <20091228114611.A67B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Dec 2009 11:46:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, mlock_vma_pages_range() only return len or 0. then
current error handling of mmap_region() is meaningless complex.

this patch makes simplify and makes consist with brk() code.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/mmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 826b0ec..0f10176 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1247,8 +1247,8 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		long nr_pages = mlock_vma_pages_range(vma, addr, addr + len);
-		mm->locked_vm += (len >> PAGE_SHIFT) - nr_pages;
+		if (!mlock_vma_pages_range(vma, addr, addr + len))
+			mm->locked_vm += (len >> PAGE_SHIFT);
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 	return addr;
-- 
1.6.5.2



