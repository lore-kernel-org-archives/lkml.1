Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbYD0VtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbYD0VtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 17:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYD0Vs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 17:48:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYD0Vsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 17:48:55 -0400
Date: Sun, 27 Apr 2008 23:48:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080427214837.GA11631@elte.hu>
References: <1209329485.3801.46.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209329485.3801.46.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> This patch:
> 
> commit 6371b495991debfd1417b17c2bc4f7d7bae05739
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jan 30 13:33:40 2008 +0100
> 
>     x86: change ioremap() to default to uncached
> 
> As far as I can tell went blindly into the x86 tree without being 
> shared on any mailing list at all.  How can something that completely 
> alters the semantics of ioremap on x86 platforms go in without any 
> review.

what happened before was that on x86 ioremap() was "lax" about the PTE 
cachability and just said "writeback cached". That was utterly false for 
most of the real ioremap()s done by drivers, but it happened to work out 
fine due to the courtesy of BIOSes setting up UC MTRRs that forced those 
areas into uncachable.

with the PAT changes, what used to be this default and careless 
ioremap() behavior by x86 turned into a hard cache aliasing conflict. So 
we pretty much _have to_ default to uncached - like all other sane 
architectures already did forever. This is a direct consequence of the 
PAT changes which were discussed on lkml.

But with PAT we take over from the MTRRs on x86 and using a cacheable 
ioremap() would give us aliasing conflicts and trouble all around the 
place.

In the Voyager case we should use ioremap_cache(), and thanks for 
pointing out that dependency of the QIC. Does the patch below fix it for 
you?

	Ingo

--------------->
Subject: x86, voyager: fix ioremap_nocache()
From: Ingo Molnar <mingo@elte.hu>
Date: Sun Apr 27 23:21:03 CEST 2008

James Bottomley reported that the following PAT related commit:

| commit 6371b495991debfd1417b17c2bc4f7d7bae05739
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Wed Jan 30 13:33:40 2008 +0100
|
|     x86: change ioremap() to default to uncached

broke Voyager.

James says:

" it broke a class of voyager machines: those which
  rely on the quad interrupt controller (QIC).  The precis of why they
  broke is because the QIC does IPIs (or CPIs in its terminology) via
  cache line interference: you interrupt a processor by moving a
  designated memory area to write exclusive in the cache (by simply
  writing to the line) and the CPU acks the interrupt by moving it back to
  read shared (by reading from it).  That area, is, of course, mapped by
  ioremap, so reversing the ioremap semantics and adding the uncached bit
  completely breaks the QIC. "

Sorry about that!

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mach-voyager/voyager_cat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/mach-voyager/voyager_cat.c
===================================================================
--- linux-x86.q.orig/arch/x86/mach-voyager/voyager_cat.c
+++ linux-x86.q/arch/x86/mach-voyager/voyager_cat.c
@@ -602,7 +602,7 @@ void __init voyager_cat_init(void)
 
 		request_resource(&iomem_resource, &res);
 		voyager_SUS = (struct voyager_SUS *)
-		    ioremap(addr, 0x400);
+		    ioremap_cache(addr, 0x400);
 		printk(KERN_NOTICE "Voyager SUS mailbox version 0x%x\n",
 		       voyager_SUS->SUS_version);
 		voyager_SUS->kernel_version = VOYAGER_MAILBOX_VERSION;
@@ -877,7 +877,7 @@ void __init voyager_cat_init(void)
 			request_resource(&iomem_resource, res);
 		}
 
-		qic_addr = (unsigned long)ioremap(qic_addr, 0x400);
+		qic_addr = (unsigned long)ioremap_cache(qic_addr, 0x400);
 
 		for (j = 0; j < 4; j++) {
 			__u8 cpu;
