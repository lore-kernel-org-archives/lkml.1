Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbZFXODR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbZFXODR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZFXODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:03:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55109 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZFXODB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:03:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for some arches
Date: Wed, 24 Jun 2009 16:02:37 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com> <20090624131357.GA6224@elte.hu>
In-Reply-To: <20090624131357.GA6224@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906241602.38422.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18wmc4wfdDd9+dHyRKCcxGvW09rx+wd1ZJuGuY
 jKj2HOH3SU3lDVNNsldGSnYJ5j5+5sSsuum+Y3YrUbYD5oRhic
 JJ3o/Gm1VupyRtg2/n9ug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Ingo Molnar wrote:
> * Mike Frysinger <vapier.adi@gmail.com> wrote:
> 
> > if we look at linux/hardirq.h, it makes this claim:
> >  * - bit 28 is the PREEMPT_ACTIVE flag
> > if that's true, then why are we letting any arch set this define ?  a
> > quick survey shows that half the arches (11) are using 0x10000000 (bit
> > 28) while the other half (10) are using 0x4000000 (bit 26).  and then
> > there is the ia64 oddity which uses bit 30.  the exact value here
> > shouldnt really matter across arches though should it ?

actually alpha, arm and avr32 also use bit 30 (0x40000000), there are only
five (or eight, depending on how you count) architectures (blackfin, h8300,
m68k, s390 and sparc) using bit 26.

> Correct - what matters is to have no collision between the fields.
> 
> > how about adding this to linux/thread_info.h:
> > #ifndef PREEMPT_ACTIVE
> > # ifndef PREEMPT_ACTIVE_BIT
> > #  define PREEMPT_ACTIVE_BIT 28
> > # endif
> > # define PREEMPT_ACTIVE (1 << PREEMPT_ACTIVE_BIT)
> > #endif
> 
> Makes sense i guess - but do we really need that level of
> #ifdef nesting? PREEMPT_ACTIVE_BIT should be the main control - with
> a default to 28 if it's not set. PREEMPT_ACTIVE is then derived off 
> that, without any #ifdefs.

I think it would fit better into linux/hardirq.h instead of
linux/thread_info.h, because that is where the other bits of
the preempt count are defined.

How would this one work out?

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -62,6 +62,12 @@
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
 #define NMI_OFFSET	(1UL << NMI_SHIFT)
 
+#ifndef PREEMPT_ACTIVE
+#define PREEMPT_ACTIVE_BITS	1
+#define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
+#define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_SHIFT)
+#endif
+
 #if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
 #error PREEMPT_ACTIVE is too low!
 #endif
