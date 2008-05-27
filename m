Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYE0IBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYE0IBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYE0IA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:00:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbYE0IA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:00:56 -0400
Date: Tue, 27 May 2008 10:00:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mikukkon@iki.fi
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       arjan@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2.6.26-rc4] Fix nesting error checking in
	arch/x86/mm/ioremap.c
Message-ID: <20080527080030.GC29246@elte.hu>
References: <20080527054930.GA2488@srv1-m700-lanp.koti>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527054930.GA2488@srv1-m700-lanp.koti>
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

* Mika Kukkonen <mikukkon@srv1-m700-lanp.koti> wrote:

>  	unsigned int nesting;
>  
> -	nesting = --early_ioremap_nested;
> -	WARN_ON(nesting < 0);
> +	if (early_ioremap_nested)
> +		nesting = --early_ioremap_nested;
> +	else { 
> +		nesting = 0;
> +		WARN_ON(1);
> +	}

the better fix would be to turn 'nesting' into an int, hm?

Also, instead of forcing nesting to 0, it is better to just return - as 
we cannot do any sane unmap here anymore. (we are unbalanced)

I.e. something like the fix below?

	Ingo

------------------------------>
Subject: ioremap: nesting fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue May 27 09:56:49 CEST 2008

Mika Kukkonen noticed that the nesting check in early_iounmap() is not 
actually done.

Reported-by: Mika Kukkonen <mikukkon@srv1-m700-lanp.koti>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/ioremap.c
===================================================================
--- linux.orig/arch/x86/mm/ioremap.c
+++ linux/arch/x86/mm/ioremap.c
@@ -602,10 +602,11 @@ void __init early_iounmap(void *addr, un
 	unsigned long offset;
 	unsigned int nrpages;
 	enum fixed_addresses idx;
-	unsigned int nesting;
+	int nesting;
 
 	nesting = --early_ioremap_nested;
-	WARN_ON(nesting < 0);
+	if (WARN_ON(nesting < 0))
+		return;
 
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
