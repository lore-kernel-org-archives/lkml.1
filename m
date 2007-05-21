Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbXEUKP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbXEUKP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761952AbXEUKJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:36 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:4457 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761266AbXEUKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:18 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510267:sNHT35131166"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 01/32] Blackfin arch: Add Workaround for ANOMALY 05000257
Date: Mon, 21 May 2007 18:09:09 +0800
Message-Id: <11797421812662-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/lib/ins.S           |   20 ++++++++++++++------
 arch/blackfin/mach-common/entry.S |    6 ++++++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/lib/ins.S b/arch/blackfin/lib/ins.S
index 730d2b4..7d5e984 100644
--- a/arch/blackfin/lib/ins.S
+++ b/arch/blackfin/lib/ins.S
@@ -29,6 +29,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/blackfin.h>
 
 .align 2
 
@@ -39,11 +40,14 @@ ENTRY(_insl)
 	P2 = R2;	/* P2 = count */
 	SSYNC;
 	LSETUP( .Llong_loop_s, .Llong_loop_e) LC0 = P2;
-.Llong_loop_s: R0 = [P0];
-.Llong_loop_e: [P1++] = R0;
+.Llong_loop_s:  R0 = [P0];
+		[P1++] = R0;
+		NOP;
+.Llong_loop_e: 	NOP;
 	sti R3;
 	RTS;
 
+
 ENTRY(_insw)
 	P0 = R0;	/* P0 = port */
 	cli R3;
@@ -51,8 +55,10 @@ ENTRY(_insw)
 	P2 = R2;	/* P2 = count */
 	SSYNC;
 	LSETUP( .Lword_loop_s, .Lword_loop_e) LC0 = P2;
-.Lword_loop_s: R0 = W[P0];
-.Lword_loop_e: W[P1++] = R0;
+.Lword_loop_s:  R0 = W[P0];
+		W[P1++] = R0;
+		NOP;
+.Lword_loop_e: 	NOP;
 	sti R3;
 	RTS;
 
@@ -63,7 +69,9 @@ ENTRY(_insb)
 	P2 = R2;	/* P2 = count */
 	SSYNC;
 	LSETUP( .Lbyte_loop_s, .Lbyte_loop_e) LC0 = P2;
-.Lbyte_loop_s: R0 = B[P0];
-.Lbyte_loop_e: B[P1++] = R0;
+.Lbyte_loop_s:  R0 = B[P0];
+		B[P1++] = R0;
+		NOP;
+.Lbyte_loop_e:  NOP;
 	sti R3;
 	RTS;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 8eb0a90..e463733 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -181,6 +181,12 @@ ENTRY(_ex_single_step)
 
 _return_from_exception:
 	DEBUG_START_HWTRACE
+#ifdef ANOMALY_05000257
+	R7=LC0;
+	LC0=R7;
+	R7=LC1;
+	LC1=R7;
+#endif
 	(R7:6,P5:4) = [sp++];
 	ASTAT = [sp++];
 	sp = retn;
-- 
1.5.1.2
