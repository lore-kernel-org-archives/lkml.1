Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbYBMPdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbYBMPdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765931AbYBMPdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:33:06 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:60021 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765903AbYBMPdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:33:02 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JW6NYC-01-5PD-01
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Message-ID: <20080213151841.586864000@amd.com>
References: <20080213151811.804698000@amd.com>
User-Agent: quilt/0.46-1
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 2/2] x86: apic: Extended interrupt LVT support for AMD
 Barcelona (32bit)
Date: Wed, 13 Feb 2008 16:19:36 +0100 (CET)
X-OriginalArrivalTime: 13 Feb 2008 15:19:36.0665 (UTC)
 FILETIME=[D814EC90:01C86E53]
MIME-Version: 1.0
X-WSS-ID: 6BADD54E07S10443439-01-01
Content-Disposition: inline;
 filename=0002-x86-apic-Extended-interrupt-LVT-support-for-AMD-Ba.patch
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
index 35a568e..a6f9d25 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -621,6 +621,37 @@ int setup_profiling_timer(unsigned int multiplier)
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

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



