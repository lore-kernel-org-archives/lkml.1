Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYGAOyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYGAOyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759847AbYGAOyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:54:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759837AbYGAOye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:54:34 -0400
Date: Tue, 1 Jul 2008 16:54:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] percpu: Optimize percpu accesses
Message-ID: <20080701145417.GB18522@elte.hu>
References: <20080701121634.865966000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701121634.865966000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> This patchset provides the following:
> 
>   * Cleanup: Fix early references to cpumask_of_cpu(0)
>   * Generic: Percpu infrastructure to rebase the per cpu area to zero
>   * x86_64: Fold pda into per cpu area
>   * x86_64: Rebase per cpu variables to zero

thanks Mike - i've started testing it in -tip. One small merge fallout 
fix is below. (it's for the new generic-ipi topic that was not in 
tip/master yet when you merged percpu-zerobased to it)

	Ingo

---------------->
commit d1d4ed23aab090298b9d4da0fe445b96afcdd309
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Jul 1 16:44:45 2008 +0200

    x86: percpu-zerobased fallout fixlet
    
    add_pda(x,1) => x86_inc_percpu(pda.x)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 361b7a4..1ddf629 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -206,7 +206,7 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
-	add_pda(irq_call_count, 1);
+	x86_inc_percpu(pda.irq_call_count);
 #endif
 	irq_exit();
 }
