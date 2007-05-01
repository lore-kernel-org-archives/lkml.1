Return-Path: <linux-kernel-owner+w=401wt.eu-S1946438AbXEAEE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946438AbXEAEE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933455AbXEAEBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:11 -0400
Received: from mail.suse.de ([195.135.220.2]:60940 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946492AbXEAD6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:16 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: joerg.roedel@amd.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [17/30] x86: Use RDTSCP for synchronous get_cycles if possible
Message-Id: <20070501035815.41DAC13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


RDTSCP is already synchronous and doesn't need an explicit CPUID.
This is a little faster and more importantly avoids VMEXITs on Hypervisors.

Original patch from Joerg Roedel, but reworked by AK
Also includes miscompilation fix by Eric Biederman

Cc: "Joerg Roedel" <joerg.roedel@amd.com>

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/tsc.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/include/asm-i386/tsc.h
===================================================================
--- linux.orig/include/asm-i386/tsc.h
+++ linux/include/asm-i386/tsc.h
@@ -38,6 +38,15 @@ static __always_inline cycles_t get_cycl
 	unsigned eax;
 
 	/*
+  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
+ 	 * and doesn't cause a VMEXIT on Hypervisors
+	 */
+	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
+			 	 "=A" (ret), "0" (0ULL) : "ecx", "memory");
+	if (ret)
+		return ret;
+
+	/*
 	 * Don't do an additional sync on CPUs where we know
 	 * RDTSC is already synchronous:
 	 */
