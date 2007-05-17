Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbXEQXBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbXEQXBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbXEQXBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:01:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62306 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbXEQXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:01:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=DfQhHYCpd6EIEMLnCSvSkVzMlFgOPe7jJp06FSQO9PmMh9c6To7QpwTY+/o6KjdLM
	OVN2U2Img7G1Wo6NQtmsQ==
Date: Thu, 17 May 2007 16:00:18 -0700
To: ak@suse.de, vojtech@suse.cz
Cc: akpm@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: mce poll at IDLE_START and printk fix
Message-ID: <20070517230018.GA12192@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: thockin@google.com (Tim Hockin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Hockin <thockin@google.com>

Background:
 The MCE handler already has an idle-task handler which checks for the
 TIF_MCE_NOTIFY flag.  Given that the system is idle at that point, we can
 get even better granularity of MCE logging by polling for MCEs whenever
 we enter the idle loop.  This exposes a small imperfection in the
 printk() rate limiting whereby that last "Events Logged" message might
 not get printed if no more MCEs arrive.

Description:
 This patch extends the MCE idle notifier callback to poll for MCEs on the
 current CPU at IDLE_START time.  It also adds one new static variable to
 track whether any events have been logged since the last printk() and
 causes a printk at the next rate-limited opportunity.

Result:
 MCEs are found more rapidly on systems with bad memory.

Alternatives:
 None.

Testing:
 I used software to inject correctable and uncorrectable errors.  An
 application poll()ing /dev/mcelog gets woken up very quickly after error
 injection.

Patch:
 This patch is against 2.6.21-mm.

Signed-off-by: Tim Hockin <thockin@google.com>

---

This is the first version of this patch.


diff -pruN linux-2.6.21+04_tolerant_cleanup/arch/x86_64/kernel/mce.c linux-2.6.21+05/arch/x86_64/kernel/mce.c
--- linux-2.6.21+04_tolerant_cleanup/arch/x86_64/kernel/mce.c	2007-05-11 21:02:12.000000000 -0700
+++ linux-2.6.21+05/arch/x86_64/kernel/mce.c	2007-05-17 15:29:00.000000000 -0700
@@ -308,10 +308,10 @@ void do_machine_check(struct pt_regs * r
 		}
 	}
 
+ out:
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
 
- out:
 	/* the last thing we do is clear state */
 	for (i = 0; i < banks; i++)
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
@@ -389,29 +389,43 @@ static void mcheck_timer(struct work_str
  */
 int mce_notify_user(void)
 {
+	static int do_printk;
+	int retval = 0;
+
 	clear_thread_flag(TIF_MCE_NOTIFY);
-	if (test_and_clear_bit(0, &notify_user)) {
-		static unsigned long last_print;
-		unsigned long now = jiffies;
 
+	/* notify userspace apps as soon as possible */
+	if (test_and_clear_bit(0, &notify_user)) {
 		wake_up_interruptible(&mce_wait);
 		if (trigger[0])
 			call_usermodehelper(trigger, trigger_argv, NULL, -1);
+		do_printk = 1;
+		retval = 1;
+	}
+
+	/* only log a message periodically */
+	if (do_printk) {
+		static unsigned long last_print;
+		unsigned long now = jiffies;
 
 		if (time_after_eq(now, last_print + (check_interval*HZ))) {
 			last_print = now;
 			printk(KERN_INFO "Machine check events logged\n");
+			do_printk = 0;
 		}
-
-		return 1;
 	}
-	return 0;
+
+	return retval;
 }
 
-/* see if the idle task needs to notify userspace */
+/* take advantage of idle time to manage MCEs */
 static int
 mce_idle_callback(struct notifier_block *nfb, unsigned long action, void *junk)
 {
+	/* poll for new MCEs on this CPU */
+	if (action == IDLE_START)
+		mcheck_check_cpu(NULL);
+
 	/* IDLE_END should be safe - interrupts are back on */
 	if (action == IDLE_END && test_thread_flag(TIF_MCE_NOTIFY))
 		mce_notify_user();
