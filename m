Return-Path: <linux-kernel-owner+w=401wt.eu-S933642AbXKOVti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642AbXKOVti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXKOVta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:49:30 -0500
Received: from gw.goop.org ([64.81.55.164]:39704 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbXKOVt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:49:28 -0500
Message-ID: <473CBEDC.8020901@goop.org>
Date: Thu, 15 Nov 2007 13:49:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RESEND] xen: mask _PAGE_PCD from ptes
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

This became necessary because Xen started checking for this bit, rather
than silently masking it off.

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


