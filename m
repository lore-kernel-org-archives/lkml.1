Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbZAENis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbZAENis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZAENij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:38:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZAENii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:38:38 -0500
Date: Mon, 5 Jan 2009 14:38:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: irqnr fallout in gpiolib on sparc32
Message-ID: <20090105133819.GE6014@elte.hu>
References: <20090105132916.GA10545@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105132916.GA10545@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> I hit the following build error on sparc:
> 
> drivers/gpio/gpiolib.c: In function `gpiolib_dbg_show':
> drivers/gpio/gpiolib.c:1146: error: implicit declaration of function `irq_to_desc'
> drivers/gpio/gpiolib.c:1146: warning: initialization makes pointer from integer without a cast
> 
> 
> This is with an allmodconfig where I did:
> 
> make ARCH=sparc vmlinux
> 
> sparc do _not_ have GENERIC_HARDIRQS set to 'y'.
>
> I did a simple:
> #include <linux/irqnr.h> but that did not help.

yeah. Does the patch below do the trick?

btw., i'm curious, does the unification of the sparc architectures mean 
that sparc32 will be using genirq too some time in the future?

	Ingo

---------------->
>From 08522e214542b4afc6c2401bb02900cfca76f600 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 5 Jan 2009 14:34:42 +0100
Subject: [PATCH] genirq: provide irq_to_desc() to non-genirq architectures too

Impact: build fix on non-genirq architectures

Sam Ravnborg reported this build failure on sparc32 allmodconfig,
the GPIO drivers assume the presence of irq_to_desc():

 drivers/gpio/gpiolib.c: In function `gpiolib_dbg_show':
 drivers/gpio/gpiolib.c:1146: error: implicit declaration of function 'irq_to_desc'

Add it in the !genirq case too.

Reported-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irqnr.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 5504a5c..6b719fa 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -8,7 +8,12 @@
 
 #ifndef CONFIG_GENERIC_HARDIRQS
 #include <asm/irq.h>
-# define nr_irqs		NR_IRQS
+
+/*
+ * Wrappers for non-genirq architectures:
+ */
+#define nr_irqs			NR_IRQS
+#define irq_to_desc(irq)	irq_desc[irq]
 
 # define for_each_irq_desc(irq, desc)		\
 	for (irq = 0; irq < nr_irqs; irq++)
