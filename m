Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYGHXSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYGHXSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbYGHXOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:44 -0400
Received: from gw.goop.org ([64.81.55.164]:51204 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbYGHXOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 14 of 55] xen: fix 64-bit hypercall variants
X-Mercurial-Node: 944ec62b4e0ff7c3894ddcef4b80ab3e361e141a
Message-Id: <944ec62b4e0ff7c3894d.1215554796@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit guests can pass 64-bit quantities in a single argument,
so fix up the hypercalls.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/xen/hypercall.h |   60 ++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -223,12 +223,12 @@
 HYPERVISOR_update_va_mapping(unsigned long va, pte_t new_val,
 			     unsigned long flags)
 {
-	unsigned long pte_hi = 0;
-#ifdef CONFIG_X86_PAE
-	pte_hi = new_val.pte_high;
-#endif
-	return _hypercall4(int, update_va_mapping, va,
-			   new_val.pte_low, pte_hi, flags);
+	if (sizeof(new_val) == sizeof(long))
+		return _hypercall3(int, update_va_mapping, va,
+				   new_val.pte, flags);
+	else
+		return _hypercall4(int, update_va_mapping, va,
+				   new_val.pte, new_val.pte >> 32, flags);
 }
 
 static inline int
@@ -281,12 +281,13 @@
 HYPERVISOR_update_va_mapping_otherdomain(unsigned long va, pte_t new_val,
 					 unsigned long flags, domid_t domid)
 {
-	unsigned long pte_hi = 0;
-#ifdef CONFIG_X86_PAE
-	pte_hi = new_val.pte_high;
-#endif
-	return _hypercall5(int, update_va_mapping_otherdomain, va,
-			   new_val.pte_low, pte_hi, flags, domid);
+	if (sizeof(new_val) == sizeof(long))
+		return _hypercall4(int, update_va_mapping_otherdomain, va,
+				   new_val.pte, flags, domid);
+	else
+		return _hypercall5(int, update_va_mapping_otherdomain, va,
+				   new_val.pte, new_val.pte >> 32,
+				   flags, domid);
 }
 
 static inline int
@@ -327,14 +328,14 @@
 {
 	mcl->op = __HYPERVISOR_update_va_mapping;
 	mcl->args[0] = va;
-#ifdef CONFIG_X86_PAE
-	mcl->args[1] = new_val.pte_low;
-	mcl->args[2] = new_val.pte_high;
-#else
-	mcl->args[1] = new_val.pte_low;
-	mcl->args[2] = 0;
-#endif
-	mcl->args[3] = flags;
+	if (sizeof(new_val) == sizeof(long)) {
+		mcl->args[1] = new_val.pte;
+		mcl->args[2] = flags;
+	} else {
+		mcl->args[1] = new_val.pte;
+		mcl->args[2] = new_val.pte >> 32;
+		mcl->args[3] = flags;
+	}
 }
 
 static inline void
@@ -354,15 +355,16 @@
 {
 	mcl->op = __HYPERVISOR_update_va_mapping_otherdomain;
 	mcl->args[0] = va;
-#ifdef CONFIG_X86_PAE
-	mcl->args[1] = new_val.pte_low;
-	mcl->args[2] = new_val.pte_high;
-#else
-	mcl->args[1] = new_val.pte_low;
-	mcl->args[2] = 0;
-#endif
-	mcl->args[3] = flags;
-	mcl->args[4] = domid;
+	if (sizeof(new_val) == sizeof(long)) {
+		mcl->args[1] = new_val.pte;
+		mcl->args[2] = flags;
+		mcl->args[3] = domid;
+	} else {
+		mcl->args[1] = new_val.pte;
+		mcl->args[2] = new_val.pte >> 32;
+		mcl->args[3] = flags;
+		mcl->args[4] = domid;
+	}
 }
 
 static inline void


