Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZELXZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZELXZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZELXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:25 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36160
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752687AbZELXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:24 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/17] xen: create dummy ioapic mapping
Date: Tue, 12 May 2009 16:25:11 -0700
Message-Id: <1242170724-13349-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't allow direct access to the IO apic, so make sure that any
request to map it just "maps" non-present pages.  We should see any
attempts at direct access explode nicely.

[ Impact: debuggability (make failures obvious) ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 331e52d..139c8de 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1919,6 +1919,16 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 		pte = pfn_pte(phys, prot);
 		break;
 
+#ifdef CONFIG_X86_IO_APIC
+	case FIX_IO_APIC_BASE_0 ... FIX_IO_APIC_BASE_END:
+		/*
+		 * We just don't map the IO APIC - all access is via
+		 * hypercalls.  Keep the address in the pte for reference.
+		 */
+		pte = pfn_pte(phys, PAGE_NONE);
+		break;
+#endif
+
 	case FIX_PARAVIRT_BOOTMAP:
 		/* This is an MFN, but it isn't an IO mapping from the
 		   IO domain */
-- 
1.6.0.6

