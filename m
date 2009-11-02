Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZKBQuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZKBQuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZKBQuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:50:37 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:44784 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755795AbZKBQug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:50:36 -0500
X-Trace: 283350822/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.19.148/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.19.148
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AucHAIec7kpPRROU/2dsb2JhbACBUI4vJQHMXoQ8BA
X-IronPort-AV: E=Sophos;i="4.44,668,1249254000"; 
   d="scan'208";a="283350822"
Date: Mon, 2 Nov 2009 16:50:33 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bo Liu <bo-liu@hotmail.com>, Bob Liu <yjfpb04@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mm: remove incorrect swap_count() from try_to_unuse()
Message-ID: <Pine.LNX.4.64.0911021646020.23159@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bo Liu <bo-liu@hotmail.com>

In try_to_unuse(), swcount is a local copy of *swap_map, including the
SWAP_HAS_CACHE bit; but a wrong comparison against swap_count(*swap_map),
which masks off the SWAP_HAS_CACHE bit, succeeded where it should fail.

That had the effect of resetting the mm from which to start searching
for the next swap page, to an irrelevant mm instead of to an mm in which
this swap page had been found: which may increase search time by ~20%.
But we're used to swapoff being slow, so never noticed the slowdown.

Remove that one spurious use of swap_count(): Bo Liu thought it merely
redundant, Hugh rewrote the description since it was measurably wrong.

Signed-off-by: Bo Liu <bo-liu@hotmail.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: stable@kernel.org
---

 mm/swapfile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- 2.6.32-rc5/mm/swapfile.c	2009-10-05 04:20:31.000000000 +0100
+++ linux/mm/swapfile.c	2009-10-28 19:31:43.000000000 +0000
@@ -1151,8 +1151,7 @@ static int try_to_unuse(unsigned int typ
 				} else
 					retval = unuse_mm(mm, entry, page);
 
-				if (set_start_mm &&
-				    swap_count(*swap_map) < swcount) {
+				if (set_start_mm && *swap_map < swcount) {
 					mmput(new_start_mm);
 					atomic_inc(&mm->mm_users);
 					new_start_mm = mm;
