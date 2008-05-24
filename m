Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbYEXPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbYEXPmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYEXPlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:10460 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbYEXPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=ahGGOt9HT1TWnhIIOSclqG6G4pPc2vulxAy7yjcyc8P0bWufdhDHZFe1NCTcYCAb5qvbTqtB51KhcED3OjTP+ioyG1NlA+3rpWIuFLVp76kgaEQUE1f6doZMfcy6ZEEozsTdpgrlIHIwwx3ul1l2OiScHLNIx9JDwaS1KKq6bhQ=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 02/11] x86: nmi - die_nmi() output message unification
Content-Disposition: inline; filename=traps-64-output-unify
Message-ID: <4838373d.0437560a.0556.7c6d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make 64bit die_nmi() to produce the same message as 32bit mode has

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_64.c	2008-05-24 12:07:40.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_64.c	2008-05-24 12:25:57.000000000 +0400
@@ -358,8 +358,8 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		 */
 		local_inc(&__get_cpu_var(alert_counter));
 		if (local_read(&__get_cpu_var(alert_counter)) == 5*nmi_hz)
-			die_nmi("NMI Watchdog detected LOCKUP on CPU %d\n", regs,
-				panic_on_timeout);
+			die_nmi("NMI Watchdog detected LOCKUP",
+				regs, panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
 		local_set(&__get_cpu_var(alert_counter), 0);
Index: linux-2.6.git/arch/x86/kernel/traps_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_64.c	2008-05-24 12:07:40.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/traps_64.c	2008-05-24 12:25:11.000000000 +0400
@@ -614,7 +614,9 @@ die_nmi(char *str, struct pt_regs *regs,
 	 * We are in trouble anyway, lets at least try
 	 * to get a message out.
 	 */
-	printk(str, smp_processor_id());
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
 	show_registers(regs);
 	if (kexec_should_crash(current))
 		crash_kexec(regs);

-- 
