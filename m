Return-Path: <linux-kernel-owner+w=401wt.eu-S1764711AbZEHAfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764711AbZEHAfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZEHALA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:11:00 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52707
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754083AbZEHAJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:54 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/18] xen: create dummy ioapic mapping
Date: Thu,  7 May 2009 14:14:28 -0700
Message-Id: <1241730883-4917-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: debuggability (make failures obvious)

We don't allow direct access to the IO apic, so make sure that any
request to map it just "maps" non-present pages.  We should see any
attempts at direct access explode nicely.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 55da7f9..b105b73 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1907,6 +1907,16 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
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

