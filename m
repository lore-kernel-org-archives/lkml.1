Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYHMQ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYHMQ5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHMQ5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:57:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbYHMQ5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:57:02 -0400
Date: Wed, 13 Aug 2008 18:56:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       Peter Oruba <peter.oruba@amd.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] Fix date output in x86 microcode driver.
Message-ID: <20080813165638.GA15905@elte.hu>
References: <1218543944.2977.164.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218543944.2977.164.camel@pmac.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> The microcode stores its date in a uint32_t in some weird order 
> approximating pdp-endian. Rather than printing it like that, print it 
> properly in ISO standard form.

applied to tip/x86/microcode - thanks David.

Note that i did some manual merging because microcode support changed a 
few details meanwhile, due to the addition of the AMD microcode driver. 
Find the commit below.

	Ingo

--------------->
>From 34a1b9fc4995102ecbb3a980b348aebf168d8196 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 12 Aug 2008 13:25:44 +0100
Subject: [PATCH] Fix date output in x86 microcode driver.

The microcode stores its date in a uint32_t in some weird order
approximating pdp-endian. Rather than printing it like that, print it
properly in ISO standard form.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode_intel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index a61986e..d2d9d74 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -339,8 +339,11 @@ static void apply_microcode(int cpu)
 		return;
 	}
 	printk(KERN_INFO "microcode: CPU%d updated from revision "
-	       "0x%x to 0x%x, date = %08x \n",
-	       cpu_num, uci->rev, val[1], uci->mc.mc_intel->hdr.date);
+	       "0x%x to 0x%x, date = %04x-%02x-%02x \n",
+		cpu_num, uci->rev, val[1],
+		uci->mc.mc_intel->hdr.date & 0xffff,
+		uci->mc.mc_intel->hdr.date >> 24,
+		(uci->mc.mc_intel->hdr.date >> 16) & 0xff);
 	uci->rev = val[1];
 }
 
