Return-Path: <linux-kernel-owner+w=401wt.eu-S1761088AbXKILM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761088AbXKILM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 06:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbXKILMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 06:12:17 -0500
Received: from smtp27.orange.fr ([80.12.242.95]:53548 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbXKILMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 06:12:15 -0500
X-ME-UUID: 20071109111212770.BC0F61C00093@mwinf2714.orange.fr
Date: Fri, 9 Nov 2007 12:07:25 +0100
From: Philippe Elie <phil.el@wanadoo.fr>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Barry Kasindorf <barry.kasindorf@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oProfile: support for AMD family10
Message-ID: <20071109110725.GA2890@zaniah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Kasindorf <barry.kasindorf@amd.com>

oProfile Driver Module Patch for AMD Family10h Kernel 2.6.23
This patch is for controlling the upper 32bits of the event ctrl msrs.
This includes the upper 4 bits of the event select and the Guest Only
and Host Only bits
This patch is necessary to make Event Based Profiling work reliably on a
Family10h processor

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Philippe Elie <phil.el@wanadoo.fr>

---

 arch/x86/oprofile/op_model_athlon.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

Patch originally sent here: http://marc.info/?l=linux-kernel&m=119247216420600&w=2 but it didn't apply cleanly, this one only change spacing.


diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 3057a19..068541d 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -1,6 +1,6 @@
 /**
  * @file op_model_athlon.h
- * athlon / K7 model-specific MSR operations
+ * athlon / K7 / K8 / Family 10h model-specific MSR operations
  *
  * @remark Copyright 2002 OProfile authors
  * @remark Read the file COPYING
@@ -31,12 +31,16 @@
 #define CTRL_WRITE(l,h,msrs,c) do {wrmsr(msrs->controls[(c)].addr, (l), (h));} while (0)
 #define CTRL_SET_ACTIVE(n) (n |= (1<<22))
 #define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR(x) (x &= (1<<21))
+#define CTRL_CLEAR_LO(x) (x &= (1<<21))
+#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
 #define CTRL_SET_ENABLE(val) (val |= 1<<20)
 #define CTRL_SET_USR(val,u) (val |= ((u & 1) << 16))
 #define CTRL_SET_KERN(val,k) (val |= ((k & 1) << 17))
 #define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT(val, e) (val |= e)
+#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
+#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
+#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
 static unsigned long reset_value[NUM_COUNTERS];
  
@@ -70,7 +74,8 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
 			continue;
 		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR(low);
+		CTRL_CLEAR_LO(low);
+		CTRL_CLEAR_HI(high);
 		CTRL_WRITE(low, high, msrs, i);
 	}
 
@@ -89,12 +94,17 @@ static void athlon_setup_ctrs(struct op_msrs const * const msrs)
 			CTR_WRITE(counter_config[i].count, msrs, i);
 
 			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR(low);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
 			CTRL_SET_ENABLE(low);
 			CTRL_SET_USR(low, counter_config[i].user);
 			CTRL_SET_KERN(low, counter_config[i].kernel);
 			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT(low, counter_config[i].event);
+			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+
 			CTRL_WRITE(low, high, msrs, i);
 		} else {
 			reset_value[i] = 0;

