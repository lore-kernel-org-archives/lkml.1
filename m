Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbYAYVwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbYAYVwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbYAYVwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:22 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37915 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755314AbYAYVwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:20 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 11] xen: fix mismerge in masking pte flags
X-Mercurial-Node: 5b0099716286229253eaae3a57cafcddf153e7d8
Message-Id: <5b0099716286229253ea.1201296190@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a mismerge/misapply dropped one of the cases of pte flag
masking for Xen.  Also, only mask the flags for present ptes.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/xen/mmu.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -244,8 +244,10 @@ unsigned long long xen_pgd_val(pgd_t pgd
 
 pte_t xen_make_pte(unsigned long long pte)
 {
-	if (pte & 1)
+	if (pte & _PAGE_PRESENT) {
 		pte = phys_to_machine(XPADDR(pte)).maddr;
+		pte &= ~(_PAGE_PCD | _PAGE_PWT);
+	}
 
 	return (pte_t){ .pte = pte };
 }
@@ -291,10 +293,10 @@ unsigned long xen_pgd_val(pgd_t pgd)
 
 pte_t xen_make_pte(unsigned long pte)
 {
-	if (pte & _PAGE_PRESENT)
+	if (pte & _PAGE_PRESENT) {
 		pte = phys_to_machine(XPADDR(pte)).maddr;
-
-	pte &= ~(_PAGE_PCD | _PAGE_PWT);
+		pte &= ~(_PAGE_PCD | _PAGE_PWT);
+	}
 
 	return (pte_t){ pte };
 }


