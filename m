Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbZKMX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbZKMX20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZKMX2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:28:17 -0500
Received: from mga06.intel.com ([134.134.136.21]:23208 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932435AbZKMX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:28:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,739,1249282800"; 
   d="scan'208";a="569382154"
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 2/5] x86, sleep: always save the value of EFER
Date: Fri, 13 Nov 2009 15:28:14 -0800
Message-Id: <1258154897-6770-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258154897-6770-1-git-send-email-hpa@zytor.com>
References: <1258154897-6770-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always save the value of EFER, regardless of the state of NX.  Since
EFER may not actually exist, use rdmsr_safe() to do so.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@tuxonice.net>
---
 arch/x86/kernel/acpi/sleep.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index ca93638..c2e4455 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -78,12 +78,9 @@ int acpi_save_state_mem(void)
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
-	header->pmode_efer_low = nx_enabled;
-	if (header->pmode_efer_low & 1) {
-		/* This is strange, why not save efer, always? */
-		rdmsr(MSR_EFER, header->pmode_efer_low,
-			header->pmode_efer_high);
-	}
+	header->pmode_efer_low = header->pmode_efer_high = 0;
+	rdmsr_safe(MSR_EFER,
+		   &header->pmode_efer_low, &header->pmode_efer_high);
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
-- 
1.6.2.5

