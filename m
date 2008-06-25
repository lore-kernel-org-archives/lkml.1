Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbYFYEp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbYFYEp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbYFYEhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:41 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37470 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754960AbYFYEhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:24 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 28 of 36] Save %fs and %gs before load_TLS() and
	arch_leave_lazy_cpu_mode()
X-Mercurial-Node: e1b1dec7ea53301b67497c0637b80d1d0c5c4db9
Message-Id: <e1b1dec7ea53301b6749.1214367564@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:24 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    We must do this because load_TLS() may need to clear %fs and %gs,
    such (e.g. under Xen).

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/process_64.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -579,6 +579,7 @@
 				 *next = &next_p->thread;
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
+	unsigned fsindex, gsindex;
 
 	/* we're going to use this soon, after a few expensive things */
 	if (next_p->fpu_counter>5)
@@ -601,6 +602,15 @@
 	if (unlikely(next->ds | prev->ds))
 		loadsegment(ds, next->ds);
 
+
+	/* We must save %fs and %gs before load_TLS() because
+	 * %fs and %gs may be cleared by load_TLS().
+	 *
+	 * (e.g. xen_load_tls())
+	 */
+	savesegment(fs, fsindex);
+	savesegment(gs, gsindex);
+
 	load_TLS(next, cpu);
 
 	/*
@@ -616,8 +626,6 @@
 	 * Switch FS and GS.
 	 */
 	{ 
-		unsigned fsindex;
-		savesegment(fs, fsindex);
 		/* segment register != 0 always requires a reload. 
 		   also reload when it has changed. 
 		   when prev process used 64bit base always reload
@@ -635,10 +643,7 @@
 		if (next->fs) 
 			wrmsrl(MSR_FS_BASE, next->fs); 
 		prev->fsindex = fsindex;
-	}
-	{ 
-		unsigned gsindex;
-		savesegment(gs, gsindex);
+
 		if (unlikely(gsindex | next->gsindex | prev->gs)) {
 			load_gs_index(next->gsindex);
 			if (gsindex)


