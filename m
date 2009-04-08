Return-Path: <linux-kernel-owner+w=401wt.eu-S1765261AbZDHOuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765261AbZDHOuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760485AbZDHOuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:50:23 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38520 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998AbZDHOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=irm0R1ox2sNJWtnW55yMXHPaM9SIBYRL7I5ng4qI5TM4GxIWNvv4l2BfD119mUpi2L
         QwK0n31f8vYjd1j1RaQczyKdUZLPdCne+ZclilTQQauzmRBLqlili3sq6z6JTPm8mQww
         f8lyTJuz5xMbZeS+VXfVpsco5SeH/MwUhm1gw=
Date: Wed, 8 Apr 2009 18:50:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler v2
Message-ID: <20090408145017.GB7556@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If IRQ has no handler it remains non-Ack'ed even if APIC is not
requested for being disabled. Fix it.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

|more stuff needs fixing here first:
|
|arch/x86/kernel/irq.c: In function ‘do_IRQ’:
|arch/x86/kernel/irq.c:226: error: ‘disable_apic’ undeclared (first use in this
|function)
|arch/x86/kernel/irq.c:226: error: (Each undeclared identifier is reported only
|once
|arch/x86/kernel/irq.c:226: error: for each function it appears in.)
|
|like making 'disable_apic' available everywhere.
|
|Or better yet: introduce a dummy apic->write() method in the
|disable_apic=1 case so we can call a straight ack_APIC_irq().
|
|        Ingo

Ingo, I think introducing additional dummy here would be a bit
expencive -- a number of callers of ack_APIC_irq just should not
check for disable_apic since it's not needed. disable_apic is to
depend on CONFIG_X86_LOCAL_APIC rather then CONFIG_X86_64 actually.
So make it then. Or you mean something else? Like new apic->write_eoi
operation? (I'm a bit tired so brain is a half functional now :)

 arch/x86/kernel/irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irq.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq.c
+++ linux-2.6.git/arch/x86/kernel/irq.c
@@ -223,10 +223,10 @@ unsigned int __irq_entry do_IRQ(struct p
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_LOCAL_APIC
 		if (!disable_apic)
-			ack_APIC_irq();
 #endif
+			ack_APIC_irq();
 
 		if (printk_ratelimit())
 			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
