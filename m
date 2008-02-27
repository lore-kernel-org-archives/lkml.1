Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYB0NiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYB0NiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYB0Nhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:37:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37306 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYB0Nhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:37:50 -0500
Subject: [RFC/PATCH] RLIMIT_ARG_MAX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: aaw <aaw@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       michael.kerrisk@gmail.com, carlos@codesourcery.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 14:37:35 +0100
Message-Id: <1204119455.6242.403.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Raised by: http://bugzilla.kernel.org/show_bug.cgi?id=10095 , there is
the question of whether we want to separate the env+arg arrays from the
stack proper.

Currently these arrays are considered part of the stack, and
RLIMIT_STACK includes them. However POSIX does not specify it must be
so.

The complaint is that sysconf(_SC_ARG_MAX) returns a hard coded value
(which is not obtained from the kernel) and might, depending on the
RLIMIT_STACK setting, be invalid.

POSIX disallows sysconf() variables to change during the execution of a
process, so even if it would ask the kernel for a value, we could not
give a sane answer.

The suggestion is to introduce a new RLIMIT_ARG_MAX which takes over the
role of sysconf(_SC_ARG_MAX), however this would require we either
separate these values into their own vma, or subtract 
  mm->env_end - mm->env_start + mm->arg_end - mm->arg_start
from the computed vma size when we test RLIMIT_STACK.

I'm still of two minds on this issue.. but fwiw here is a patch
implementing RLIMIT_ARG_MAX - utterly untested and doesn't consider 
!MMU.

---
Subject: RLIMIT_ARG_MAX

Having this rlimit allows userspace to determine how large argv arrays
can be (after they bother to calculate the env size).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/exec.c                      |    2 +-
 fs/proc/base.c                 |    1 +
 include/asm-generic/resource.h |    4 +++-
 mm/mmap.c                      |    6 +++++-
 4 files changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c
+++ linux-2.6/fs/exec.c
@@ -183,7 +183,7 @@ static struct page *get_arg_page(struct 
 		 *  - the program will have a reasonable amount of stack left
 		 *    to work from.
 		 */
-		if (size > rlim[RLIMIT_STACK].rlim_cur / 4) {
+		if (size > rlim[RLIMIT_ARG_MAX].rlim_cur) {
 			put_page(page);
 			return NULL;
 		}
Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c
+++ linux-2.6/fs/proc/base.c
@@ -412,6 +412,7 @@ static const struct limit_names lnames[R
 	[RLIMIT_NICE] = {"Max nice priority", NULL},
 	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
 	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+	[RLIMIT_ARG_MAX] = {"Max env+arg space", "bytes"},
 };
 
 /* Display limits for a process */
Index: linux-2.6/include/asm-generic/resource.h
===================================================================
--- linux-2.6.orig/include/asm-generic/resource.h
+++ linux-2.6/include/asm-generic/resource.h
@@ -45,7 +45,8 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+#define RLIMIT_ARG_MAX		16	/* maximum env+arg space */
+#define RLIM_NLIMITS		17
 
 /*
  * SuS says limits have to be unsigned.
@@ -87,6 +88,7 @@
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
 	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_ARG_MAX]	= { 32*PAGE_SIZE, _STK_LIM/4 },	\
 }
 
 #endif	/* __KERNEL__ */
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -1516,13 +1516,17 @@ static int acct_stack_growth(struct vm_a
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
 	unsigned long new_start;
+	unsigned long env_arg_size;
 
 	/* address space limit tests */
 	if (!may_expand_vm(mm, grow))
 		return -ENOMEM;
 
+	env_arg_size = mm->env_end - mm->env_start +
+		       mm->arg_end - mm->arg_start;
+
 	/* Stack limit test */
-	if (size > rlim[RLIMIT_STACK].rlim_cur)
+	if (size - env_arg_size > rlim[RLIMIT_STACK].rlim_cur)
 		return -ENOMEM;
 
 	/* mlock limit tests */



