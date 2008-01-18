Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYARA0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYARA0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbYARAZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:25:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:24603 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbYARAZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pP2Y+kkYWfNKZNKhd+DmwoytzpAoZ03OhV2cYpNv3Y0y9whSSTiK+Neq3LqqSh51UcDTCV99wJ+EDFfCDAjvv8/+u2tF1AI1Vkaj6fZD5BbukOEj6933blB2YA51PVbLUshB0sInXvEPS39VkD/TX8IsjF4hGxTVNsKZ7NlSRd8=
Subject: [PATCHv2] x86: Use v8086_mode helper, trivial unification
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 16:25:57 -0800
Message-Id: <1200615957.5724.75.camel@brick>
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
HPA noted that v8086_mode is always zero on X86_64, no ifdef
needed.

 arch/x86/mm/fault_32.c |    3 ++-
 arch/x86/mm/fault_64.c |   10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 77915ac..53f4fe4 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -550,11 +550,12 @@ good_area:
 	/*
 	 * Did it hit the DOS screen memory VA from vm86 mode?
 	 */
-	if (regs->flags & VM_MASK) {
+	if (v8086_mode(regs)) {
 		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
 		if (bit < 32)
 			tsk->thread.screen_bitmap |= 1 << bit;
 	}
+
 	up_read(&mm->mmap_sem);
 	return;
 
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 84531d8..c05211d 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -551,6 +551,16 @@ good_area:
 		tsk->maj_flt++;
 	else
 		tsk->min_flt++;
+
+	/*
+	 * Did it hit the DOS screen memory VA from vm86 mode?
+	 */
+	if (v8086_mode(regs)) {
+		unsigned long bit = (address - 0xA0000) >> PAGE_SHIFT;
+		if (bit < 32)
+			tsk->thread.screen_bitmap |= 1 << bit;
+	}
+
 	up_read(&mm->mmap_sem);
 	return;
 
-- 
1.5.4.rc2.1164.g6451



