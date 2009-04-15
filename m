Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZDOOkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZDOOkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZDOOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:40:23 -0400
Received: from ozlabs.org ([203.10.76.45]:42483 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbZDOOkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:40:22 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 16 Apr 2009 00:10:18 +0930
Subject: [PATCH 2/3] lguest: fix KVM-style hypercalls with vmlinux images
Cc: Patrick McHardy <kaber@trash.net>,
       Matias Zabaljauregui <zabaljauregui@gmail.com>,
       lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904160010.19150.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matias Zabaljauregui <zabaljauregui@gmail.com>

Impact: fix guest crash 'lguest: unhandled trap 6 at 0x418726 (0x0)'

The Launcher mmaps the kernel image.  The Guest executes and
immediately faults in the first text page (read-only).  Then it hits a
hypercall, and we rewrite that hypercall, causing a copy-on-write.
But the Guest pagetables still refer to the old page: we fault again,
but as Host we see the hypercall already rewritten, and pass the fault
back to the Guest.  The Guest hasn't set up an IDT yet, so we kill it.

This doesn't happen with bzImages: they unpack themselves and so the
text pages are already read-write.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Patrick McHardy <kaber@trash.net>
---
 drivers/lguest/x86/core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index a6b7176..b4747f7 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -324,6 +324,11 @@ static void rewrite_hypercall(struct lg_cpu *cpu)
 	u8 insn[3] = {0xcd, 0x1f, 0x90};
 
 	__lgwrite(cpu, guest_pa(cpu, cpu->regs->eip), insn, sizeof(insn));
+	/* The above write might have caused a copy of that page to be made
+	 * (if it was read-only).  We need to make sure the Guest has
+	 * up-to-date pagetables.  As this doesn't happen often, we can just
+	 * drop them all. */
+	guest_pagetable_clear_all(cpu);
 }
 
 static bool is_hypercall(struct lg_cpu *cpu)




