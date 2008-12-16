Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYLPLpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYLPLpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbYLPLph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:45:37 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39859 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbYLPLpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:45:36 -0500
Message-Id: <4947A304.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:45:56 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: add some compile time checks to mem_init()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the inconsistencies checked for at run time can be detected at
build time already, so duplicate the checks done at run time to also be
done at build time.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_32.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- linux-2.6.28-rc8/arch/x86/mm/init_32.c	2008-12-11 14:36:52.000000000 +0100
+++ 2.6.28-rc8-i386-mem-init-build-check/arch/x86/mm/init_32.c	2008-12-15 11:35:43.000000000 +0100
@@ -1040,11 +1040,25 @@ void __init mem_init(void)
 		(unsigned long)&_text, (unsigned long)&_etext,
 		((unsigned long)&_etext - (unsigned long)&_text) >> 10);
 
+	/*
+	 * Check boundaries twice: Some fundamental inconsistencies can
+	 * be detected at build time already.
+	 */
+#define __FIXADDR_TOP (-PAGE_SIZE)
+#ifdef CONFIG_HIGHMEM
+	BUILD_BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
+	BUILD_BUG_ON(VMALLOC_END			> PKMAP_BASE);
+#endif
+#define high_memory (-128UL << 20)
+	BUILD_BUG_ON(VMALLOC_START			>= VMALLOC_END);
+#undef high_memory
+#undef __FIXADDR_TOP
+
 #ifdef CONFIG_HIGHMEM
 	BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
 	BUG_ON(VMALLOC_END				> PKMAP_BASE);
 #endif
-	BUG_ON(VMALLOC_START				> VMALLOC_END);
+	BUG_ON(VMALLOC_START				>= VMALLOC_END);
 	BUG_ON((unsigned long)high_memory		> VMALLOC_START);
 
 	if (boot_cpu_data.wp_works_ok < 0)



