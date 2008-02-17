Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYBQM2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYBQM2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbYBQMXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:16 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38367 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbYBQMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH 15/27] cpufreq: fix section mismatch warnings
Date: Sun, 17 Feb 2008 13:22:52 +0100
Message-Id: <1203250984-11285-15-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings:
WARNING: vmlinux.o(.text+0xfe6711): Section mismatch in reference from the function cpufreq_unregister_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
WARNING: vmlinux.o(.text+0xfe68af): Section mismatch in reference from the function cpufreq_register_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
WARNING: vmlinux.o(.exit.text+0xc4fa): Section mismatch in reference from the function cpufreq_stats_exit() to the variable .cpuinit.data:cpufreq_stat_cpu_notifier

The warnings were casued by references to unregister_hotcpu_notifier()
from normal functions or exit functions.
This is flagged by modpost as a potential error because
it does not know that for the non HOTPLUG_CPU
scenario the unregister_hotcpu_notifier() is a nop.
Silence the warning by replacing the __initdata
annotation with a __refdata annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
---
 drivers/cpufreq/cpufreq.c       |    2 +-
 drivers/cpufreq/cpufreq_stats.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 64926aa..c45768a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1783,7 +1783,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpufreq_cpu_notifier =
+static struct notifier_block __refdata cpufreq_cpu_notifier =
 {
     .notifier_call = cpufreq_cpu_callback,
 };
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 1b8312b..070421a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -323,7 +323,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpufreq_stat_cpu_notifier __cpuinitdata =
+static struct notifier_block cpufreq_stat_cpu_notifier __refdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
 };
-- 
1.5.4.rc3.14.g44397

