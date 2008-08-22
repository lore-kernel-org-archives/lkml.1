Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYHVGZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYHVGZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbYHVGZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:25:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50467 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114AbYHVGZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:25:35 -0400
Date: Fri, 22 Aug 2008 08:24:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Joshua Hoblitt <josh@hoblitt.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080822062459.GO14110@elte.hu>
References: <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com> <20080822002952.GG23377@hoblitt.com> <20080822010014.GH23377@hoblitt.com> <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu> <86802c440808212316t1c89321fl717fa80d2013f155@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808212316t1c89321fl717fa80d2013f155@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > +               if (tmp != mask_lo) {
> > +                       WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
> 
> can you change WARN_ON to WARN_ON_ONCE ?

the commit below does that. Note that the condition is 
WARN_ON(condition) or WARN(string) - WARN_ON(string) will just print a 
kernel stack unconditionally. Unfortunately there's no WARN_ONCE(). 
(Arjan?)

	Ingo

---------->
>From 1c8aa33e17dc4aa68b329d262fff253648a98adb Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 22 Aug 2008 08:22:23 +0200
Subject: [PATCH] x86: work around MTRR mask setting, v2

improve the debug printout:

- make it actually display something
- print it only once

would be nice to have a WARN_ONCE() facility, to feed such things to
kerneloops.org.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 43102e0..cb7d3b6 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -401,7 +401,12 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			static int once = 1;
+
+			if (once) {
+				printk(KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+				once = 0;
+			}
 			mask_lo = tmp;
 		}
 	}
