Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXD2K6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXD2K6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXD2Kxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:52133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbXD2KxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:15 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [25/48] x86_64: Introduce load_TLS to the "for" loop.
Message-Id: <20070429105314.5791115108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

GCC (4.1 at least) unrolls it anyway, but I can't believe this code
was ever justifiable.  (I've also submitted a patch which cleans up
i386, which is even uglier).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/desc.h |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux/include/asm-x86_64/desc.h
===================================================================
--- linux.orig/include/asm-x86_64/desc.h
+++ linux/include/asm-x86_64/desc.h
@@ -135,16 +135,13 @@ static inline void set_ldt_desc(unsigned
 	(info)->useable		== 0	&& \
 	(info)->lm		== 0)
 
-#if TLS_SIZE != 24
-# error update this code.
-#endif
-
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
+	unsigned int i;
 	u64 *gdt = (u64 *)(cpu_gdt(cpu) + GDT_ENTRY_TLS_MIN);
-	gdt[0] = t->tls_array[0];
-	gdt[1] = t->tls_array[1];
-	gdt[2] = t->tls_array[2];
+
+	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
+		gdt[i] = t->tls_array[i];
 } 
 
 /*
