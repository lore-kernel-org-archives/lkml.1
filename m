Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZDUGd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZDUGd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZDUGdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:33:49 -0400
Received: from ozlabs.org ([203.10.76.45]:39496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZDUGdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:33:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] x86: avoid theoretical spurious NMI backtraces with CONFIG_CPUMASK_OFFSTACK=y
Date: Tue, 21 Apr 2009 16:03:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com> <200904211600.16348.rusty@rustcorp.com.au>
In-Reply-To: <200904211600.16348.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211603.41980.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In theory (though not shown in practice) alloc_cpumask_var() doesn't zero
memory, so CPUs might print an "NMI backtrace for cpu %d" once on boot.

(Bug introduced in fcef8576d8a64fc603e719c97d423f9f6d4e0e8b).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/apic/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -138,7 +138,7 @@ int __init check_nmi_watchdog(void)
 	if (!prev_nmi_count)
 		goto error;
 
-	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL);
+	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL|__GFP_ZERO);
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
 #ifdef CONFIG_SMP
