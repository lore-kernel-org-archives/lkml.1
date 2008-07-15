Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbYGOBLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbYGOBLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYGOBL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:11:26 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:47845 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbYGOBLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:11:25 -0400
X-IronPort-AV: E=Sophos;i="4.30,362,1212364800"; 
   d="scan'208";a="65426727"
From: Roland Dreier <rdreier@cisco.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Current head x86_64 breakage - csum-copy_64.S
References: <1216082378.25534.43.camel@nigel-laptop>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 14 Jul 2008 18:11:23 -0700
In-Reply-To: <1216082378.25534.43.camel@nigel-laptop> (Nigel Cunningham's
	message of "Tue, 15 Jul 2008 10:39:38 +1000")
Message-ID: <adafxqchryc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jul 2008 01:11:24.0066 (UTC) FILETIME=[B2EE5820:01C8E617]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >   AS      arch/x86/lib/csum-copy_64.o
 > arch/x86/lib/csum-copy_64.S: Assembler messages:
 > arch/x86/lib/csum-copy_64.S:48: Error: Macro `ignore' was already defined

Yes, the culprit seems to be 70f1bba4 ("x86: use ignore macro instead of
hash comment"), which introduces the ignore macro in dwarf2.h, which
collides with the macro already in csum-copy_64.S.

Perhaps something like the patch below?

---

[PATCH] x86: Rename "ignore" macro in <asm/dwarf2.h> to avoid collision

Commit 70f1bba4 ("x86: use ignore macro instead of hash comment") breaks
the 64-bit x86 build on toolchains that have CONFIG_AS_CFI undefined with:

    arch/x86/lib/csum-copy_64.S:48: Error: Macro `ignore' was already defined

because <asm/dwarf2.h> now uses the ignore macro name itself.  Fix this
by changing to __cfi_ignore in dwarf2.h.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---

 include/asm-x86/dwarf2.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/asm-x86/dwarf2.h b/include/asm-x86/dwarf2.h
index 0bfe250..1a283d5 100644
--- a/include/asm-x86/dwarf2.h
+++ b/include/asm-x86/dwarf2.h
@@ -38,23 +38,23 @@
 
 /* Due to the structure of pre-exisiting code, don't use assembler line
    comment character # to ignore the arguments. Instead, use a dummy macro. */
-.macro ignore a=0, b=0, c=0, d=0
+.macro __cfi_ignore a=0, b=0, c=0, d=0
 .endm
 
-#define CFI_STARTPROC	ignore
-#define CFI_ENDPROC	ignore
-#define CFI_DEF_CFA	ignore
-#define CFI_DEF_CFA_REGISTER	ignore
-#define CFI_DEF_CFA_OFFSET	ignore
-#define CFI_ADJUST_CFA_OFFSET	ignore
-#define CFI_OFFSET	ignore
-#define CFI_REL_OFFSET	ignore
-#define CFI_REGISTER	ignore
-#define CFI_RESTORE	ignore
-#define CFI_REMEMBER_STATE ignore
-#define CFI_RESTORE_STATE ignore
-#define CFI_UNDEFINED ignore
-#define CFI_SIGNAL_FRAME ignore
+#define CFI_STARTPROC	__cfi_ignore
+#define CFI_ENDPROC	__cfi_ignore
+#define CFI_DEF_CFA	__cfi_ignore
+#define CFI_DEF_CFA_REGISTER	__cfi_ignore
+#define CFI_DEF_CFA_OFFSET	__cfi_ignore
+#define CFI_ADJUST_CFA_OFFSET	__cfi_ignore
+#define CFI_OFFSET	__cfi_ignore
+#define CFI_REL_OFFSET	__cfi_ignore
+#define CFI_REGISTER	__cfi_ignore
+#define CFI_RESTORE	__cfi_ignore
+#define CFI_REMEMBER_STATE __cfi_ignore
+#define CFI_RESTORE_STATE __cfi_ignore
+#define CFI_UNDEFINED __cfi_ignore
+#define CFI_SIGNAL_FRAME __cfi_ignore
 
 #endif
 
