Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbXBNWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbXBNWlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXBNWlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:41:20 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:20785 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbXBNWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:41:19 -0500
X-IronPort-AV: i="4.14,170,1170662400"; 
   d="scan'208"; a="360987220:sNHT155380548"
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org,
       "Hugh Dickins <hugh@veritas.com> Andrew Morton" 
	<akpm@linux-foundation.org>,
       "Torvalds@linux-foundation.org Torvalds" 
	<torvalds@linux-foundation.org>
Subject: CONFIG_SWAP=n broken in latest tree
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Feb 2007 14:41:05 -0800
Message-ID: <adak5ykz7jy.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2007 22:41:07.0819 (UTC) FILETIME=[37AD3BB0:01C75089]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 42da9cbd ("mm: mincore anon") breaks CONFIG_SWAP=n builds with:

    mm/built-in.o: In function `sys_mincore':
    (.text+0xe2c4): undefined reference to `swapper_space'

because swapper_space is used unconditionally in mm/mincore.c but only
defined in swap_state.c, which isn't built if CONFIG_SWAP=n.

I'd include a patch but I'm not sure what the right fix is really --
the naively obvious thing to do would be to add an #ifdef to mincore.c
like the below, but I don't know this area at all well enough to be
confident in the fix.

diff --git a/mm/mincore.c b/mm/mincore.c
index 95c5f49..266506f 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -109,8 +109,9 @@ static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pag
 		} else if (pte_file(pte)) {
 			pgoff = pte_to_pgoff(pte);
 			present = mincore_page(vma->vm_file->f_mapping, pgoff);
-
-		} else { /* pte is a swap entry */
+		}
+#ifdef CONFIG_SWAP
+		else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 			if (is_migration_entry(entry)) {
 				/* migration entries are always uptodate */
@@ -120,6 +121,7 @@ static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pag
 				present = mincore_page(&swapper_space, pgoff);
 			}
 		}
+#endif /* CONFIG_SWAP */
 	}
 	pte_unmap_unlock(ptep-1, ptl);
 
