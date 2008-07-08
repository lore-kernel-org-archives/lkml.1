Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYGHXTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYGHXTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbYGHXOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:48 -0400
Received: from gw.goop.org ([64.81.55.164]:51208 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 25 of 55] xen64: use set_fixmap for shared_info structure
X-Mercurial-Node: 603a56260ca50739f45b499c8fb8909474d8fff2
Message-Id: <603a56260ca50739f45b.1215554807@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -902,18 +902,11 @@
 void xen_setup_shared_info(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		unsigned long addr = fix_to_virt(FIX_PARAVIRT_BOOTMAP);
+		set_fixmap(FIX_PARAVIRT_BOOTMAP,
+			   xen_start_info->shared_info);
 
-		/*
-		 * Create a mapping for the shared info page.
-		 * Should be set_fixmap(), but shared_info is a machine
-		 * address with no corresponding pseudo-phys address.
-		 */
-		set_pte_mfn(addr,
-			    PFN_DOWN(xen_start_info->shared_info),
-			    PAGE_KERNEL);
-
-		HYPERVISOR_shared_info = (struct shared_info *)addr;
+		HYPERVISOR_shared_info =
+			(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
 	} else
 		HYPERVISOR_shared_info =
 			(struct shared_info *)__va(xen_start_info->shared_info);
@@ -1050,8 +1043,13 @@
 #ifdef CONFIG_X86_F00F_BUG
 	case FIX_F00F_IDT:
 #endif
+#ifdef CONFIG_X86_32
 	case FIX_WP_TEST:
 	case FIX_VDSO:
+	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
+#else
+	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	case FIX_APIC_BASE:	/* maps dummy local APIC */
 #endif


