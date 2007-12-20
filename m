Return-Path: <linux-kernel-owner+w=401wt.eu-S1763651AbXLTNkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763651AbXLTNkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762661AbXLTNft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:35:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761974AbXLTNfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:35:47 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 15/16] make pending notifications per-vcpu
Date: Thu, 20 Dec 2007 11:33:55 -0200
Message-Id: <11981577132025-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981577083517-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com> <11981576833314-git-send-email-gcosta@redhat.com> <11981576884121-git-send-email-gcosta@redhat.com> <1198157692575-git-send-email-gcosta@redhat.com> <11981576972655-git-send-email-gcosta@redhat.com> <11981577021091-git-send-email-gcosta@redhat.com> <11981577083517-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch makes the pending_notify field, used to control
pending notifications, per-vcpu, instead of per-guest

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/core.c        |    6 +++---
 drivers/lguest/hypercalls.c  |    6 +++---
 drivers/lguest/lg.h          |    3 ++-
 drivers/lguest/lguest_user.c |    4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 285a465..d628515 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -186,10 +186,10 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user)
 
 		/* It's possible the Guest did a NOTIFY hypercall to the
 		 * Launcher, in which case we return from the read() now. */
-		if (lg->pending_notify) {
-			if (put_user(lg->pending_notify, user))
+		if (vcpu->pending_notify) {
+			if (put_user(vcpu->pending_notify, user))
 				return -EFAULT;
-			return sizeof(lg->pending_notify);
+			return sizeof(vcpu->pending_notify);
 		}
 
 		/* Check for signals */
diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index c6b87ef..95e1062 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -89,7 +89,7 @@ static void do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 		vcpu->halted = 1;
 		break;
 	case LHCALL_NOTIFY:
-		lg->pending_notify = args->arg1;
+		vcpu->pending_notify = args->arg1;
 		break;
 	default:
 		/* It should be an architecture-specific hypercall. */
@@ -152,7 +152,7 @@ static void do_async_hcalls(struct lguest_vcpu *vcpu)
 
 		/* Stop doing hypercalls if they want to notify the Launcher:
 		 * it needs to service this first. */
-		if (lg->pending_notify)
+		if (vcpu->pending_notify)
 			break;
 	}
 }
@@ -217,7 +217,7 @@ void do_hypercalls(struct lguest_vcpu *vcpu)
 	/* If we stopped reading the hypercall ring because the Guest did a
 	 * NOTIFY to the Launcher, we want to return now.  Otherwise we do
 	 * the hypercall. */
-	if (!vcpu->lg->pending_notify) {
+	if (!vcpu->pending_notify) {
 		do_hcall(vcpu, vcpu->hcall);
 		/* Tricky point: we reset the hcall pointer to mark the
 		 * hypercall as "done".  We use the hcall pointer rather than
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index dbf70c6..6faf90d 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -51,6 +51,8 @@ struct lguest_vcpu {
 	u32 esp1;
 	u8 ss1;
 
+	unsigned long pending_notify; /* pfn from LHCALL_NOTIFY */
+
 	/* At end of a page shared mapped over lguest_pages in guest.  */
 	unsigned long regs_page;
 	struct lguest_regs *regs;
@@ -95,7 +97,6 @@ struct lguest
 	struct pgdir pgdirs[4];
 
 	unsigned long noirq_start, noirq_end;
-	unsigned long pending_notify; /* pfn from LHCALL_NOTIFY */
 
 	unsigned int stack_pages;
 	u32 tsc_khz;
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index d081db4..349d69d 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -88,8 +88,8 @@ static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
 
 	/* If we returned from read() last time because the Guest notified,
 	 * clear the flag. */
-	if (lg->pending_notify)
-		lg->pending_notify = 0;
+	if (vcpu->pending_notify)
+		vcpu->pending_notify = 0;
 
 	/* Run the Guest until something interesting happens. */
 	return run_guest(vcpu, (unsigned long __user *)user);
-- 
1.5.0.6

