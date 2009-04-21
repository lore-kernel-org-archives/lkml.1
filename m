Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZDUINV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZDUINV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZDUINH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:13:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:33808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZDUINF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:13:05 -0400
Date: Tue, 21 Apr 2009 08:12:31 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
Subject: [tip:x86/urgent] x86: fix boot crash in NMI watchdog with CONFIG_CPUMASK_OFFSTACK=y and flat APIC
Message-ID: <tip-2f537a9f8e82f55c241b002c8cfbf34303b45ada@git.kernel.org>
Git-Commit-ID: 2f537a9f8e82f55c241b002c8cfbf34303b45ada
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 08:12:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f537a9f8e82f55c241b002c8cfbf34303b45ada
Gitweb:     http://git.kernel.org/tip/2f537a9f8e82f55c241b002c8cfbf34303b45ada
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 21 Apr 2009 16:00:15 +0930
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 10:09:49 +0200

x86: fix boot crash in NMI watchdog with CONFIG_CPUMASK_OFFSTACK=y and flat APIC

fcef8576d8a64fc603e719c97d423f9f6d4e0e8b converted backtrace_mask to a
cpumask_var_t, and assumed check_nmi_watchdog was called before
nmi_watchdog_tick was ever called.  Steven's oops shows I was wrong.

This is something of a bandaid: I'm not sure we *should* be calling
nmi_watchdog_tick before check_nmi_watchdog.  Note that gcc eliminates
this test for the CONFIG_CPUMASK_OFFSTACK=n case.

[ Impact: fix boot crash in rare configs ]

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/nmi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index d6bd624..2ba52f3 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -414,7 +414,8 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		touched = 1;
 	}
 
-	if (cpumask_test_cpu(cpu, backtrace_mask)) {
+	/* We can be called before check_nmi_watchdog, hence NULL check. */
+	if (backtrace_mask != NULL && cpumask_test_cpu(cpu, backtrace_mask)) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
