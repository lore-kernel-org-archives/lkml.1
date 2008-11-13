Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYKMTmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYKMTmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKMTeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:25 -0500
Received: from gw.goop.org ([64.81.55.164]:34384 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbYKMTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 29 of 38] xen: create dummy ioapic mapping
X-Mercurial-Node: ec3f3830cce7c4753c9715bb9676e07a61e4fa18
Message-Id: <ec3f3830cce7c4753c97.1226603427@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't allow direct access to the IO apic, so make sure that any
request to map it just "maps" non-present pages.  We should see any
attempts at direct access explode nicely.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1166,6 +1166,16 @@
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


