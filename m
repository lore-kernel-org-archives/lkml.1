Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbYDQB3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbYDQB3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbYDQBJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:51 -0400
Received: from sous-sol.org ([216.99.217.87]:59020 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762116AbYDQBJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:50 -0400
Message-Id: <20080417010326.442366326@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: xen: fix RMW when unmasking events
Content-Disposition: inline; filename=xen-fix-rmw-when-unmasking-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

upstream commit: 04c44a080d2f699a3042d4e743f7ad2ffae9d538

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

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/xen/enlighten.c |    2 +-
 arch/x86/xen/xen-asm.S   |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -95,7 +95,7 @@ struct shared_info *HYPERVISOR_shared_in
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement = 0;
+static int have_vcpu_info_placement = 1;
 
 static void __init xen_vcpu_setup(int cpu)
 {
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

-- 
