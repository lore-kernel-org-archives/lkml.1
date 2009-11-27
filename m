Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZK0PEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZK0PEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZK0PEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:04:52 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:10035 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZK0PEv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Fri, 27 Nov 2009 10:04:51 -0500
Message-Id: <4B0FF8AA0200007800022703@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 27 Nov 2009 15:04:58 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/alternatives: check replacementlen <= instrlen at
	 build time
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having run into the run-(boot-)time check a couple of times lately, I
finally took time to find a build-time check so that one doesn't need
to analyze the register/stack dump and resolve this (through manual
lookup in vmlinux) to the offending construct. The assembler will emit
a message like "Error: value of <num> too large for field of 1 bytes
at <offset>", which while not pointing out the source location still
makes analysis quite a bit easier.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/alternative.h     |    1 +
 1 files changed, 1 insertion(+)

--- linux-2.6.32-rc8/arch/x86/include/asm/alternative.h
+++ 2.6.32-rc8-x86-alternative/arch/x86/include/asm/alternative.h
@@ -84,6 +84,7 @@ static inline void alternatives_smp_swit
       "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
       "	 .byte 662b-661b\n"			/* sourcelen       */	\
       "	 .byte 664f-663f\n"			/* replacementlen  */	\
+      "	 .byte 0xff + (664f-663f) - (662b-661b)\n" /* rlen <= slen */	\
       ".previous\n"							\
       ".section .altinstr_replacement, \"ax\"\n"			\
       "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\



