Return-Path: <linux-kernel-owner+w=401wt.eu-S1946814AbXBJLxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946814AbXBJLxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933441AbXBJLx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:53:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:50377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbXBJLwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:52:42 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101252.033732000@suse.de>
In-Reply-To: <200702101252.033732000@suse.de>
To: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review II] [3/10] i386: iOPL handling for paravirt guests
Message-Id: <20070210115231.2F26B13DD5@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:52:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

I found a clever way to make the extra IOPL switching invisible to
non-paravirt compiles - since kernel_rpl is statically defined to be zero
there, and only non-zero rpl kernel have a problem restoring IOPL, as popf
does not restore IOPL flags unless run at CPL-0.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/process.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -670,6 +670,15 @@ struct task_struct fastcall * __switch_t
 	load_TLS(next, cpu);
 
 	/*
+	 * Restore IOPL if needed.  In normal use, the flags restore
+	 * in the switch assembly will handle this.  But if the kernel
+	 * is running virtualized at a non-zero CPL, the popf will
+	 * not restore flags, so it must be done in a separate step.
+	 */
+	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
+		set_iopl_mask(next->iopl);
+
+	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
