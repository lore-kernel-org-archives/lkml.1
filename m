Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZFPM4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZFPM4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZFPMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:44893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 3/9] x86: add .broken section to the vDSO linker script
Date: Tue, 16 Jun 2009 14:55:23 +0200
Message-Id: <1245156929-30395-4-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This section should not contain anything unless the vDSO is
broken. It is intended to hold sections which are known not
to work correctly inside a vDSO.

If such a "broken" section is found at link-time, the linker
issues an error with a hint how to find out more.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index af3fa61..cc66120 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -73,9 +73,33 @@ SECTIONS
 	.text : {
 		*(.text*)
 	} :text	=0x90909090
+
+	/*
+	 * Some sections require some additional work from the dynamic
+	 * linker to work properly. However, there is no dynamic-link
+	 * pass for the vDSO, so these sections will not work.
+	 * Put them into a special section and raise a link-time error
+	 * if they get used by accident.
+	 */
+	.broken : {
+	}
 }
 
 /*
+ * This assert is triggered if the linker finds a section in one of its
+ * input files which is known not to work inside a vDSO.
+ *
+ * To see which is the offending sections, you may:
+ *   a. use objdump -h on the object files which make up the vDSO, or
+ *   b. add -Wl,-M to VDSO_LDFLAGS and examine the linker map.
+ *
+ * See individual comments in the definition of the .broken section
+ * above for more information on why any given section is considered
+ * "broken".
+ */
+ASSERT(!SIZEOF(.broken), "The vdso linker script found a section that is bad. See vdso-layout.lds.S for details.");
+
+/*
  * Very old versions of ld do not recognize this name token; use the constant.
  */
 #define PT_GNU_EH_FRAME	0x6474e550
-- 
1.6.0.2

