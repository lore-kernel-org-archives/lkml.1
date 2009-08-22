Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbZHVAII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbZHVAII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 20:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbZHVAIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 20:08:07 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7423 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbZHVAIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:08:04 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh203h65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KOR4D8-01-0LX-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: [PATCH][cpufreq] Powernow: Enable more than 2 low P-states
Date: Fri, 21 Aug 2009 19:15:28 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200908211915.28162.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 22 Aug 2009 00:07:57.0330 (UTC) FILETIME=[9A69C720:01CA22BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an obsolete check that used to prevent there being more
than 2 low P-states.  Now that low-to-low P-states changes are
enabled, it prevents otherwise workable configurations with
multiple low P-states.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Tested-by: Krists Krilovs <pow@pow.za.net>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   29 ++++-------------------------
 1 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 2a50ef8..0cbce04 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -854,6 +854,10 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 		goto err_out;
 	}
 
+	/* fill in data */
+	data->numps = data->acpi_data.state_count;
+	powernow_k8_acpi_pst_values(data, 0);
+
 	if (cpu_family == CPU_HW_PSTATE)
 		ret_val = fill_powernow_table_pstate(data, powernow_table);
 	else
@@ -866,11 +870,8 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 	powernow_table[data->acpi_data.state_count].index = 0;
 	data->powernow_table = powernow_table;
 
-	/* fill in data */
-	data->numps = data->acpi_data.state_count;
 	if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
 		print_basics(data);
-	powernow_k8_acpi_pst_values(data, 0);
 
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
@@ -941,7 +942,6 @@ static int fill_powernow_table_fidvid(struct powernow_k8_data *data,
 		struct cpufreq_frequency_table *powernow_table)
 {
 	int i;
-	int cntlofreq = 0;
 
 	for (i = 0; i < data->acpi_data.state_count; i++) {
 		u32 fid;
@@ -982,27 +982,6 @@ static int fill_powernow_table_fidvid(struct powernow_k8_data *data,
 			continue;
 		}
 
-		/* verify only 1 entry from the lo frequency table */
-		if (fid < HI_FID_TABLE_BOTTOM) {
-			if (cntlofreq) {
-				/* if both entries are the same,
-				 * ignore this one ... */
-				if ((freq != powernow_table[cntlofreq].frequency) ||
-				    (index != powernow_table[cntlofreq].index)) {
-					printk(KERN_ERR PFX
-						"Too many lo freq table "
-						"entries\n");
-					return 1;
-				}
-
-				dprintk("double low frequency table entry, "
-						"ignoring it.\n");
-				invalidate_entry(data, i);
-				continue;
-			} else
-				cntlofreq = i;
-		}
-
 		if (freq != (data->acpi_data.states[i].core_frequency * 1000)) {
 			printk(KERN_INFO PFX "invalid freq entries "
 				"%u kHz vs. %u kHz\n", freq,

