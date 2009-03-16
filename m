Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZCPXLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZCPXLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZCPXLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:11:38 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:56896 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758886AbZCPXLg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:11:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQFANx5vklMQW1W/2dsb2JhbACBTtNIg38GYQ
Date: Mon, 16 Mar 2009 19:11:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, danymadden@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/irq/handle.c fix kstat_irqs_cpu and irq_to_desc
	symbols
Message-ID: <20090316231122.GA18113@Krystal>
References: <20090316182227.GA2444@yoda.jdub.homelinux.org> <20090316194459.GD11878@Krystal> <20090316200115.GA22538@yoda.jdub.homelinux.org> <20090316202500.GA13872@Krystal> <20090316205829.GB22538@yoda.jdub.homelinux.org> <20090316215337.GB15119@Krystal> <20090316220518.GD22538@yoda.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090316220518.GD22538@yoda.jdub.homelinux.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:01:50 up 16 days, 19:28,  1 user,  load average: 0.38, 0.43,
	0.45
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 05:53:37PM -0400, Mathieu Desnoyers wrote:
>* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
>> On Mon, Mar 16, 2009 at 04:25:00PM -0400, Mathieu Desnoyers wrote:
>> >* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
>> >> On Mon, Mar 16, 2009 at 03:44:59PM -0400, Mathieu Desnoyers wrote:
>> >> >* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
>> >> >> Hi All,
>> >> >> 
>> >> >> I was attempting to build a simple ppc64_defconfig using
>> >> >> the latest LTTng tag from git.  When doing a:
>> >> >> 
>> >> >> 	make ppc64_defconfig
>> >> >> 	make
>> >> >> 
>> >> >> I get the error below.
>> >> >> 
>> >> >
>> >> >Hi Josh,
>> >> >
>> >> >Yes, LTTng has been tested with slub, but not for the powerpc64
>> >> >cross-build. Thanks for the report, this is actually a header circular
>> >> >dependency I caused. It should be fixed in LTTng 0.111.
>> >> 
>> >> Bah. Yes, I should have clarified on ppc/ppc64.  Sorry for the confusion
>> >> there.
>> >> 
>> >> >I'll have to update my powerpc64 cross compiler to test it, because I am
>> >> >stucked with a broken gcc 4.1. Please tell me if 0.111 fixes the problem
>> >> >for you or if you encounter other problems.
>> >> 
>> >> Yep, the extern on tb_ticks_per_sec is what I had come up with locally.
>> >> It should work fine, and does indeed get past the error I was seeing.  The
>> >> build now dies with:
>> >> 
>> >> kernel/irq/handle.c:259: error: __ksymtab_irq_to_desc causes a section type conflict
>> >> kernel/irq/handle.c:259: error: __ksymtab_irq_to_desc causes a section type conflict
>> >> make[2]: *** [kernel/irq/handle.o] Error 1
>> >> make[1]: *** [kernel/irq] Error 2
>> >> make: *** [kernel] Error 2
>> >> make: *** Waiting for unfinished jobs....
>> >> 
>> >
>> >Can I get your full .config ?
>> 
>> Sure, attached.  Note, this is just:
>> 
>> make ppc64_defconfig
>> make vmlinux
>> 
>> josh
>
>Can you try moving this code around ?

Yep, allows vmlinux and modules to build just fine.  Here's a patch for you ;)

Mathieu :

This build problem was exhibited because of the added
EXPORT_SYMBOL(irq_to_desc) in the LTTng tree, but only on powerpc.

Applies on 2.6.29-rc8.

From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/irqnr.h |    4 ++++
 kernel/irq/handle.c   |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/linux/irqnr.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/irqnr.h	2009-02-10 22:53:36.000000000 -0500
+++ linux-2.6-lttng/include/linux/irqnr.h	2009-03-16 18:40:01.000000000 -0400
@@ -38,6 +38,10 @@ extern struct irq_desc *irq_to_desc(unsi
 
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
+extern int nr_irqs;
+struct irq_desc;
+extern struct irq_desc *irq_to_desc(unsigned int irq);
+
 #define for_each_irq_nr(irq)                   \
        for (irq = 0; irq < nr_irqs; irq++)
 
Index: linux-2.6-lttng/kernel/irq/handle.c
===================================================================
--- linux-2.6-lttng.orig/kernel/irq/handle.c	2009-03-16 18:38:51.000000000 -0400
+++ linux-2.6-lttng/kernel/irq/handle.c	2009-03-16 18:40:01.000000000 -0400
@@ -473,6 +473,6 @@ unsigned int kstat_irqs_cpu(unsigned int
 	struct irq_desc *desc = irq_to_desc(irq);
 	return desc ? desc->kstat_irqs[cpu] : 0;
 }
-#endif
 EXPORT_SYMBOL(kstat_irqs_cpu);
+#endif
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
