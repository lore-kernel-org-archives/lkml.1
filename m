Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYJVKIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYJVKIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYJVKIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:08:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:56758 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYJVKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kXXKe3+3kwJ7OfKyMHj4oPuHSHv4mA7uTWk6gpC1asmhlQJ/BmC0hEIM/FWLTzdz/S
         F0o1UHJyaRK2U7GzYwwbV32tzqO9TxZCeqCUqWqndk+TguK+hnhe79zeaUHwtbPP0hMD
         Pp3LoVahQ7Bf5UHSlzrav2ko0IH7raEetK9m4=
Message-ID: <19f34abd0810220308m2a5dcb64qd63fad510f6a17dd@mail.gmail.com>
Date: Wed, 22 Oct 2008 12:08:01 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: [GIT PULL] kmemcheck.git
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20081021170106.GA30963@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081021170106.GA30963@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend with Cc: linux-kernel]

Hei,

A few updates below. No code changes except for the mismerge in sysctl
table. Please pull, thanks a lot :-)


Vegard


The following changes since commit 760932c8607b736504a134ed6feec25e90e089ac:
 Vegard Nossum (1):
       kmemcheck: (finally) use 4k pages for identity mapping

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git
for-tip-kmemcheck-v2

Vegard Nossum (5):
     x86: fix mis-merge
     kmemcheck: fix mis-merge in sysctl table
     kmemcheck: update documentation
     kmemcheck: update Kconfig help text
     kmemcheck: document the shadow member of struct page

 Documentation/kmemcheck.txt  |   12 +++---------
 arch/x86/Kconfig.debug       |   11 ++++++-----
 arch/x86/kernel/cpu/common.c |    4 ----
 include/linux/mm_types.h     |    4 ++++
 kernel/sysctl.c              |   20 ++++++++++----------
 5 files changed, 23 insertions(+), 28 deletions(-)


diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
index 843a63c..a848d49 100644
--- a/Documentation/kmemcheck.txt
+++ b/Documentation/kmemcheck.txt
@@ -82,15 +82,9 @@ The most prominent problem seems to be that of
bit-fields. kmemcheck can only
 track memory with byte granularity. Therefore, when gcc generates code to
 access only one bit in a bit-field, there is really no way for kmemcheck to
 know which of the other bits will be used or thrown away. Consequently, there
-may be bogus warnings for bit-field accesses. There is some experimental
-support to detect this automatically, though it is probably better to work
-around this by explicitly initializing whole bit-fields at once.
-
-Some allocations are used for DMA. As DMA doesn't go through the paging
-mechanism, we have absolutely no way to detect DMA writes. This means that
-spurious warnings may be seen on access to DMA memory. DMA allocations should
-be annotated with the __GFP_NOTRACK flag or allocated from caches marked
-SLAB_NOTRACK to work around this problem.
+may be bogus warnings for bit-field accesses. We have added a "bitfields" API
+to get around this problem. See include/linux/kmemcheck.h for detailed
+instructions!


 Parameters
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d393ad1..73cc0d3 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -338,11 +338,12 @@ config KMEMCHECK_QUEUE_SIZE
       depends on KMEMCHECK
       default 64
       help
-         Select the maximum number of errors to store in the queue. This
-         queue will be emptied once every second, so this is effectively a
-         limit on how many reports to print in one go. Note however, that
-         if the number of errors occuring between two bursts is larger than
-         this number, the extra error reports will get lost.
+         Select the maximum number of errors to store in the queue. Since
+         errors can occur virtually anywhere and in any context, we need a
+         temporary storage area which is guarantueed not to generate any
+         other faults. The queue will be emptied as soon as a tasklet may
+         be scheduled. If the queue is full, new error reports will be
+         lost.

 config KMEMCHECK_SHADOW_COPY_SHIFT
       int "kmemcheck: shadow copy size (5 => 32 bytes, 6 => 64 bytes)"
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ff26d87..25581dc 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -581,10 +581,6 @@ void __init early_cpu_init(void)
 * The NOPL instruction is supposed to exist on all CPUs with
 * family >= 6; unfortunately, that's not true in practice because
 * of early VIA chips and (more importantly) broken virtualizers that
- *
- * Note: no 64-bit chip is known to lack these, but put the code here
- * for consistency with 32 bits, and to make it utterly trivial to
- * diagnose the problem should it ever surface.
 * are not easy to detect.  In the latter case it doesn't even *fail*
 * reliably, so probing for it doesn't even work.  Disable it completely
 * unless we can find a reliable way to detect all the broken cases.
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bca924a..02d66ab 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -99,6 +99,10 @@ struct page {
 #endif

 #ifdef CONFIG_KMEMCHECK
+       /*
+        * kmemcheck wants to track the status of each byte in a page; this
+        * is a pointer to such a status block. NULL if not tracked.
+        */
       void *shadow;
 #endif
 };
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 73fcc23..c7f9d77 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -836,6 +836,16 @@ static struct ctl_table kern_table[] = {
               .child          = key_sysctls,
       },
 #endif
+#ifdef CONFIG_RCU_TORTURE_TEST
+       {
+               .ctl_name       = CTL_UNNUMBERED,
+               .procname       = "rcutorture_runnable",
+               .data           = &rcutorture_runnable,
+               .maxlen         = sizeof(int),
+               .mode           = 0644,
+               .proc_handler   = &proc_dointvec,
+       },
+#endif
 #ifdef CONFIG_KMEMCHECK
       {
               .ctl_name       = CTL_UNNUMBERED,
@@ -1176,16 +1186,6 @@ static struct ctl_table vm_table[] = {
               .extra2         = &one,
       },
 #endif
-#ifdef CONFIG_RCU_TORTURE_TEST
-       {
-               .ctl_name       = CTL_UNNUMBERED,
-               .procname       = "rcutorture_runnable",
-               .data           = &rcutorture_runnable,
-               .maxlen         = sizeof(int),
-               .mode           = 0644,
-               .proc_handler   = &proc_dointvec,
-       },
-#endif
 /*
 * NOTE: do not add new entries to this table unless you have read
 * Documentation/sysctl/ctl_unnumbered.txt
