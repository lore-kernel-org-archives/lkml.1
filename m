Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbYBSTyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbYBSTyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYBSTyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:54:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:51272 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYBSTyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:54:43 -0500
Date: Tue, 19 Feb 2008 13:51:37 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: davem@davemloft.net
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [PATCH v2][POWERPC] Fix initial lmb add region with a non-zero base
Message-ID: <Pine.LNX.4.64.0802191350590.10089@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we add to an empty lmb region with a non-zero base we will not coalesce
the number of regions down to one.  This causes problems on ppc32 for the
memory region as its assumed to only have one region.

We can fix this easily by causing the initial add to replace the dummy
region.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Fix a bug the initial patch introduced if we have a region that gets added
at the beginning of the list we wouldn't actually add it.

Dave can you replace the patch in you tree with this one.

 arch/powerpc/mm/lmb.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/mm/lmb.c b/arch/powerpc/mm/lmb.c
index 4ce23bc..4bf8f19 100644
--- a/arch/powerpc/mm/lmb.c
+++ b/arch/powerpc/mm/lmb.c
@@ -141,6 +141,12 @@ static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
 	unsigned long coalesced = 0;
 	long adjacent, i;

+	if ((rgn->cnt == 1) && (rgn->region[0].size == 0)) {
+		rgn->region[0].base = base;
+		rgn->region[0].size = size;
+		return 0;
+	}
+
 	/* First try and coalesce this LMB with another. */
 	for (i=0; i < rgn->cnt; i++) {
 		unsigned long rgnbase = rgn->region[i].base;
@@ -185,6 +191,12 @@ static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
 			break;
 		}
 	}
+
+	if (base < rgn->region[0].base) {
+		rgn->region[0].base = base;
+		rgn->region[0].size = size;
+	}
+
 	rgn->cnt++;

 	return 0;
-- 
1.5.3.8

