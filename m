Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbZB1COl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbZB1COl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZB1COM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:14:12 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:46132
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751054AbZB1COL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:14:11 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/10] xen: create dummy ioapic mapping
Date: Fri, 27 Feb 2009 18:14:01 -0800
Message-Id: <1235787248-18184-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235787248-18184-1-git-send-email-jeremy@goop.org>
References: <1235787248-18184-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't allow direct access to the IO apic, so make sure that any
request to map it just "maps" non-present pages.  We should see any
attempts at direct access explode nicely.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 05d6adb..33f39de 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1845,6 +1845,16 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
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

