Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbXKMBgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbXKMBgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759202AbXKMBg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:36:29 -0500
Received: from gw.goop.org ([64.81.55.164]:51527 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079AbXKMBg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:36:27 -0500
Message-ID: <4738FF33.90105@goop.org>
Date: Mon, 12 Nov 2007 17:34:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: mask _PAGE_PCD from ptes
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

_PAGE_PCD maps a page with caching disabled, which is typically used
for mapping harware registers.  Xen never allows it to be set on a
mapping, and unprivileged guests never need it since they can't see
the real underlying hardware.  However, some uncached mappings are
made early when probing the (non-existent) APIC, and its OK to mask
off the PCD flag in these cases.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/xen/mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -244,6 +244,8 @@ pte_t xen_make_pte(unsigned long long pt
 	if (pte & 1)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
 
+	pte &= ~_PAGE_PCD;
+
 	return (pte_t){ pte, pte >> 32 };
 }
 
@@ -290,6 +292,8 @@ pte_t xen_make_pte(unsigned long pte)
 {
 	if (pte & _PAGE_PRESENT)
 		pte = phys_to_machine(XPADDR(pte)).maddr;
+
+	pte &= ~_PAGE_PCD;
 
 	return (pte_t){ pte };
 }


