Return-Path: <linux-kernel-owner+w=401wt.eu-S935236AbYBNBLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935236AbYBNBLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934920AbYBNBKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:10:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43582
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935151AbYBNBKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:10:03 -0500
Date: Wed, 13 Feb 2008 17:10:35 -0800 (PST)
Message-Id: <20080213.171035.249149650.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4]: [LMB]: Fix bug in __lmb_alloc_base().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[LMB]: Fix bug in __lmb_alloc_base().

We need to check lmb_add_region() for errors, it can run out
of regions etc.

Also, the size needs to be padded to the given alignment
or else the lmb.reserved regions don't get expanded and
instead we get tons of holes and eventually run out of
regions prematurely.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 lib/lmb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index 98078b4..6390d63 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -245,6 +245,11 @@ static unsigned long lmb_align_down(unsigned long addr, unsigned long size)
 	return addr & ~(size - 1);
 }
 
+static unsigned long lmb_align_up(unsigned long addr, unsigned long size)
+{
+	return (addr + (size - 1)) & ~(size - 1);
+}
+
 unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
 				    unsigned long max_addr)
 {
@@ -281,7 +286,8 @@ unsigned long __init __lmb_alloc_base(unsigned long size, unsigned long align,
 	if (i < 0)
 		return 0;
 
-	lmb_add_region(&lmb.reserved, base, size);
+	if (lmb_add_region(&lmb.reserved, base, lmb_align_up(size, align)) < 0)
+		return 0;
 
 	return base;
 }
-- 
1.5.4.29.gb828fe

