Return-Path: <linux-kernel-owner+w=401wt.eu-S933708AbZGQAFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbZGQAFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbZGQAFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39114 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933681AbZGQAFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 04/21] Blackfin: work around anomaly 05000281
Date: Thu, 16 Jul 2009 20:05:29 -0400
Message-Id: <1247789146-18786-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Add missing anomaly workaround for anomaly 05000281 - we can't return to
instructions which cause hardware errors otherwise we trigger the error
again which means we go into an infinite loop of handling, returning, and
retriggering.  This work around confuses gdb when the error occurs as the
PC will seemed to have moved, so a better long term fix will need to be
figured out, but for now this is better than an infinite crash loop.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 8a1caf2..664de56 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -619,7 +619,8 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		force_sig_info(sig, &info, current);
 	}
 
-	if (ANOMALY_05000461 && trapnr == VEC_HWERR && !access_ok(VERIFY_READ, fp->pc, 8))
+	if ((ANOMALY_05000461 && trapnr == VEC_HWERR && !access_ok(VERIFY_READ, fp->pc, 8)) ||
+		(ANOMALY_05000281 && trapnr == VEC_HWERR))
 		fp->pc = SAFE_USER_INSTRUCTION;
 
  traps_done:
-- 
1.6.3.3

