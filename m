Return-Path: <linux-kernel-owner+w=401wt.eu-S1764137AbYDYQr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764137AbYDYQr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761548AbYDYQrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:47:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44096 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760058AbYDYQrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:47:03 -0400
Date: Fri, 25 Apr 2008 18:45:09 +0200
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
Message-ID: <20080425164509.GB19962@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu> <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org>
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

> But there was actually a much worse problem with my patch: 
> __set_fixmap() is __init. Which means that my patch was just totally 
> broken.

ah, on 64-bit. That we better make consistent anyway, via the patch 
below. set_pte_phys() needs to become non-init as well.

	Ingo

----------->
Subject: x86: make __set_fixmap() non-init
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 18:28:21 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -135,7 +135,7 @@ static __init void *spp_getpage(void)
 	return ptr;
 }
 
-static __init void
+static void
 set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
 {
 	pgd_t *pgd;
@@ -214,8 +214,7 @@ void __init cleanup_highmap(void)
 }
 
 /* NOTE: this is meant to be run only at boot */
-void __init
-__set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
+void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
 {
 	unsigned long address = __fix_to_virt(idx);
 
