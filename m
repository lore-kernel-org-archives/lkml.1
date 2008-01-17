Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYAQXFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYAQXFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbYAQXEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:04:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:28882 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbYAQXEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LaRo3cjHrQJtc/lNJXA94tGfDfwnn1TpfXxRIsp1oabvDquh6eHlFbfblAXlj1zQongsYf+7R+eOFJNtebYscc1FbKGAi8qnaX1DrB8qnvacMXYRum0LnapXiwa9dR4ATW8ndqVDGaH8guHiTPIZ71Nsk/18Jrfxr/todmS2bh0=
Subject: [PATCH] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:04:38 -0800
Message-Id: <1200611078.5724.46.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use v8086_mode inline in fault_32.c, no functional change
also ifdef the section for 32-bit only and add to fault_64.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |    4 +++-
 arch/x86/mm/fault_64.c |   11 +++++++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 77915ac..6d8a0bb 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -547,14 +547,16 @@ good_area:
 	else
 		tsk->min_flt++;
 
+#ifdef CONFIG_X86_32
 	/*
 	 * Did it hit the DOS screen memory VA from vm86 mode?
 	 */
-	if (regs->flags & VM_MASK) {
+	if (v8086_mode(regs)) {
 		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
 		if (bit < 32)
 			tsk->thread.screen_bitmap |= 1 << bit;
 	}
+#endif
 	up_read(&mm->mmap_sem);
 	return;
 
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 84531d8..8393275 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -551,6 +551,17 @@ good_area:
 		tsk->maj_flt++;
 	else
 		tsk->min_flt++;
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Did it hit the DOS screen memory VA from vm86 mode?
+	 */
+	if (v8086_mode(regs)) {
+		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
+		if (bit < 32)
+			tsk->thread.screen_bitmap |= 1 << bit;
+	}
+#endif
 	up_read(&mm->mmap_sem);
 	return;
 
-- 
1.5.4.rc2.1164.g6451



