Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbXLTNfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbXLTNfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761952AbXLTNe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761778AbXLTNe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:26 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 04/16] per-cpu run guest
Date: Thu, 20 Dec 2007 11:33:44 -0200
Message-Id: <11981576581695-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1198157654189-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the run_guest() routine use the vcpu struct.
This is required since in a smp guest environment, there's no
more the notion of "running the guest", but rather, it is "running the vcpu"

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/core.c        |    6 ++++--
 drivers/lguest/lg.h          |    4 ++--
 drivers/lguest/lguest_user.c |    6 +++++-
 drivers/lguest/x86/core.c    |   16 +++++++++++-----
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index cb4c670..70fc65e 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -174,8 +174,10 @@ void __lgwrite(struct lguest *lg, unsigned long addr, const void *b,
 /*H:030 Let's jump straight to the the main loop which runs the Guest.
  * Remember, this is called by the Launcher reading /dev/lguest, and we keep
  * going around and around until something interesting happens. */
-int run_guest(struct lguest *lg, unsigned long __user *user)
+int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user)
 {
+	struct lguest *lg = vcpu->lg;
+
 	/* We stop running once the Guest is dead. */
 	while (!lg->dead) {
 		/* First we run any hypercalls the Guest wants done. */
@@ -226,7 +228,7 @@ int run_guest(struct lguest *lg, unsigned long __user *user)
 		local_irq_disable();
 
 		/* Actually run the Guest until something happens. */
-		lguest_arch_run_guest(lg);
+		lguest_arch_run_guest(vcpu);
 
 		/* Now we're ready to be interrupted or moved to other CPUs */
 		local_irq_enable();
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 9723732..c4a0a97 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -131,7 +131,7 @@ void __lgwrite(struct lguest *, unsigned long, const void *, unsigned);
 	} while(0)
 /* (end of memory access helper routines) :*/
 
-int run_guest(struct lguest *lg, unsigned long __user *user);
+int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user);
 
 /* Helper macros to obtain the first 12 or the last 20 bits, this is only the
  * first step in the migration to the kernel types.  pte_pfn is already defined
@@ -182,7 +182,7 @@ void page_table_guest_data_init(struct lguest *lg);
 /* <arch>/core.c: */
 void lguest_arch_host_init(void);
 void lguest_arch_host_fini(void);
-void lguest_arch_run_guest(struct lguest *lg);
+void lguest_arch_run_guest(struct lguest_vcpu *vcpu);
 void lguest_arch_handle_trap(struct lguest *lg);
 int lguest_arch_init_hypercalls(struct lguest *lg);
 int lguest_arch_do_hcall(struct lguest *lg, struct hcall_args *args);
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index d1b1c26..894d530 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -55,11 +55,15 @@ static int user_send_irq(struct lguest *lg, const unsigned long __user *input)
 static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
 {
 	struct lguest *lg = file->private_data;
+	struct lguest_vcpu *vcpu = NULL;
+	unsigned int vcpu_id = *o;
 
 	/* You must write LHREQ_INITIALIZE first! */
 	if (!lg)
 		return -EINVAL;
 
+	vcpu = &lg->vcpus[vcpu_id];
+
 	/* If you're not the task which owns the Guest, go away. */
 	if (current != lg->tsk)
 		return -EPERM;
@@ -85,7 +89,7 @@ static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
 		lg->pending_notify = 0;
 
 	/* Run the Guest until something interesting happens. */
-	return run_guest(lg, (unsigned long __user *)user);
+	return run_guest(vcpu, (unsigned long __user *)user);
 }
 
 static int vcpu_start(struct lguest_vcpu *vcpu, int vcpu_id,
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 482aec2..0530ef3 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -73,8 +73,10 @@ static DEFINE_PER_CPU(struct lguest *, last_guest);
  * since it last ran.  We saw this set in interrupts_and_traps.c and
  * segments.c.
  */
-static void copy_in_guest_info(struct lguest *lg, struct lguest_pages *pages)
+static void copy_in_guest_info(struct lguest_vcpu *vcpu,
+			       struct lguest_pages *pages)
 {
+	struct lguest *lg = vcpu->lg;
 	/* Copying all this data can be quite expensive.  We usually run the
 	 * same Guest we ran last time (and that Guest hasn't run anywhere else
 	 * meanwhile).  If that's not the case, we pretend everything in the
@@ -113,14 +115,16 @@ static void copy_in_guest_info(struct lguest *lg, struct lguest_pages *pages)
 }
 
 /* Finally: the code to actually call into the Switcher to run the Guest. */
-static void run_guest_once(struct lguest *lg, struct lguest_pages *pages)
+static void run_guest_once(struct lguest_vcpu *vcpu,
+			   struct lguest_pages *pages)
 {
 	/* This is a dummy value we need for GCC's sake. */
 	unsigned int clobber;
+	struct lguest *lg = vcpu->lg;
 
 	/* Copy the guest-specific information into this CPU's "struct
 	 * lguest_pages". */
-	copy_in_guest_info(lg, pages);
+	copy_in_guest_info(vcpu, pages);
 
 	/* Set the trap number to 256 (impossible value).  If we fault while
 	 * switching to the Guest (bad segment registers or bug), this will
@@ -161,8 +165,10 @@ static void run_guest_once(struct lguest *lg, struct lguest_pages *pages)
 
 /*H:040 This is the i386-specific code to setup and run the Guest.  Interrupts
  * are disabled: we own the CPU. */
-void lguest_arch_run_guest(struct lguest *lg)
+void lguest_arch_run_guest(struct lguest_vcpu *vcpu)
 {
+	struct lguest *lg = vcpu->lg;
+
 	/* Remember the awfully-named TS bit?  If the Guest has asked to set it
 	 * we set it now, so we can trap and pass that trap to the Guest if it
 	 * uses the FPU. */
@@ -180,7 +186,7 @@ void lguest_arch_run_guest(struct lguest *lg)
 	/* Now we actually run the Guest.  It will return when something
 	 * interesting happens, and we can examine its registers to see what it
 	 * was doing. */
-	run_guest_once(lg, lguest_pages(raw_smp_processor_id()));
+	run_guest_once(vcpu, lguest_pages(raw_smp_processor_id()));
 
 	/* Note that the "regs" pointer contains two extra entries which are
 	 * not really registers: a trap number which says what interrupt or
-- 
1.5.0.6

