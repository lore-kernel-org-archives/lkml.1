Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZBDXYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZBDXYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZBDXYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:24:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:27358 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbZBDXYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:24:13 -0500
Message-ID: <498A2399.4090503@ct.jp.nec.com>
Date: Wed, 04 Feb 2009 15:24:09 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: mm: introduce helper function in fault.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce helper function fault_in_kernel_address() to make editors happy.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/mm/fault.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index bfac289..27ec123 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -783,6 +783,15 @@ static inline int access_error(unsigned long error_code, int write,
 	return 0;
 }
 
+static int fault_in_kernel_space(unsigned long address)
+{
+#ifdef CONFIG_X86_32
+	return address >= TASK_SIZE;
+#else /* !CONFIG_X86_32 */
+	return address >= TASK_SIZE64;
+#endif /* CONFIG_X86_32 */
+}
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -832,11 +841,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	 * (error_code & 4) == 0, and that the fault was not a
 	 * protection error (error_code & 9) == 0.
 	 */
-#ifdef CONFIG_X86_32
-	if (unlikely(address >= TASK_SIZE)) {
-#else
-	if (unlikely(address >= TASK_SIZE64)) {
-#endif
+	if (unlikely(fault_in_kernel_space(address))) {
 		if (!(error_code & (PF_RSVD | PF_USER | PF_PROT))) {
 			if (vmalloc_fault(address) >= 0)
 				return;
-- 
1.6.1.2

