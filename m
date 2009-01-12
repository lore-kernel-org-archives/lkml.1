Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZALSjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZALSjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZALSjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:39:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbZALSjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:39:22 -0500
Date: Mon, 12 Jan 2009 19:39:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: heukelum@fastmail.fm, linux-kernel@vger.kernel.org, ak@suse.de,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 22/24] i386: add TRACE_IRQS_OFF for the nmi
Message-ID: <20090112183904.GC12249@elte.hu>
References: <1220990178-29773-15-git-send-email-heukelum@fastmail.fm> <1220990178-29773-16-git-send-email-heukelum@fastmail.fm> <1220990178-29773-17-git-send-email-heukelum@fastmail.fm> <1220990178-29773-18-git-send-email-heukelum@fastmail.fm> <1220990178-29773-19-git-send-email-heukelum@fastmail.fm> <1220990178-29773-20-git-send-email-heukelum@fastmail.fm> <1220990178-29773-21-git-send-email-heukelum@fastmail.fm> <1220990178-29773-22-git-send-email-heukelum@fastmail.fm> <1220990178-29773-23-git-send-email-heukelum@fastmail.fm> <1231780911.4371.196.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231780911.4371.196.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2008-09-09 at 21:56 +0200, heukelum@fastmail.fm wrote:
> > From: Alexander van Heukelum <heukelum@fastmail.fm>
> > 
> > At this point interrupts are off, so let's inform the tracing
> > code of that fact before calling into C.
> 
> Sorry but this is an obvious dud, lockdep (and thus the irq state
> tracer) aren't nmi safe.
> 
> Ingo, please revert, as people are already seeing lockdep warnings due
> to this.

done - reverted it in tip/x86/urgent, see the commit below. Is that all 
that we need, wasnt there a 64-bit side done too?

	Ingo

--------------->
>From e8cea892dff8e3ebed42954c46730309b617196f Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 12 Jan 2009 19:36:59 +0100
Subject: [PATCH] Revert "i386: add TRACE_IRQS_OFF for the nmi"

This reverts commit e0c7317557c8fc8eacf611e30c2a80f4e24e47a3.

This patch was wrong, as lockdep (and thus the irq state tracer)
aren't nmi safe. People are already seeing lockdep warnings due
to this.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_32.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index d6f0490..4646902 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1203,7 +1203,6 @@ nmi_stack_correct:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
-	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_nmi
@@ -1244,7 +1243,6 @@ nmi_espfix_stack:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
-	TRACE_IRQS_OFF
 	FIXUP_ESPFIX_STACK		# %eax == %esp
 	xorl %edx,%edx			# zero error code
 	call do_nmi
