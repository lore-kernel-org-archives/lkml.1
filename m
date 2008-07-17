Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYGQNsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYGQNsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbYGQNsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:48:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:54182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbYGQNsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:48:07 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH] Re: cpufreq limits avilable frequencies to 800MHz on git kernel
Date: Thu, 17 Jul 2008 15:48:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, gnorton@novell.com,
       miguel@novell.com, "linux-acpi" <linux-acpi@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <200805231944.57320.arekm@maven.pl> <200805261815.40601.arekm@maven.pl> <200805261823.03140.arekm@maven.pl>
In-Reply-To: <200805261823.03140.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171548.04584.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

maybe I found something..., can someone review/test this.

Thanks,

         Thomas

------------
CPUFREQ ACPI: Only call _PPC after cpufreq ACPI init funcs got called already

Ingo Molnar provided a fix to not call _PPC at processor driver initialization 
time.
Git commit #e4233dec749a3519069d9390561b5636a75c7579

But it can still happen that _PPC is called at  processor driver 
initialization time.

This patch should make sure that this is not possible anymore.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 ++++++
 drivers/acpi/processor_perflib.c              |   13 ++++++++++++-
 drivers/cpufreq/cpufreq.c                     |    3 +++
 include/linux/cpufreq.h                       |    1 +
 4 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c 
b/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
index 69288f6..3233fe8 100644
--- a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
+++ b/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
@@ -96,6 +96,12 @@ static int pmi_notifier(struct notifier_block *nb,
 	struct cpufreq_frequency_table *cbe_freqs;
 	u8 node;
 
+	/* Should this really be called for CPUFREQ_ADJUST, CPUFREQ_INCOMPATIBLE
+	 * and CPUFREQ_NOTIFY policy events?)
+	 */
+	if (event == CPUFREQ_START)
+		return 0;
+
 	cbe_freqs = cpufreq_frequency_get_table(policy->cpu);
 	node = cbe_cpu_to_node(policy->cpu);
 
diff --git a/drivers/acpi/processor_perflib.c 
b/drivers/acpi/processor_perflib.c
index b474996..63ccf80 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -72,7 +72,13 @@ MODULE_PARM_DESC(ignore_ppc, "If the frequency of your 
machine gets wrongly" \
 #define PPC_REGISTERED   1
 #define PPC_IN_USE       2
 
-static int acpi_processor_ppc_status = 0;
+/* ignore_ppc:
+ * -1 -> cpufreq low level drivers not initialized -> _PSS, etc. not called 
yet
+ *       ignore _PPC
+ *  0 -> cpufreq low level drivers initialized -> consider _PPC values
+ *  1 -> ignore _PPC totally -> forced by user through boot param
+ */
+static int acpi_processor_ppc_status = -1;
 
 static int acpi_processor_ppc_notifier(struct notifier_block *nb,
 				       unsigned long event, void *data)
@@ -81,6 +87,11 @@ static int acpi_processor_ppc_notifier(struct 
notifier_block *nb,
 	struct acpi_processor *pr;
 	unsigned int ppc = 0;
 
+	if (event == CPUFREQ_START && ignore_ppc <= 0) {
+		ignore_ppc = 0;
+		return 0;
+	}
+
 	if (ignore_ppc)
 		return 0;
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1d41496..0471ef5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -825,6 +825,9 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	policy->user_policy.min = policy->cpuinfo.min_freq;
 	policy->user_policy.max = policy->cpuinfo.max_freq;
 
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+				     CPUFREQ_START, policy);
+
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index e7e91db..07cb761 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -109,6 +109,7 @@ struct cpufreq_policy {
 #define CPUFREQ_ADJUST		(0)
 #define CPUFREQ_INCOMPATIBLE	(1)
 #define CPUFREQ_NOTIFY		(2)
+#define CPUFREQ_START		(3)
 
 #define CPUFREQ_SHARED_TYPE_NONE (0) /* None */
 #define CPUFREQ_SHARED_TYPE_HW	 (1) /* HW does needed coordination */
-- 
1.5.4.5

