Return-Path: <linux-kernel-owner+w=401wt.eu-S965717AbXBHXor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717AbXBHXor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965680AbXBHXor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:44:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965717AbXBHXoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:44:46 -0500
Date: Thu, 8 Feb 2007 15:44:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070208154442.678a214b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 00:29:06 +0100 (MET)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Feb 8 2007 15:07, Andrew Morton wrote:
> 
> >scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
> >scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
> >scheduled-removal-of-sa_xxx-interrupt-flags.patch
> >scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
> >
> > This removes SA_INTERRUPT and friends, so 10000000 external drivers won't
> > compile any more.  I think I'd prefer to find a way to get usage of SA_* to
> > spit a deprecated warning.
> 
> Here's an idea:
> 
> #define SA_INTERRUPT sa_interrupt_with_warning()
> static inline int sa_interrupt_with_warning(void) {
>     if(more_or_less_often)
>         printk(fat_warning);
>     return 0x123456; /* whatever numerical value it is */
> }
> 

Yeah, this seems to work.

--- a/include/linux/interrupt.h~deprecate-sa_interrupt-and-friends
+++ a/include/linux/interrupt.h
@@ -54,17 +54,32 @@
  * Migration helpers. Scheduled for removal in 1/2007
  * Do not use for new code !
  */
-#define SA_INTERRUPT		IRQF_DISABLED
-#define SA_SAMPLE_RANDOM	IRQF_SAMPLE_RANDOM
-#define SA_SHIRQ		IRQF_SHARED
-#define SA_PROBEIRQ		IRQF_PROBE_SHARED
-#define SA_PERCPU		IRQF_PERCPU
-
-#define SA_TRIGGER_LOW		IRQF_TRIGGER_LOW
-#define SA_TRIGGER_HIGH		IRQF_TRIGGER_HIGH
-#define SA_TRIGGER_FALLING	IRQF_TRIGGER_FALLING
-#define SA_TRIGGER_RISING	IRQF_TRIGGER_RISING
-#define SA_TRIGGER_MASK		IRQF_TRIGGER_MASK
+#define emit_old_interrupt_name(old, new)				\
+static inline unsigned __deprecated emit_old_interrupt_name##old(void)	\
+{									\
+	return (new);							\
+}
+
+emit_old_interrupt_name(SA_INTERRUPT, IRQF_DISABLED)
+#define SA_INTERRUPT emit_old_interrupt_nameSA_INTERRUPT()
+emit_old_interrupt_name(SA_SAMPLE_RANDOM, IRQF_SAMPLE_RANDOM)
+#define SA_SAMPLE_RANDOM emit_old_interrupt_nameSA_SAMPLE_RANDOM()
+emit_old_interrupt_name(SA_SHIRQ, IRQF_SHARED)
+#define SA_SHIRQ emit_old_interrupt_nameSA_SHIRQ()
+emit_old_interrupt_name(SA_PROBEIRQ, IRQF_PROBE_SHARED)
+#define SA_PROBEIRQ emit_old_interrupt_nameSA_PROBEIRQ()
+emit_old_interrupt_name(SA_PERCPU, IRQF_PERCPU)
+#define SA_PERCPU emit_old_interrupt_nameSA_PERCPU()
+emit_old_interrupt_name(SA_TRIGGER_LOW, IRQF_TRIGGER_LOW)
+#define SA_TRIGGER_LOW emit_old_interrupt_nameSA_TRIGGER_LOW()
+emit_old_interrupt_name(SA_TRIGGER_HIGH, IRQF_TRIGGER_HIGH)
+#define SA_TRIGGER_HIGH emit_old_interrupt_nameSA_TRIGGER_HIGH()
+emit_old_interrupt_name(SA_TRIGGER_FALLING, IRQF_TRIGGER_FALLING)
+#define SA_TRIGGER_FALLING emit_old_interrupt_nameSA_TRIGGER_FALLING()
+emit_old_interrupt_name(SA_TRIGGER_RISING, IRQF_TRIGGER_RISING)
+#define SA_TRIGGER_RISING emit_old_interrupt_nameSA_TRIGGER_RISING()
+emit_old_interrupt_name(SA_TRIGGER_MASK, IRQF_TRIGGER_MASK)
+#define SA_TRIGGER_MASK emit_old_interrupt_nameSA_TRIGGER_MASK()
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
_

For some reason

	enum foo {
		...
	} __deprecated;

doesn't work.
