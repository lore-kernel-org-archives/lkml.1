Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbZKYVlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbZKYVlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbZKYVlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:41:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58047 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbZKYVjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:08 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] Blackfin: work around testset anomaly 05000477
Date: Wed, 25 Nov 2009 16:39:03 -0500
Message-Id: <1259185147-31999-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
References: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ironically, the atomic testset instruction cannot be interrupted else it
will produce incorrect results.  So disable interrupts to help it out.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf561/atomic.S |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf561/atomic.S b/arch/blackfin/mach-bf561/atomic.S
index 0261a5e..f99f174 100644
--- a/arch/blackfin/mach-bf561/atomic.S
+++ b/arch/blackfin/mach-bf561/atomic.S
@@ -19,6 +19,16 @@
 	\reg\().h = _corelock;
 .endm
 
+.macro safe_testset addr:req, scratch:req
+#if ANOMALY_05000477
+	cli \scratch;
+	testset (\addr);
+	sti \scratch;
+#else
+	testset (\addr);
+#endif
+.endm
+
 /*
  * r0 = address of atomic data to flush and invalidate (32bit).
  *
@@ -33,7 +43,7 @@ ENTRY(_get_core_lock)
 	cli r0;
 	coreslot_loadaddr p0;
 .Lretry_corelock:
-	testset (p0);
+	safe_testset p0, r2;
 	if cc jump .Ldone_corelock;
 	SSYNC(r2);
 	jump .Lretry_corelock
@@ -56,7 +66,7 @@ ENTRY(_get_core_lock_noflush)
 	cli r0;
 	coreslot_loadaddr p0;
 .Lretry_corelock_noflush:
-	testset (p0);
+	safe_testset p0, r2;
 	if cc jump .Ldone_corelock_noflush;
 	SSYNC(r2);
 	jump .Lretry_corelock_noflush
-- 
1.6.5.3

