Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbXIFPAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbXIFPAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXIFO74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:59:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:33272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbXIFO7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:59:54 -0400
From: Andi Kleen <ak@suse.de>
References: <20070906459.839970000@suse.de>
In-Reply-To: <20070906459.839970000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH for 2.6.23] [2/3] x86_64: Remove CLFLUSH in text_poke()
Message-Id: <20070906145953.0D473152E9@wotan.suse.de>
Date: Thu,  6 Sep 2007 16:59:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The CLFLUSH for the modified code line in text_poke was supposed
to speed up CPU recovery. Unfortunately it seems to cause hangs
on some VIA C3s (at least on VIA Esther Model 10 Stepping 9)
Remove it.

Thanks to Stefan Becker for reporting/testing.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/alternative.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -445,8 +445,6 @@ void __kprobes text_poke(void *addr, uns
 {
 	memcpy(addr, opcode, len);
 	sync_core();
-	/* Not strictly needed, but can speed CPU recovery up. Ignore cross cacheline
-	   case. */
-	if (cpu_has_clflush)
-		asm("clflush (%0) " :: "r" (addr) : "memory");
+	/* Could also do a CLFLUSH here to speed up CPU recovery; but
+	   that causes hangs on some VIA CPUs. */
 }
