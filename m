Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYFPFP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYFPFP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYFPFPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:15:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57820 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbYFPFPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:15:18 -0400
Date: Mon, 16 Jun 2008 07:15:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Message-ID: <20080616051504.GA3492@elte.hu>
References: <20080613140057.GA25833@damson.getinternet.no> <20080614063114.GA24188@elte.hu> <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com> <20080614090023.GA13798@elte.hu> <19f34abd0806140217x1ea73a8k1cae18a12128a2b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806140217x1ea73a8k1cae18a12128a2b1@mail.gmail.com>
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


-tip testing found a build failure with kmemcheck:

include/asm/string_32.h:320:1: warning: "memset" redefined
include/asm/string_32.h:245:1: warning: this is the location of the previous definition

arch/x86/mm/kmemcheck/smp.c: In function 'kmemcheck_pause_allbutself':
arch/x86/mm/kmemcheck/smp.c:59: error: 'NMI_VECTOR' undeclared (first use in this function)
arch/x86/mm/kmemcheck/smp.c:59: error: (Each undeclared identifier is reported only once
arch/x86/mm/kmemcheck/smp.c:59: error: for each function it appears in.)

with this config:

  http://redhat.com/~mingo/misc/config-Mon_Jun_16_04_15_22_CEST_2008.bad

the patch below fixes the build failure, but note that there are lots of 
those memset redefined warnings with that config as well.

	Ingo

------------>
commit 36bdad27f868eba1d17e6d9dc1cbb6794361d541
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 16 07:11:37 2008 +0200

    kmemcheck: fix build error
    
    fix:
    
    arch/x86/mm/kmemcheck/smp.c: In function 'kmemcheck_pause_allbutself':
    arch/x86/mm/kmemcheck/smp.c:59: error: 'NMI_VECTOR' undeclared (first use in this function)
    arch/x86/mm/kmemcheck/smp.c:59: error: (Each undeclared identifier is reported only once
    arch/x86/mm/kmemcheck/smp.c:59: error: for each function it appears in.)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/kmemcheck/smp.c b/arch/x86/mm/kmemcheck/smp.c
index c4ff615..cd17ddf 100644
--- a/arch/x86/mm/kmemcheck/smp.c
+++ b/arch/x86/mm/kmemcheck/smp.c
@@ -5,6 +5,7 @@
 #include <mach_ipi.h>
 
 #include "smp.h"
+#include <asm/irq_vectors.h>
 
 static spinlock_t nmi_spinlock;
 
