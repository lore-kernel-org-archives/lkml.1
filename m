Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYCRF20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYCRF20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYCRFYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:18 -0400
Received: from gw.goop.org ([64.81.55.164]:37851 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYCRFYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 31] xen: fix RMW when unmasking events
X-Mercurial-Node: f50ab2080db6568bda837b88c8a201ca0e0f0069
Message-Id: <f50ab2080db6568bda83.1205797012@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:36:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable <stable@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_irq_enable_direct and xen_sysexit were using "andw $0x00ff,
XEN_vcpu_info_pending(vcpu)" to unmask events and test for pending ones
in one instuction.

Unfortunately, the pending flag must be modified with a locked operation
since it can be set by another CPU, and the unlocked form of this
operation was causing the pending flag to get lost, allowing the processor
to return to usermode with pending events and ultimately deadlock.

The simple fix would be to make it a locked operation, but that's rather
costly and unnecessary.  The fix here is to split the mask-clearing and
pending-testing into two instructions; the interrupt window between
them is of no concern because either way pending or new events will
be processed.

This should fix lingering bugs in using direct vcpu structure access too.

[ Stable: needed in 2.6.24.x ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Stable <stable@kernel.org>
---
 arch/x86/xen/enlighten.c |    2 +-
 arch/x86/xen/xen-asm.S   |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -96,7 +96,7 @@
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement = 0;
+static int have_vcpu_info_placement = 1;
 
 static void __init xen_vcpu_setup(int cpu)
 {
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -33,12 +33,17 @@
 	events, then enter the hypervisor to get them handled.
  */
 ENTRY(xen_irq_enable_direct)
-	/* Clear mask and test pending */
-	andw $0x00ff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
+	/* Unmask events */
+	movb $0, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_mask
+
 	/* Preempt here doesn't matter because that will deal with
 	   any pending interrupts.  The pending check may end up being
 	   run on the wrong CPU, but that doesn't hurt. */
+
+	/* Test for pending */
+	testb $0xff, PER_CPU_VAR(xen_vcpu_info)+XEN_vcpu_info_pending
 	jz 1f
+
 2:	call check_events
 1:
 ENDPATCH(xen_irq_enable_direct)


