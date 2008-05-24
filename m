Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYEXPnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYEXPnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYEXPl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:17641 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbYEXPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=hUvpVrtL88zgXmW24EOcD0wH4kCw7LkntuJO48M0uFc8K+OEPNibxv7QbcuJw5kTwzrHPRq/dcyJz2e2jDyWV5U+wZBrvGmFFjQw8pWhijE+QI6Wmi2B0qL9+PLd5wW57TOGOVdM+2H72DRUPK9wRozql+8rITTLVHKCWmVua7E=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 04/11] x86: nmi_32.c - add "panic" option
Content-Disposition: inline; filename=nmi-32-panic-on-timeout
Message-ID: <4838373d.0405560a.1421.7c54@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to pass "panic" option in 32bit mode

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 12:29:17.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 12:45:30.000000000 +0400
@@ -42,6 +42,7 @@ static cpumask_t backtrace_mask = CPU_MA
  *  0: the lapic NMI watchdog is disabled, but can be enabled
  */
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
+static int panic_on_timeout;
 
 unsigned int nmi_watchdog = NMI_DEFAULT;
 static unsigned int nmi_hz = HZ;
@@ -140,6 +141,14 @@ static int __init setup_nmi_watchdog(cha
 {
 	int nmi;
 
+	if (!strncmp(str, "panic", 5)) {
+		panic_on_timeout = 1;
+		str = strchr(str, ',');
+		if (!str)
+			return 1;
+		++str;
+	}
+
 	get_option(&str, &nmi);
 
 	if ((nmi >= NMI_INVALID) || (nmi < NMI_NONE))
@@ -374,7 +383,7 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 			 * die_nmi will return ONLY if NOTIFY_STOP happens..
 			 */
 			die_nmi("BUG: NMI Watchdog detected LOCKUP",
-				regs, 0);
+				regs, panic_on_timeout);
 	} else {
 		__get_cpu_var(last_irq_sum) = sum;
 		local_set(&__get_cpu_var(alert_counter), 0);

-- 
