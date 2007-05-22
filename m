Return-Path: <linux-kernel-owner+w=401wt.eu-S935177AbXEVPXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177AbXEVPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934771AbXEVPT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:26 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4977
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762348AbXEVPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:12 -0400
Message-Id: <20070522141253.058860996@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:10:05 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 24/33] xen: xen: hack to prevent bad segment register reload
Content-Disposition: inline; filename=xen-segreg-hack.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hypervisor saves and restores the segment registers as part of the
state is saves while context switching.  If, during a context switch,
the next process doesn't use the TLS segments, it invalidates the GDT
entry, causing the segment register reload to fault.  This fault
effectively doubles the cost of a context switch.

This patch is a band-aid workaround which clears the usermode %gs
after it has been saved for the previous process, but before it gets
reloaded for the next, and it avoids having the hypervisor attempt to
erroneously reload it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/enlighten.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -291,6 +291,18 @@ static void xen_load_tls(struct thread_s
 	load_TLS_descriptor(t, cpu, 2);
 
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
+
+	/*
+	 * XXX sleazy hack: If we're being called in a lazy-cpu zone,
+	 * it means we're in a context switch, and %gs has just been
+	 * saved.  This means we can zero it out to prevent faults on
+	 * exit from the hypervisor if the next process has no %gs.
+	 * Either way, it has been saved, and the new value will get
+	 * loaded properly.  This will go away as soon as Xen has been
+	 * modified to not save/restore %gs for normal hypercalls.
+	 */
+	if (xen_get_lazy_mode() == PARAVIRT_LAZY_CPU)
+		loadsegment(gs, 0);
 }
 
 static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum, u32 low, u32 high)

-- 

