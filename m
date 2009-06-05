Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbZFEIUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbZFEIUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbZFEIGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37478 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbZFEIGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 42/62] Blackfin: update gptimers API
Date: Fri,  5 Jun 2009 04:04:51 -0400
Message-Id: <1244189111-19639-43-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

First we fix the prototypes for functions that return boolean values by
using "int" rather than "uint16_t".  Then we introduce a get_gptimer_run()
function for checking the current run status of a timer, and then we add a
disable_gptimers_sync() function which parallels disable_gptimers() with
corresponding normal "_sync" behavior.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/gptimers.h |   43 +++++++++++++++++++---------------
 arch/blackfin/kernel/gptimers.c      |   30 +++++++++++++++++++----
 2 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/arch/blackfin/include/asm/gptimers.h b/arch/blackfin/include/asm/gptimers.h
index b0f847a..89f08de 100644
--- a/arch/blackfin/include/asm/gptimers.h
+++ b/arch/blackfin/include/asm/gptimers.h
@@ -30,6 +30,7 @@
 # else
 #  define MAX_BLACKFIN_GPTIMERS 11
 #  define TIMER8_GROUP_REG      TIMER_ENABLE1
+#  define TIMER_GROUP2          1
 # endif
 # define TIMER0_GROUP_REG       TIMER_ENABLE0
 #endif
@@ -40,10 +41,12 @@
 # define MAX_BLACKFIN_GPTIMERS 12
 # define TIMER0_GROUP_REG      TMRS8_ENABLE
 # define TIMER8_GROUP_REG      TMRS4_ENABLE
+# define TIMER_GROUP2          1
 #endif
 /*
  * All others: 3 timers:
  */
+#define TIMER_GROUP1           0
 #if !defined(MAX_BLACKFIN_GPTIMERS)
 # define MAX_BLACKFIN_GPTIMERS 3
 # define TIMER0_GROUP_REG      TIMER_ENABLE
@@ -109,8 +112,8 @@
 #define TIMER_ERR_PROG_PER  0x8000
 #define TIMER_ERR_PROG_PW   0xC000
 #define TIMER_EMU_RUN       0x0200
-#define	TIMER_TOGGLE_HI     0x0100
-#define	TIMER_CLK_SEL       0x0080
+#define TIMER_TOGGLE_HI     0x0100
+#define TIMER_CLK_SEL       0x0080
 #define TIMER_OUT_DIS       0x0040
 #define TIMER_TIN_SEL       0x0020
 #define TIMER_IRQ_ENA       0x0010
@@ -169,23 +172,25 @@
 
 /* The actual gptimer API */
 
-void     set_gptimer_pwidth    (int timer_id, uint32_t width);
-uint32_t get_gptimer_pwidth    (int timer_id);
-void     set_gptimer_period    (int timer_id, uint32_t period);
-uint32_t get_gptimer_period    (int timer_id);
-uint32_t get_gptimer_count     (int timer_id);
-uint16_t get_gptimer_intr      (int timer_id);
-void     clear_gptimer_intr    (int timer_id);
-uint16_t get_gptimer_over      (int timer_id);
-void     clear_gptimer_over    (int timer_id);
-void     set_gptimer_config    (int timer_id, uint16_t config);
-uint16_t get_gptimer_config    (int timer_id);
-void     set_gptimer_pulse_hi  (int timer_id);
+void     set_gptimer_pwidth(int timer_id, uint32_t width);
+uint32_t get_gptimer_pwidth(int timer_id);
+void     set_gptimer_period(int timer_id, uint32_t period);
+uint32_t get_gptimer_period(int timer_id);
+uint32_t get_gptimer_count(int timer_id);
+int      get_gptimer_intr(int timer_id);
+void     clear_gptimer_intr(int timer_id);
+int      get_gptimer_over(int timer_id);
+void     clear_gptimer_over(int timer_id);
+void     set_gptimer_config(int timer_id, uint16_t config);
+uint16_t get_gptimer_config(int timer_id);
+int      get_gptimer_run(int timer_id);
+void     set_gptimer_pulse_hi(int timer_id);
 void     clear_gptimer_pulse_hi(int timer_id);
-void     enable_gptimers       (uint16_t mask);
-void     disable_gptimers      (uint16_t mask);
-uint16_t get_enabled_gptimers  (void);
-uint32_t get_gptimer_status    (int group);
-void     set_gptimer_status    (int group, uint32_t value);
+void     enable_gptimers(uint16_t mask);
+void     disable_gptimers(uint16_t mask);
+void     disable_gptimers_sync(uint16_t mask);
+uint16_t get_enabled_gptimers(void);
+uint32_t get_gptimer_status(int group);
+void     set_gptimer_status(int group, uint32_t value);
 
 #endif
diff --git a/arch/blackfin/kernel/gptimers.c b/arch/blackfin/kernel/gptimers.c
index 3a3e961..7281a91 100644
--- a/arch/blackfin/kernel/gptimers.c
+++ b/arch/blackfin/kernel/gptimers.c
@@ -189,10 +189,10 @@ void set_gptimer_status(int group, uint32_t value)
 }
 EXPORT_SYMBOL(set_gptimer_status);
 
-uint16_t get_gptimer_intr(int timer_id)
+int get_gptimer_intr(int timer_id)
 {
 	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
-	return (group_regs[BFIN_TIMER_OCTET(timer_id)]->status & timil_mask[timer_id]) ? 1 : 0;
+	return !!(group_regs[BFIN_TIMER_OCTET(timer_id)]->status & timil_mask[timer_id]);
 }
 EXPORT_SYMBOL(get_gptimer_intr);
 
@@ -203,10 +203,10 @@ void clear_gptimer_intr(int timer_id)
 }
 EXPORT_SYMBOL(clear_gptimer_intr);
 
-uint16_t get_gptimer_over(int timer_id)
+int get_gptimer_over(int timer_id)
 {
 	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
-	return (group_regs[BFIN_TIMER_OCTET(timer_id)]->status & tovf_mask[timer_id]) ? 1 : 0;
+	return !!(group_regs[BFIN_TIMER_OCTET(timer_id)]->status & tovf_mask[timer_id]);
 }
 EXPORT_SYMBOL(get_gptimer_over);
 
@@ -217,6 +217,13 @@ void clear_gptimer_over(int timer_id)
 }
 EXPORT_SYMBOL(clear_gptimer_over);
 
+int get_gptimer_run(int timer_id)
+{
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	return !!(group_regs[BFIN_TIMER_OCTET(timer_id)]->status & trun_mask[timer_id]);
+}
+EXPORT_SYMBOL(get_gptimer_run);
+
 void set_gptimer_config(int timer_id, uint16_t config)
 {
 	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
@@ -244,7 +251,7 @@ void enable_gptimers(uint16_t mask)
 }
 EXPORT_SYMBOL(enable_gptimers);
 
-void disable_gptimers(uint16_t mask)
+static void _disable_gptimers(uint16_t mask)
 {
 	int i;
 	uint16_t m = mask;
@@ -253,6 +260,12 @@ void disable_gptimers(uint16_t mask)
 		group_regs[i]->disable = m & 0xFF;
 		m >>= 8;
 	}
+}
+
+void disable_gptimers(uint16_t mask)
+{
+	int i;
+	_disable_gptimers(mask);
 	for (i = 0; i < MAX_BLACKFIN_GPTIMERS; ++i)
 		if (mask & (1 << i))
 			group_regs[BFIN_TIMER_OCTET(i)]->status |= trun_mask[i];
@@ -260,6 +273,13 @@ void disable_gptimers(uint16_t mask)
 }
 EXPORT_SYMBOL(disable_gptimers);
 
+void disable_gptimers_sync(uint16_t mask)
+{
+	_disable_gptimers(mask);
+	SSYNC();
+}
+EXPORT_SYMBOL(disable_gptimers_sync);
+
 void set_gptimer_pulse_hi(int timer_id)
 {
 	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
-- 
1.6.3.1

