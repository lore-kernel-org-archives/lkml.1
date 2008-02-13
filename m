Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbYBMNk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbYBMNk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYBMNkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:40:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:54985 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYBMNkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:40:19 -0500
Date: Wed, 13 Feb 2008 07:37:27 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linuxppc-dev@ozlabs.org
cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: [PATCH] [POWERPC] Fix initial lmb add region with a non-zero base
Message-ID: <Pine.LNX.4.64.0802130719330.14428@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we add to an empty lmb region with a non-zero base we will not coalesce
the number of regions done to one.  This causes problems on ppc32 for the
memory region as its assumed to only have one region.

We can fix this be easily specially casing the initial add to just replace
the dummy region.

---

Posting this since Dave's looking a pulling the lmb code out into lib/ and
sharing it between powerpc and sparc.

(this is my git tree git.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git)

- k

 arch/powerpc/mm/lmb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/mm/lmb.c b/arch/powerpc/mm/lmb.c
index 4ce23bc..1ea8df0 100644
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
-- 
1.5.3.8

