Return-Path: <linux-kernel-owner+w=401wt.eu-S1762334AbZEGS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762334AbZEGS56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761976AbZEGS5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:57:31 -0400
Received: from gw.goop.org ([64.81.55.164]:40224 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbZEGS5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:57:30 -0400
Message-ID: <4A032EE0.9030607@goop.org>
Date: Thu, 07 May 2009 11:56:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 2/5] xen/x86-64: clean up warnings about IST-using traps
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore known IST-using traps.  Aside from the debugger traps, they're
low-level faults which Xen will handle for us, so the kernel needn't
worry about them.  Keep warning in case unknown trap starts using IST.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index cb49f57..88f3aa4 100644
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



