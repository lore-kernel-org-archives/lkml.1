Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbXLWL6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbXLWL6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 06:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbXLWL55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 06:57:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbXLWL54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 06:57:56 -0500
Date: Sun, 23 Dec 2007 12:57:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20071223115735.GA13423@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071223110456.GB10818@elte.hu> <20071223111004.GA2259@elte.hu> <20071223033424.01dab700.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071223033424.01dab700.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Still.  The crash is 100% repeatable and is the same every time.  
> Happens on both my i386 test boxes.
> 
> http://userweb.kernel.org/~akpm/config-sony.txt
> http://userweb.kernel.org/~akpm/config-vmm.txt
> 
> and I bisected it down to e3c1b141.

ok, can reproduce it - the patch below fixes it for me.

	Ingo

------------------------->
Subject: x86: fix system gate related crash
From: Ingo Molnar <mingo@elte.hu>

on 32-bit, system gates are traps.

on 64-bit, they are interrupts (which disable hardirqs).

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/desc.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-x86.q/include/asm-x86/desc.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/desc.h
+++ linux-x86.q/include/asm-x86/desc.h
@@ -310,7 +310,11 @@ static inline void set_trap_gate(unsigne
 static inline void set_system_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
+#ifdef CONFIG_X86_32
+	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
+#else
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
+#endif
 }
 
 static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
