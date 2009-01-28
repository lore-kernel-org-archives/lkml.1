Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZA2AEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZA2AEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZA1XpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:53007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758620AbZA1XpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:11 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 052/114] x86, smp: clean up mps_oem_check()
Date: Wed, 28 Jan 2009 23:41:58 +0000
Message-Id: <1233186180-29883-53-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

 - allow NULL ->mps_oem_check() entries

 - clean up the code flow

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h |    3 +--
 arch/x86/mach-generic/probe.c  |   22 +++++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 14b19de..8bb1c73 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -55,8 +55,7 @@ struct genapic {
 	 * is switched to this. Essentially they are additional
 	 * probe functions:
 	 */
-	int (*mps_oem_check)(struct mpc_table *mpc, char *oem,
-			     char *productid);
+	int (*mps_oem_check)(struct mpc_table *mpc, char *oem, char *productid);
 
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index a21e2b1..799a70f 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -113,17 +113,21 @@ void __init generic_apic_probe(void)
 int __init mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	int i;
+
 	for (i = 0; apic_probe[i]; ++i) {
-		if (apic_probe[i]->mps_oem_check(mpc, oem, productid)) {
-			if (!cmdline_apic) {
-				apic = apic_probe[i];
-				if (x86_quirks->update_genapic)
-					x86_quirks->update_genapic();
-				printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-				       apic->name);
-			}
-			return 1;
+		if (!apic_probe[i]->mps_oem_check)
+			continue;
+		if (!apic_probe[i]->mps_oem_check(mpc, oem, productid))
+			continue;
+
+		if (!cmdline_apic) {
+			apic = apic_probe[i];
+			if (x86_quirks->update_genapic)
+				x86_quirks->update_genapic();
+			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
+			       apic->name);
 		}
+		return 1;
 	}
 	return 0;
 }
-- 
1.6.0.2

