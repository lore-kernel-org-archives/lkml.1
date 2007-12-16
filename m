Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbXLPVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbXLPVWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbXLPVWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:22:23 -0500
Received: from saeurebad.de ([85.214.36.134]:33849 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbXLPVWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:22:22 -0500
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH] cpufreq: Default governor initialisation before use
Date: Sun, 16 Dec 2007 22:20:48 +0100
Message-ID: <x78x3u2v67.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the selected default cpufreq governor is initialised before
used by the cpufreq driver on boot by using fs_initcall() instead of
module_init().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
On boot, speedstep_init() calls into cpufreq_gov_dbs().  The driver has
not yet been initialised by cpufreq_gov_dbs_init() and kondemand_wq is
still NULL when it is dereferenced.

Changing the drivers module_init() to fs_initcall() fixed it.  The same
is already done in the performance and userspace governor drivers.

The patch migrates all governors to use fs_initcall() when being the
default governor.

 drivers/cpufreq/cpufreq_conservative.c |    4 ++++
 drivers/cpufreq/cpufreq_ondemand.c     |    5 ++++-
 drivers/cpufreq/cpufreq_performance.c  |    4 ++++
 drivers/cpufreq/cpufreq_userspace.c    |    4 ++++
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 1bba997..5d3a04b 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -603,5 +603,9 @@ MODULE_DESCRIPTION ("'cpufreq_conservative' - A dynamic cpufreq governor for "
 		"optimised for use in a battery environment");
 MODULE_LICENSE ("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+fs_initcall(cpufreq_gov_dbs_init);
+#else
 module_init(cpufreq_gov_dbs_init);
+#endif
 module_exit(cpufreq_gov_dbs_exit);
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 369f445..d2af20d 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -610,6 +610,9 @@ MODULE_DESCRIPTION("'cpufreq_ondemand' - A dynamic cpufreq governor for "
                    "Low Latency Frequency Transition capable processors");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
+fs_initcall(cpufreq_gov_dbs_init);
+#else
 module_init(cpufreq_gov_dbs_init);
+#endif
 module_exit(cpufreq_gov_dbs_exit);
-
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index e8e1451..df5fca3 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -60,5 +60,9 @@ MODULE_AUTHOR("Dominik Brodowski <linux@brodo.de>");
 MODULE_DESCRIPTION("CPUfreq policy governor 'performance'");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 fs_initcall(cpufreq_gov_performance_init);
+#else
+module_init(cpufreq_gov_performance_init);
+#endif
 module_exit(cpufreq_gov_performance_exit);
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 51bedab..f8cdde4 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -231,5 +231,9 @@ MODULE_AUTHOR ("Dominik Brodowski <linux@brodo.de>, Russell King <rmk@arm.linux.
 MODULE_DESCRIPTION ("CPUfreq policy governor 'userspace'");
 MODULE_LICENSE ("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
 fs_initcall(cpufreq_gov_userspace_init);
+#else
+module_init(cpufreq_gov_userspace_init);
+#endif
 module_exit(cpufreq_gov_userspace_exit);
