Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYANTC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYANTC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYANTCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:02:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYANTCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:02:46 -0500
Date: Mon, 14 Jan 2008 20:02:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] x86 updates
Message-ID: <20080114190236.GA31546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


[ resent with lkml Cc:-ed too. ]

Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Thanks!

	Ingo

------------------>
Bernhard Walle (1):
      x86: fix RTC_AIE with CONFIG_HPET_EMULATE_RTC

Mike Frysinger (1):
      x86: asm-x86/msr.h: pull in linux/types.h

Rafael J. Wysocki (1):
      x86: hibernation: document __save_processor_state() on x86

 arch/x86/kernel/hpet.c       |    2 +-
 arch/x86/kernel/suspend_64.c |   20 ++++++++++++++++++++
 include/asm-x86/msr.h        |    4 ++++
 include/asm-x86/suspend_64.h |    9 ++++++++-
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4a86ffd..2f99ee2 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -657,7 +657,7 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 		hpet_pie_count = 0;
 	}
 
-	if (hpet_rtc_flags & RTC_PIE &&
+	if (hpet_rtc_flags & RTC_AIE &&
 	    (curr_time.tm_sec == hpet_alarm_time.tm_sec) &&
 	    (curr_time.tm_min == hpet_alarm_time.tm_min) &&
 	    (curr_time.tm_hour == hpet_alarm_time.tm_hour))
diff --git a/arch/x86/kernel/suspend_64.c b/arch/x86/kernel/suspend_64.c
index 2e5efaa..569f1b5 100644
--- a/arch/x86/kernel/suspend_64.c
+++ b/arch/x86/kernel/suspend_64.c
@@ -19,6 +19,21 @@ extern const void __nosave_begin, __nosave_end;
 
 struct saved_context saved_context;
 
+/**
+ *	__save_processor_state - save CPU registers before creating a
+ *		hibernation image and before restoring the memory state from it
+ *	@ctxt - structure to store the registers contents in
+ *
+ *	NOTE: If there is a CPU register the modification of which by the
+ *	boot kernel (ie. the kernel used for loading the hibernation image)
+ *	might affect the operations of the restored target kernel (ie. the one
+ *	saved in the hibernation image), then its contents must be saved by this
+ *	function.  In other words, if kernel A is hibernated and different
+ *	kernel B is used for loading the hibernation image into memory, the
+ *	kernel A's __save_processor_state() function must save all registers
+ *	needed by kernel A, so that it can operate correctly after the resume
+ *	regardless of what kernel B does in the meantime.
+ */
 void __save_processor_state(struct saved_context *ctxt)
 {
 	kernel_fpu_begin();
@@ -69,6 +84,11 @@ static void do_fpu_end(void)
 	kernel_fpu_end();
 }
 
+/**
+ *	__restore_processor_state - restore the contents of CPU registers saved
+ *		by __save_processor_state()
+ *	@ctxt - structure to load the registers contents from
+ */
 void __restore_processor_state(struct saved_context *ctxt)
 {
 	/*
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 664a2fa..80b0270 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -3,6 +3,10 @@
 
 #include <asm/msr-index.h>
 
+#ifndef __ASSEMBLY__
+# include <linux/types.h>
+#endif
+
 #ifdef __i386__
 
 #ifdef __KERNEL__
diff --git a/include/asm-x86/suspend_64.h b/include/asm-x86/suspend_64.h
index c505a76..4404668 100644
--- a/include/asm-x86/suspend_64.h
+++ b/include/asm-x86/suspend_64.h
@@ -15,7 +15,14 @@ arch_prepare_suspend(void)
 	return 0;
 }
 
-/* Image of the saved processor state. If you touch this, fix acpi/wakeup.S. */
+/*
+ * Image of the saved processor state, used by the low level ACPI suspend to
+ * RAM code and by the low level hibernation code.
+ *
+ * If you modify it, fix arch/x86/kernel/acpi/wakeup_64.S and make sure that
+ * __save/__restore_processor_state(), defined in arch/x86/kernel/suspend_64.c,
+ * still work as required.
+ */
 struct saved_context {
 	struct pt_regs regs;
   	u16 ds, es, fs, gs, ss;
