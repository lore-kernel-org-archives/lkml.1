Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYKKKNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYKKKNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYKKKNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:13:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbYKKKNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:13:00 -0500
Date: Tue, 11 Nov 2008 11:12:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing, x86: function return tracer, fix assembly
	constraints
Message-ID: <20081111101252.GA3355@elte.hu>
References: <49191C31.1050402@gmail.com> <20081111094312.GA16496@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111094312.GA16496@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 867f7fb3ebb831970847b179e7df5a9ab10da16d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 11 Nov 2008 11:18:14 +0100
Subject: [PATCH] tracing, x86: function return tracer, fix assembly constraints

fix:

 arch/x86/kernel/ftrace.c: Assembler messages:
 arch/x86/kernel/ftrace.c:140: Error: missing ')'
 arch/x86/kernel/ftrace.c:140: Error: junk `(%ebp))' after expression
 arch/x86/kernel/ftrace.c:141: Error: missing ')'
 arch/x86/kernel/ftrace.c:141: Error: junk `(%ebp))' after expression

the [parent_replaced] is used in an =rm fashion, so that constraint
is correct in isolation - but [parent_old] aliases register %0 and uses
it in an addressing mode that is only valid with registers - so change
the constraint from =rm to =r.

This fixes the build failure.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d68033b..9b2325a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -151,7 +151,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		"   .long 2b, 3b\n"
 		".previous\n"
 
-		: [parent_replaced] "=rm" (parent), [old] "=r" (old),
+		: [parent_replaced] "=r" (parent), [old] "=r" (old),
 		  [faulted] "=r" (faulted)
 		: [parent_old] "0" (parent), [return_hooker] "r" (return_hooker)
 		: "memory"
