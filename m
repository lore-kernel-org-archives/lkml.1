Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbZACSLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbZACSLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbZACSLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:11:38 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51457 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZACSLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:11:37 -0500
Date: Sun, 4 Jan 2009 03:11:05 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Raja R Harinath" <harinath@hurrynot.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH for -tip 4/4] irq: for_each_irq_desc() makes simplify
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <2f11576a0901012156w30a6b162v96aed31d357929e6@mail.gmail.com>
References: <87wsdezyu6.fsf@hariville.hurrynot.org> <2f11576a0901012156w30a6b162v96aed31d357929e6@mail.gmail.com>
Message-Id: <20090104030849.069A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi
> 
> >>  # define for_each_irq_desc(irq, desc)                                        \
> >>       for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;           \
> >> -          irq++, desc = irq_to_desc(irq))
> >> +          irq++, desc = irq_to_desc(irq))                            \
> >> +             if (desc)
> >> +
> >> +
> >>  # define for_each_irq_desc_reverse(irq, desc)                                \
> >>       for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;      \
> >> -          irq--, desc = irq_to_desc(irq))
> >> +          irq--, desc = irq_to_desc(irq))                            \
> >> +             if (desc)
> >
> > I know this has gone in, but isn't this naked 'if' unsafe.  Consider the
> > following hypothetical code:
> >
> >  if (safe)
> >    for_each_irq_desc(irq, desc) {
> >       ...
> >    }
> >  else
> >    panic();
> >
> > With the macro definition above, the loop would panic() each time !desc,
> > and _not_ panic() when !safe.  I'd consider this behaviour to be
> > unexpected, to say the least :-)
> 
> Correct.
> 
> > The fix is to change the
> >
> >  if (desc)
> >
> > in the macro to
> >
> >  if (!desc) ; else
> 
> Ok. I'll do that.
> Very thanks for good reviewing.

Done.
Thnaks Raja.

Ingo, could you please apply this patch to -tip tree?


===
>From 6f1210e6912afd8ca07518e82f89ba92137302b2 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sun, 4 Jan 2009 02:37:26 +0900
Subject: [PATCH] sparseirq: fix for_each_irq_desc() nit

Raja reported for_each_irq_desc() has possibility unsafeness.
if anyone write folliwing code, for_each_irq_desc() doesn't works intetionally.
(Now, its code doesn't exist at all)

 if (safe)
   for_each_irq_desc(irq, desc) {
      ...
   }
 else
   panic();


Reported-by: Raja R Harinath <harinath@hurrynot.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/irqnr.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 5504a5c..99b91c6 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -23,13 +23,17 @@ extern struct irq_desc *irq_to_desc(unsigned int irq);
 # define for_each_irq_desc(irq, desc)					\
 	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs;		\
 	     irq++, desc = irq_to_desc(irq))				\
-		if (desc)
+		if (!desc)						\
+			;						\
+		else
 
 
 # define for_each_irq_desc_reverse(irq, desc)				\
 	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
 	     irq--, desc = irq_to_desc(irq))				\
-		if (desc)
+		if (!desc)						\
+			;						\
+		else
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
-- 
1.5.3




