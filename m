Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYFGFV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYFGFV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 01:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYFGFVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 01:21:20 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:54758 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYFGFVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 01:21:20 -0400
X-IronPort-AV: E=Sophos;i="4.27,603,1204531200"; 
   d="scan'208";a="109793548"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [PATCH] IB/umem: Avoid sign problems when demoting npages to integer
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Jun 2008 22:21:18 -0700
Message-ID: <adamylxakhd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Jun 2008 05:21:18.0686 (UTC) FILETIME=[50B947E0:01C8C85E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 64-bit architecture, if ib_umem_get() is called with a size value
that is so big that npages is negative when cast to int, then the
length of the page list passed to get_user_pages(), namely

	min_t(int, npages, PAGE_SIZE / sizeof (struct page *))

will be negative, and get_user_pages() will immediately return 0 (at
least since 900cf086, "Be more robust about bad arguments in
get_user_pages()").  This leads to an infinite loop in ib_umem_get(),
since the code boils down to:

	while (npages) {
		ret = get_user_pages(...);
		npages -= ret;
	}

Fix this by taking the minimum as unsigned longs, so that the value of
npages is never truncated.

The impact of this bug isn't too severe, since the value of npages is
checked against RLIMIT_MEMLOCK, so a process would need to have an
astronomical limit or have CAP_IPC_LOCK to be able to trigger this,
and such a process could already cause lots of mischief.  But it does
let buggy userspace code cause a kernel lock-up; for example I hit
this with code that passes a negative value into a memory registartion
function where it is promoted to a huge u64 value.

Cc: <stable@kernel.org>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
One I hit while debugging my own buggy userspace code.  Definitely
should go into 2.6.26 and I think -stable too.

 drivers/infiniband/core/umem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index fe78f7d..a1768db 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -150,7 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	ret = 0;
 	while (npages) {
 		ret = get_user_pages(current, current->mm, cur_base,
-				     min_t(int, npages,
+				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
 				     1, !umem->writable, page_list, vma_list);
 
-- 
1.5.5.1

