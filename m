Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbZEHAQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbZEHAQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZEHAKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:13 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52714
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753599AbZEHAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:57 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/8] xen/x86-64: clean up warnings about IST-using traps
Date: Thu,  7 May 2009 13:24:56 -0700
Message-Id: <1241727902-3176-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241727902-3176-1-git-send-email-jeremy@goop.org>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Ignore known IST-using traps.  Aside from the debugger traps, they're
low-level faults which Xen will handle for us, so the kernel needn't
worry about them.  Keep warning in case unknown trap starts using IST.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 16afbc3..cbb31eb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -439,12 +439,30 @@ static int cvt_gate_to_trap(int vector, const gate_desc *val,
 
 	addr = gate_offset(*val);
 #ifdef CONFIG_X86_64
+	/*
+	 * Look for known traps using IST, and substitute them
+	 * appropriately.  The debugger ones are the only ones we care
+	 * about.  Xen will handle faults like double_fault and
+	 * machine_check, so we should never see them.  Warn if
+	 * there's an unexpected IST-using fault handler.
+	 */
 	if (addr == (unsigned long)debug)
 		addr = (unsigned long)xen_debug;
 	else if (addr == (unsigned long)int3)
 		addr = (unsigned long)xen_int3;
-	else
-		WARN_ON(val->ist != 0);
+	else if (addr == (unsigned long)double_fault ||
+		 addr == (unsigned long)stack_segment) {
+		/* Don't need to handle these */
+		return 0;
+#ifdef CONFIG_X86_MCE
+	} else if (addr == (unsigned long)machine_check) {
+		return 0;
+#endif
+	} else {
+		/* Some other trap using IST? */
+		if (WARN_ON(val->ist != 0))
+			return 0;
+	}
 #endif	/* CONFIG_X86_64 */
 	info->address = addr;
 
-- 
1.6.0.6

