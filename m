Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbZFLNZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbZFLNZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbZFLNZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbZFLNZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:41 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH 4/8] x86: add .broken section to the vDSO linker script
Date: Fri, 12 Jun 2009 15:25:38 +0200
Message-Id: <12e9f65d163582c2d1dafc5cd6962865200d548e.1244812577.git.ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1244812577.git.ptesarik@suse.cz>
References: <cover.1244812577.git.ptesarik@suse.cz>
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
 arch/x86/vdso/vdso-layout.lds.S |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 0386c92..23da4a1 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -70,8 +70,30 @@ SECTIONS
 	.text : {
 		*(.text* .gnu.linkonce.t.*)
 	} :text	=0x90909090
+
+	/* Some sections require some additional work from the dynamic
+	 * linker to work properly. However, there is no dynamic-link
+	 * pass for the vDSO, so these sections will not work.
+	 * Put them into a special section and raise a link-time error
+	 * if they get used by accident.
+	 */
+	.broken : {
+	}
 }
 
+/* This assert is triggered if the linker finds a section in one of its
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
 /*
  * Very old versions of ld do not recognize this name token; use the constant.
  */
-- 
1.6.0.2

