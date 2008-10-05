Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYJERZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYJERZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 13:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYJERZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 13:25:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:19295 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbYJERY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 13:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=DOmYoQWf7WZ6ArBjlppSdagUciODrNHuCgPXED+XMRGF18Vr9B9ohBXKS/afH9U4bI
         S/HhgPuhsU846QepI56M6aiDHrwnlkRuzBUAaEPvgLy0VS8Wh8qOlga+OUy0esNNC2kf
         RgU+QInoxkOcYpT+CKSVy+n8NzYhG/A0l69CA=
Date: Sun, 5 Oct 2008 19:25:04 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] kmemcheck: fix crash in PnP BIOS calls
Message-ID: <20081005172504.GB24825@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 251667c0cd0bc9d3d3e32ae137f49e51c0bb062c Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 5 Oct 2008 15:46:30 +0200
Subject: [PATCH] kmemcheck: fix crash in PnP BIOS calls

Ingo Molnar reported this crash:
> PnPBIOS: Scanning system for PnP BIOS support...
> PnPBIOS: Found PnP BIOS installation structure at 0xc00fc550
> PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc580, dseg 0xf0000
> BUG: unable to handle kernel paging request at 0000c6ef

It turns out that BIOS calls are made with a different code segment. So
when kmemcheck tries to dereference the EIP/RIP (using the kernel data
segment register), we get the unhandled page fault.

I think we can solve this by verifying (in the page fault handler) that
the faulting code is using the kernel CS.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/kmemcheck/kmemcheck.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index d649aa7..bd739a4 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -666,6 +666,17 @@ bool kmemcheck_fault(struct pt_regs *regs, unsigned long address,
 	pte_t *pte;
 	unsigned int level;
 
+	/*
+	 * XXX: Is it safe to assume that memory accesses from virtual 86
+	 * mode or non-kernel code segments will _never_ access kernel
+	 * memory (e.g. tracked pages)? For now, we need this to avoid
+	 * invoking kmemcheck for PnP BIOS calls.
+	 */
+	if (regs->flags & X86_VM_MASK)
+		return false;
+	if (regs->cs != __KERNEL_CS)
+		return false;
+
 	pte = lookup_address(address, &level);
 	if (!pte)
 		return false;
-- 
1.5.5.1

