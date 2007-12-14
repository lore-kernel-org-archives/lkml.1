Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbXLNNqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbXLNNqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXLNNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:46:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56751 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXLNNqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:46:13 -0500
Date: Fri, 14 Dec 2007 13:45:48 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam@infradead.org>, David Jones <davej@redhat.com>
Subject: [PATCH] Don't mark cpufreq_stats_free_table with __cpuexit
Message-ID: <20071214134548.GA15149@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 55395ae72b6e5ae614d28df74158c47454652583 introduced:

`.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

Never mark functions that may be called during run time or
initialisation time with a section that may be (or have been)
discarded.

It was mentioned in the commit comments that an exit-section function
was being called from an init-section function.  This should _always_
result in the patch being rejected.  It's just a big no no.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 8a45d0f..bf5f780 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -164,7 +164,8 @@ freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 	return -1;
 }
 
-static void __cpuexit cpufreq_stats_free_table(unsigned int cpu)
+/* functions called from init paths can not be marked for an exit section */
+static void /*__cpuexit*/ cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = cpufreq_stats_table[cpu];
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
