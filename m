Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYDYQX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYDYQX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbYDYQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:23:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55976 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916AbYDYQXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:23:17 -0400
Date: Fri, 25 Apr 2008 18:22:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080425162215.GA16273@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> +		spin_lock_irqsave(&poke_lock, flags);
> +		set_fixmap(FIX_POKE, phys);
> +		memcpy((void *)(virt + offset), opcode, len);
> +		spin_unlock_irqrestore(&poke_lock, flags);

hm, right now we've got a debug protection in set_fixmap() to make sure 
it's only ever called once. So it's going to be a noisy bootup. (but 
it's a warning only) The patch below removes that.

	Ingo

------------->
Subject: x86: remove set_fixmap() warning
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 18:05:57 CEST 2008

set_fixmap() is safe as long as it's explicitly serialized between
all users.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -173,9 +173,6 @@ set_pte_phys(unsigned long vaddr, unsign
 	new_pte = pfn_pte(phys >> PAGE_SHIFT, prot);
 
 	pte = pte_offset_kernel(pmd, vaddr);
-	if (!pte_none(*pte) &&
-	    pte_val(*pte) != (pte_val(new_pte) & __supported_pte_mask))
-		pte_ERROR(*pte);
 	set_pte(pte, new_pte);
 
 	/*
