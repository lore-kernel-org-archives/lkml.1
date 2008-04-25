Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbYDYP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbYDYP2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYDYP2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:28:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42526 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYDYP2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:28:23 -0400
Date: Fri, 25 Apr 2008 17:26:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080425152650.GA894@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425151931.GA25510@elte.hu>
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


> > > The 0xf0 pattern comes from alternatives_smp_lock: text_poke(*ptr, 
> > > ((unsigned char []){0xf0}), 1);
> > 
> > And we should really add a lot more sanity checking there.

something like the patch below? (untested)

	Ingo

--------------->
Subject: harden kernel code patching
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 17:07:03 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    5 +++++
 mm/vmalloc.c                  |    3 +++
 2 files changed, 8 insertions(+)

Index: linux/arch/x86/kernel/alternative.c
===================================================================
--- linux.orig/arch/x86/kernel/alternative.c
+++ linux/arch/x86/kernel/alternative.c
@@ -518,6 +518,11 @@ void *__kprobes text_poke(void *addr, co
 	if (core_kernel_text((unsigned long)addr)) {
 		struct page *pages[2] = { virt_to_page(addr),
 			virt_to_page(addr + PAGE_SIZE) };
+		/*
+		 * Module text pages are PageReserved:
+		 */
+		WARN_ON(pages[0] && !PageReserved(pages[0]))
+		WARN_ON(pages[1] && !PageReserved(pages[1]))
 		if (!pages[1])
 			nr_pages = 1;
 		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
Index: linux/mm/vmalloc.c
===================================================================
--- linux.orig/mm/vmalloc.c
+++ linux/mm/vmalloc.c
@@ -391,6 +391,7 @@ static void __vunmap(const void *addr, i
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
+			ClearPageReserved(page);
 			__free_page(page);
 		}
 
@@ -507,6 +508,8 @@ static void *__vmalloc_area_node(struct 
 			area->nr_pages = i;
 			goto fail;
 		}
+		if (prot == PAGE_KERNEL_EXEC)
+			SetPageReserved(page);
 		area->pages[i] = page;
 	}
 
