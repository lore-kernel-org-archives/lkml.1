Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZDNPww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZDNPww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZDNPvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:46 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45960 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353AbZDNPvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:43 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 02/14] [VOYAGER] x86/mca: make mca_nmi_hook external
Date: Tue, 14 Apr 2009 10:51:28 -0500
Message-Id: <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the apic rework brought the mca_nmi_hook to a place where it
can't be accessed by architecture specific code.  Publish it again,
this time as a settable function vector so that voyager can use it.

If there were more than one possible architecture wanting to use this,
it could become a call chain, but there's only one and MCA is an old
bus, so leave it as a single call hook.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/mca.h |    3 +++
 arch/x86/kernel/mca_32.c   |   12 ++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mca.h b/arch/x86/include/asm/mca.h
index eedbb6c..785a2a4 100644
--- a/arch/x86/include/asm/mca.h
+++ b/arch/x86/include/asm/mca.h
@@ -4,6 +4,9 @@
 #ifndef _ASM_X86_MCA_H
 #define _ASM_X86_MCA_H
 
+/* hook for the bus chain of the MCA NMI */
+extern void (*mca_nmi_hook)(void);
+
 /* Maximal number of MCA slots - actually, some machines have less, but
  * they all have sufficient number of POS registers to cover 8.
  */
diff --git a/arch/x86/kernel/mca_32.c b/arch/x86/kernel/mca_32.c
index 845d80c..4bb3cc9 100644
--- a/arch/x86/kernel/mca_32.c
+++ b/arch/x86/kernel/mca_32.c
@@ -466,6 +466,13 @@ static int __kprobes mca_handle_nmi_callback(struct device *dev, void *data)
 	return 0;
 }
 
+/*
+ *     The MCA (Microchannel Architecture) has an NMI chain for NMI sources
+ *     along the MCA bus.  Use this to hook into that chain if you will need
+ *     it.
+ */
+void (*mca_nmi_hook)(void) = NULL;
+
 void __kprobes mca_handle_nmi(void)
 {
 	/*
@@ -473,4 +480,9 @@ void __kprobes mca_handle_nmi(void)
 	 * adapter was responsible for the error.
 	 */
 	bus_for_each_dev(&mca_bus_type, NULL, NULL, mca_handle_nmi_callback);
+
+	if (mca_nmi_hook)
+		mca_nmi_hook();
+	else
+		pr_warning("NMI generated from unknown source!\n");
 }
-- 
1.6.2.1

