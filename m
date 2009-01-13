Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZAMBQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZAMBQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZAMBQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:16:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbZAMBQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:16:31 -0500
Date: Tue, 13 Jan 2009 02:16:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] core fixes
Message-ID: <20090113011614.GA854@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      smp_call_function_single(): be slightly less stupid, fix #2

Peter Zijlstra (1):
      lockdep, mm: fix might_fault() annotation


 kernel/up.c |    1 +
 mm/memory.c |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/up.c b/kernel/up.c
index c04b9dc..1ff27a2 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -2,6 +2,7 @@
  * Uniprocessor-only support functions.  The counterpart to kernel/smp.c
  */
 
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/smp.h>
diff --git a/mm/memory.c b/mm/memory.c
index e009ce8..c2d4c47 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3165,6 +3165,15 @@ void print_vma_addr(char *prefix, unsigned long ip)
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void)
 {
+	/*
+	 * Some code (nfs/sunrpc) uses socket ops on kernel memory while
+	 * holding the mmap_sem, this is safe because kernel memory doesn't
+	 * get paged out, therefore we'll never actually fault, and the
+	 * below annotations will generate false positives.
+	 */
+	if (segment_eq(get_fs(), KERNEL_DS))
+		return;
+
 	might_sleep();
 	/*
 	 * it would be nicer only to annotate paths which are not under
