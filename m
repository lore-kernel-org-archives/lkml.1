Return-Path: <linux-kernel-owner+w=401wt.eu-S933959AbYBNBLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbYBNBLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934267AbYBNBKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:10:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43584
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934198AbYBNBKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:10:19 -0500
Date: Wed, 13 Feb 2008 17:10:50 -0800 (PST)
Message-Id: <20080213.171050.183740061.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4]: [LMB]: Fix initial lmb add region with a non-zero base
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[LMB]: Fix initial lmb add region with a non-zero base

If we add to an empty lmb region with a non-zero base we will not
coalesce the number of regions down to one.  This causes problems on
ppc32 for the memory region as its assumed to only have one region.

We can fix this be easily specially casing the initial add to just
replace the dummy region.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 lib/lmb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index 6390d63..e34a9e5 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -134,6 +134,12 @@ static long __init lmb_add_region(struct lmb_region *rgn, unsigned long base,
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
-- 
1.5.4.29.gb828fe

