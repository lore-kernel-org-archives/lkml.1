Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbXLEQl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbXLEQl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXLEQlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:41:22 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:53789 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbXLEQlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:41:21 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
From: "Robert Richter" <robert.richter@amd.com>
Subject: [PATCH] x86: apic: Extended interrupt LVT support for AMD
 Barcelona (32bit)
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Message-ID: <20071205164026.3CC738098@erda.amd.com>
Date: Wed,  5 Dec 2007 17:40:26 +0100 (CET)
X-OriginalArrivalTime: 05 Dec 2007 16:40:26.0232 (UTC)
 FILETIME=[89BB9F80:01C8375D]
MIME-Version: 1.0
X-WSS-ID: 6B480B2024S4488829-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic_32.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 1872f88..ce6e341 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -605,6 +605,37 @@ int setup_profiling_timer(unsigned int multiplier)
 }
 
 /*
+ * Setup extended LVT, AMD specific (K8, family 10h)
+ *
+ * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
+ * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ */
+
+#define APIC_EILVT_LVTOFF_MCE 0
+#define APIC_EILVT_LVTOFF_IBS 1
+
+static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
+{
+	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
+	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
+	apic_write(reg, v);
+}
+
+u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_MCE;
+}
+EXPORT_SYMBOL(setup_APIC_eilvt_mce);
+
+u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_IBS;
+}
+EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
+
+/*
  * Local APIC start and shutdown
  */
 
-- 
1.5.1.6



