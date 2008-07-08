Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbYGHX0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYGHX0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbYGHXPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:04 -0400
Received: from gw.goop.org ([64.81.55.164]:51219 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 48 of 55] xen64: Clear %fs on xen_load_tls()
X-Mercurial-Node: e021b6376850d022ef0de6d117711dfa5c035f01
Message-Id: <e021b6376850d022ef0d.1215554830@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

We need to do this, otherwise we can get a GPF on hypercall return
after TLS descriptor is cleared but %fs is still pointing to it.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -364,14 +364,6 @@
 
 static void xen_load_tls(struct thread_struct *t, unsigned int cpu)
 {
-	xen_mc_batch();
-
-	load_TLS_descriptor(t, cpu, 0);
-	load_TLS_descriptor(t, cpu, 1);
-	load_TLS_descriptor(t, cpu, 2);
-
-	xen_mc_issue(PARAVIRT_LAZY_CPU);
-
 	/*
 	 * XXX sleazy hack: If we're being called in a lazy-cpu zone,
 	 * it means we're in a context switch, and %gs has just been
@@ -380,9 +372,30 @@
 	 * Either way, it has been saved, and the new value will get
 	 * loaded properly.  This will go away as soon as Xen has been
 	 * modified to not save/restore %gs for normal hypercalls.
+	 *
+	 * On x86_64, this hack is not used for %gs, because gs points
+	 * to KERNEL_GS_BASE (and uses it for PDA references), so we
+	 * must not zero %gs on x86_64
+	 *
+	 * For x86_64, we need to zero %fs, otherwise we may get an
+	 * exception between the new %fs descriptor being loaded and
+	 * %fs being effectively cleared at __switch_to().
 	 */
-	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU)
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU) {
+#ifdef CONFIG_X86_32
 		loadsegment(gs, 0);
+#else
+		loadsegment(fs, 0);
+#endif
+	}
+
+	xen_mc_batch();
+
+	load_TLS_descriptor(t, cpu, 0);
+	load_TLS_descriptor(t, cpu, 1);
+	load_TLS_descriptor(t, cpu, 2);
+
+	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
 #ifdef CONFIG_X86_64


