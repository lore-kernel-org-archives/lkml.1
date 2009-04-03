Return-Path: <linux-kernel-owner+w=401wt.eu-S935528AbZDCS5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935528AbZDCS5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZDCS5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:57:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:65528 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbZDCS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nbpzxemeXmx4X2VR6dV8wVrookledSklYMCfoF70w+j3gshfIme7Wj5XayUiLHZsSd
         j7yaIPe424bkPvtyOesyfHUjl0igTOJQbi66ZHXUbuoZYHRTqEjiwbx79FNctIA259Ea
         38UxLG1vcp63FbRTCs6r5BOgSHdoGGbbVgXjM=
Date: Fri, 3 Apr 2009 22:57:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler
Message-ID: <20090403185729.GC12273@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For X86-32 if IRQ has no handler it remains non-Ack'ed
even if APIC is not requested for being disabled.
Fix it.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/irq.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq.c
+++ linux-2.6.git/arch/x86/kernel/irq.c
@@ -218,10 +218,8 @@ unsigned int __irq_entry do_IRQ(struct p
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
 		if (!disable_apic)
 			ack_APIC_irq();
-#endif
 
 		if (printk_ratelimit())
 			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
