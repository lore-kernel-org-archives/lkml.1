Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZBKOpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZBKOpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZBKOpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:45:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbZBKOpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:45:30 -0500
Date: Wed, 11 Feb 2009 15:45:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com
Subject: Re: [patch] x86, ptrace: fix double-free on race
Message-ID: <20090211144520.GA7633@elte.hu>
References: <20090211151027.A16643@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211151027.A16643@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Ptrace_detach() races with __ptrace_unlink() if the traced task is
> reaped while detaching. This might cause a double-free of the BTS
> buffer.
> 
> Change the ptrace_detach() path to only do the memory accounting in
> ptrace_bts_detach() and leave the buffer free to ptrace_bts_untrace()
> which will be called from __ptrace_unlink().
> 
> The fix follows a proposal from Oleg Nesterov.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

Applied to tip:x86/urgent, thanks Markus!

Note, i fixed up the comment style to match the rest of ptrace.c,
see the final commit below.

	Ingo

-------------------->
>From 9f339e7028e2855717af3193c938f9960ad13b38 Mon Sep 17 00:00:00 2001
From: Markus Metzger <markus.t.metzger@intel.com>
Date: Wed, 11 Feb 2009 15:10:27 +0100
Subject: [PATCH] x86, ptrace, mm: fix double-free on race

Ptrace_detach() races with __ptrace_unlink() if the traced task is
reaped while detaching. This might cause a double-free of the BTS
buffer.

Change the ptrace_detach() path to only do the memory accounting in
ptrace_bts_detach() and leave the buffer free to ptrace_bts_untrace()
which will be called from __ptrace_unlink().

The fix follows a proposal from Oleg Nesterov.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ptrace.c |   16 ++++++++++------
 include/linux/mm.h       |    1 +
 mm/mlock.c               |    7 ++++++-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0a5df5f..5a4c23d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -810,12 +810,16 @@ static void ptrace_bts_untrace(struct task_struct *child)
 
 static void ptrace_bts_detach(struct task_struct *child)
 {
-	if (unlikely(child->bts)) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-
-		ptrace_bts_free_buffer(child);
-	}
+	/*
+	 * Ptrace_detach() races with ptrace_untrace() in case
+	 * the child dies and is reaped by another thread.
+	 *
+	 * We only do the memory accounting at this point and
+	 * leave the buffer deallocation and the bts tracer
+	 * release to ptrace_bts_untrace() which will be called
+	 * later on with tasklist_lock held.
+	 */
+	release_locked_buffer(child->bts_buffer, child->bts_size);
 }
 #else
 static inline void ptrace_bts_fork(struct task_struct *tsk) {}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e8ddc98..3d7fb44 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1305,5 +1305,6 @@ void vmemmap_populate_print_last(void);
 
 extern void *alloc_locked_buffer(size_t size);
 extern void free_locked_buffer(void *buffer, size_t size);
+extern void release_locked_buffer(void *buffer, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/mlock.c b/mm/mlock.c
index 028ec48..2b57f7e 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -657,7 +657,7 @@ void *alloc_locked_buffer(size_t size)
 	return buffer;
 }
 
-void free_locked_buffer(void *buffer, size_t size)
+void release_locked_buffer(void *buffer, size_t size)
 {
 	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
@@ -667,6 +667,11 @@ void free_locked_buffer(void *buffer, size_t size)
 	current->mm->locked_vm -= pgsz;
 
 	up_write(&current->mm->mmap_sem);
+}
+
+void free_locked_buffer(void *buffer, size_t size)
+{
+	release_locked_buffer(buffer, size);
 
 	kfree(buffer);
 }
