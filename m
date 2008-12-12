Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYLLIZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYLLIZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYLLIZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:25:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYLLIZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:25:24 -0500
Date: Fri, 12 Dec 2008 09:24:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081212082456.GA25106@elte.hu>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <49407CE1.9090600@googlemail.com> <1228979963.3254.8.camel@gaiman.anholt.net> <200812111707.20857.elendil@planet.nl> <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain> <20081211163548.GA11859@elte.hu> <alpine.LFD.2.00.0812110902450.3340@localhost.localdomain> <20081211203604.GA14817@elte.hu> <84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020812111246m7f6470f2n8b09283f54ead81@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Thu, Dec 11, 2008 at 10:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > ok. In this case i'd suggest we should just remove the warning. People do
> > get scared by needless kernel stack dumps - no matter whether it's marked
> > informational or not.
> >
> > So how about the patch below, queued up in tip/x86/debug? Arjan, what do
> > you think?
> 
> How come we don't put it under CONFIG_X86_DEBUG or something and hide 
> somewhere in the "Kernel debugging" menu?

okay - how about the following then instead - we still keep the warning, 
but do various things to make it appear less scary.

	Ingo

----------------->
>From 8808500f26a61757cb414da76b271bbd09d5958c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 12 Dec 2008 09:20:12 +0100
Subject: [PATCH] x86: soften multi-BAR mapping sanity check warning message

Impact: make debug warning less scary

The ioremap() time multi-BAR map warning has been causing false
positives:

  http://lkml.org/lkml/2008/12/10/432
  http://lkml.org/lkml/2008/12/11/136

So make it less scary by making it once-per-boot, by making it KERN_INFO
and by adding this text:

  "Info: mapping multiple BARs. Your kernel is fine."

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index d4c4307..bd85d42 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -223,7 +223,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	 * Check if the request spans more than any BAR in the iomem resource
 	 * tree.
 	 */
-	WARN_ON(iomem_map_sanity_check(phys_addr, size));
+	WARN_ONCE(iomem_map_sanity_check(phys_addr, size),
+		  KERN_INFO "Info: mapping multiple BARs. Your kernel is fine.");
 
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..

