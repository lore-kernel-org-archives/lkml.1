Return-Path: <linux-kernel-owner+w=401wt.eu-S1765092AbYDOPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765092AbYDOPCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761376AbYDOPCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:02:04 -0400
Received: from saeurebad.de ([85.214.36.134]:58524 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYDOPCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:02:03 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Johannes Weiner <hannes@saeurebad.de>, Roel Kluin <12o3l@tiscali.nl>,
       Andreas Schwab <schwab@suse.de>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: Fix possible off-by-one in walk_pte_range()
Date: Tue, 15 Apr 2008 16:00:40 +0200
Message-Id: <12082680403770-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.2.2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the loop in walk_pte_range() pte might point to the first address
after the pmd it walks.  The pte_unmap() is then applied to something
bad.

Spotted by Roel Kluin and Andreas Schwab.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Roel Kluin <12o3l@tiscali.nl>
CC: Andreas Schwab <schwab@suse.de>
CC: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---

A bug is unlikely, though.  kunmap_atomic() looks up the kmap entry by
map-type instead of the address the pte points.  So the worst thing I
could find with a quick grep was that a wrong TLB entry is being
flushed.  Still, the code is wrong :)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 1cf1417..cf3c004 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -13,7 +13,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		err = walk->pte_entry(pte, addr, addr + PAGE_SIZE, private);
 		if (err)
 		       break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	} while (addr += PAGE_SIZE, addr != end && pte++);
 
 	pte_unmap(pte);
 	return err;
