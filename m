Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbYFYEsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbYFYEsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYFYEhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:50 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37471 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008AbYFYEhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:31 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 36] x86: remove open-coded save/load segment operations
X-Mercurial-Node: ed616a93080693df5341fe7a84258743c167732a
Message-Id: <ed616a93080693df5341.1214367540@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:00 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a pile of buggy open-coded implementations of savesegment
and loadsegment.

(They are buggy because they don't have memory barriers to prevent
them from being reordered with respect to memory accesses.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/common_64.c |    3 ++-
 arch/x86/kernel/process_64.c    |   28 +++++++++++++++-------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -480,7 +480,8 @@
 	struct x8664_pda *pda = cpu_pda(cpu);
 
 	/* Setup up data that may be needed in __get_free_pages early */
-	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0));
+	loadsegment(fs, 0);
+	loadsegment(gs, 0);
 	/* Memory clobbers used to order PDA accessed */
 	mb();
 	wrmsrl(MSR_GS_BASE, pda);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -362,10 +362,10 @@
 	p->thread.fs = me->thread.fs;
 	p->thread.gs = me->thread.gs;
 
-	asm("mov %%gs,%0" : "=m" (p->thread.gsindex));
-	asm("mov %%fs,%0" : "=m" (p->thread.fsindex));
-	asm("mov %%es,%0" : "=m" (p->thread.es));
-	asm("mov %%ds,%0" : "=m" (p->thread.ds));
+	savesegment(gs, p->thread.gsindex);
+	savesegment(fs, p->thread.fsindex);
+	savesegment(es, p->thread.es);
+	savesegment(ds, p->thread.ds);
 
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
@@ -404,7 +404,9 @@
 void
 start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
 {
-	asm volatile("movl %0, %%fs; movl %0, %%es; movl %0, %%ds" :: "r"(0));
+	loadsegment(fs, 0);
+	loadsegment(es, 0);
+	loadsegment(ds, 0);
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
@@ -591,11 +593,11 @@
 	 * Switch DS and ES.
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
-	asm volatile("mov %%es,%0" : "=m" (prev->es));
+	savesegment(es, prev->es);
 	if (unlikely(next->es | prev->es))
 		loadsegment(es, next->es); 
-	
-	asm volatile ("mov %%ds,%0" : "=m" (prev->ds));
+
+	savesegment(ds, prev->ds);
 	if (unlikely(next->ds | prev->ds))
 		loadsegment(ds, next->ds);
 
@@ -606,7 +608,7 @@
 	 */
 	{ 
 		unsigned fsindex;
-		asm volatile("movl %%fs,%0" : "=r" (fsindex)); 
+		savesegment(fs, fsindex);
 		/* segment register != 0 always requires a reload. 
 		   also reload when it has changed. 
 		   when prev process used 64bit base always reload
@@ -627,7 +629,7 @@
 	}
 	{ 
 		unsigned gsindex;
-		asm volatile("movl %%gs,%0" : "=r" (gsindex)); 
+		savesegment(gs, gsindex);
 		if (unlikely(gsindex | next->gsindex | prev->gs)) {
 			load_gs_index(next->gsindex);
 			if (gsindex)
@@ -807,7 +809,7 @@
 			set_32bit_tls(task, FS_TLS, addr);
 			if (doit) {
 				load_TLS(&task->thread, cpu);
-				asm volatile("movl %0,%%fs" :: "r"(FS_TLS_SEL));
+				loadsegment(fs, FS_TLS_SEL);
 			}
 			task->thread.fsindex = FS_TLS_SEL;
 			task->thread.fs = 0;
@@ -817,7 +819,7 @@
 			if (doit) {
 				/* set the selector to 0 to not confuse
 				   __switch_to */
-				asm volatile("movl %0,%%fs" :: "r" (0));
+				loadsegment(fs, 0);
 				ret = checking_wrmsrl(MSR_FS_BASE, addr);
 			}
 		}
@@ -840,7 +842,7 @@
 		if (task->thread.gsindex == GS_TLS_SEL)
 			base = read_32bit_tls(task, GS_TLS);
 		else if (doit) {
-			asm("movl %%gs,%0" : "=r" (gsindex));
+			savesegment(gs, gsindex);
 			if (gsindex)
 				rdmsrl(MSR_KERNEL_GS_BASE, base);
 			else


