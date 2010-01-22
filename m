Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626Ab0AVKwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0AVKwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293Ab0AVKw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:52:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:55174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0AVKwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:52:24 -0500
Date: Fri, 22 Jan 2010 10:51:59 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de
In-Reply-To: <20100121221711.GA8242@basil.fritz.box>
References: <20100121221711.GA8242@basil.fritz.box>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
Message-ID: <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org>
Git-Commit-ID: f91c4d2649531cc36e10c6bc0f92d0f99116b209
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jan 2010 10:52:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f91c4d2649531cc36e10c6bc0f92d0f99116b209
Gitweb:     http://git.kernel.org/tip/f91c4d2649531cc36e10c6bc0f92d0f99116b209
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 21 Jan 2010 18:31:54 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 21 Jan 2010 18:31:54 -0800

x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll

cpu_specific_poll is a global variable, and it should have a global
namespace name.  Since it is MCE-specific (it takes a struct mce *),
rename it mce_cpu_specific_poll.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <20100121221711.GA8242@basil.fritz.box>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c          |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index d5b7eec..8e7c2f4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -28,4 +28,4 @@ extern int mce_ser;
 
 extern struct mce_bank *mce_banks;
 
-extern void (*cpu_specific_poll)(struct mce *);
+extern void (*mce_cpu_specific_poll)(struct mce *);
diff --git a/arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c b/arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c
index 67ad39b..e09b736 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c
@@ -396,7 +396,7 @@ static int __init xeon75xx_mce_init(void)
 	pr_info("Found Xeon75xx PFA memory error translation table at %x\n",
 		addr);
 	mb();
-	cpu_specific_poll = xeon75xx_mce_poll;
+	mce_cpu_specific_poll = xeon75xx_mce_poll;
 	return 0;
 
 error_unmap:
@@ -412,7 +412,7 @@ MODULE_DESCRIPTION("Intel Xeon 75xx specific DIMM error reporting");
 #ifdef CONFIG_MODULE
 static void __exit xeon75xx_mce_exit(void)
 {
-	cpu_specific_poll = NULL;
+	mce_cpu_specific_poll = NULL;
 	wmb();
 	/* Wait for all machine checks to finish before really unloading */
 	synchronize_rcu();
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1c1e4aa..a277d34 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -88,8 +88,8 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-void				(*cpu_specific_poll)(struct mce *);
-EXPORT_SYMBOL_GPL(cpu_specific_poll);
+void				(*mce_cpu_specific_poll)(struct mce *);
+EXPORT_SYMBOL_GPL(mce_cpu_specific_poll);
 
 /*
  * CPU/chipset specific EDAC code can register a notifier call here to print
@@ -576,8 +576,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
 
-		if (cpu_specific_poll && !under_injection() && !mce_dont_log_ce)
-			cpu_specific_poll(&m);
+		if (mce_cpu_specific_poll && !under_injection() && !mce_dont_log_ce)
+			mce_cpu_specific_poll(&m);
 
 		/*
 		 * Don't get the IP here because it's unlikely to
