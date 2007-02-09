Return-Path: <linux-kernel-owner+w=401wt.eu-S965715AbXBIK6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965715AbXBIK6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965728AbXBIK6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:58:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:4898 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965715AbXBIK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:58:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=GAVqBevWlt+P/2nPmV1I3p4vIZN9s11jiYSZl7ssHxums+QHWo2Mct9MNugiZph/TD3q15Z0Tf7YA676BavWAFFC9bFEeRj3TJQHgE/77Fq9soGriIEN58gcA+suFPRTtLtb8bbZqzuctVvVP5+8P+7JYPo6VoqegmhSvQLknHE=
Date: Fri, 9 Feb 2007 10:57:37 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070209105737.GF5785@slug>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 12:29:06AM +0100, Jan Engelhardt wrote:
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
I'd say that we want to warn the developper, not the user, isn't it?
The attached patch marks the variables as __deprecated, and re-schedules
the removal for January 2008.

Regards,
Frederik


diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index b7c642c..4a5aad3 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -308,3 +308,12 @@ Why:   OSS drivers with ALSA replacements
 Who:   Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
+
+What:	Interrupt only SA_* flags
+When:	January 2008
+Why:	The interrupt related SA_* flags are replaced by IRQF_* to move them
+	out of the signal namespace.
+
+Who:	Frederik Deweerdt <deweerdt@free.fr>
+
+---------------------------
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e66b458..472f2d2 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -52,6 +52,25 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 
+/*
+ * Migration helpers. Scheduled for removal in 1/2008
+ * SA_* flags are now deprecated, leaving time for out-of-the-tree drivers 
+ * to catch up.
+ *
+ * Do not use for new code !
+ */
+static const int __deprecated SA_INTERRUPT = IRQF_DISABLED;
+static const int __deprecated SA_SAMPLE_RANDOM = IRQF_SAMPLE_RANDOM;
+static const int __deprecated SA_SHIRQ = IRQF_SHARED;
+static const int __deprecated SA_PROBEIRQ = IRQF_PROBE_SHARED;
+static const int __deprecated SA_PERCPU = IRQF_PERCPU;
+
+static const int __deprecated SA_TRIGGER_LOW = IRQF_TRIGGER_LOW;
+static const int __deprecated SA_TRIGGER_HIGH = IRQF_TRIGGER_HIGH;
+static const int __deprecated SA_TRIGGER_FALLING = IRQF_TRIGGER_FALLING;
+static const int __deprecated SA_TRIGGER_RISING = IRQF_TRIGGER_RISING;
+static const int __deprecated SA_TRIGGER_MASK = IRQF_TRIGGER_MASK;
+
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
 struct irqaction {
