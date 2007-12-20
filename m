Return-Path: <linux-kernel-owner+w=401wt.eu-S1762570AbXLTNg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762570AbXLTNg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760428AbXLTNeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762050AbXLTNe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:29 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 06/16] make hypercalls use the vcpu struct
Date: Thu, 20 Dec 2007 11:33:46 -0200
Message-Id: <11981576671720-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981576632726-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch changes do_hcall() and do_async_hcall() interfaces (and obviously their
callers) to get a vcpu struct. Again, a vcpu services the hypercall, not the whole
guest

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/core.c       |    6 +++---
 drivers/lguest/hypercalls.c |   42 +++++++++++++++++++++++-------------------
 drivers/lguest/lg.h         |   16 ++++++++--------
 drivers/lguest/x86/core.c   |   16 ++++++++++------
 4 files changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 70fc65e..ef35e02 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -181,8 +181,8 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user)
 	/* We stop running once the Guest is dead. */
 	while (!lg->dead) {
 		/* First we run any hypercalls the Guest wants done. */
-		if (lg->hcall)
-			do_hypercalls(lg);
+		if (vcpu->hcall)
+			do_hypercalls(vcpu);
 
 		/* It's possible the Guest did a NOTIFY hypercall to the
 		 * Launcher, in which case we return from the read() now. */
@@ -234,7 +234,7 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user)
 		local_irq_enable();
 
 		/* Now we deal with whatever happened to the Guest. */
-		lguest_arch_handle_trap(lg);
+		lguest_arch_handle_trap(vcpu);
 	}
 
 	/* The Guest is dead => "No such file or directory" */
diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index b478aff..62da355 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -29,8 +29,10 @@
 
 /*H:120 This is the core hypercall routine: where the Guest gets what it wants.
  * Or gets killed.  Or, in the case of LHCALL_CRASH, both. */
-static void do_hcall(struct lguest *lg, struct hcall_args *args)
+static void do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 {
+	struct lguest *lg = vcpu->lg;
+
 	switch (args->arg0) {
 	case LHCALL_FLUSH_ASYNC:
 		/* This call does nothing, except by breaking out of the Guest
@@ -91,7 +93,7 @@ static void do_hcall(struct lguest *lg, struct hcall_args *args)
 		break;
 	default:
 		/* It should be an architecture-specific hypercall. */
-		if (lguest_arch_do_hcall(lg, args))
+		if (lguest_arch_do_hcall(vcpu, args))
 			kill_guest(lg, "Bad hypercall %li\n", args->arg0);
 	}
 }
@@ -104,10 +106,11 @@ static void do_hcall(struct lguest *lg, struct hcall_args *args)
  * Guest put them in the ring, but we also promise the Guest that they will
  * happen before any normal hypercall (which is why we check this before
  * checking for a normal hcall). */
-static void do_async_hcalls(struct lguest *lg)
+static void do_async_hcalls(struct lguest_vcpu *vcpu)
 {
 	unsigned int i;
 	u8 st[LHCALL_RING_SIZE];
+	struct lguest *lg = vcpu->lg;
 
 	/* For simplicity, we copy the entire call status array in at once. */
 	if (copy_from_user(&st, &lg->lguest_data->hcall_status, sizeof(st)))
@@ -119,7 +122,7 @@ static void do_async_hcalls(struct lguest *lg)
 		/* We remember where we were up to from last time.  This makes
 		 * sure that the hypercalls are done in the order the Guest
 		 * places them in the ring. */
-		unsigned int n = lg->next_hcall;
+		unsigned int n = vcpu->next_hcall;
 
 		/* 0xFF means there's no call here (yet). */
 		if (st[n] == 0xFF)
@@ -127,8 +130,8 @@ static void do_async_hcalls(struct lguest *lg)
 
 		/* OK, we have hypercall.  Increment the "next_hcall" cursor,
 		 * and wrap back to 0 if we reach the end. */
-		if (++lg->next_hcall == LHCALL_RING_SIZE)
-			lg->next_hcall = 0;
+		if (++vcpu->next_hcall == LHCALL_RING_SIZE)
+			vcpu->next_hcall = 0;
 
 		/* Copy the hypercall arguments into a local copy of
 		 * the hcall_args struct. */
@@ -139,7 +142,7 @@ static void do_async_hcalls(struct lguest *lg)
 		}
 
 		/* Do the hypercall, same as a normal one. */
-		do_hcall(lg, &args);
+		do_hcall(vcpu, &args);
 
 		/* Mark the hypercall done. */
 		if (put_user(0xFF, &lg->lguest_data->hcall_status[n])) {
@@ -156,16 +159,17 @@ static void do_async_hcalls(struct lguest *lg)
 
 /* Last of all, we look at what happens first of all.  The very first time the
  * Guest makes a hypercall, we end up here to set things up: */
-static void initialize(struct lguest *lg)
+static void initialize(struct lguest_vcpu *vcpu)
 {
+	struct lguest *lg = vcpu->lg;
 	/* You can't do anything until you're initialized.  The Guest knows the
 	 * rules, so we're unforgiving here. */
-	if (lg->hcall->arg0 != LHCALL_LGUEST_INIT) {
-		kill_guest(lg, "hypercall %li before INIT", lg->hcall->arg0);
+	if (vcpu->hcall->arg0 != LHCALL_LGUEST_INIT) {
+		kill_guest(lg, "hypercall %li before INIT", vcpu->hcall->arg0);
 		return;
 	}
 
-	if (lguest_arch_init_hypercalls(lg))
+	if (lguest_arch_init_hypercalls(vcpu))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 
 	/* The Guest tells us where we're not to deliver interrupts by putting
@@ -194,27 +198,27 @@ static void initialize(struct lguest *lg)
  * Remember from the Guest, hypercalls come in two flavors: normal and
  * asynchronous.  This file handles both of types.
  */
-void do_hypercalls(struct lguest *lg)
+void do_hypercalls(struct lguest_vcpu *vcpu)
 {
 	/* Not initialized yet?  This hypercall must do it. */
-	if (unlikely(!lg->lguest_data)) {
+	if (unlikely(!vcpu->lg->lguest_data)) {
 		/* Set up the "struct lguest_data" */
-		initialize(lg);
+		initialize(vcpu);
 		/* Hcall is done. */
-		lg->hcall = NULL;
+		vcpu->hcall = NULL;
 		return;
 	}
 
 	/* The Guest has initialized.
 	 *
 	 * Look in the hypercall ring for the async hypercalls: */
-	do_async_hcalls(lg);
+	do_async_hcalls(vcpu);
 
 	/* If we stopped reading the hypercall ring because the Guest did a
 	 * NOTIFY to the Launcher, we want to return now.  Otherwise we do
 	 * the hypercall. */
-	if (!lg->pending_notify) {
-		do_hcall(lg, lg->hcall);
+	if (!vcpu->lg->pending_notify) {
+		do_hcall(vcpu, vcpu->hcall);
 		/* Tricky point: we reset the hcall pointer to mark the
 		 * hypercall as "done".  We use the hcall pointer rather than
 		 * the trap number to indicate a hypercall is pending.
@@ -225,7 +229,7 @@ void do_hypercalls(struct lguest *lg)
 		 * Launcher, the run_guest() loop will exit without running the
 		 * Guest.  When it comes back it would try to re-run the
 		 * hypercall. */
-		lg->hcall = NULL;
+		vcpu->hcall = NULL;
 	}
 }
 
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index c4a0a97..696cdf1 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -43,6 +43,10 @@ struct lguest;
 struct lguest_vcpu {
 	int vcpu_id;
 	struct lguest *lg;
+
+	/* If a hypercall was asked for, this points to the arguments. */
+	struct hcall_args *hcall;
+	u32 next_hcall;
 };
 
 /* The private info the thread maintains about the guest. */
@@ -65,13 +69,9 @@ struct lguest
 	u32 cr2;
 	int halted;
 	int ts;
-	u32 next_hcall;
 	u32 esp1;
 	u8 ss1;
 
-	/* If a hypercall was asked for, this points to the arguments. */
-	struct hcall_args *hcall;
-
 	/* Do we need to stop what we're doing and return to userspace? */
 	int break_out;
 	wait_queue_head_t break_wq;
@@ -183,9 +183,9 @@ void page_table_guest_data_init(struct lguest *lg);
 void lguest_arch_host_init(void);
 void lguest_arch_host_fini(void);
 void lguest_arch_run_guest(struct lguest_vcpu *vcpu);
-void lguest_arch_handle_trap(struct lguest *lg);
-int lguest_arch_init_hypercalls(struct lguest *lg);
-int lguest_arch_do_hcall(struct lguest *lg, struct hcall_args *args);
+void lguest_arch_handle_trap(struct lguest_vcpu *vcpu);
+int lguest_arch_init_hypercalls(struct lguest_vcpu *vcpu);
+int lguest_arch_do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args);
 void lguest_arch_setup_regs(struct lguest *lg, unsigned long start);
 
 /* <arch>/switcher.S: */
@@ -196,7 +196,7 @@ int lguest_device_init(void);
 void lguest_device_remove(void);
 
 /* hypercalls.c: */
-void do_hypercalls(struct lguest *lg);
+void do_hypercalls(struct lguest_vcpu *vcpu);
 void write_timestamp(struct lguest *lg);
 
 /*L:035
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 0530ef3..5e56629 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -285,8 +285,9 @@ static int emulate_insn(struct lguest *lg)
 }
 
 /*H:050 Once we've re-enabled interrupts, we look at why the Guest exited. */
-void lguest_arch_handle_trap(struct lguest *lg)
+void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 {
+	struct lguest *lg = vcpu->lg;
 	switch (lg->regs->trapnum) {
 	case 13: /* We've intercepted a General Protection Fault. */
 		/* Check if this was one of those annoying IN or OUT
@@ -338,7 +339,7 @@ void lguest_arch_handle_trap(struct lguest *lg)
 	case LGUEST_TRAP_ENTRY:
 		/* Our 'struct hcall_args' maps directly over our regs: we set
 		 * up the pointer now to indicate a hypercall is pending. */
-		lg->hcall = (struct hcall_args *)lg->regs;
+		vcpu->hcall = (struct hcall_args *)lg->regs;
 		return;
 	}
 
@@ -493,8 +494,10 @@ void __exit lguest_arch_host_fini(void)
 
 
 /*H:122 The i386-specific hypercalls simply farm out to the right functions. */
-int lguest_arch_do_hcall(struct lguest *lg, struct hcall_args *args)
+int lguest_arch_do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 {
+	struct lguest *lg = vcpu->lg;
+
 	switch (args->arg0) {
 	case LHCALL_LOAD_GDT:
 		load_guest_gdt(lg, args->arg1, args->arg2);
@@ -513,13 +516,14 @@ int lguest_arch_do_hcall(struct lguest *lg, struct hcall_args *args)
 }
 
 /*H:126 i386-specific hypercall initialization: */
-int lguest_arch_init_hypercalls(struct lguest *lg)
+int lguest_arch_init_hypercalls(struct lguest_vcpu *vcpu)
 {
 	u32 tsc_speed;
+	struct lguest *lg = vcpu->lg;
 
 	/* The pointer to the Guest's "struct lguest_data" is the only
 	 * argument.  We check that address now. */
-	if (!lguest_address_ok(lg, lg->hcall->arg1, sizeof(*lg->lguest_data)))
+	if (!lguest_address_ok(lg, vcpu->hcall->arg1, sizeof(*lg->lguest_data)))
 		return -EFAULT;
 
 	/* Having checked it, we simply set lg->lguest_data to point straight
@@ -527,7 +531,7 @@ int lguest_arch_init_hypercalls(struct lguest *lg)
 	 * copy_to_user/from_user from now on, instead of lgread/write.  I put
 	 * this in to show that I'm not immune to writing stupid
 	 * optimizations. */
-	lg->lguest_data = lg->mem_base + lg->hcall->arg1;
+	lg->lguest_data = lg->mem_base + vcpu->hcall->arg1;
 
 	/* We insist that the Time Stamp Counter exist and doesn't change with
 	 * cpu frequency.  Some devious chip manufacturers decided that TSC
-- 
1.5.0.6

