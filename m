Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbYBHQhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbYBHQhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbYBHQgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:36:19 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:54986 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587AbYBHQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:36:17 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208536.837219990@suse.de>
In-Reply-To: <20080208536.837219990@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/5] CPA: Make advised protection check truly advisory
Message-Id: <20080208163614.DF4FC1B41AA@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 17:36:14 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 16:29:54.0824 (UTC) FILETIME=[D63C2880:01C86A6F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Only force RO in the advisory protection checks when all pages in the 
range are RO. Previously it would trigger when any page in the range
was ro.

I believe this will make try_preserve_large_page much safer to use.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -193,14 +193,16 @@ advised_static_prot(pgprot_t prot, unsig
 	pgprot_t forbidden = __pgprot(0);
 
 	/* The .rodata section needs to be read-only */
-	if (within_range(start, end, (unsigned long)__start_rodata,
-				(unsigned long)__end_rodata))
+	if (within_range((unsigned long)__start_rodata,
+			 (unsigned long)__end_rodata,
+			 start, end))
 		pgprot_val(forbidden) |= _PAGE_RW;
 	/*
 	 * Do the same for the x86-64 high kernel mapping
 	 */
-	if (within_range(start, end, virt_to_highmap(__start_rodata),
-				virt_to_highmap(__end_rodata)))
+	if (within_range(virt_to_highmap(__start_rodata),
+		   virt_to_highmap(__end_rodata),
+		   start, end))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
