Return-Path: <linux-kernel-owner+w=401wt.eu-S2992729AbXCGXQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992729AbXCGXQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992700AbXCGXQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:16:38 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57588 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992715AbXCGXP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:15:59 -0500
Date: Wed, 7 Mar 2007 15:13:21 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <ak@suse.de>, Luigi Genoni <luigi.genoni@pirelli.com>
Subject: [patch 104/101] x86-64: survive having no irq mapping for a vector
Message-ID: <20070307231321.GR10574@sequoia.sous-sol.org>
References: <20070307171035.150802805@mini.kroah.org> <20070307173420.GA24957@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307173420.GA24957@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Occasionally the kernel has bugs that result in no irq being found for a
given cpu vector.  If we acknowledge the irq the system has a good chance
of continuing even though we dropped an irq message.  If we continue to
simply print a message and not acknowledge the irq the system is likely to
become non-responsive shortly there after.

AK: Fixed compilation for UP kernels

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86_64/kernel/irq.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/arch/x86_64/kernel/irq.c
+++ linux-2.6.20.1/arch/x86_64/kernel/irq.c
@@ -18,6 +18,7 @@
 #include <asm/uaccess.h>
 #include <asm/io_apic.h>
 #include <asm/idle.h>
+#include <asm/smp.h>
 
 atomic_t irq_err_count;
 
@@ -120,9 +121,14 @@ asmlinkage unsigned int do_IRQ(struct pt
 
 	if (likely(irq < NR_IRQS))
 		generic_handle_irq(irq);
-	else if (printk_ratelimit())
-		printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
-			__func__, smp_processor_id(), vector);
+	else {
+		if (!disable_apic)
+			ack_APIC_irq();
+
+		if (printk_ratelimit())
+			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
+				__func__, smp_processor_id(), vector);
+	}
 
 	irq_exit();
 
