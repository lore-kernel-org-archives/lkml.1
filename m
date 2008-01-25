Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYAYElU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYAYElU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 23:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYAYElM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 23:41:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:49667 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYAYElL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 23:41:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t0DKTTl9zVdZGsWvHRRWJUdttL3VCuyu0fysjdh6v22k9pylX8+w7JeqtFkoAGVmuVfyNQzoy43jEok8R+mI9YL5cZOkJS0qQ/g3rN0Ko3iSilfajEcSG6+o4YzP+Cf6RC5oepjPHny3yUq28haNqYUDdrWZxHw2yvFBqfxRclg=
Subject: [PATCH] x86: Remove nx_enabled from fault.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 20:41:08 -0800
Message-Id: <1201236068.12822.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On !PAE 32-bit, _PAGE_NX will be 0, making is_prefetch always
return early.  The test is sufficient on PAE as __supported_pte_mask
is updated in the same places as nx_enabled in init_32.c which also
takes disable_nx into account.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index bdf0282..32755eb 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -92,18 +92,13 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	unsigned char *max_instr;
 
 #ifdef CONFIG_X86_32
-# ifdef CONFIG_X86_PAE
-	/* If it was a exec fault on NX page, ignore */
-	if (nx_enabled && (error_code & PF_INSTR))
+	if (!(__supported_pte_mask & _PAGE_NX))
 		return 0;
-# else
-	return 0;
-# endif
-#else /* CONFIG_X86_64 */
+#endif
+
 	/* If it was a exec fault on NX page, ignore */
 	if (error_code & PF_INSTR)
 		return 0;
-#endif
 
 	instr = (unsigned char *)convert_ip_to_linear(current, regs);
 	max_instr = instr + 15;
@@ -468,7 +463,7 @@ static int vmalloc_fault(unsigned long address)
 	pmd_t *pmd, *pmd_ref;
 	pte_t *pte, *pte_ref;
 
-	if (address >= VMALLOC_START && address < VMALLOC_END)
+	if (!(address >= VMALLOC_START && address < VMALLOC_END))
 		return -1;
 
 	/* Copy kernel mappings over when needed. This can also
-- 
1.5.4.rc4.1142.gf5a97



