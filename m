Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbYAKHlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbYAKHlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 02:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYAKHkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 02:40:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbYAKHkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 02:40:55 -0500
Date: Fri, 11 Jan 2008 08:40:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [x86/mm] vsyscall_fn fault in early startup
Message-ID: <20080111074038.GA27186@elte.hu>
References: <20080111072143.D940526F9A9@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111072143.D940526F9A9@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> I bisected my startup problem down to:

i fixed this in my tree yesterday but was held up by another problem 
from uploading it. The patch below should apply to the tree you have.

	Ingo

-------------->
Subject: x86: fix sched_clock()
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/rtc.c |   12 ------------
 include/asm-x86/msr.h |   11 ++++++++++-
 2 files changed, 10 insertions(+), 13 deletions(-)

Index: linux-x86.q/arch/x86/kernel/rtc.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/rtc.c
+++ linux-x86.q/arch/x86/kernel/rtc.c
@@ -195,15 +195,3 @@ int update_persistent_clock(struct times
 {
 	return set_rtc_mmss(now.tv_sec);
 }
-
-unsigned long long __vsyscall_fn native_read_tsc(void)
-{
-	DECLARE_ARGS(val, low, high);
-
-	rdtsc_barrier();
-	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
-	rdtsc_barrier();
-
-	return EAX_EDX_VAL(val, low, high);
-}
-EXPORT_SYMBOL_GPL(native_read_tsc);
Index: linux-x86.q/include/asm-x86/msr.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/msr.h
+++ linux-x86.q/include/asm-x86/msr.h
@@ -91,7 +91,16 @@ static inline int native_write_msr_safe(
 	return err;
 }
 
-extern unsigned long long native_read_tsc(void);
+static __always_inline unsigned long long native_read_tsc(void)
+{
+	DECLARE_ARGS(val, low, high);
+
+	rdtsc_barrier();
+	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
+	rdtsc_barrier();
+
+	return EAX_EDX_VAL(val, low, high);
+}
 
 static inline unsigned long long native_read_pmc(int counter)
 {
