Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZLDWl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZLDWl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZLDWl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:41:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbZLDWlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:41:25 -0500
Message-ID: <4B199060.1060604@gmail.com>
Date: Fri, 04 Dec 2009 23:42:40 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/31] Constify struct platform_hibernation_ops for 2.6.32
 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct platform_hibernation_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/acpi/sleep.c     |    4 ++--
 include/linux/suspend.h  |   24 ++++++++++++------------
 kernel/power/hibernate.c |    4 ++--
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 5f2c379..3f5957a 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -552,7 +552,7 @@ static void acpi_pm_enable_gpes(void)
 	acpi_enable_all_runtime_gpes();
 }
 
-static struct platform_hibernation_ops acpi_hibernation_ops = {
+static const struct platform_hibernation_ops acpi_hibernation_ops = {
 	.begin = acpi_hibernation_begin,
 	.end = acpi_pm_end,
 	.pre_snapshot = acpi_hibernation_pre_snapshot,
@@ -605,7 +605,7 @@ static int acpi_hibernation_pre_snapshot_old(void)
  * The following callbacks are used if the pre-ACPI 2.0 suspend ordering has
  * been requested.
  */
-static struct platform_hibernation_ops acpi_hibernation_ops_old = {
+static const struct platform_hibernation_ops acpi_hibernation_ops_old = {
 	.begin = acpi_hibernation_begin_old,
 	.end = acpi_pm_end,
 	.pre_snapshot = acpi_hibernation_pre_snapshot_old,
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5e781d8..cb4cc7d 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -215,16 +215,16 @@ extern void mark_free_pages(struct zone *zone);
  *	platforms which require special recovery actions in that situation.
  */
 struct platform_hibernation_ops {
-	int (*begin)(void);
-	void (*end)(void);
-	int (*pre_snapshot)(void);
-	void (*finish)(void);
-	int (*prepare)(void);
-	int (*enter)(void);
-	void (*leave)(void);
-	int (*pre_restore)(void);
-	void (*restore_cleanup)(void);
-	void (*recover)(void);
+	int (* const begin)(void);
+	void (* const end)(void);
+	int (* const pre_snapshot)(void);
+	void (* const finish)(void);
+	int (* const prepare)(void);
+	int (* const enter)(void);
+	void (* const leave)(void);
+	int (* const pre_restore)(void);
+	void (* const restore_cleanup)(void);
+	void (* const recover)(void);
 };
 
 #ifdef CONFIG_HIBERNATION
@@ -243,7 +243,7 @@ extern void swsusp_set_page_free(struct page *);
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
+extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
 #else /* CONFIG_HIBERNATION */
@@ -251,7 +251,7 @@ static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
-static inline void hibernation_set_ops(struct platform_hibernation_ops *ops) {}
+static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 04a9e90..bc355aa 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -48,14 +48,14 @@ enum {
 
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
-static struct platform_hibernation_ops *hibernation_ops;
+static const struct platform_hibernation_ops *hibernation_ops;
 
 /**
  * hibernation_set_ops - set the global hibernate operations
  * @ops: the hibernation operations to use in subsequent hibernation transitions
  */
 
-void hibernation_set_ops(struct platform_hibernation_ops *ops)
+void hibernation_set_ops(const struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->begin && ops->end &&  ops->pre_snapshot
 	    && ops->prepare && ops->finish && ops->enter && ops->pre_restore

