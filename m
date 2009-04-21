Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbZDUGac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbZDUGac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZDUGaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:30:23 -0400
Received: from ozlabs.org ([203.10.76.45]:37491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZDUGaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:30:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] x86: fix boot crash in NMI watchdog with CONFIG_CPUMASK_OFFSTACK=y and flat APIC
Date: Tue, 21 Apr 2009 16:00:15 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211600.16348.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fcef8576d8a64fc603e719c97d423f9f6d4e0e8b converted backtrace_mask to a
cpumask_var_t, and assumed check_nmi_watchdog was called before
nmi_watchdog_tick was ever called.  Steven's oops shows I was wrong.

This is something of a bandaid: I'm not sure we *should* be calling
nmi_watchdog_tick before check_nmi_watchdog.  Note that gcc eliminates
this test for the CONFIG_CPUMASK_OFFSTACK=n case.

LKML Message-ID: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/apic/nmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -414,7 +414,8 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		touched = 1;
 	}
 
-	if (cpumask_test_cpu(cpu, backtrace_mask)) {
+	/* We can be called before check_nmi_watchdog, hence NULL check. */
+	if (backtrace_mask != NULL && cpumask_test_cpu(cpu, backtrace_mask)) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
