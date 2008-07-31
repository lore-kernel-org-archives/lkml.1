Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYGaA3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYGaA3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761319AbYGaA0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:26:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759585AbYGaA0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:26:36 -0400
Date: Wed, 30 Jul 2008 17:00:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Renninger <trenn@suse.de>,
       Andi Kleen <andi@firstfloor.org>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 59/62] cpufreq acpi: only call _PPC after cpufreq ACPI init
	funcs got called already
Message-ID: <20080731000005.GG12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Thomas Renninger <trenn@suse.de>

commit a1531acd43310a7e4571d52e8846640667f4c74b upstream

Ingo Molnar provided a fix to not call _PPC at processor driver
initialization time in "[PATCH] ACPI: fix cpufreq regression" (git
commit e4233dec749a3519069d9390561b5636a75c7579)

But it can still happen that _PPC is called at processor driver
initialization time.

This patch should make sure that this is not possible anymore.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 ++++++
 drivers/acpi/processor_perflib.c              |   15 +++++++++++++--
 drivers/cpufreq/cpufreq.c                     |    3 +++
 include/linux/cpufreq.h                       |    1 +
 4 files changed, 23 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
+++ b/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
@@ -96,6 +96,12 @@ static int pmi_notifier(struct notifier_
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
 
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -64,7 +64,13 @@ static DEFINE_MUTEX(performance_mutex);
  * policy is adjusted accordingly.
  */
 
-static unsigned int ignore_ppc = 0;
+/* ignore_ppc:
+ * -1 -> cpufreq low level drivers not initialized -> _PSS, etc. not called yet
+ *       ignore _PPC
+ *  0 -> cpufreq low level drivers initialized -> consider _PPC values
+ *  1 -> ignore _PPC totally -> forced by user through boot param
+ */
+static unsigned int ignore_ppc = -1;
 module_param(ignore_ppc, uint, 0644);
 MODULE_PARM_DESC(ignore_ppc, "If the frequency of your machine gets wrongly" \
 		 "limited by BIOS, this should help");
@@ -72,7 +78,7 @@ MODULE_PARM_DESC(ignore_ppc, "If the fre
 #define PPC_REGISTERED   1
 #define PPC_IN_USE       2
 
-static int acpi_processor_ppc_status = 0;
+static int acpi_processor_ppc_status;
 
 static int acpi_processor_ppc_notifier(struct notifier_block *nb,
 				       unsigned long event, void *data)
@@ -81,6 +87,11 @@ static int acpi_processor_ppc_notifier(s
 	struct acpi_processor *pr;
 	unsigned int ppc = 0;
 
+	if (event == CPUFREQ_START && ignore_ppc <= 0) {
+		ignore_ppc = 0;
+		return 0;
+	}
+
 	if (ignore_ppc)
 		return 0;
 
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -825,6 +825,9 @@ static int cpufreq_add_dev(struct sys_de
 	policy->user_policy.min = policy->cpuinfo.min_freq;
 	policy->user_policy.max = policy->cpuinfo.max_freq;
 
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+				     CPUFREQ_START, policy);
+
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
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
