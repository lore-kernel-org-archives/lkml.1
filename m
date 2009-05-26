Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZEZLYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZEZLYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 07:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZEZLYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:24:46 -0400
Received: from ozlabs.org ([203.10.76.45]:36020 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZEZLYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:24:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] lguest: fix on Intel when KVM loaded (unhandled trap 13)
Date: Tue, 26 May 2009 20:54:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: "kvm-devel" <kvm-devel@lists.sourceforge.net>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905262054.42566.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When KVM is loaded, and hence VT set up, the vmcall instruction in an
lguest guest causes a #GP, not #UD.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/x86/core.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -358,6 +358,16 @@ void lguest_arch_handle_trap(struct lg_c
 			if (emulate_insn(cpu))
 				return;
 		}
+		/* If KVM is active, the vmcall instruction triggers a
+		 * General Protection Fault.  Normally it triggers an
+		 * invalid opcode fault (6): */
+	case 6:
+		/* We need to check if ring == GUEST_PL and
+		 * faulting instruction == vmcall. */
+		if (is_hypercall(cpu)) {
+			rewrite_hypercall(cpu);
+			return;
+		}
 		break;
 	case 14: /* We've intercepted a Page Fault. */
 		/* The Guest accessed a virtual address that wasn't mapped.
@@ -403,15 +413,6 @@ void lguest_arch_handle_trap(struct lg_c
 		 * up the pointer now to indicate a hypercall is pending. */
 		cpu->hcall = (struct hcall_args *)cpu->regs;
 		return;
-	case 6:
-		/* kvm hypercalls trigger an invalid opcode fault (6).
-		 * We need to check if ring == GUEST_PL and
-		 * faulting instruction == vmcall. */
-		if (is_hypercall(cpu)) {
-			rewrite_hypercall(cpu);
-			return;
-		}
-		break;
 	}
 
 	/* We didn't handle the trap, so it needs to go to the Guest. */

