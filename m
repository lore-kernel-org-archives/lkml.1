Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbYBHN20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbYBHN20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYBHN1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:27:51 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:44860 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843AbYBHN1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:27:50 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208227.168531243@suse.de>
In-Reply-To: <20080208227.168531243@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/5] CPA: Make advised protection check truly advisory
Message-Id: <20080208132746.34FB51B41BB@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 14:27:46 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 13:21:25.0935 (UTC) FILETIME=[819CA3F0:01C86A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Only force RO in the advisory protection checks when all pages in the 
range are RO. Previously it would trigger when any page in the range
was ro.

I believe this will make try_preserve_large_page much safer to use.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -191,14 +191,14 @@ advised_static_prot(pgprot_t prot, unsig
 {
 #ifdef CONFIG_DEBUG_RODATA
 	/* The .rodata section needs to be read-only */
-	if (within_range(start, end, (unsigned long)__start_rodata,
-				(unsigned long)__end_rodata))
+	if (within_range((unsigned long)__start_rodata,
+				(unsigned long)__end_rodata, start, end))
 		pgprot_val(prot) &= ~_PAGE_RW;
 	/*
 	 * Do the same for the x86-64 high kernel mapping
 	 */
-	if (within_range(start, end, virt_to_highmap(__start_rodata),
-				virt_to_highmap(__end_rodata)))
+	if (within_range(virt_to_highmap(__start_rodata),
+				virt_to_highmap(__end_rodata), start, end))
 		pgprot_val(prot) &= ~_PAGE_RW;
 #endif
 	return prot;
