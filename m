Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbXESFDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbXESFDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXESFDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:03:42 -0400
Received: from quark.didntduck.org ([69.55.226.66]:34942 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbXESFDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:03:41 -0400
X-Greylist: delayed 1649 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 01:03:41 EDT
Message-ID: <464E7EFC.5030608@didntduck.org>
Date: Sat, 19 May 2007 00:37:16 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtrr: fix PGE mask
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cr4 is a 32-bit register, so casting the mask to an unsigned char is wrong,
as it clears more than the PGE bit.

Signed-off-by: Brian Gerst <bgerst@didntduck.org>
---
 arch/i386/kernel/cpu/mtrr/cyrix.c |    2 +-
 arch/i386/kernel/cpu/mtrr/state.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/mtrr/cyrix.c b/arch/i386/kernel/cpu/mtrr/cyrix.c
index 0737a59..9edf562 100644
--- a/arch/i386/kernel/cpu/mtrr/cyrix.c
+++ b/arch/i386/kernel/cpu/mtrr/cyrix.c
@@ -136,7 +136,7 @@ static void prepare_set(void)
 	/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
 	if ( cpu_has_pge ) {
 		cr4 = read_cr4();
-		write_cr4(cr4 & (unsigned char) ~(1 << 7));
+		write_cr4(cr4 & ~X86_CR4_PGE);
 	}
 
 	/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
diff --git a/arch/i386/kernel/cpu/mtrr/state.c b/arch/i386/kernel/cpu/mtrr/state.c
index f62ecd1..7b39a2f 100644
--- a/arch/i386/kernel/cpu/mtrr/state.c
+++ b/arch/i386/kernel/cpu/mtrr/state.c
@@ -19,7 +19,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 		/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
 		if ( cpu_has_pge ) {
 			ctxt->cr4val = read_cr4();
-			write_cr4(ctxt->cr4val & (unsigned char) ~(1 << 7));
+			write_cr4(ctxt->cr4val & ~X86_CR4_PGE);
 		}
 
 		/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
-- 
1.5.2.rc3.39.gaf9b



